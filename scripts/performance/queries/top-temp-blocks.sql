-- Title: Statements by temporary blocks
-- Description: Find statements with cumulative temporary block writes; compare snapshots for rates.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_read_all_stats; extension already installed
-- Risk: read-only
-- Source: user:POSTGRES_STATS.Sql
-- Runbook: procedures/slow-queries.md
-- Usarla per individuare statement con più blocchi temporanei scritti secondo pg_stat_statements.
-- temp_blks_written è cumulativo; temp_blks_read e shared_blks_read aiutano a contestualizzare il traffico.
-- Il ranking non dà dimensione esatta dei file né rate; confrontare snapshot e verificare reset.
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
SELECT queryid,calls,temp_blks_read,temp_blks_written,shared_blks_read,left(query,
                                                                           400) AS query_prefix
FROM :"pgss_schema".pg_stat_statements
ORDER BY temp_blks_written DESC
LIMIT 50;
\else
\echo pg_stat_statements is not installed in this database; query skipped.
\endif
COMMIT;
