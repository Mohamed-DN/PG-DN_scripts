-- Title: WAL and checkpoint settings
-- Description: Inspect safe WAL retention and archiving settings; command strings, paths and secrets are excluded.
-- Postgres: 14+
-- Privilege: pg_read_all_settings for full view
-- Risk: read-only
-- Source: user:PROBLEMA_WAL_POSTGRES.sql
-- Runbook: runbooks/wal-growth.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT name,setting,unit,source,pending_restart FROM pg_catalog.pg_settings WHERE name=ANY(ARRAY['archive_mode','archive_timeout','checkpoint_timeout','max_wal_size','min_wal_size','wal_keep_size','wal_level','max_slot_wal_keep_size']) ORDER BY name;
COMMIT;
