-- Title: Old transactions
-- Description: Inspect backends with open transactions; long transactions can delay cleanup.
-- Postgres: 14+
-- Privilege: pg_read_all_stats for complete details
-- Risk: read-only
-- Source: user:+Postgres_Troubleshooting_WAL_Replica_Vacuum_Bloat.sql
-- Runbook: runbooks/vacuum-bloat.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT pid,datname,usename,state,clock_timestamp()-xact_start AS age,backend_xid,backend_xmin,wait_event_type,wait_event,left(query,300) AS query_prefix FROM pg_catalog.pg_stat_activity WHERE xact_start IS NOT NULL ORDER BY xact_start LIMIT 100;
COMMIT;
