-- Title: WAL counters
-- Description: Show cumulative WAL byte and record counters; compare snapshots for rates.
-- Postgres: 14+
-- Privilege: pg_read_all_stats
-- Risk: read-only
-- Source: user:PROBLEMA_WAL_POSTGRES.sql
-- Runbook: runbooks/wal-growth.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT wal_records,wal_fpi,wal_bytes,wal_buffers_full,stats_reset FROM pg_catalog.pg_stat_wal;
COMMIT;
