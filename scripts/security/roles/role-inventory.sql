-- Title: Role inventory
-- Description: List role attributes and validity without password hashes.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT
-- Risk: read-only
-- Source: user:+Postgres_Comandi_Principali_Diagnostica_Stats_Ruoli.sql
-- Runbook: procedures/security.md
-- Usarla per rivedere attributi dei ruoli e scadenze senza leggere hash o password.
-- rolsuper, rolcreaterole, rolreplication e rolbypassrls evidenziano capacità sensibili; gli altri campi mostrano limiti e login.
-- Non mostra membership, grants o attività recente; incrociare con ACL e autenticazione.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT rolname,rolcanlogin,rolsuper,rolcreatedb,rolcreaterole,rolreplication,rolbypassrls,rolconnlimit,
       rolvaliduntil
FROM pg_catalog.pg_roles
ORDER BY rolname
LIMIT 500;
COMMIT;
