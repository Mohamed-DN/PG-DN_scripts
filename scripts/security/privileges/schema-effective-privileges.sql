-- Title: Effective schema privileges
-- Description: Evaluate USAGE and CREATE privileges for visible application schemas and login roles.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT; metadata visibility follows object visibility
-- Risk: read-only
-- Source: original; https://github.com/Azmodey/pg_dba_scripts/blob/3ff7a9041e5a6a78a91bb222c962f76e30c1d3ab/scripts/pg_database_information.sh; https://www.postgresql.org/docs/18/functions-info.html
-- Runbook: procedures/security.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- has_schema_privilege calcola il diritto effettivo inclusi membership e PUBLIC.
-- La moltiplicazione ruoli×schemi può generare molte righe: elenco ridotto ai login e a 250 schemi.
-- Non sostituisce la verifica di accesso effettivo a una tabella o di RLS.
SELECT r.rolname AS role_name,n.nspname AS schema_name,
       pg_catalog.has_schema_privilege(r.oid, n.oid, 'USAGE') AS can_use, pg_catalog.has_schema_privilege(r.oid,
                                                                                         n.oid,
                                                                                         'CREATE') AS can_create_objects
FROM pg_catalog.pg_roles r
CROSS JOIN LATERAL
    (SELECT oid,nspname
     FROM pg_catalog.pg_namespace
     WHERE nspname NOT IN ('pg_catalog','information_schema')
         AND nspname !~ '^pg_toast'
     ORDER BY nspname
     LIMIT 250) n
WHERE r.rolcanlogin
ORDER BY r.rolname,n.nspname
LIMIT 5000;
COMMIT;
