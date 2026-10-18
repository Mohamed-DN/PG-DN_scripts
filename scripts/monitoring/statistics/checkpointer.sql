-- Title: Checkpointer counters
-- Description: Show checkpoint and restartpoint counters on PostgreSQL 17+; cumulative counters need delta snapshots.
-- Postgres: 17+
-- Privilege: pg_read_all_stats
-- Risk: read-only
-- Source: user:script 4
-- Runbook: runbooks/monitoring.md
\set ON_ERROR_STOP on
\pset pager off
SELECT (current_setting('server_version_num')::integer >= 170000) AS pg_version_supported \gset
\if :pg_version_supported
\else
\echo PostgreSQL 17+ is required.
\quit
\endif
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT num_timed,num_requested,restartpoints_timed,restartpoints_req,restartpoints_done,write_time,sync_time,buffers_written,stats_reset FROM pg_catalog.pg_stat_checkpointer;
COMMIT;
