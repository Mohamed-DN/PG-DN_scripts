-- Title: Checkpoint counters
-- Description: Show checkpoint and background writer counters common across PostgreSQL 14–18.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_monitor
-- Risk: read-only
-- Source: original; https://www.postgresql.org/docs/18/monitoring-stats.html
-- Runbook: procedures/wal-growth.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Interpretazione e limiti: i contatori sono cumulativi; confrontare snapshot con reset coerenti. PostgreSQL 17 ha spostato diversi campi in pg_stat_checkpointer.
SELECT current_setting('server_version_num')::integer < 170000 AS legacy_checkpointer \gset
\if :legacy_checkpointer
SELECT checkpoints_timed,checkpoints_req,checkpoint_write_time,checkpoint_sync_time,buffers_checkpoint,
       buffers_clean,maxwritten_clean,buffers_backend,buffers_backend_fsync,buffers_alloc,stats_reset
FROM pg_catalog.pg_stat_bgwriter;
\else
SELECT num_timed,num_requested,restartpoints_timed,restartpoints_req,restartpoints_done,write_time,
       sync_time,buffers_written,stats_reset
FROM pg_catalog.pg_stat_checkpointer;
\endif
COMMIT;
