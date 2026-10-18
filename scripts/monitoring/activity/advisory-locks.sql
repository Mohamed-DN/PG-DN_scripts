-- Title: Advisory lock summary
-- Description: List advisory lock ownership and wait state without exposing session query text.
-- Postgres: 14+
-- Privilege: pg_read_all_stats for complete session details
-- Risk: read-only
-- Source: user:script 4.txt
-- Runbook: runbooks/locks.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT l.pid,a.datname,a.usename,a.application_name,l.mode,l.granted,l.classid,l.objid,l.objsubid FROM pg_catalog.pg_locks AS l LEFT JOIN pg_catalog.pg_stat_activity AS a ON a.pid=l.pid WHERE l.locktype='advisory' ORDER BY l.granted,l.pid LIMIT 500;
COMMIT;
