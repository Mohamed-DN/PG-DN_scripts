-- Title: Database commit and rollback ratio
-- Description: Calculate cumulative committed versus rolled-back transaction counts per database.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_monitor for complete statistics visibility
-- Risk: read-only
-- Source: original; https://github.com/andyatkinson/pg_scripts/blob/b7736708e0cfa5b8a3e88df8b1704a80b3566896/pg_stat_database.sql; https://www.postgresql.org/docs/18/monitoring-stats.html
-- Runbook: procedures/monitoring.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Un rollback è un esito applicativo/transazionale e non implica sempre un errore; l'indice è utile
-- solo se comparato su intervalli con stats_reset stabile. I contatori includono anche transazioni
-- read-only: non rappresentano il numero di transazioni che hanno scritto dati.
SELECT datname,stats_reset,xact_commit,xact_rollback,
       round(100.0 * xact_rollback / NULLIF(xact_commit + xact_rollback, 0), 2) AS rollback_percent
FROM pg_catalog.pg_stat_database
WHERE datname IS NOT NULL
ORDER BY xact_rollback DESC,datname
LIMIT 100;
COMMIT;
