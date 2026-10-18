-- Title: Index keys and included columns
-- Description: Distinguish index search keys from INCLUDE payload and report size.
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
-- Interpretazione e limiti: Le colonne INCLUDE aumentano spazio e manutenzione senza essere chiavi di ricerca. Gli indici su espressioni sono riportati come tali.
SELECT n.nspname,t.relname AS table_name,x.relname AS index_name,i.indnkeyatts,
       i.indnatts - i.indnkeyatts AS included_count,pg_catalog.pg_get_indexdef(x.oid) AS definition,
       pg_catalog.pg_relation_size(x.oid) AS bytes
FROM pg_catalog.pg_index i
JOIN pg_catalog.pg_class t ON t.oid = i.indrelid
JOIN pg_catalog.pg_class x ON x.oid = i.indexrelid
JOIN pg_catalog.pg_namespace n ON n.oid = t.relnamespace
WHERE n.nspname !~ '^pg_'
    AND n.nspname <> 'information_schema'
ORDER BY bytes DESC
LIMIT 300;
COMMIT;
