-- Title: HOT update ratio
-- Description: Report HOT updates against total updates with table size context.
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
-- Interpretazione e limiti: i contatori sono cumulativi dal reset; una quota HOT bassa da sola non indica un difetto.
SELECT schemaname,relname,n_tup_upd,n_tup_hot_upd,
       round(100.0 * n_tup_hot_upd / nullif(n_tup_upd, 0), 2) AS hot_update_pct,n_live_tup,n_dead_tup,pg_catalog.pg_total_relation_size(relid) AS total_bytes
FROM pg_catalog.pg_stat_user_tables
ORDER BY n_tup_upd DESC
LIMIT 250;
COMMIT;
