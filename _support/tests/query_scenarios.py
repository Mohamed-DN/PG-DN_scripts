"""Result assertions for synthetic catalog objects and controlled live sessions."""
from __future__ import annotations

from contextlib import contextmanager
from decimal import Decimal, ROUND_HALF_UP
from pathlib import Path
import re
import subprocess
import time


def result_lines(text):
    """Evidence lines, not a SQL row count (query text may itself contain newlines)."""
    return [line for line in text.splitlines() if line and line not in {'BEGIN', 'COMMIT', 'SET', 'Pager usage is off.'}]


def populate(lab):
    lab.sql((Path(__file__).parent / 'fixtures/extended.sql').read_text(encoding='utf-8'))
    invalid = lab.sql('CREATE UNIQUE INDEX CONCURRENTLY pgdn_invalid_index ON pgdn_fixture.duplicate_keys(id);', check=False)
    if invalid.returncode == 0 or 'duplicate' not in invalid.stderr.lower():
        raise RuntimeError('Failed unique index fixture was not rejected for duplicate data')
    lab.sql("CREATE SUBSCRIPTION pgdn_offline CONNECTION 'host=127.0.0.1 port=1 dbname=synthetic application_name=pgdn_redaction_canary' PUBLICATION pgdn_publication WITH(connect=false,create_slot=false,enabled=false);")
    lab.sql("BEGIN; INSERT INTO pgdn_fixture.prepared_target VALUES(1); PREPARE TRANSACTION 'pgdn_prepared';")
    # Force an external sort so the pg_stat_statements temporary-block report has a positive case.
    lab.sql("SET work_mem='64kB'; SELECT count(*) FROM (SELECT md5(i::text) AS payload FROM generate_series(1,100000) i ORDER BY payload) sorted;")
    lab.sql('SELECT pg_sleep(0.03) FROM generate_series(1,3);')


def wait_until(predicate, description, timeout=12, interval=.1):
    deadline = time.monotonic() + timeout
    while time.monotonic() < deadline:
        value = predicate()
        if value:
            return value
        time.sleep(interval)
    raise RuntimeError('Deadline exceeded: ' + description)


@contextmanager
def session(lab, application, statements, *, idle=False):
    """Own the entire psql process; cleanup affects only this disposable cluster."""
    process = subprocess.Popen(
        [lab.engine, 'exec', '-i', lab.name, 'psql', '-X', '-w', '-v', 'ON_ERROR_STOP=1',
         '-U', 'postgres', '-d', 'pgdn_lab', '-At'],
        stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
        text=True, encoding='utf-8', errors='replace')
    try:
        process.stdin.write(f"SET application_name='{application}';\n" + statements + '\n')
        process.stdin.flush()
        pid = wait_until(lambda: lab.sql(
            f"SELECT pid FROM pg_stat_activity WHERE application_name='{application}' AND backend_type='client backend'"
            + (" AND state='idle in transaction'" if idle else '') + ';').stdout.strip(), application)
        yield int(pid)
    finally:
        if process.poll() is None:
            # Cancel only this named test session, then let psql roll back/exit normally.
            lab.sql(f"SELECT pg_cancel_backend(pid) FROM pg_stat_activity WHERE application_name='{application}';", check=False)
            try:
                process.communicate('ROLLBACK;\n\\q\n', timeout=15)
            except (subprocess.TimeoutExpired, BrokenPipeError):
                process.kill()
                process.communicate(timeout=10)


def assert_results(lab, observed, report):
    checks = report.setdefault('scenario_checks', {})

    def check(name, paths, predicate):
        if not predicate():
            raise RuntimeError('Scenario assertion failed: ' + name)
        checks[name] = {'status': 'passed', 'scripts': ['scripts/' + p for p in paths]}

    def text(path):
        return observed['scripts/' + path]

    positives = {
        'administration/inventory/columns.sql': ('pgdn_fixture', 'optional'),
        'administration/inventory/constraints.sql': ('fk_not_valid', 'FOREIGN KEY'),
        'administration/inventory/databases.sql': ('pgdn_lab',),
        'administration/inventory/extensions.sql': ('postgres_fdw', 'extensions'),
        'administration/inventory/extensions-dependencies.sql': ('postgres_fdw',),
        'administration/inventory/fdw-metadata.sql': ('pgdn_foreign', 'pgdn_reader'),
        'administration/inventory/largest-relations.sql': ('toast_heap',),
        'administration/inventory/materialized-views.sql': ('order_summary',),
        'administration/inventory/object-dependencies.sql': ('order_view', 'orders'),
        'administration/inventory/ownership.sql': ('owned_table', 'pgdn_owner'),
        'administration/inventory/partition-tree.sql': ('partition_p1', 'partition_p2'),
        'administration/inventory/relations-detailed.sql': ('toast_heap', 'remote_metadata'),
        'administration/inventory/routines.sql': ('safe_definer', 'touch_row'),
        'administration/inventory/schemas.sql': ('pgdn_fixture', 'Case.Schema'),
        'administration/inventory/sequences.sql': ('near_limit', 'descending_limit'),
        'administration/inventory/triggers.sql': ('pgdn_touch', 'touch_row'),
        'administration/inventory/views-and-definitions.sql': ('order_view', 'orders'),
        'monitoring/activity/prepared-transactions.sql': ('pgdn_prepared',),
        'monitoring/statistics/table-statistics-coverage.sql': ('never_analyzed',),
        'performance/indexes/access-methods.sql': ('orders_payload_idx', 'btree'),
        'performance/indexes/constraint-index-signatures.sql': ('orders_pkey',),
        'performance/indexes/definitions.sql': ('orders_payload_idx',),
        'performance/indexes/index-validity-state.sql': ('pgdn_invalid_index',),
        'performance/indexes/invalid-indexes.sql': ('pgdn_invalid_index',),
        'performance/indexes/key-included-columns.sql': ('fk_include_lookup',),
        'performance/statistics/analyze-freshness.sql': ('never_analyzed',),
        'performance/statistics/column-skew-metadata.sql': ('null_sample', 'optional'),
        'performance/statistics/null-fractions.sql': ('null_sample', 'optional'),
        'performance/statistics/partition-hierarchy.sql': ('partition_p1', 'partition_p2'),
        'performance/statistics/physical-correlation.sql': ('null_sample',),
        'performance/statistics/sequence-context.sql': ('descending_limit',),
        'replication/logical/publications.sql': ('pgdn_publication',),
        'replication/logical/publication-tables.sql': ('pgdn_publication', 'orders'),
        'replication/logical/subscriptions.sql': ('pgdn_offline',),
        'replication/slots/logical-stats.sql': ('pgdn_logical',),
        'replication/slots/retention.sql': ('pgdn_logical', 'pgdn_reserved'),
        'replication/slots/wal-limit-headroom.sql': ('pgdn_logical',),
        'replication/slots/xmin-horizons.sql': ('pgdn_logical',),
        'security/privileges/database-acl.sql': ('pgdn_lab', 'CONNECT'),
        'security/privileges/effective-database-privileges.sql': ('pgdn_reader',),
        'security/privileges/public-schema-grants.sql': ('public_view', 'SELECT'),
        'security/privileges/relation-acl.sql': ('orders', 'pgdn_reader', 'SELECT'),
        'security/privileges/rls-policies.sql': ('reader_policy', 'rls_no_policy'),
        'security/privileges/routine-execute-grants.sql': ('safe_definer', 'pgdn_reader'),
        'security/privileges/routine-security-definer.sql': ('safe_definer',),
        'security/privileges/schema-acl.sql': ('pgdn_fixture', 'pgdn_reader'),
        'security/privileges/schema-effective-privileges.sql': ('pgdn_reader|pgdn_fixture|t|f',),
        'security/roles/default-acl.sql': ('pgdn_reader', 'pgdn_fixture'),
        'security/roles/expiring-logins.sql': ('pgdn_expired',),
        'security/roles/role-attributes.sql': ('pgdn_expired', 'pgdn_owner'),
        'security/roles/role-inventory.sql': ('pgdn_reader',),
        'security/roles/role-membership-edges.sql': ('pgdn_owner|pgdn_reader',),
    }
    for path, tokens in positives.items():
        check('fixture:' + path, [path], lambda p=path, ts=tokens: all(t in text(p) for t in ts))
    for path in ('administration/inventory/fdw-metadata.sql', 'replication/logical/subscriptions.sql'):
        check('option-values-not-exposed:' + path, [path], lambda p=path: 'pgdn_redaction_canary' not in text(p))

    duplicate = 'performance/indexes/duplicate-candidates.sql'
    pairs = [line.split('|')[2:4] for line in result_lines(text(duplicate)) if line.startswith('pgdn_fixture|')]
    check('duplicate-signature-positive-negative', [duplicate], lambda:
          any(set(pair) == {'orders_payload_idx', 'orders_payload_duplicate'} for pair in pairs)
          and not any(set(pair) == {'orders_partial_idx', 'orders_partial_other'} for pair in pairs))
    source = (Path(__file__).resolve().parents[2] / 'scripts' / duplicate).read_text(encoding='utf-8')
    mutated, replacements = re.subn(
        r'AND\s+\(pg_catalog\.pg_get_expr\(i1\.indpred,\s*i1\.indrelid\)\)\s+IS NOT DISTINCT\s+FROM\s+\(pg_catalog\.pg_get_expr\(i2\.indpred,\s*i2\.indrelid\)\)',
        '', source)
    if replacements != 1:
        raise RuntimeError('Duplicate-index mutation no longer targets exactly one predicate comparison')
    mutant_rows = lab.sql(mutated).stdout
    mutant_pairs = [line.split('|')[2:4] for line in result_lines(mutant_rows) if line.startswith('pgdn_fixture|')]
    check('mutation-detects-lost-partial-index-predicate', [duplicate], lambda:
          any(set(pair) == {'orders_partial_idx', 'orders_partial_other'} for pair in mutant_pairs))
    toast = 'maintenance/bloat/toast-breakdown.sql'
    toast_rows = [line.split('|') for line in result_lines(text(toast)) if line.startswith('pgdn_fixture|toast_heap|')]
    check('toast-allocation-is-nonzero', [toast], lambda: len(toast_rows) == 1 and int(toast_rows[0][4]) > 0)
    headroom = 'performance/statistics/sequence-headroom.sql'
    check('descending-sequence-headroom', [headroom], lambda:
          any('|descending_limit|' in line and line.endswith('|1') for line in result_lines(text(headroom))))
    identity = 'administration/inventory/server-info.sql'
    check('database-role-primary-readonly-identity', [identity], lambda:
          any(line.startswith('pgdn_lab|postgres|postgres|') and line.endswith('|f|on') for line in result_lines(text(identity))))
    nulls = 'performance/statistics/null-fractions.sql'
    check('known-half-null-population', [nulls], lambda:
          any(line.startswith('pgdn_fixture|null_sample|optional|0.5|') for line in result_lines(text(nulls))))
    for path, a, b, target in [
        ('monitoring/statistics/database-counters.sql', 8, 7, 9),
        ('monitoring/statistics/database-cache-hit.sql', 3, 2, 4),
        ('monitoring/statistics/database-transaction-ratio.sql', 3, 2, 4),
    ]:
        rows = [line.split('|') for line in result_lines(text(path)) if line.startswith('pgdn_lab|')]
        def correct_ratio():
            if len(rows) != 1:
                return False
            row = rows[0]
            numerator, other = Decimal(row[a]), Decimal(row[b])
            if numerator + other == 0:
                return row[target] == ''
            expected = (100 * numerator / (numerator + other)).quantize(Decimal('.01'), rounding=ROUND_HALF_UP)
            return Decimal(row[target]) == expected
        check('ratio-arithmetic:' + path, [path], correct_ratio)
    wal = 'wal/retention/wal-directory-dimensions.sql'
    wal_rows = [line.split('|') for line in result_lines(text(wal)) if line.split('|')[0].isdigit()]
    check('wal-segment-count-and-size', [wal], lambda:
          len(wal_rows) == 1 and int(wal_rows[0][1]) > 0 and int(wal_rows[0][4]) == int(wal_rows[0][5]) == 16777216
          and int(wal_rows[0][3]) >= int(wal_rows[0][1]) * 16777216)
    if int(lab.version) >= 16:
        membership = 'security/roles/membership.sql'
        check('role-membership-16-columns', [membership], lambda: 'pgdn_owner|pgdn_reader|' in text(membership))

    # The catalog fixture must not confer access to the unprivileged application role.
    allowed = lab.sql('SELECT count(*) FROM pgdn_fixture.orders;', user='pgdn_reader')
    denied = lab.sql('SELECT count(*) FROM pgdn_fixture.private_table;', user='pgdn_reader', check=False)
    check('application-role-select-boundary', ['security/privileges/relation-acl.sql'],
          lambda: allowed.stdout.strip() == '200' and denied.returncode != 0 and 'permission denied' in denied.stderr)
    lab.sql("ROLLBACK PREPARED 'pgdn_prepared';")


def live_results(lab, report):
    checks = report.setdefault('scenario_checks', {})

    def script(path):
        return lab.sql('\\i /tmp/pgdn-scripts/' + path + '\n').stdout

    def passed(name, paths):
        checks[name] = {'status': 'passed', 'scripts': ['scripts/' + p for p in paths]}

    with session(lab, 'pgdn_idle_fixture', 'BEGIN ISOLATION LEVEL REPEATABLE READ; SELECT * FROM pgdn_fixture.orders LIMIT 1;', idle=True) as pid:
        paths = ['administration/connections/idle-in-transaction.sql', 'administration/connections/oldest-backend-transactions.sql', 'administration/connections/xid-holding-backends.sql', 'maintenance/vacuum/oldest-transactions.sql']
        for path in paths:
            if f'{pid}|' not in script(path):
                raise RuntimeError('Idle transaction fixture missing from ' + path)
        passed('idle-transaction-and-identity', paths)
    with session(lab, 'pgdn_advisory_fixture', 'SELECT pg_advisory_lock(424242); SELECT pg_sleep(12);') as pid:
        path = 'monitoring/activity/advisory-locks.sql'
        wait_until(lambda: str(pid) in script(path), 'owned advisory lock')
        passed('real-advisory-lock', [path])
        active = 'administration/connections/active.sql'
        if f'{pid}|' not in script(active):
            raise RuntimeError('Active session not reported')
        passed('real-active-backend', [active])
    # COPY remains active while waiting for client data, without a timer or large data file.
    with session(lab, 'pgdn_copy_fixture', 'COPY pgdn_fixture.copy_target FROM STDIN;') as pid:
        path = 'maintenance/progress/copy.sql'
        wait_until(lambda: f'{pid}|' in script(path), 'COPY progress row')
        passed('real-copy-progress', [path])
    # A writer keeps a concurrent index build in a stable, observable waiting phase.
    with session(lab, 'pgdn_writer_fixture', 'BEGIN; UPDATE pgdn_fixture.orders SET touched=clock_timestamp() WHERE id=1;', idle=True):
        with session(lab, 'pgdn_index_fixture', 'CREATE INDEX CONCURRENTLY pgdn_live_index ON pgdn_fixture.orders(touched);') as pid:
            paths = ['maintenance/progress/create-index.sql', 'maintenance/progress/index-build.sql']
            for path in paths:
                wait_until(lambda p=path: f'{pid}|' in script(p), 'concurrent index build ' + path)
            passed('real-index-build-progress', paths)
    # Moderate heap size plus cost delay keeps real VACUUM/ANALYZE visible to the observer.
    lab.sql('CREATE TABLE pgdn_fixture.progress_heap(id int,payload text) WITH(autovacuum_enabled=false); '
            "INSERT INTO pgdn_fixture.progress_heap SELECT i,(SELECT string_agg(md5((i*32+j)::text),'') FROM generate_series(1,16) j) FROM generate_series(1,20000) i;")
    for operation, path in [('ANALYZE', 'maintenance/progress/analyze.sql'),
                            ('VACUUM (DISABLE_PAGE_SKIPPING)', 'maintenance/progress/vacuum.sql')]:
        with session(lab, 'pgdn_maintenance_fixture',
                     "SET vacuum_cost_delay='10ms'; SET vacuum_cost_limit=1; " + operation + ' pgdn_fixture.progress_heap;') as pid:
            wait_until(lambda: f'{pid}|' in script(path), operation + ' progress')
            passed('real-progress:' + path, [path])
    lab.sql('CREATE INDEX pgdn_unused_large ON pgdn_fixture.progress_heap(payload);')
    unused = 'performance/indexes/unused-candidates.sql'
    if 'pgdn_unused_large' not in script(unused):
        evidence = lab.sql("SELECT pg_relation_size('pgdn_fixture.pgdn_unused_large'),idx_scan FROM pg_stat_user_indexes WHERE indexrelname='pgdn_unused_large';").stdout.strip()
        raise RuntimeError('Large unused index fixture not reported; bytes|scans=' + evidence)
    passed('real-large-unused-index', [unused])
    # Values stay identical; a delayed immutable function makes the actual CLUSTER index rebuild observable.
    lab.sql("CREATE FUNCTION pgdn_fixture.slow_key(int) RETURNS int LANGUAGE plpgsql IMMUTABLE AS 'BEGIN RETURN $1; END'; "
            'CREATE INDEX pgdn_slow_cluster ON pgdn_fixture.progress_heap(pgdn_fixture.slow_key(id)); '
            "CREATE OR REPLACE FUNCTION pgdn_fixture.slow_key(int) RETURNS int LANGUAGE plpgsql IMMUTABLE AS 'BEGIN PERFORM pg_sleep(0.001); RETURN $1; END';")
    with session(lab, 'pgdn_cluster_fixture', 'CLUSTER pgdn_fixture.progress_heap USING pgdn_slow_cluster;') as pid:
        path = 'maintenance/progress/cluster-rewrite.sql'
        wait_until(lambda: f'{pid}|' in script(path), 'CLUSTER progress')
        passed('real-cluster-rewrite-progress', [path])
    start = "pg_start_backup('pgdn_fixture',true,false)" if int(lab.version) < 15 else "pg_backup_start('pgdn_fixture',true)"
    with session(lab, 'pgdn_backup_fixture', f'WITH b AS MATERIALIZED(SELECT {start} AS lsn) SELECT lsn,pg_sleep(20) FROM b;') as pid:
        path = 'backup/inspection/backup-api-activity.sql'
        wait_until(lambda: f'{pid}|' in script(path), 'real backup API statement')
        passed('real-backup-api-activity', [path])
    with session(lab, 'pgdn_long_fixture', 'SELECT pg_sleep(120);') as pid:
        wait_until(lambda: lab.sql(f"SELECT 1 FROM pg_stat_activity WHERE pid={pid} AND clock_timestamp()-query_start>interval '61 seconds';").stdout.strip(),
                   'query actually older than one minute', timeout=80, interval=2)
        path = 'monitoring/activity/long-running.sql'
        if f'{pid}|' not in script(path):
            raise RuntimeError('Long-running query not reported after the real threshold')
        passed('real-query-over-one-minute', [path])
