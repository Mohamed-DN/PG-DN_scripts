-- Title: Index access methods
-- Description: Inventory index access methods, capabilities and validity state.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_monitor for complete relation visibility
-- Risk: read-only
-- Source: original; https://www.postgresql.org/docs/18/functions-info.html
-- Runbook: procedures/slow-queries.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Interpretazione e limiti: Metodo e capability non attestano uso o efficienza: correlare con operatori, query e piani.
SELECT n.nspname,t.relname AS table_name,x.relname AS index_name,am.amname,
       pg_catalog.pg_indexam_has_property(x.relam,
                      'can_unique') AS can_unique, pg_catalog.pg_indexam_has_property(x.relam,
                                                                  'can_order') AS can_order,
       pg_catalog.pg_indexam_has_property(x.relam,
                      'can_multi_col') AS can_multi_col, i.indisvalid,i.indisready,i.indislive,pg_catalog.pg_relation_size(x.oid) AS bytes
FROM pg_catalog.pg_index i
JOIN pg_catalog.pg_class t ON t.oid = i.indrelid
JOIN pg_catalog.pg_class x ON x.oid = i.indexrelid
JOIN pg_catalog.pg_am am ON am.oid = x.relam
JOIN pg_catalog.pg_namespace n ON n.oid = t.relnamespace
WHERE n.nspname !~ '^pg_'
    AND n.nspname <> 'information_schema'
ORDER BY am.amname,bytes DESC
LIMIT 300;
COMMIT;
