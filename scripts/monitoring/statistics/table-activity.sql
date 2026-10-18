-- Title: Table activity
-- Description: Show scans, estimated tuples and last maintenance timestamps.
-- Postgres: 14+
-- Privilege: database CONNECT; estimates and visibility vary
-- Risk: read-only
-- Source: user:POSTGRES_STATS.Sql
-- Runbook: runbooks/monitoring.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT schemaname,relname,seq_scan,idx_scan,n_live_tup,n_dead_tup,last_analyze,last_autoanalyze FROM pg_catalog.pg_stat_user_tables ORDER BY seq_scan DESC NULLS LAST LIMIT 100;
COMMIT;
