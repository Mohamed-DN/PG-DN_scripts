-- Title: Checkpointer activity counters
-- Description: Inspect PostgreSQL 17+ checkpointer counters including timed/requested checkpoints and write time.
-- Postgres: 17–18 (verificato; pg_stat_checkpointer separata da pg_stat_bgwriter in PostgreSQL 17)
-- Privilege: pg_monitor for complete cluster statistics visibility
-- Risk: read-only
-- Source: original; https://github.com/andyatkinson/pg_scripts/blob/b7736708e0cfa5b8a3e88df8b1704a80b3566896/pg_stat_database.sql; https://www.postgresql.org/docs/18/monitoring-stats.html
-- Runbook: procedures/monitoring.md
\set ON_ERROR_STOP on
\pset pager off
SELECT current_setting('server_version_num')::integer >= 170000 AS version_supported \gset
\if :version_supported
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Usare solo su PostgreSQL 17+ perché il catalogo è stato separato e le colonne delle release 14–16
-- non coincidono. I tempi sono aggregati dall'ultimo reset: una media può nascondere picchi o storage
-- lento; confrontare campioni e log checkpoint prima di modificare configurazione.
SELECT num_timed,num_requested,write_time,sync_time, buffers_written,stats_reset
FROM pg_catalog.pg_stat_checkpointer;
COMMIT;
\else
\echo PostgreSQL 17+ is required; query skipped.
\endif
