-- Title: Server identity
-- Description: Identify database, role, server version, startup and primary or standby state before diagnosis.
-- Postgres: 14+
-- Privilege: CONNECT
-- Risk: read-only
-- Source: original; https://www.postgresql.org/docs/18/functions-info.html
-- Runbook: runbooks/triage.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT pg_catalog.current_database() AS database,
       current_user AS role, session_user AS login_role,
       pg_catalog.current_setting('server_version') AS version,
       pg_catalog.inet_server_addr() AS server_address,
       pg_catalog.inet_server_port() AS server_port,
       pg_catalog.pg_postmaster_start_time() AS started_at,
       pg_catalog.pg_is_in_recovery() AS standby,
       pg_catalog.current_setting('transaction_read_only') AS transaction_read_only;
COMMIT;
