#!/usr/bin/env python3
"""Run curated SQL and recovery checks on disposable PostgreSQL containers."""
from __future__ import annotations
import argparse
from concurrent.futures import ThreadPoolExecutor, as_completed
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import time
import uuid

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools'))
from catalog import scripts


class Lab:
    def __init__(self, engine, version):
        self.engine = engine
        self.version = version
        self.owner = uuid.uuid4().hex
        self.name = f'pgdn-test-{version}-{self.owner[:8]}'
        self.created = False

    def command(self, *args, input=None, check=True, timeout=90):
        result = subprocess.run([self.engine, *args], input=input, text=True,
                                encoding='utf-8', errors='replace', capture_output=True, timeout=timeout)
        if check and result.returncode:
            raise RuntimeError(f'{args[0]} failed: {result.stderr[-2500:]} {result.stdout[-1000:]}')
        return result

    def sql(self, text, user='postgres', database='pgdn_lab', check=True):
        return self.command('exec', '-i', self.name, 'psql', '-X', '-w', '-v', 'ON_ERROR_STOP=1',
                            '-U', user, '-d', database, '-At', input=text, check=check)

    def start(self):
        self.created = True
        # No host mount, published port or access to an existing stack.
        self.command('run', '-d', '--name', self.name, '--network', 'none',
                     '--label', 'pgdn.disposable=true', '--label', f'pgdn.owner={self.owner}',
                     '-e', 'POSTGRES_HOST_AUTH_METHOD=trust',
                     '-e', 'POSTGRES_DB=pgdn_lab', f'docker.io/library/postgres:{self.version}-alpine',
                     '-c', 'wal_level=logical', '-c', 'shared_preload_libraries=pg_stat_statements', timeout=300)
        deadline = time.monotonic() + 90
        while time.monotonic() < deadline:
            ready = self.command('exec', self.name, 'pg_isready', '-U', 'postgres', check=False)
            if ready.returncode == 0:
                # initdb briefly starts a temporary server; require the final service process.
                state = self.command('exec', self.name, 'sh', '-c', 'test "$(cat /proc/1/comm)" = postgres', check=False)
                if state.returncode == 0:
                    return
            time.sleep(1)
        raise RuntimeError('PostgreSQL readiness deadline exceeded')

    def close(self):
        if self.created:
            label = self.command('inspect', '--format', '{{ index .Config.Labels "pgdn.owner" }}', self.name, check=False)
            if label.returncode == 0 and label.stdout.strip() == self.owner:
                self.command('rm', '-f', '-v', self.name, check=False)

    def run(self):
        report = {'postgres_major': int(self.version), 'scripts': [], 'checks': {}}
        self.start()
        report['server_version'] = self.sql('SHOW server_version;').stdout.strip()
        report['image_id'] = self.command('inspect', '--format', '{{.Image}}', self.name).stdout.strip()
        self.sql('''CREATE SCHEMA extensions;
CREATE EXTENSION pg_stat_statements SCHEMA extensions;
CREATE EXTENSION pg_buffercache SCHEMA extensions;
CREATE SCHEMA pgdn_fixture;
CREATE TABLE pgdn_fixture.orders (id integer PRIMARY KEY, payload text NOT NULL, touched timestamptz DEFAULT now());
INSERT INTO pgdn_fixture.orders(id,payload) SELECT i,repeat(md5(i::text),4) FROM generate_series(1,200) i;
CREATE INDEX orders_payload_idx ON pgdn_fixture.orders(payload);
CREATE INDEX orders_partial_idx ON pgdn_fixture.orders(id) WHERE id > 100;
CREATE TABLE pgdn_fixture.no_pk (id int);
INSERT INTO pgdn_fixture.no_pk VALUES (1);
ANALYZE pgdn_fixture.orders;
CREATE ROLE pgdn_monitor LOGIN;
GRANT pg_monitor TO pgdn_monitor;
GRANT USAGE ON SCHEMA extensions TO pgdn_monitor;
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
CREATE PUBLICATION pgdn_publication FOR TABLE pgdn_fixture.orders;
SELECT pg_create_physical_replication_slot('pgdn_reserved',true);
SELECT pg_create_logical_replication_slot('pgdn_logical','pgoutput');
SELECT count(*) FROM pgdn_fixture.orders;
''')
        self.command('cp', str(ROOT / 'scripts'), self.name + ':/tmp/pgdn-scripts')
        for item in scripts():
            row = {'path': item['path']}
            minimum = int(re.search(r'\d+', item['postgres']).group())
            path = '/tmp/pgdn-scripts/' + item['path'].removeprefix('scripts/')
            result = self.sql(f'\\i {path}\n', check=False)
            if result.returncode:
                raise RuntimeError(f"PG{self.version} {item['path']}: {result.stderr[-2500:]}")
            row['admin'] = 'passed' if int(self.version) >= minimum else 'version-guard-passed'
            privilege = item.get('privilege', '').lower()
            if 'superuser' not in privilege or ' or pg_monitor' in privilege:
                limited = self.sql(f'\\i {path}\n', user='pgdn_monitor', check=False)
                if limited.returncode:
                    raise RuntimeError(f"PG{self.version} pg_monitor {item['path']}: {limited.stderr[-2500:]}")
                row['pg_monitor'] = 'passed' if int(self.version) >= minimum else 'version-guard-passed'
            else:
                row['pg_monitor'] = 'not-run: requires superuser'
            report['scripts'].append(row)
        for item in scripts():
            if item['path'].startswith('scripts/performance/queries/') or item['path'].endswith('/buffercache-summary.sql'):
                path = '/tmp/pgdn-scripts/' + item['path'].removeprefix('scripts/')
                missing = self.sql(f'\\i {path}\n', database='postgres', check=False)
                if missing.returncode:
                    raise RuntimeError(f"Missing-extension guard failed for {item['path']}: {missing.stderr}")
                if int(self.version) >= int(re.search(r'\d+', item['postgres']).group()) and 'not installed' not in missing.stdout.lower():
                    raise RuntimeError(f"Missing-extension guard did not explain skip for {item['path']}")
        report['checks']['optional_extensions_nonpublic_schema_and_missing_guard'] = True
        denied = self.sql('BEGIN READ ONLY; CREATE TABLE pgdn_fixture.forbidden(id int);', check=False)
        if denied.returncode == 0 or 'read-only' not in denied.stderr:
            raise RuntimeError('Read-only write rejection not proved')
        report['checks']['read_only_write_rejected'] = True
        limited_denied = self.sql('CREATE TABLE public.forbidden(id int);', user='pgdn_monitor', check=False)
        if limited_denied.returncode == 0:
            raise RuntimeError('Restricted role unexpectedly created a table')
        report['checks']['monitor_write_rejected'] = True
        self.command('exec', self.name, 'pg_dump', '-U', 'postgres', '-d', 'pgdn_lab', '-Fc', '-f', '/tmp/pgdn.dump')
        self.command('exec', self.name, 'createdb', '-U', 'postgres', 'pgdn_restored')
        self.command('exec', self.name, 'pg_restore', '-U', 'postgres', '-d', 'pgdn_restored', '--exit-on-error',
                     '--no-owner', '--no-privileges', '/tmp/pgdn.dump')
        original = self.sql('SELECT count(*),md5(string_agg(id::text || payload,\'\' ORDER BY id)) FROM pgdn_fixture.orders;').stdout.strip()
        restored = self.sql('SELECT count(*),md5(string_agg(id::text || payload,\'\' ORDER BY id)) FROM pgdn_fixture.orders;', database='pgdn_restored').stdout.strip()
        if original != restored or not restored.startswith('200|'):
            raise RuntimeError('Logical restore data mismatch')
        report['checks']['logical_backup_restore_200_rows'] = True
        # Exercise real lock contention rather than relying on empty pg_locks output.
        holder_args = [self.engine, 'exec', self.name, 'psql', '-X', '-U', 'postgres', '-d', 'pgdn_lab',
                       '-c', 'BEGIN; LOCK TABLE pgdn_fixture.orders IN ACCESS EXCLUSIVE MODE; SELECT pg_sleep(8); COMMIT;']
        holder = subprocess.Popen(holder_args, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        waiter = None
        try:
            deadline = time.monotonic() + 5
            while time.monotonic() < deadline:
                observed = self.sql("SELECT count(*) FROM pg_locks WHERE relation='pgdn_fixture.orders'::regclass AND mode='AccessExclusiveLock' AND granted;").stdout.strip()
                if observed == '1':
                    break
                time.sleep(.1)
            else:
                raise RuntimeError('Lock holder not observed')
            waiter = subprocess.Popen([self.engine, 'exec', self.name, 'psql', '-X', '-U', 'postgres', '-d', 'pgdn_lab',
                                       '-c', 'SELECT count(*) FROM pgdn_fixture.orders;'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            deadline = time.monotonic() + 4
            while time.monotonic() < deadline:
                if self.sql("SELECT count(*) FROM pg_stat_activity WHERE cardinality(pg_blocking_pids(pid))>0;").stdout.strip() != '0':
                    report['checks']['real_blocker_observed'] = True
                    diagnosis = self.sql('\\i /tmp/pgdn-scripts/monitoring/activity/blocking-sessions.sql\n')
                    if 'pgdn_fixture.orders' not in diagnosis.stdout:
                        raise RuntimeError('Curated blocking query did not report the blocked fixture')
                    report['checks']['curated_blocker_query_reports_waiter'] = True
                    break
                time.sleep(.1)
            else:
                raise RuntimeError('Real blocked session not observed')
        finally:
            holder.communicate(timeout=15)
            if waiter:
                waiter.communicate(timeout=15)
        return report


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--engine', choices=['podman', 'docker'], default='docker')
    parser.add_argument('--versions', nargs='+', default=['14', '15', '16', '17', '18'], choices=['14', '15', '16', '17', '18'])
    parser.add_argument('--output', default='test-results/integration.json')
    parser.add_argument('--jobs', type=int, default=1, choices=range(1, 6), help='Parallel disposable clusters (1-5)')
    args = parser.parse_args()
    reports = []
    failed = False
    def exercise(version):
        lab = Lab(args.engine, version)
        print(f'PostgreSQL {version}: isolated lab starting', flush=True)
        try:
            report = lab.run()
            print(f'PostgreSQL {version}: {len(report["scripts"])} scripts and recovery/permission/lock checks passed', flush=True)
            return report
        except Exception as exc:
            print(f'PostgreSQL {version}: FAIL {exc}', flush=True)
            return {'postgres_major': int(version), 'error': str(exc)}
        finally:
            lab.close()
    with ThreadPoolExecutor(max_workers=args.jobs) as pool:
        futures = [pool.submit(exercise, version) for version in args.versions]
        for future in as_completed(futures):
            report = future.result()
            failed = failed or 'error' in report
            reports.append(report)
            reports.sort(key=lambda r: r['postgres_major'])
            destination = ROOT / args.output
            destination.parent.mkdir(parents=True, exist_ok=True)
            destination.write_text(json.dumps(reports, indent=2) + '\n', encoding='utf-8')
    return int(failed)


if __name__ == '__main__':
    sys.exit(main())
