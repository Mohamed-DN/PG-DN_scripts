-- Title: Analyze freshness
-- Description: Compare estimated modified tuples to live rows and latest ANALYZE timestamps.
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
-- Interpretazione e limiti: Stime cumulative e approssimate; partizioni e parent richiedono controlli separati.
SELECT schemaname,relname,n_live_tup,n_mod_since_analyze,
       round(100.0 * n_mod_since_analyze / nullif(n_live_tup + n_mod_since_analyze,
                                               0), 2) AS modified_estimate_pct,last_analyze,last_autoanalyze,analyze_count,autoanalyze_count
FROM pg_catalog.pg_stat_user_tables
ORDER BY n_mod_since_analyze DESC NULLS LAST
LIMIT 250;
COMMIT;
