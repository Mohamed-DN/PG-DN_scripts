-- Title: Schema inventory
-- Description: List non-system schemas and owners.
-- Postgres: 14+
-- Privilege: database CONNECT
-- Risk: read-only
-- Source: user:+Postgres_Comandi_Principali_Diagnostica_Stats_Ruoli.sql
-- Runbook: runbooks/monitoring.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT n.nspname AS schema_name,pg_catalog.pg_get_userbyid(n.nspowner) AS owner FROM pg_catalog.pg_namespace n WHERE n.nspname !~ '^pg_' AND n.nspname<>'information_schema' ORDER BY 1 LIMIT 500;
COMMIT;
