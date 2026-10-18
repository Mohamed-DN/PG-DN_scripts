-- Title: Invalid indexes
-- Description: Identify indexes marked invalid or not ready for DBA investigation.
-- Postgres: 14+
-- Privilege: database CONNECT
-- Risk: read-only
-- Source: user:script 4
-- Runbook: runbooks/slow-queries.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT n.nspname,c.relname AS table_name,i.relname AS index_name,x.indisvalid,x.indisready,x.indislive FROM pg_catalog.pg_index x JOIN pg_catalog.pg_class c ON c.oid=x.indrelid JOIN pg_catalog.pg_class i ON i.oid=x.indexrelid JOIN pg_catalog.pg_namespace n ON n.oid=c.relnamespace WHERE NOT x.indisvalid OR NOT x.indisready OR NOT x.indislive ORDER BY 1,2,3 LIMIT 200;
COMMIT;
