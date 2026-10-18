-- Title: Index usage by table
-- Description: Compare sequential and index scans and tuple fetches; counters can reset.
-- Postgres: 14+
-- Privilege: database CONNECT
-- Risk: read-only
-- Source: user:POSTGRES_STATS.Sql
-- Runbook: runbooks/slow-queries.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT schemaname,relname,seq_scan,seq_tup_read,idx_scan,idx_tup_fetch FROM pg_catalog.pg_stat_user_tables ORDER BY seq_scan DESC NULLS LAST LIMIT 100;
COMMIT;
