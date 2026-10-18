-- Title: Analyze progress
-- Description: Show active ANALYZE progress counters.
-- Postgres: 14+
-- Privilege: pg_read_all_stats for full visibility
-- Risk: read-only
-- Source: user:script 4
-- Runbook: runbooks/vacuum-bloat.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT pid,datname,relid::regclass AS relation,phase,sample_blks_total,sample_blks_scanned,ext_stats_total,ext_stats_computed,child_tables_total,child_tables_done FROM pg_catalog.pg_stat_progress_analyze ORDER BY pid LIMIT 100;
COMMIT;
