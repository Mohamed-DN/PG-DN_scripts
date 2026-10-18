-- Title: Database inventory
-- Description: List non-template databases, owners, connection limits and allocated size.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT
-- Risk: read-only
-- Source: user:+Postgres_Comandi_Principali_Diagnostica_Stats_Ruoli.sql
-- Runbook: procedures/monitoring.md
-- Usarla per l'inventario dei database non-template, ordinato per spazio allocato.
-- owner e datconnlimit descrivono proprietario e limite; size è calcolata sul database indicato e resa leggibile.
-- Allocazione non equivale a spazio logico o recuperabile; la funzione può avere costo proporzionale agli oggetti del database.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT d.datname,pg_catalog.pg_get_userbyid(d.datdba) AS owner,d.datallowconn,d.datconnlimit,
       pg_catalog.pg_size_pretty(pg_catalog.pg_database_size(d.datname)) AS size
FROM pg_catalog.pg_database d
WHERE NOT d.datistemplate
ORDER BY pg_catalog.pg_database_size(d.datname) DESC
LIMIT 100;
COMMIT;
