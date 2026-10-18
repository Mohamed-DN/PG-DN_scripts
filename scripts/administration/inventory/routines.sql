-- Title: Routine inventory
-- Description: List function and procedure metadata without exposing routine source text or bodies.
-- Postgres: 14+
-- Privilege: database CONNECT; routine metadata visibility depends on privileges
-- Risk: read-only
-- Source: user:script 3.txt
-- Runbook: runbooks/monitoring.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT n.nspname AS schema_name,p.proname AS routine_name,CASE p.prokind WHEN 'f' THEN 'function' WHEN 'p' THEN 'procedure' WHEN 'a' THEN 'aggregate' WHEN 'w' THEN 'window function' END AS routine_kind,pg_catalog.pg_get_userbyid(p.proowner) AS owner,l.lanname AS language,p.pronargs AS argument_count,pg_catalog.pg_get_function_identity_arguments(p.oid) AS identity_arguments,pg_catalog.pg_get_function_result(p.oid) AS result_type,p.provolatile AS volatility,p.prosecdef AS security_definer FROM pg_catalog.pg_proc AS p JOIN pg_catalog.pg_namespace AS n ON n.oid=p.pronamespace JOIN pg_catalog.pg_language AS l ON l.oid=p.prolang WHERE n.nspname !~ '^pg_' AND n.nspname<>'information_schema' ORDER BY 1,2,7 LIMIT 2000;
COMMIT;
