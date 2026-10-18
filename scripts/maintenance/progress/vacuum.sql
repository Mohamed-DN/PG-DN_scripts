-- Title: Vacuum progress
-- Description: Show active vacuum phase and block counters common to PostgreSQL 14-18.
-- Postgres: 14+
-- Privilege: pg_read_all_stats for full visibility
-- Risk: read-only
-- Source: user:+Postgres_Main_commands.sql
-- Runbook: runbooks/vacuum-bloat.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
-- Tuple-memory counters changed in PostgreSQL 17; compare only common block counters here.
SELECT pid,datname,relid::regclass AS relation,phase,heap_blks_total,heap_blks_scanned,heap_blks_vacuumed,index_vacuum_count FROM pg_catalog.pg_stat_progress_vacuum ORDER BY pid LIMIT 100;
COMMIT;
