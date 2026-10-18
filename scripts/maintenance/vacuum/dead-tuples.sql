-- Title: Dead tuple estimates
-- Description: Rank user tables by estimated dead tuples and show last maintenance times.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT; statistics may be stale
-- Risk: read-only
-- Source: user:+Postgres_Main_commands.sql
-- Runbook: procedures/vacuum-bloat.md
-- Usarla per ordinare tabelle secondo la stima di tuple morte e verificare gli ultimi timestamp di manutenzione.
-- n_live_tup/n_dead_tup sono stime e dead_pct è la quota calcolata; last_* distingue vacuum e analyze manuali o automatici.
-- Le statistiche possono essere stale o resettate: dead tuples non equivalgono a bloat né a spazio recuperabile.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT schemaname,relname,n_live_tup,n_dead_tup,
       round(100.0 * n_dead_tup / NULLIF(n_live_tup + n_dead_tup, 0), 2) AS dead_pct,last_vacuum,last_autovacuum,last_analyze,last_autoanalyze
FROM pg_catalog.pg_stat_user_tables
ORDER BY n_dead_tup DESC NULLS LAST
LIMIT 100;
COMMIT;
