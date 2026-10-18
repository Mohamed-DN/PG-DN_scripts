-- Title: Database shared-buffer hit ratio
-- Description: Calculate cumulative shared-buffer hit ratios by database since statistics reset.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_monitor for all databases; otherwise visible statistics only
-- Risk: read-only
-- Source: original; https://github.com/andyatkinson/pg_scripts/blob/b7736708e0cfa5b8a3e88df8b1704a80b3566896/cache_hit_rate.sql; https://www.postgresql.org/docs/18/monitoring-stats.html
-- Runbook: procedures/monitoring.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Il rapporto è calcolato su contatori cumulativi dall'ultimo reset e non descrive un intervallo breve.
-- Blks_read conta letture richieste dal server, non necessariamente I/O fisico perché può intervenire
-- la cache del sistema operativo. Evitare di interpretare una soglia isolata come prova di problema.
SELECT datname,stats_reset,blks_read,blks_hit,
       round(100.0 * blks_hit / NULLIF(blks_hit + blks_read, 0), 2) AS shared_buffer_hit_percent, numbackends
FROM pg_catalog.pg_stat_database
WHERE datname IS NOT NULL
ORDER BY (blks_hit + blks_read) DESC,datname
LIMIT 100;
COMMIT;
