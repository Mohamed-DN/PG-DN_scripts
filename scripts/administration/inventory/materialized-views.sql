-- Title: Materialized view inventory
-- Description: List materialized view ownership, tablespace and population state without exposing view definitions.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT
-- Risk: read-only
-- Source: user:script 3.txt
-- Runbook: procedures/monitoring.md
-- Usarla per censire materialized view, proprietario, tablespace e stato di popolamento.
-- hasindexes segnala la presenza di indici; ispopulated=false indica che il risultato non è popolato.
-- Non mostra definizione né data dell'ultimo refresh e l'output è limitato a 1000 righe.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT schemaname AS schema_name,matviewname AS view_name,matviewowner AS owner,tablespace,hasindexes,ispopulated
FROM pg_catalog.pg_matviews
ORDER BY schemaname,matviewname
LIMIT 1000;
COMMIT;
