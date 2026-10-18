-- Title: Ready WAL archive files
-- Description: Count .ready/.done marker files in pg_wal/archive_status; marker sizes are not WAL sizes.
-- Postgres: 14+
-- Privilege: pg_monitor or EXECUTE on pg_ls_archive_statusdir
-- Risk: read-only
-- Source: user:PROBLEMA_WAL_POSTGRES.sql
-- Runbook: runbooks/wal-growth.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT count(*) FILTER(WHERE name ~ '^[0-9A-F]{24}[.]ready$') AS ready_markers,count(*) FILTER(WHERE name ~ '^[0-9A-F]{24}[.]done$') AS done_markers FROM pg_catalog.pg_ls_archive_statusdir();
COMMIT;
