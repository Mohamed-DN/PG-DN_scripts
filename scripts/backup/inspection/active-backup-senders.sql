-- Title: Active backup senders
-- Description: Show current walsender activity as clues for a physical backup; validate against backup tooling.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_read_all_stats
-- Risk: read-only
-- Source: user:+Postgres_Backup_Recovery.sql
-- Runbook: procedures/backup-restore.md
-- Usarla come indizio durante un backup fisico per vedere backend di tipo walsender.
-- state/wait_event mostrano lo stato corrente; age misura il tempo dall'avvio backend, non la durata certa del backup.
-- Un walsender può servire anche la replica: confrontare application_name e tooling prima di attribuirgli uno scopo.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT pid,backend_type,application_name,client_addr,state,wait_event_type,wait_event,
       clock_timestamp() - backend_start AS age
FROM pg_catalog.pg_stat_activity
WHERE backend_type = 'walsender'
ORDER BY backend_start
LIMIT 100;
COMMIT;
