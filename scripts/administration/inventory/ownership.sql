-- Title: Application object ownership
-- Description: Inventory relation owners to find objects owned by unexpected or retired roles.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT; metadata visibility follows object visibility
-- Risk: read-only
-- Source: original; https://github.com/Azmodey/pg_dba_scripts/blob/3ff7a9041e5a6a78a91bb222c962f76e30c1d3ab/scripts/pg_database_information.sh; https://www.postgresql.org/docs/18/catalog-pg-class.html
-- Runbook: procedures/security.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Owner conserva poteri speciali sull'oggetto che non emergono come normali ACL.
-- Questo censisce relazioni e sequenze, ma non tutti gli oggetti database: routine, schema e tipi
-- richiedono inventari dedicati. Il risultato è limitato per impedire output eccessivo.
SELECT n.nspname AS schema_name,c.relname AS object_name,c.relkind AS kind_code,
       pg_catalog.pg_get_userbyid(c.relowner) AS owner_role, pg_catalog.pg_size_pretty(pg_catalog.pg_total_relation_size(c.oid)) AS total_size
FROM pg_catalog.pg_class c
JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
WHERE c.relkind IN ('r','p','v','m','f','S')
    AND n.nspname NOT IN ('pg_catalog','information_schema')
    AND n.nspname !~ '^pg_toast'
ORDER BY owner_role,n.nspname,c.relname
LIMIT 2000;
COMMIT;
