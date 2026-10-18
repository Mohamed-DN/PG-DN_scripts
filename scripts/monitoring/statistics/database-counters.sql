-- Title: Database counters
-- Description: Show cumulative transaction, deadlock, temp and block counters; use snapshot deltas for rates.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_read_all_stats
-- Risk: read-only
-- Source: user:POSTGRES_STATS.Sql
-- Runbook: procedures/monitoring.md
-- Usarla per una fotografia per database di transazioni, deadlock, file temporanei e blocchi.
-- shared_buffer_hit_pct deriva dai contatori hit/read; temp_bytes quantifica byte temporanei accumulati.
-- I valori sono cumulativi e resettabili; la percentuale aggregata non descrive ogni query e richiede finestre omogenee.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT datname,stats_reset,xact_commit,xact_rollback,deadlocks,temp_files,temp_bytes,blks_read,
       blks_hit,round(100.0 * blks_hit / NULLIF(blks_hit + blks_read,
                                             0), 2) AS shared_buffer_hit_pct
FROM pg_catalog.pg_stat_database
ORDER BY datname
LIMIT 100;
COMMIT;
