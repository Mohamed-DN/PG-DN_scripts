-- Title: Row-level security policy inventory
-- Description: List user tables' RLS flags and policy names, modes, commands and roles; policy expressions are excluded.
-- Postgres: 14+
-- Privilege: database CONNECT; metadata visibility depends on ownership/privileges
-- Risk: read-only
-- Source: user:script 3.txt
-- Runbook: runbooks/security.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT n.nspname AS schema_name,c.relname AS table_name,c.relrowsecurity AS rls_enabled,c.relforcerowsecurity AS rls_forced,p.policyname,p.permissive,p.cmd,p.roles FROM pg_catalog.pg_class AS c JOIN pg_catalog.pg_namespace AS n ON n.oid=c.relnamespace LEFT JOIN pg_catalog.pg_policies AS p ON p.schemaname=n.nspname AND p.tablename=c.relname WHERE c.relkind IN ('r','p') AND n.nspname !~ '^pg_' AND n.nspname<>'information_schema' AND (c.relrowsecurity OR c.relforcerowsecurity OR p.policyname IS NOT NULL) ORDER BY 1,2,5 LIMIT 1000;
COMMIT;
