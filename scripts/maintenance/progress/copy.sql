-- Title: COPY progress
-- Description: Show COPY phase counters and completion estimate when total bytes are known.
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
-- Interpretazione e limiti: il totale può essere sconosciuto per alcune sorgenti; la percentuale non stima il tempo residuo.
SELECT pid,datname,relid::regclass AS relation,command,type,bytes_processed,bytes_total,
       round(100.0 * bytes_processed / nullif(bytes_total, 0), 2) AS bytes_pct,tuples_processed,tuples_excluded
FROM pg_catalog.pg_stat_progress_copy
WHERE datid =
        (SELECT oid
         FROM pg_catalog.pg_database
         WHERE datname = current_database())
ORDER BY pid
LIMIT 100;
COMMIT;
