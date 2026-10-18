-- Title: Backup API activity
-- Description: List active legacy and current backup API calls as supporting evidence.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_read_all_stats
-- Risk: read-only
-- Source: original; https://www.postgresql.org/docs/18/monitoring-stats.html
-- Runbook: procedures/backup-restore.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Interpretazione e limiti: la presenza del processo non prova il completamento di un backup consistente; verificare manifest e log del software di backup.
SELECT pid,backend_type,application_name,client_addr,state,wait_event_type,wait_event, query_start,
       clock_timestamp() - query_start AS age
FROM pg_catalog.pg_stat_activity
WHERE state = 'active'
    AND pid <> pg_catalog.pg_backend_pid()
    AND query ~* '(pg_start_backup|pg_stop_backup|pg_backup_start|pg_backup_stop)'
ORDER BY query_start
LIMIT 100;
COMMIT;
