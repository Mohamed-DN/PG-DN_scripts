-- Title: Relation inventory with storage and state
-- Description: Catalog inventory of user relations, kinds, persistence, size and maintenance flags.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT; pg_read_all_stats for complete statistics visibility
-- Risk: read-only
-- Source: original; https://github.com/andyatkinson/pg_scripts/blob/b7736708e0cfa5b8a3e88df8b1704a80b3566896/list_indexes.sql; https://www.postgresql.org/docs/18/catalog-pg-class.html
-- Runbook: procedures/triage.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Unisce pg_class e namespace per includere anche viste, tabelle partizionate e sequenze.
-- La dimensione usa funzioni di sizing che eseguono accessi ai metadati/storage: su cataloghi
-- molto grandi può costare, quindi qui si limita alle relazioni applicative e ai primi 1000 risultati.
-- relallvisible e relpages sono stime di catalogo, non una misura aggiornata in tempo reale.
SELECT n.nspname AS schema_name, c.relname AS relation_name,
       CASE c.relkind WHEN 'r' THEN 'table' WHEN 'p' THEN 'partitioned table' WHEN 'v' THEN 'view' WHEN 'm' THEN 'materialized view' WHEN 'f' THEN 'foreign table' WHEN 'S' THEN 'sequence' ELSE c.relkind::text
       END AS relation_kind, c.relpersistence, c.relispartition, c.reltuples::bigint AS estimated_rows, c.relpages,
       c.relallvisible, pg_catalog.pg_size_pretty(pg_catalog.pg_relation_size(c.oid)) AS main_fork,
       pg_catalog.pg_size_pretty(pg_catalog.pg_total_relation_size(c.oid)) AS total_size
FROM pg_catalog.pg_class AS c
JOIN pg_catalog.pg_namespace AS n ON n.oid = c.relnamespace
WHERE c.relkind IN ('r','p','v','m','f','S')
    AND n.nspname NOT IN ('pg_catalog','information_schema')
    AND n.nspname !~ '^pg_toast'
ORDER BY pg_catalog.pg_total_relation_size(c.oid) DESC, n.nspname, c.relname
LIMIT 1000;
COMMIT;
