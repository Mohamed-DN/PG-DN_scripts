-- Title: PUBLIC schema and relation grants
-- Description: Find explicit grants to PUBLIC on schemas and relations in the current database.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT; visible object metadata
-- Risk: read-only
-- Source: original; https://github.com/Azmodey/pg_dba_scripts/blob/3ff7a9041e5a6a78a91bb222c962f76e30c1d3ab/scripts/pg_database_information.sh; https://www.postgresql.org/docs/18/functions-info.html
-- Runbook: procedures/security.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- PUBLIC è rappresentato da grantee OID 0. L'elenco evidenzia privilegi espliciti visibili
-- senza assumere che ogni grant sia vulnerabilità: confrontare con l'intento applicativo e ACL ereditate.
-- Non copre implicitamente tutte le capacità derivanti da owner, superuser o funzioni SECURITY DEFINER.
WITH grants AS
    (SELECT 'schema'::text AS object_type,n.nspname AS object_name, x.grantee,x.privilege_type,x.is_grantable
     FROM pg_catalog.pg_namespace n
     CROSS JOIN LATERAL pg_catalog.aclexplode(COALESCE(n.nspacl,
                                                  pg_catalog.acldefault('n',
                                                                 n.nspowner))) x
     UNION ALL SELECT 'relation',format('%I.%I', n.nspname, c.relname),x.grantee,x.privilege_type,
                      x.is_grantable
     FROM pg_catalog.pg_class c
     JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
     CROSS JOIN LATERAL pg_catalog.aclexplode(COALESCE(c.relacl,

                                                  pg_catalog.acldefault(CASE
                                                                            WHEN c.relkind = 'S' THEN 'S'::"char"
                                                                            ELSE 'r'::"char"
                                                                        END,
                                                                 c.relowner))) x
     WHERE c.relkind IN ('r','p','v','m','f','S'))
SELECT object_type,object_name,privilege_type,is_grantable
FROM grants
WHERE grantee = 0
ORDER BY object_type,object_name,privilege_type
LIMIT 1000;
COMMIT;
