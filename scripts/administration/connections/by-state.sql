-- Title: Connections by state
-- Description: Summarize visible sessions by database, role, state and wait class.
-- Postgres: 14+
-- Privilege: pg_read_all_stats for complete details
-- Risk: read-only
-- Source: user:+Postgres_Main_commands.sql
-- Runbook: runbooks/triage.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT datname,usename,state,wait_event_type,count(*) AS sessions FROM pg_catalog.pg_stat_activity GROUP BY datname,usename,state,wait_event_type ORDER BY sessions DESC LIMIT 100;
COMMIT;
