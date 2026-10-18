-- Title: Index validity state
-- Description: List indexes that are invalid, not ready or not live for manual recovery review.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_monitor for complete relation visibility
-- Risk: read-only
-- Source: original; https://www.postgresql.org/docs/18/catalog-pg-index.html
-- Runbook: procedures/slow-queries.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Interpretazione e limiti: Stati anomali possono derivare da CREATE INDEX CONCURRENTLY interrotta; controllare vincoli e log prima di intervenire.
SELECT n.nspname,t.relname AS table_name,x.relname AS index_name,i.indisvalid,i.indisready,i.indislive,
       i.indisprimary,i.indisunique,pg_catalog.pg_get_indexdef(x.oid) AS definition
FROM pg_catalog.pg_index i
JOIN pg_catalog.pg_class t ON t.oid = i.indrelid
JOIN pg_catalog.pg_class x ON x.oid = i.indexrelid
JOIN pg_catalog.pg_namespace n ON n.oid = t.relnamespace
WHERE NOT i.indisvalid
    OR NOT i.indisready
    OR NOT i.indislive
ORDER BY 1,2,3;
COMMIT;
