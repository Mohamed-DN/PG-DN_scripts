-- Title: Statistics reset times
-- Description: Show database statistics reset timestamps to interpret cumulative counters.
-- Postgres: 14+
-- Privilege: database CONNECT
-- Risk: read-only
-- Source: user:POSTGRES_STATS.Sql
-- Runbook: runbooks/monitoring.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT datname,stats_reset FROM pg_catalog.pg_stat_database ORDER BY datname LIMIT 100;
COMMIT;
