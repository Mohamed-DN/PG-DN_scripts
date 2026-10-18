-- Title: Table statistics coverage
-- Description: Find user tables with no recorded analyze or vacuum and report dead/live estimates.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_monitor for complete statistics visibility; database CONNECT
-- Risk: read-only
-- Source: original; https://github.com/andyatkinson/pg_scripts/blob/b7736708e0cfa5b8a3e88df8b1704a80b3566896/last_tables_autovacuumed.sql; https://www.postgresql.org/docs/18/monitoring-stats.html
-- Runbook: procedures/monitoring.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- NULL indica che l'operazione non risulta registrata nel periodo disponibile, non necessariamente
-- che la tabella non sia mai stata analizzata: statistiche possono essere state azzerate o la relazione
-- appena creata. n_live_tup e n_dead_tup sono stime; la query non conta fisicamente le righe.
SELECT schemaname,relname,n_live_tup,n_dead_tup, last_vacuum,last_autovacuum,last_analyze,last_autoanalyze,
       vacuum_count,autovacuum_count,analyze_count,autoanalyze_count
FROM pg_catalog.pg_stat_user_tables
WHERE last_analyze IS NULL
    AND last_autoanalyze IS NULL
ORDER BY n_live_tup DESC,schemaname,relname
LIMIT 500;
COMMIT;
