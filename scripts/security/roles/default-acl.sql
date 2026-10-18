-- Title: Default privileges inventory
-- Description: Show per-role and per-schema default ACL entries that affect future objects.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT; visible role and schema metadata
-- Risk: read-only
-- Source: original; https://github.com/Azmodey/pg_dba_scripts/blob/3ff7a9041e5a6a78a91bb222c962f76e30c1d3ab/scripts/pg_database_information.sh; https://www.postgresql.org/docs/18/catalog-pg-default-acl.html
-- Runbook: procedures/security.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Un ACL assente significa che valgono i privilegi predefiniti hard-coded, non che manca un grant.
-- Queste regole si applicano agli oggetti creati in futuro dal ruolo; non modificano ACL esistenti.
SELECT r.rolname AS creator_role,
       CASE d.defaclobjtype WHEN 'r' THEN 'relations' WHEN 'S' THEN 'sequences' WHEN 'f' THEN 'routines' WHEN 'T' THEN 'types' WHEN 'n' THEN 'schemas' WHEN 'L' THEN 'large objects' ELSE d.defaclobjtype::text
       END AS object_type, COALESCE(n.nspname, '<all schemas>') AS schema_name,
       CASE WHEN x.grantee = 0 THEN 'PUBLIC' ELSE gr.rolname
       END AS grantee, grantor.rolname AS grantor, x.privilege_type, x.is_grantable
FROM pg_catalog.pg_default_acl d
JOIN pg_catalog.pg_roles r ON r.oid = d.defaclrole
LEFT JOIN pg_catalog.pg_namespace n ON n.oid = d.defaclnamespace
CROSS JOIN LATERAL pg_catalog.aclexplode(d.defaclacl) x
LEFT JOIN pg_catalog.pg_roles gr ON gr.oid = x.grantee
LEFT JOIN pg_catalog.pg_roles grantor ON grantor.oid = x.grantor
ORDER BY r.rolname,object_type,schema_name
LIMIT 1000;
COMMIT;
