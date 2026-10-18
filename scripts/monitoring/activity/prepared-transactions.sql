-- Title: Prepared transactions
-- Description: List two-phase transactions; resolution belongs to the transaction coordinator.
-- Postgres: 14+
-- Privilege: database CONNECT
-- Risk: read-only
-- Source: user:script 3
-- Runbook: runbooks/locks.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT transaction,gid,prepared,owner,database FROM pg_catalog.pg_prepared_xacts ORDER BY prepared LIMIT 100;
COMMIT;
