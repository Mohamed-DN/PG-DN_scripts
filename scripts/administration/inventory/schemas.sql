-- Title: Schema inventory
-- Description: List non-system schemas and owners.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT
-- Risk: read-only
-- Source: user:+Postgres_Comandi_Principali_Diagnostica_Stats_Ruoli.sql
-- Runbook: procedures/monitoring.md
-- Usarla per elencare gli schemi non di sistema e i rispettivi proprietari nel database corrente.
-- schema_name identifica lo namespace e owner è risolto dal ruolo proprietario.
-- Non elenca grants o membership effettive; sono esclusi pg_* e information_schema e il limite è 500.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT n.nspname AS schema_name,pg_catalog.pg_get_userbyid(n.nspowner) AS owner
FROM pg_catalog.pg_namespace n
WHERE n.nspname !~ '^pg_'
    AND n.nspname <> 'information_schema'
ORDER BY 1
LIMIT 500;
COMMIT;
