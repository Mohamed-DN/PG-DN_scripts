-- Title: Logical subscriptions
-- Description: List subscriptions without connection strings or credentials.
-- Postgres: 14+
-- Privilege: database owner or pg_read_all_stats
-- Risk: read-only
-- Source: user:script 3
-- Runbook: runbooks/replication-lag.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT subname,subenabled,subslotname,subpublications,subbinary FROM pg_catalog.pg_subscription ORDER BY subname LIMIT 200;
COMMIT;
