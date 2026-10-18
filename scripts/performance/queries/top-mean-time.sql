-- Title: Statements by mean time
-- Description: Rank normalized statements by mean time; low call counts may skew results.
-- Postgres: 14+
-- Privilege: pg_read_all_stats; extension already installed
-- Risk: read-only
-- Source: user:POSTGRES_STATS.Sql
-- Runbook: runbooks/slow-queries.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT EXISTS (SELECT 1 FROM pg_catalog.pg_extension WHERE extname='pg_stat_statements') AS pgss_available \gset
\if :pgss_available
SELECT n.nspname AS pgss_schema FROM pg_catalog.pg_extension e JOIN pg_catalog.pg_namespace n ON n.oid=e.extnamespace WHERE e.extname='pg_stat_statements' \gset
SELECT queryid,calls,total_exec_time,mean_exec_time,rows,left(query,400) AS query_prefix FROM :"pgss_schema".pg_stat_statements WHERE calls>0 ORDER BY mean_exec_time DESC LIMIT 50;
\else
\echo pg_stat_statements is not installed in this database; query skipped.
\endif
COMMIT;
