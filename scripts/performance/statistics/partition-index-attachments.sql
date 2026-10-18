-- Title: Partition index attachments
-- Description: Find parent indexes and attached child indexes across partition hierarchy.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_monitor for complete relation visibility
-- Risk: read-only
-- Source: original; https://www.postgresql.org/docs/18/catalog-pg-inherits.html
-- Runbook: procedures/slow-queries.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Interpretazione e limiti: Relazioni legacy non partitioned possono avere inheritance; verificare relkind e vincoli prima di interpretare un indice figlio mancante.
SELECT pn.nspname AS parent_schema,p.relname AS parent_table,pi.relname AS parent_index, cn.nspname AS child_schema,
       c.relname AS child_table,ci.relname AS child_index, pg_catalog.pg_get_indexdef(pi.oid) AS parent_definition
FROM pg_catalog.pg_inherits h
JOIN pg_catalog.pg_class p ON p.oid = h.inhparent
JOIN pg_catalog.pg_class c ON c.oid = h.inhrelid
JOIN pg_catalog.pg_namespace pn ON pn.oid = p.relnamespace
JOIN pg_catalog.pg_namespace cn ON cn.oid = c.relnamespace
LEFT JOIN pg_catalog.pg_index pidx ON pidx.indrelid = p.oid
LEFT JOIN pg_catalog.pg_class pi ON pi.oid = pidx.indexrelid
LEFT JOIN pg_catalog.pg_index cidx ON cidx.indrelid = c.oid
AND EXISTS
    (SELECT 1
     FROM pg_catalog.pg_inherits ih
     WHERE ih.inhparent = pidx.indexrelid
         AND ih.inhrelid = cidx.indexrelid)
LEFT JOIN pg_catalog.pg_class ci ON ci.oid = cidx.indexrelid
WHERE p.relkind = 'p'
ORDER BY 1,2,3,4,5,6;
COMMIT;
