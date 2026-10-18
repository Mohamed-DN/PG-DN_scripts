-- Title: Effective database privileges for roles
-- Description: Evaluate CONNECT, CREATE and TEMPORARY rights for a bounded set of database roles.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT; visible database and role names
-- Risk: read-only
-- Source: original; https://github.com/Azmodey/pg_dba_scripts/blob/3ff7a9041e5a6a78a91bb222c962f76e30c1d3ab/scripts/pg_database_information.sh; https://www.postgresql.org/docs/18/functions-info.html
-- Runbook: procedures/security.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Le funzioni has_database_privilege valutano anche membership e PUBLIC, quindi sono più adatte
-- a una verifica puntuale del solo ACL diretto. Si limita a 200 ruoli login; integrare con un
-- controllo per i ruoli applicativi non-login che vengono assunti tramite SET ROLE.
SELECT r.rolname AS role_name, pg_catalog.has_database_privilege(r.oid,
                                              d.oid, 'CONNECT') AS can_connect,
       pg_catalog.has_database_privilege(r.oid,
                      d.oid, 'CREATE') AS can_create_schema, pg_catalog.has_database_privilege(r.oid,
                                                                            d.oid, 'TEMPORARY') AS can_create_temp
FROM pg_catalog.pg_roles r
CROSS JOIN pg_catalog.pg_database d
WHERE d.datname = pg_catalog.current_database()
    AND r.rolcanlogin
ORDER BY r.rolname
LIMIT 200;
COMMIT;
