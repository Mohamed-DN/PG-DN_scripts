-- Title: Checkpoint setting context
-- Description: Show checkpoint and background write settings relevant to observed counter trends.
-- Postgres: 14–18 (verificato)
-- Privilege: CONNECT
-- Risk: read-only
-- Source: original; https://www.postgresql.org/docs/18/runtime-config-wal.html
-- Runbook: procedures/monitoring.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Interpretazione e limiti: la configurazione fornisce contesto ma non prova pressione; confrontarla con contatori checkpoint e metriche storage.
SELECT name,setting,unit,source
FROM pg_catalog.pg_settings
WHERE name IN ('checkpoint_timeout','checkpoint_completion_target','max_wal_size','min_wal_size','wal_buffers',
               'full_page_writes','wal_compression','bgwriter_delay','bgwriter_lru_maxpages',
               'bgwriter_lru_multiplier')
ORDER BY name;
COMMIT;
