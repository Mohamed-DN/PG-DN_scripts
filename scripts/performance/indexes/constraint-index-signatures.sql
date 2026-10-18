-- Title: Constraint index signatures
-- Description: Map unique and primary-key constraints to their supporting index definitions and size.
-- Postgres: 14–18 (verificato)
-- Privilege: CONNECT
-- Risk: read-only
-- Source: original; https://www.postgresql.org/docs/18/catalog-pg-constraint.html
-- Runbook: procedures/slow-queries.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Interpretazione e limiti: La firma dell’indice dipende dalla definizione del vincolo; non dedurre ridondanza solo da nomi o colonne.
SELECT n.nspname,t.relname,c.conname,c.contype,i.relname AS index_name,
       pg_catalog.pg_get_constraintdef(c.oid, true) AS constraint_definition,pg_catalog.pg_get_indexdef(c.conindid) AS index_definition,
       pg_catalog.pg_relation_size(c.conindid) AS index_bytes
FROM pg_catalog.pg_constraint c
JOIN pg_catalog.pg_class t ON t.oid = c.conrelid
JOIN pg_catalog.pg_namespace n ON n.oid = t.relnamespace
LEFT JOIN pg_catalog.pg_class i ON i.oid = c.conindid
WHERE c.contype IN ('p','u','x')
    AND n.nspname !~ '^pg_'
    AND n.nspname <> 'information_schema'
ORDER BY n.nspname,t.relname,c.conname;
COMMIT;
