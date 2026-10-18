-- Title: WAL and checkpoint settings
-- Description: Inspect safe WAL retention and archiving settings; command strings, paths and secrets are excluded.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_read_all_settings for full view
-- Risk: read-only
-- Source: user:PROBLEMA_WAL_POSTGRES.sql
-- Runbook: procedures/wal-growth.md
-- Usarla per controllare soglie WAL, checkpoint e archiviazione durante un'indagine di crescita.
-- setting e unit descrivono il valore attivo; source e pending_restart aiutano a ricostruirne l'applicazione.
-- Non prova che l'archiver funzioni né quantifica WAL presente: affiancare contatori, slot e spazio su disco.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT name,setting,unit,source,pending_restart
FROM pg_catalog.pg_settings
WHERE name = ANY(ARRAY['archive_mode',
                 'archive_timeout', 'checkpoint_timeout', 'max_wal_size', 'min_wal_size', 'wal_keep_size',
                 'wal_level', 'max_slot_wal_keep_size'])
ORDER BY name;
COMMIT;
