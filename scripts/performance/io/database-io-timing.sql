-- Title: Database I/O timing
-- Description: Show cumulative block timings; zero can mean track_io_timing was disabled.
-- Postgres: 14+
-- Privilege: pg_read_all_stats
-- Risk: read-only
-- Source: user:script 4
-- Runbook: runbooks/monitoring.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT datname,blk_read_time,blk_write_time,stats_reset FROM pg_catalog.pg_stat_database ORDER BY blk_read_time+blk_write_time DESC LIMIT 100;
COMMIT;
