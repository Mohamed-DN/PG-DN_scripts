-- Title: RLS-enabled relations without visible policies
-- Description: Find application relations with row security enabled but no catalog-visible policy.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT; metadata visibility follows object visibility
-- Risk: read-only
-- Source: original; https://github.com/Azmodey/pg_dba_scripts/blob/3ff7a9041e5a6a78a91bb222c962f76e30c1d3ab/scripts/pg_database_information.sh; https://www.postgresql.org/docs/18/catalog-pg-policy.html
-- Runbook: procedures/security.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Con RLS attivo e nessuna policy, PostgreSQL applica deny-by-default alle query dei ruoli ordinari.
-- L'owner può bypassare RLS se relforcerowsecurity è falso; i ruoli BYPASSRLS e superuser bypassano
-- comunque. Le policy invisibili al chiamante rendono questa lista incompleta.
SELECT n.nspname AS schema_name,c.relname AS relation_name, c.relforcerowsecurity AS forced_for_owner,
       pg_catalog.pg_get_userbyid(c.relowner) AS owner_role
FROM pg_catalog.pg_class c
JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
WHERE c.relkind IN ('r','p')
    AND c.relrowsecurity
    AND n.nspname NOT IN ('pg_catalog','information_schema')
    AND NOT EXISTS
        (SELECT 1
         FROM pg_catalog.pg_policy p
         WHERE p.polrelid = c.oid)
ORDER BY n.nspname,c.relname
LIMIT 1000;
COMMIT;
