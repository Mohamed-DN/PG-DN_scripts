-- Title: Base backup progress
-- Description: Show base backup phase, streamed bytes and tablespace counters.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_read_all_stats
-- Risk: read-only
-- Source: original; https://www.postgresql.org/docs/18/progress-reporting.html
-- Runbook: procedures/backup-restore.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Interpretazione e limiti: il totale è stimato e può cambiare; verificare il completamento con il client e il manifest del backup.
SELECT p.pid,a.application_name,a.client_addr,p.phase,p.backup_total,p.backup_streamed,
       round(100.0 * p.backup_streamed / nullif(p.backup_total,
                                             0), 2) AS streamed_pct,p.tablespaces_total,p.tablespaces_streamed,clock_timestamp() - a.query_start AS elapsed
FROM pg_catalog.pg_stat_progress_basebackup p
JOIN pg_catalog.pg_stat_activity a USING(pid)
ORDER BY a.query_start
LIMIT 100;
COMMIT;
