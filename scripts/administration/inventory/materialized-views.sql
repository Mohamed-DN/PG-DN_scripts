-- Title: Materialized view inventory
-- Description: List materialized view ownership, tablespace and population state without exposing view definitions.
-- Postgres: 14+
-- Privilege: database CONNECT
-- Risk: read-only
-- Source: user:script 3.txt
-- Runbook: runbooks/monitoring.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT schemaname AS schema_name,matviewname AS view_name,matviewowner AS owner,tablespace,hasindexes,ispopulated FROM pg_catalog.pg_matviews ORDER BY schemaname,matviewname LIMIT 1000;
COMMIT;
