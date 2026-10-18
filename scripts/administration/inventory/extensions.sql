-- Title: Installed extensions
-- Description: Show extensions installed in this database; no installation or update is performed.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT
-- Risk: read-only
-- Source: user:script 3
-- Runbook: procedures/monitoring.md
-- Usarla per verificare le estensioni installate nel database corrente.
-- extversion è la versione installata e schema_name indica dove risiedono gli oggetti dell'estensione.
-- Non è un inventario del cluster e non segnala aggiornamenti disponibili; ripetere per ciascun database.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT e.extname,e.extversion,n.nspname AS schema_name
FROM pg_catalog.pg_extension e
JOIN pg_catalog.pg_namespace n ON n.oid = e.extnamespace
ORDER BY 1;
COMMIT;
