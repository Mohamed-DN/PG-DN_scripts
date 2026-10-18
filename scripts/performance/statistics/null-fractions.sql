-- Title: Column null fraction metadata
-- Description: Rank analyzed columns by estimated null fraction and show analysis context.
-- Postgres: 14–18 (verificato)
-- Privilege: CONNECT and SELECT on analyzed columns; pg_monitor does not bypass pg_stats visibility
-- Risk: read-only
-- Source: original; https://www.postgresql.org/docs/18/view-pg-stats.html
-- Runbook: procedures/slow-queries.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Interpretazione e limiti: null_frac deriva dal campione ANALYZE, non da un conteggio esatto; NULL elevati possono essere intenzionali.
SELECT p.schemaname,p.tablename,p.attname,p.null_frac,p.n_distinct,t.n_live_tup,t.n_mod_since_analyze,
       t.last_analyze,t.last_autoanalyze
FROM pg_catalog.pg_stats p
JOIN pg_catalog.pg_stat_user_tables t ON t.schemaname = p.schemaname
AND t.relname = p.tablename
WHERE p.schemaname !~ '^pg_'
    AND p.schemaname <> 'information_schema'
ORDER BY p.null_frac DESC
LIMIT 300;
COMMIT;
