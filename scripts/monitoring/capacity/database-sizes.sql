-- Title: Database sizes
-- Description: Rank connectable databases by allocated size.
-- Postgres: 14+
-- Privilege: database CONNECT
-- Risk: read-only
-- Source: user:+Postgres_Main_commands.sql
-- Runbook: runbooks/monitoring.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT datname,pg_catalog.pg_database_size(datname) AS bytes,pg_catalog.pg_size_pretty(pg_catalog.pg_database_size(datname)) AS size FROM pg_catalog.pg_database WHERE datallowconn ORDER BY bytes DESC LIMIT 100;
COMMIT;
