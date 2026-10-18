-- Title: Vacuum and autovacuum settings
-- Description: Show allowlisted vacuum-related settings; command strings, paths and secrets are excluded.
-- Postgres: 14+
-- Privilege: pg_read_all_settings for full values
-- Risk: read-only
-- Source: user:script 1
-- Runbook: runbooks/vacuum-bloat.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT name,setting,unit,source,pending_restart FROM pg_catalog.pg_settings WHERE name=ANY(ARRAY['autovacuum','autovacuum_analyze_scale_factor','autovacuum_analyze_threshold','autovacuum_freeze_max_age','autovacuum_max_workers','autovacuum_multixact_freeze_max_age','autovacuum_naptime','autovacuum_vacuum_cost_delay','autovacuum_vacuum_cost_limit','autovacuum_vacuum_scale_factor','autovacuum_vacuum_threshold','autovacuum_work_mem','vacuum_cost_delay','vacuum_cost_limit','vacuum_freeze_min_age','vacuum_freeze_table_age','vacuum_multixact_freeze_min_age','vacuum_multixact_freeze_table_age']) ORDER BY name LIMIT 100;
COMMIT;
