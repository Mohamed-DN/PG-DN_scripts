-- Title: SSL connection summary
-- Description: Show TLS use and negotiated parameters without client or issuer distinguished names.
-- Postgres: 14+
-- Privilege: pg_read_all_stats for complete visibility
-- Risk: read-only
-- Source: user:script 4.txt
-- Runbook: runbooks/security.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT a.pid,a.datname,a.usename,a.application_name,a.client_addr,s.ssl,s.version,s.cipher,s.bits FROM pg_catalog.pg_stat_ssl AS s JOIN pg_catalog.pg_stat_activity AS a ON a.pid=s.pid ORDER BY a.datname,a.pid LIMIT 500;
COMMIT;
