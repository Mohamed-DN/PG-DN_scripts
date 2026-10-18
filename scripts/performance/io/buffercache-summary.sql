-- Title: Buffer cache summary
-- Description: Summarize shared-buffer usage only when pg_buffercache is already installed; extension schema is discovered and quoted safely.
-- Postgres: 16+
-- Privilege: pg_monitor; function EXECUTE may be granted separately
-- Risk: read-only
-- Source: user:script 3.txt
-- Runbook: runbooks/monitoring.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT (current_setting('server_version_num')::integer >= 160000) AS version_supported \gset
\if :version_supported
  \set extension_name pg_buffercache
  \unset extension_schema
  SELECT EXISTS (SELECT 1 FROM pg_catalog.pg_extension WHERE extname=:'extension_name') AS buffer_available \gset
  \if :buffer_available
    SELECT n.nspname AS extension_schema FROM pg_catalog.pg_extension AS e JOIN pg_catalog.pg_namespace AS n ON n.oid=e.extnamespace WHERE e.extname=:'extension_name' \gset
    SELECT * FROM :"extension_schema".pg_buffercache_summary();
  \else
    \echo pg_buffercache is not installed in this database; no summary was queried.
  \endif
\else
\echo PostgreSQL 16+ is required; no query was run.
\endif
COMMIT;
