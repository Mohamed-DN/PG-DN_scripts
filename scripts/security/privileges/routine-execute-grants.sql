-- Title: Routine EXECUTE grants
-- Description: List explicit EXECUTE ACL entries on visible application routines, including grantee and grant option.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT; visible routine metadata
-- Risk: read-only
-- Source: original; https://github.com/Azmodey/pg_dba_scripts/blob/3ff7a9041e5a6a78a91bb222c962f76e30c1d3ab/scripts/pg_database_information.sh; https://www.postgresql.org/docs/18/ddl-priv.html
-- Runbook: procedures/security.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- pg_proc.proacl NULL rappresenta ACL predefinita e non viene espansa qui: la query espone solo
-- grant espliciti registrati. Le funzioni normalmente concedono EXECUTE a PUBLIC per default;
-- valutare anche il default ACL e il rischio SECURITY DEFINER, non soltanto l'ACL presente.
SELECT n.nspname AS schema_name,p.proname AS routine_name,
       pg_catalog.pg_get_function_identity_arguments(p.oid) AS identity_arguments, CASE
                                                                                       WHEN x.grantee = 0 THEN 'PUBLIC'
                                                                                       ELSE gr.rolname
                                                                                   END AS grantee, x.privilege_type,
       x.is_grantable, pg_catalog.pg_get_userbyid(p.proowner) AS owner_role,p.prosecdef AS security_definer
FROM pg_catalog.pg_proc p
JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace
CROSS JOIN LATERAL pg_catalog.aclexplode(p.proacl) x
LEFT JOIN pg_catalog.pg_roles gr ON gr.oid = x.grantee
WHERE n.nspname NOT IN ('pg_catalog','information_schema')
    AND x.privilege_type = 'EXECUTE'
ORDER BY n.nspname,p.proname,identity_arguments,grantee
LIMIT 2000;
COMMIT;
