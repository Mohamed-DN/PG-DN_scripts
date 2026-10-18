-- Title: Recovery state
-- Description: Report recovery state and system identifier/timeline; control data access may require elevated privileges.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_monitor; control functions may need elevated rights
-- Risk: read-only
-- Source: user:+Postgres_Backup_Recovery.sql
-- Runbook: procedures/backup-restore.md
-- Usarla per confermare se il nodo è in recovery e raccogliere identificatore cluster e timeline.
-- system_identifier identifica il cluster; timeline_id proviene dai dati di controllo del checkpoint.
-- Le funzioni di controllo possono richiedere privilegi elevati; la query non confronta timeline con il primary né convalida un backup.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT pg_catalog.pg_is_in_recovery() AS in_recovery,(pg_catalog.pg_control_system()).system_identifier AS system_identifier,(pg_catalog.pg_control_checkpoint()).timeline_id AS timeline_id;
COMMIT;
