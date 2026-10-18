-- Title: Relation block I/O counters
-- Description: Compare cumulative heap, index and toast block read/hit counters for user tables.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_monitor for complete statistics visibility; database CONNECT
-- Risk: read-only
-- Source: original; https://github.com/andyatkinson/pg_scripts/blob/b7736708e0cfa5b8a3e88df8b1704a80b3566896/table_stats.sql; https://www.postgresql.org/docs/18/monitoring-stats.html
-- Runbook: procedures/monitoring.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- I contatori sono cumulativi e possono essere stati azzerati; read non significa sempre disco fisico,
-- perché il sistema operativo può servire la pagina. heap_blks_hit/read non sono confrontabili con
-- contatori OS senza una finestra temporale e la stessa definizione di cache.
SELECT schemaname,relname,heap_blks_read,heap_blks_hit, idx_blks_read,idx_blks_hit,toast_blks_read,
       toast_blks_hit, pg_catalog.pg_size_pretty(pg_catalog.pg_total_relation_size(relid)) AS total_size
FROM pg_catalog.pg_statio_user_tables
ORDER BY heap_blks_read + idx_blks_read + toast_blks_read DESC
LIMIT 200;
COMMIT;
