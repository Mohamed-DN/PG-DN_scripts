-- Title: Table HOT update ratios
-- Description: Identify tables where updates often avoid creating new index entries through HOT updates.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_monitor for complete statistics; database CONNECT
-- Risk: read-only
-- Source: original; https://github.com/andyatkinson/pg_scripts/blob/b7736708e0cfa5b8a3e88df8b1704a80b3566896/find_hot_updates.sql; https://www.postgresql.org/docs/18/monitoring-stats.html
-- Runbook: procedures/monitoring.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- n_tup_hot_upd è cumulativo dall'ultimo reset; il rapporto aiuta a confrontare tabelle, non misura
-- il beneficio in byte né indica da solo un problema. Le tabelle a basso volume possono avere percentuali
-- instabili; correlare con dimensione, indici, fillfactor e andamento temporale prima di intervenire.
SELECT schemaname,relname,n_tup_upd,n_tup_hot_upd,
       round(100.0 * n_tup_hot_upd / NULLIF(n_tup_upd, 0), 2) AS hot_update_percent, last_autoanalyze
FROM pg_catalog.pg_stat_user_tables
WHERE n_tup_upd > 0
ORDER BY hot_update_percent ASC,n_tup_upd DESC
LIMIT 100;
COMMIT;
