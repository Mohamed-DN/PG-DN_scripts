-- Title: Long-running queries
-- Description: Find active queries older than one minute; query text may contain sensitive literals.
-- Postgres: 14+
-- Privilege: pg_read_all_stats for complete details
-- Risk: read-only
-- Source: user:+Postgres_Main_commands.sql
-- Runbook: runbooks/slow-queries.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT pid,datname,usename,application_name,clock_timestamp()-query_start AS runtime,wait_event_type,wait_event,left(query,400) AS query_prefix FROM pg_catalog.pg_stat_activity WHERE state='active' AND query_start<clock_timestamp()-interval '1 minute' AND pid<>pg_catalog.pg_backend_pid() ORDER BY query_start LIMIT 100;
COMMIT;
