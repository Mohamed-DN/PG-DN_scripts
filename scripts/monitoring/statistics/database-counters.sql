-- Title: Database counters
-- Description: Show cumulative transaction, deadlock, temp and block counters; use snapshot deltas for rates.
-- Postgres: 14+
-- Privilege: pg_read_all_stats
-- Risk: read-only
-- Source: user:POSTGRES_STATS.Sql
-- Runbook: runbooks/monitoring.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT datname,stats_reset,xact_commit,xact_rollback,deadlocks,temp_files,temp_bytes,blks_read,blks_hit,round(100.0*blks_hit/NULLIF(blks_hit+blks_read,0),2) AS shared_buffer_hit_pct FROM pg_catalog.pg_stat_database ORDER BY datname LIMIT 100;
COMMIT;
