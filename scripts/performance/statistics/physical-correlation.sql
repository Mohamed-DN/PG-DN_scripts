-- Title: Column physical correlation
-- Description: Review planner correlation estimates with analysis timestamps.
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
-- Interpretazione e limiti: Correlazione vicina a ±1 indica associazione con l’ordine fisico stimato, non misura direttamente la velocità né il clustering attuale.
SELECT p.schemaname,p.tablename,p.attname,p.correlation,abs(p.correlation) AS absolute_correlation,
       p.null_frac,p.n_distinct,t.last_analyze,t.last_autoanalyze
FROM pg_catalog.pg_stats p
LEFT JOIN pg_catalog.pg_stat_user_tables t ON t.schemaname = p.schemaname
AND t.relname = p.tablename
WHERE p.schemaname !~ '^pg_'
    AND p.schemaname <> 'information_schema'
ORDER BY absolute_correlation NULLS FIRST
LIMIT 300;
COMMIT;
