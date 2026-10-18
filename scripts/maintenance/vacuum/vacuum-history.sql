-- Title: Per-table vacuum history
-- Description: Compare vacuum counts, latest timestamps and dead tuple estimates by table.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_monitor for complete statistics visibility
-- Risk: read-only
-- Source: original; https://www.postgresql.org/docs/18/monitoring-stats.html
-- Runbook: procedures/vacuum-bloat.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Interpretazione e limiti: i timestamp possono essere NULL dopo un reset o prima del primo avvio; consultare i log per durata ed esito.
SELECT schemaname,relname,vacuum_count,autovacuum_count,last_vacuum,last_autovacuum,n_live_tup,n_dead_tup
FROM pg_catalog.pg_stat_user_tables
ORDER BY coalesce(last_autovacuum, last_vacuum, '-infinity'::timestamptz),n_dead_tup DESC
LIMIT 250;
COMMIT;
