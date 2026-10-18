-- Title: Partition hierarchy
-- Description: Show direct parent-child table edges and partition bounds.
-- Postgres: 14–18 (verificato)
-- Privilege: CONNECT
-- Risk: read-only
-- Source: original; https://www.postgresql.org/docs/18/catalog-pg-inherits.html
-- Runbook: procedures/slow-queries.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Interpretazione e limiti: Sono mostrate solo le relazioni dirette; discendenze profonde richiedono una traversata ricorsiva.
SELECT pn.nspname AS parent_schema,p.relname AS parent_table,cn.nspname AS child_schema,c.relname AS child_table,
       pg_catalog.pg_get_expr(c.relpartbound, c.oid, true) AS partition_bound
FROM pg_catalog.pg_inherits h
JOIN pg_catalog.pg_class p ON p.oid = h.inhparent
JOIN pg_catalog.pg_class c ON c.oid = h.inhrelid
JOIN pg_catalog.pg_namespace pn ON pn.oid = p.relnamespace
JOIN pg_catalog.pg_namespace cn ON cn.oid = c.relnamespace
WHERE p.relispartition
    OR p.relkind = 'p'
ORDER BY 1,2,3,4;
COMMIT;
