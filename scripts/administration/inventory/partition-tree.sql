-- Title: Partition hierarchy
-- Description: List partition parents and children using catalog inheritance links, without scanning table data.
-- Postgres: 14+
-- Privilege: CONNECT
-- Risk: read-only
-- Source: original; https://www.postgresql.org/docs/18/catalog-pg-inherits.html
-- Runbook: runbooks/triage.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT i.inhparent::regclass AS parent, i.inhrelid::regclass AS child,
       c.relispartition, pg_catalog.pg_get_expr(c.relpartbound,c.oid) AS partition_bound
FROM pg_catalog.pg_inherits AS i
JOIN pg_catalog.pg_class AS c ON c.oid=i.inhrelid
ORDER BY i.inhparent::regclass::text, i.inhrelid::regclass::text
LIMIT 500;
COMMIT;
