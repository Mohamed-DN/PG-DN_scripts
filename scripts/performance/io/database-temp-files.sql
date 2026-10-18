-- Title: Database temporary file counters
-- Description: Rank databases by temporary file volume and count since reset.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_monitor
-- Risk: read-only
-- Source: original; https://www.postgresql.org/docs/18/monitoring-stats.html
-- Runbook: procedures/monitoring.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Interpretazione e limiti: i contatori sono cumulativi e sommano cause diverse di spill; isolare le query prima di modificare la memoria.
SELECT datname,temp_files,temp_bytes,pg_catalog.pg_size_pretty(temp_bytes) AS temp_size,stats_reset
FROM pg_catalog.pg_stat_database
WHERE datname IS NOT NULL
ORDER BY temp_bytes DESC
LIMIT 100;
COMMIT;
