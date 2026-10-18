-- Title: Index usage counter context
-- Description: Compare cumulative index usage counters, size and reset timestamp.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_monitor for complete statistics visibility
-- Risk: read-only
-- Source: original; https://www.postgresql.org/docs/18/monitoring-stats.html
-- Runbook: procedures/slow-queries.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Interpretazione e limiti: statistiche cumulative; indici unici e di vincolo possono essere necessari anche con poche scansioni. Non eliminarli sulla base dei contatori.
SELECT s.schemaname,s.relname,u.indexrelname,u.idx_scan,u.idx_tup_read,u.idx_tup_fetch,
       pg_catalog.pg_relation_size(u.indexrelid) AS index_bytes
FROM pg_catalog.pg_stat_user_indexes u
JOIN pg_catalog.pg_stat_user_tables s ON s.relid = u.relid
ORDER BY u.idx_scan ASC NULLS FIRST,index_bytes DESC
LIMIT 300;
COMMIT;
