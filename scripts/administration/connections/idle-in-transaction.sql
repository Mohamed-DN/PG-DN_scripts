-- Title: Idle transactions
-- Description: Find idle-in-transaction sessions and transaction age.
-- Postgres: 14+
-- Privilege: pg_read_all_stats; otherwise own sessions
-- Risk: read-only
-- Source: user:+Postgres_Main_commands.sql
-- Runbook: runbooks/locks.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT pid,datname,usename,application_name,state,clock_timestamp()-xact_start AS xact_age,left(query,400) AS query_prefix FROM pg_catalog.pg_stat_activity WHERE state LIKE 'idle in transaction%' ORDER BY xact_start NULLS LAST LIMIT 100;
COMMIT;
