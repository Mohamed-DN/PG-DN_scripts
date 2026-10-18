-- Title: Non-default settings
-- Description: Show only allowlisted diagnostic settings; connection strings, commands, paths and secrets are excluded.
-- Postgres: 14+
-- Privilege: pg_read_all_settings for full view
-- Risk: read-only
-- Source: user:+Postgres_Comandi_Principali_Diagnostica_Stats_Ruoli.sql
-- Runbook: runbooks/monitoring.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT name,setting,unit,source,context,pending_restart FROM pg_catalog.pg_settings WHERE source<>'default' AND name=ANY(ARRAY['max_connections','shared_buffers','work_mem','maintenance_work_mem','effective_cache_size','autovacuum','autovacuum_work_mem','autovacuum_vacuum_scale_factor','autovacuum_vacuum_threshold','autovacuum_analyze_scale_factor','autovacuum_analyze_threshold','statement_timeout','lock_timeout','idle_in_transaction_session_timeout','checkpoint_timeout','max_wal_size','min_wal_size','wal_keep_size','max_slot_wal_keep_size','archive_mode','wal_level','track_io_timing','log_min_duration_statement']) ORDER BY name LIMIT 100;
COMMIT;
