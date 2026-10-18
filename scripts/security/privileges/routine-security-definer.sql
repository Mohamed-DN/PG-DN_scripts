-- Title: SECURITY DEFINER routine inventory
-- Description: Locate routines running with owner privileges and expose their owner and configuration metadata.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT; visible routine metadata
-- Risk: read-only
-- Source: original; https://github.com/Azmodey/pg_dba_scripts/blob/3ff7a9041e5a6a78a91bb222c962f76e30c1d3ab/scripts/pg_database_information.sh; https://www.postgresql.org/docs/18/catalog-pg-proc.html
-- Runbook: procedures/security.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- SECURITY DEFINER rende il controllo del search_path e dei privilegi EXECUTE particolarmente importante.
-- proconfig può riportare parametri di sessione ma viene omesso per evitare divulgare valori operativi;
-- pg_get_function_identity_arguments distingue gli overload senza estrarre il corpo SQL.
SELECT n.nspname AS schema_name,p.proname AS routine_name,
       pg_catalog.pg_get_function_identity_arguments(p.oid) AS identity_arguments, pg_catalog.pg_get_userbyid(p.proowner) AS owner_role,p.prokind,
       p.prosecdef AS security_definer,p.proleakproof, p.proacl IS NULL AS default_acl
FROM pg_catalog.pg_proc p
JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace
WHERE p.prosecdef
    AND n.nspname NOT IN ('pg_catalog','information_schema')
ORDER BY n.nspname,p.proname
LIMIT 1000;
COMMIT;
