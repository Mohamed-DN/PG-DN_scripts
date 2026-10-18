-- Title: CLUSTER and rewrite progress
-- Description: Show progress for CLUSTER and VACUUM FULL rewrites.
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
-- Interpretazione e limiti: i contatori dei blocchi cambiano significato tra le fasi; la percentuale non stima linearmente il tempo residuo.
SELECT p.pid,p.datname,p.relid::regclass AS relation,p.command,p.phase, p.heap_tuples_scanned,
       p.heap_tuples_written,p.heap_blks_total,p.heap_blks_scanned, p.index_rebuild_count,
       clock_timestamp() - a.query_start AS elapsed
FROM pg_catalog.pg_stat_progress_cluster p
JOIN pg_catalog.pg_stat_activity a USING(pid)-- Gli OID di relazione hanno significato nel solo database corrente.

WHERE p.datid =
        (SELECT oid
         FROM pg_catalog.pg_database
         WHERE datname = current_database())
ORDER BY a.query_start
LIMIT 100;
COMMIT;
