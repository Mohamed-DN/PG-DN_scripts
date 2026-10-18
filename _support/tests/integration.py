#!/usr/bin/env python3
"""Run curated SQL and recovery checks on disposable PostgreSQL containers."""
from __future__ import annotations
import argparse
import hashlib
from concurrent.futures import ThreadPoolExecutor, as_completed
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import time
import uuid

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / '_support/tools'))
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
CREATE TABLE pgdn_fixture.customers(id integer PRIMARY KEY);
INSERT INTO pgdn_fixture.customers VALUES(1);
CREATE TABLE pgdn_fixture.fk_missing(id int PRIMARY KEY,customer_id int REFERENCES pgdn_fixture.customers(id));
CREATE TABLE pgdn_fixture.fk_covered(id int PRIMARY KEY,customer_id int REFERENCES pgdn_fixture.customers(id));
CREATE INDEX fk_covered_lookup ON pgdn_fixture.fk_covered(customer_id);
CREATE TABLE pgdn_fixture.fk_partial(id int,customer_id int REFERENCES pgdn_fixture.customers(id));
CREATE INDEX fk_partial_lookup ON pgdn_fixture.fk_partial(customer_id) WHERE customer_id > 0;
CREATE TABLE pgdn_fixture.fk_include(id int,customer_id int REFERENCES pgdn_fixture.customers(id));
CREATE INDEX fk_include_lookup ON pgdn_fixture.fk_include(id) INCLUDE(customer_id);
CREATE TABLE pgdn_fixture.composite_parent(a int,b int,PRIMARY KEY(a,b));
CREATE TABLE pgdn_fixture.fk_reversed(a int,b int,FOREIGN KEY(a,b) REFERENCES pgdn_fixture.composite_parent(a,b));
CREATE INDEX fk_reversed_lookup ON pgdn_fixture.fk_reversed(b,a);
CREATE TABLE pgdn_fixture.fk_interleaved(a int,b int,c int,FOREIGN KEY(a,b) REFERENCES pgdn_fixture.composite_parent(a,b));
CREATE INDEX fk_interleaved_lookup ON pgdn_fixture.fk_interleaved(a,c,b);
ALTER TABLE pgdn_fixture.fk_missing ADD CONSTRAINT fk_not_valid FOREIGN KEY(customer_id) REFERENCES pgdn_fixture.customers(id) NOT VALID;
CREATE TABLE pgdn_fixture.rls_no_policy(id int);
ALTER TABLE pgdn_fixture.rls_no_policy ENABLE ROW LEVEL SECURITY;
CREATE TABLE pgdn_fixture.rls_with_policy(id int);
ALTER TABLE pgdn_fixture.rls_with_policy ENABLE ROW LEVEL SECURITY;
CREATE POLICY reader_policy ON pgdn_fixture.rls_with_policy FOR SELECT USING(true);
CREATE TYPE pgdn_fixture.order_status AS ENUM('draft','paid');
CREATE DOMAIN pgdn_fixture.positive_int AS integer CHECK(VALUE>0);
CREATE VIEW pgdn_fixture.order_view AS SELECT id FROM pgdn_fixture.orders;
CREATE MATERIALIZED VIEW pgdn_fixture.order_summary AS SELECT count(*) AS row_count FROM pgdn_fixture.orders;
CREATE TABLE pgdn_fixture.partitioned_orders(id int) PARTITION BY RANGE(id);
CREATE TABLE pgdn_fixture.partition_p1 PARTITION OF pgdn_fixture.partitioned_orders FOR VALUES FROM(0) TO(100);
CREATE TABLE pgdn_fixture.partition_p2 PARTITION OF pgdn_fixture.partitioned_orders FOR VALUES FROM(100) TO(200);
CREATE INDEX partitioned_id_idx ON pgdn_fixture.partitioned_orders(id);
CREATE SEQUENCE pgdn_fixture.near_limit MINVALUE 1 MAXVALUE 10 START WITH 9 CACHE 1;
SELECT nextval('pgdn_fixture.near_limit');
CREATE SCHEMA "Case.Schema";
CREATE TABLE "Case.Schema"."Weird Table"("Key A" int);
INSERT INTO "Case.Schema"."Weird Table" SELECT i FROM generate_series(1,10) i;
ANALYZE "Case.Schema"."Weird Table";
SELECT pg_create_physical_replication_slot('pgdn_reserved',true);
SELECT pg_create_logical_replication_slot('pgdn_logical','pgoutput');
SELECT count(*) FROM pgdn_fixture.orders;
''')
        self.command('cp', str(ROOT / 'scripts'), self.name + ':/tmp/pgdn-scripts')
        for item in scripts():
            row = {'path': item['path'], 'sha256': hashlib.sha256((ROOT / item['path']).read_bytes()).hexdigest()}
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
        def diagnosis(relative):
            return self.sql('\\i /tmp/pgdn-scripts/' + relative + '\n').stdout
        fk_rows = diagnosis('performance/indexes/foreign-keys-without-index.sql')
        for name in ('fk_missing','fk_partial','fk_include','fk_interleaved'):
            if f'|{name}|' not in fk_rows:
                raise RuntimeError('Foreign-key diagnosis missed ' + name)
        for name in ('fk_covered','fk_reversed'):
            if f'|{name}|' in fk_rows:
                raise RuntimeError('Foreign-key diagnosis falsely rejected usable index: ' + name)
        report['checks']['foreign_key_prefix_partial_include_and_reversed_keys'] = True
        rls_rows = diagnosis('security/privileges/rls-enabled-without-policy.sql')
        if '|rls_no_policy|' not in rls_rows or '|rls_with_policy|' in rls_rows:
            raise RuntimeError('RLS policy-presence diagnosis mismatch')
        report['checks']['rls_policy_presence_positive_negative'] = True
        if '|fk_not_valid|' not in diagnosis('administration/inventory/unvalidated-constraints.sql'):
            raise RuntimeError('NOT VALID constraint not detected')
        report['checks']['unvalidated_constraint_detected'] = True
        partition_rows = [line for line in diagnosis('performance/statistics/partition-index-attachments.sql').splitlines()
                          if line.startswith('pgdn_fixture|')]
        if len(partition_rows) != 2 or {line.split('|')[4] for line in partition_rows} != {'partition_p1','partition_p2'}:
            raise RuntimeError('Partition-index attachment query produced missing or sibling cross-product rows')
        report['checks']['partition_indexes_attached_to_correct_children'] = True
        types = diagnosis('administration/inventory/types-enums-domains.sql')
        if 'order_status' not in types or 'positive_int' not in types or 'draft' not in types or 'paid' not in types:
            raise RuntimeError('Enum/domain inventory did not report the fixture')
        report['checks']['enum_domain_inventory'] = True
        sequence_rows = diagnosis('performance/statistics/sequence-headroom.sql')
        if not any('|near_limit|' in line and line.endswith('|1') for line in sequence_rows.splitlines()):
            raise RuntimeError('Sequence headroom should be one remaining increment')
        report['checks']['sequence_headroom_does_not_consume_values'] = (
            self.sql('SELECT last_value FROM pgdn_fixture.near_limit;').stdout.strip() == '9')
        if not report['checks']['sequence_headroom_does_not_consume_values']:
            raise RuntimeError('Sequence diagnosis changed the sequence value')
        if 'Case.Schema|Weird Table|' not in diagnosis('performance/statistics/column-skew-metadata.sql'):
            raise RuntimeError('Column statistics did not support quoted schema and table names')
        report['checks']['quoted_identifiers_supported'] = True
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
                       '-c', 'BEGIN; LOCK TABLE pgdn_fixture.orders IN ACCESS EXCLUSIVE MODE; SELECT pg_sleep(12); COMMIT;']
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
                    blocking_result = self.sql('\\i /tmp/pgdn-scripts/monitoring/activity/blocking-sessions.sql\n')
                    if 'pgdn_fixture.orders' not in blocking_result.stdout:
                        raise RuntimeError('Curated blocking query did not report the blocked fixture')
                    report['checks']['curated_blocker_query_reports_waiter'] = True
                    lock_summary = diagnosis('monitoring/activity/waiting-locks-by-relation.sql')
                    blocker_summary = diagnosis('monitoring/activity/blocking-impact.sql')
                    if 'pgdn_fixture.orders' not in lock_summary or not any(
                        line and line.split('|')[0].isdigit() for line in blocker_summary.splitlines()
                    ):
                        raise RuntimeError('Lock aggregation diagnostics missed the live contention')
                    report['checks']['lock_aggregation_reports_live_contention'] = True
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
