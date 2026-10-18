-- Title: Index definitions
-- Description: List index definitions for review.
-- Postgres: 14+
-- Privilege: database CONNECT
-- Risk: read-only
-- Source: user:script 2.txt
-- Runbook: runbooks/slow-queries.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT schemaname,tablename,indexname,tablespace,indexdef FROM pg_catalog.pg_indexes ORDER BY schemaname,tablename,indexname LIMIT 500;
COMMIT;
