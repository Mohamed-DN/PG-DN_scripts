-- Title: Unused index candidates
-- Description: Find valid large indexes with zero scans; review workload cycles before any decision and never auto-drop.
-- Postgres: 14+
-- Privilege: database CONNECT
-- Risk: read-only
-- Source: user:+Postgres_Main_commands.sql
-- Runbook: runbooks/slow-queries.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT s.schemaname,s.relname,s.indexrelname,s.idx_scan,pg_catalog.pg_relation_size(s.indexrelid) AS bytes FROM pg_catalog.pg_stat_user_indexes s JOIN pg_catalog.pg_index i ON i.indexrelid=s.indexrelid WHERE s.idx_scan=0 AND i.indisvalid AND i.indisready AND pg_catalog.pg_relation_size(s.indexrelid)>=10485760 ORDER BY bytes DESC LIMIT 100;
COMMIT;
