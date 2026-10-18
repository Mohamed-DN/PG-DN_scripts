-- Title: Archive status
-- Description: Inspect cumulative archive success and failure counters; archive ordering can have exceptions.
-- Postgres: 14+
-- Privilege: database CONNECT
-- Risk: read-only
-- Source: user:PROBLEMA_WAL_POSTGRES.sql
-- Runbook: runbooks/wal-growth.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT archived_count,last_archived_wal,last_archived_time,failed_count,last_failed_wal,last_failed_time,stats_reset FROM pg_catalog.pg_stat_archiver;
COMMIT;
