-- Title: Checkpointer counters
-- Description: Show checkpoint and restartpoint counters on PostgreSQL 17+; cumulative counters need delta snapshots.
-- Postgres: 17–18 (verificato)
-- Privilege: pg_read_all_stats
-- Risk: read-only
-- Source: user:script 4
-- Runbook: procedures/monitoring.md
-- Usarla su PostgreSQL 17+ per leggere contatori di checkpoint e restartpoint.
-- num_timed/num_requested e contatori restartpoint sono cumulativi; write_time e sync_time sono tempi accumulati con stats_reset come ancora.
-- Per ricavare rate o medie servono due snapshot dopo lo stesso reset; il totale non è una frequenza.
\set ON_ERROR_STOP on
\pset pager off
SELECT (current_setting('server_version_num')::integer >= 170000) AS pg_version_supported \gset
\if :pg_version_supported
\else
\echo PostgreSQL 17+ is required.
\quit
\endif
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT num_timed,num_requested,restartpoints_timed,restartpoints_req,restartpoints_done,write_time,
       sync_time,buffers_written,stats_reset
FROM pg_catalog.pg_stat_checkpointer;
COMMIT;
