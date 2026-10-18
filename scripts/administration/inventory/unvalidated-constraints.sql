-- Title: Unvalidated constraints
-- Description: Focus on constraints whose existing rows have not been fully checked by PostgreSQL.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT; metadata visibility follows object visibility
-- Risk: read-only
-- Source: original; https://github.com/andyatkinson/pg_scripts/blob/b7736708e0cfa5b8a3e88df8b1704a80b3566896/foreign_keys.sql; https://www.postgresql.org/docs/18/sql-altertable.html
-- Runbook: procedures/triage.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- NOT VALID consente di proteggere nuove modifiche senza certificare quelle già presenti.
-- Il risultato aiuta a trovare il debito di validazione; non prova che esistano righe errate.
-- VALIDATE CONSTRAINT è un'azione distinta: pianificarla per lock, durata e volume della relazione.
SELECT n.nspname AS schema_name,c.relname AS relation_name,con.conname AS constraint_name, con.contype AS type_code,
       pg_catalog.pg_get_constraintdef(con.oid, true) AS definition, con.convalidated AS validated,
       pg_catalog.pg_size_pretty(pg_catalog.pg_total_relation_size(c.oid)) AS relation_size
FROM pg_catalog.pg_constraint AS con
JOIN pg_catalog.pg_class AS c ON c.oid = con.conrelid
JOIN pg_catalog.pg_namespace AS n ON n.oid = c.relnamespace
WHERE NOT con.convalidated
    AND n.nspname NOT IN ('pg_catalog','information_schema')
ORDER BY pg_catalog.pg_total_relation_size(c.oid) DESC,n.nspname,c.relname,con.conname
LIMIT 500;
COMMIT;
