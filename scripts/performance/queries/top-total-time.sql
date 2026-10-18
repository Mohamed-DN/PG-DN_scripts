-- Title: Statements by total time
-- Description: Rank pg_stat_statements by cumulative execution time; extension must already be available.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_read_all_stats; extension already installed
-- Risk: read-only
-- Source: user:POSTGRES_STATS.Sql
-- Runbook: procedures/slow-queries.md
-- Usarla per ordinare statement per tempo totale e trovare il contributo cumulativo maggiore.
-- calls, total_exec_time e mean_exec_time separano volume da costo medio; shared block counters aggiungono contesto cache.
-- I valori sono cumulativi dalla finestra delle statistiche; il testo query può contenere dettagli sensibili.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT EXISTS
    (SELECT 1
     FROM pg_catalog.pg_extension
     WHERE extname = 'pg_stat_statements') AS pgss_available \gset
\if :pgss_available
SELECT n.nspname AS pgss_schema
FROM pg_catalog.pg_extension e
JOIN pg_catalog.pg_namespace n ON n.oid = e.extnamespace
WHERE e.extname = 'pg_stat_statements' \gset
SELECT queryid,calls,total_exec_time,mean_exec_time,rows,shared_blks_read,shared_blks_hit,
       left(query, 400) AS query_prefix
FROM :"pgss_schema".pg_stat_statements
ORDER BY total_exec_time DESC
LIMIT 50;
\else
\echo pg_stat_statements is not installed in this database; query skipped.
\endif
COMMIT;
