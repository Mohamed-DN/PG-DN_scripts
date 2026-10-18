-- Title: Constraint inventory
-- Description: Show constraint type, validation/deferral state and definition for application relations.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT; metadata visibility follows object visibility
-- Risk: read-only
-- Source: original; https://github.com/andyatkinson/pg_scripts/blob/b7736708e0cfa5b8a3e88df8b1704a80b3566896/foreign_keys.sql; https://www.postgresql.org/docs/18/catalog-pg-constraint.html
-- Runbook: procedures/triage.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- La definizione è ricostruita dal catalogo, utile per inventario e review, non è uno script di migrazione.
-- Convalidated=false identifica vincoli aggiunti NOT VALID o non ancora verificati: valutare separatamente
-- la motivazione prima di un VALIDATE CONSTRAINT, che può attendere lock e scandire la tabella.
SELECT n.nspname AS schema_name,c.relname AS relation_name,con.conname AS constraint_name,
       CASE con.contype WHEN 'c' THEN 'check' WHEN 'f' THEN 'foreign key' WHEN 'p' THEN 'primary key' WHEN 'u' THEN 'unique' WHEN 'x' THEN 'exclusion' WHEN 'n' THEN 'not null' ELSE con.contype::text
       END AS constraint_type, con.convalidated AS validated,con.condeferrable AS deferrable,
       con.condeferred AS initially_deferred, rn.nspname AS referenced_schema,rc.relname AS referenced_relation,
       pg_catalog.pg_get_constraintdef(con.oid, true) AS definition
FROM pg_catalog.pg_constraint AS con
JOIN pg_catalog.pg_class AS c ON c.oid = con.conrelid
JOIN pg_catalog.pg_namespace AS n ON n.oid = c.relnamespace
LEFT JOIN pg_catalog.pg_class AS rc ON rc.oid = con.confrelid
LEFT JOIN pg_catalog.pg_namespace AS rn ON rn.oid = rc.relnamespace
WHERE c.relkind IN ('r','p','f')
    AND n.nspname NOT IN ('pg_catalog','information_schema')
ORDER BY n.nspname,c.relname,con.conname
LIMIT 2000;
COMMIT;
