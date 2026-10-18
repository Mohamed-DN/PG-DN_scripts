-- Title: Index build progress detail
-- Description: Show phase, locker, block and tuple counters for index builds.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_read_all_stats
-- Risk: read-only
-- Source: original; https://www.postgresql.org/docs/18/progress-reporting.html
-- Runbook: procedures/triage.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Interpretazione e limiti: i totali possono essere zero nelle fasi senza lavoro misurabile; le build concurrent possono attendere snapshot precedenti.
SELECT pid,datname,relid::regclass AS table_name,index_relid::regclass AS index_name,command,phase,
       lockers_total,lockers_done,blocks_total,blocks_done,tuples_total,tuples_done,partitions_total,
       partitions_done
FROM pg_catalog.pg_stat_progress_create_index
WHERE datid =
        (SELECT oid
         FROM pg_catalog.pg_database
         WHERE datname = current_database())
ORDER BY pid
LIMIT 100;
COMMIT;
