-- Title: SLRU activity counters
-- Description: Inspect SLRU hit, read, write and eviction counters with reset timestamp.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_monitor for complete cluster statistics visibility
-- Risk: read-only
-- Source: original; https://github.com/andyatkinson/pg_scripts/blob/b7736708e0cfa5b8a3e88df8b1704a80b3566896/pg_stat_database.sql; https://www.postgresql.org/docs/18/monitoring-stats.html
-- Runbook: procedures/monitoring.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- SLRU alimenta strutture interne come transaction status e multixact. I contatori sono cumulativi;
-- evictions o reads vanno correlati con carico, checkpoint e attese, non sono allarmi autonomi.
-- pg_stat_slru è disponibile nelle versioni supportate 14–18.
SELECT name,blks_zeroed,blks_hit,blks_read,blks_written,blks_exists, flushes,truncates,stats_reset
FROM pg_catalog.pg_stat_slru
ORDER BY blks_read DESC,name
LIMIT 100;
COMMIT;
