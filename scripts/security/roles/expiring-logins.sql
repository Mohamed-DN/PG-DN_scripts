-- Title: Expiring login roles
-- Description: Identify login roles expired or expiring in 30 days.
-- Postgres: 14+
-- Privilege: database CONNECT
-- Risk: read-only
-- Source: user:+Postgres_Comandi_Principali_Diagnostica_Stats_Ruoli.sql
-- Runbook: runbooks/security.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT rolname,rolvaliduntil FROM pg_catalog.pg_roles WHERE rolcanlogin AND rolvaliduntil IS NOT NULL AND rolvaliduntil<now()+interval '30 days' ORDER BY rolvaliduntil LIMIT 500;
COMMIT;
