-- Title: Index write pressure context
-- Description: Compare cumulative table writes, HOT updates, index count and index bytes.
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
-- Interpretazione e limiti: Contatori cumulativi dal reset; non stimano il costo marginale di ogni indice. Una quota HOT bassa richiede correlazione con fillfactor e colonne indicizzate.
SELECT s.schemaname,s.relname,s.n_tup_ins,s.n_tup_upd,s.n_tup_del,s.n_tup_hot_upd,
       round(100.0 * s.n_tup_hot_upd / nullif(s.n_tup_upd, 0), 2) AS hot_pct,count(i.indexrelid) AS index_count,
       coalesce(sum(pg_catalog.pg_relation_size(i.indexrelid)), 0) AS index_bytes
FROM pg_catalog.pg_stat_user_tables s
LEFT JOIN pg_catalog.pg_index i ON i.indrelid = s.relid
GROUP BY s.schemaname,s.relname,s.n_tup_ins,s.n_tup_upd,s.n_tup_del,s.n_tup_hot_upd
ORDER BY (s.n_tup_ins + s.n_tup_upd + s.n_tup_del) DESC
LIMIT 200;
COMMIT;
