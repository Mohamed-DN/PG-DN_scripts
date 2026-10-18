-- Title: Role security attributes
-- Description: Review login, superuser, creation and bypass-RLS attributes for roles visible to the caller.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT; pg_read_all_settings for full visibility of protected role metadata
-- Risk: read-only
-- Source: original; https://github.com/Azmodey/pg_dba_scripts/blob/3ff7a9041e5a6a78a91bb222c962f76e30c1d3ab/scripts/pg_database_information.sh; https://www.postgresql.org/docs/18/view-pg-roles.html
-- Runbook: procedures/security.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- pg_roles oscura la password hash rispetto a pg_authid, che non va interrogato per un inventario.
-- rolconfig può contenere parametri per ruolo: viene volutamente omesso perché settings possono
-- includere valori sensibili. BYPASSRLS e SUPERUSER sono privilegi ad alto impatto da ricontrollare.
SELECT rolname,rolcanlogin,rolsuper,rolcreatedb,rolcreaterole,rolreplication, rolbypassrls,rolconnlimit,
       rolvaliduntil
FROM pg_catalog.pg_roles
ORDER BY rolsuper DESC,rolbypassrls DESC,rolcanlogin DESC,rolname
LIMIT 1000;
COMMIT;
