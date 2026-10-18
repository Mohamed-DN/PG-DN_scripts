-- Title: Recovery state
-- Description: Report recovery state and system identifier/timeline; control data access may require elevated privileges.
-- Postgres: 14+
-- Privilege: pg_monitor; control functions may need elevated rights
-- Risk: read-only
-- Source: user:+Postgres_Backup_Recovery.sql
-- Runbook: runbooks/backup-restore.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT pg_catalog.pg_is_in_recovery() AS in_recovery,(pg_catalog.pg_control_system()).system_identifier AS system_identifier,(pg_catalog.pg_control_checkpoint()).timeline_id AS timeline_id;
COMMIT;
