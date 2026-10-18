-- Title: Direct object dependencies
-- Description: Show direct catalog dependency links among user relations, views, routines and types.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT; visible object metadata
-- Risk: read-only
-- Source: original; https://github.com/andyatkinson/pg_scripts/blob/b7736708e0cfa5b8a3e88df8b1704a80b3566896/list_table_object_dependencies.sql; https://www.postgresql.org/docs/18/catalog-pg-depend.html
-- Runbook: procedures/triage.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Ogni riga è una dipendenza diretta. deptype è un codice interno (n/a/i/e/P/S) con semantica
-- documentata nel catalogo; la query non calcola transitività né determina l'impatto completo di DROP.
-- pg_describe_object fornisce nomi leggibili ma può produrre descrizioni lunghe per oggetti complessi.
SELECT d.deptype AS dependency_type, pg_catalog.pg_describe_object(d.classid,
                                                    d.objid, d.objsubid) AS dependent_object,
       pg_catalog.pg_describe_object(d.refclassid,
                      d.refobjid, d.refobjsubid) AS referenced_object
FROM pg_catalog.pg_depend AS d
WHERE d.deptype IN ('n','a','i','e','P','S')
    AND (d.classid = 'pg_catalog.pg_class'::regclass
         OR d.refclassid = 'pg_catalog.pg_class'::regclass)
    AND (d.objid IN
             (SELECT c.oid
              FROM pg_catalog.pg_class c
              JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
              WHERE n.nspname NOT IN ('pg_catalog','information_schema'))
         OR d.refobjid IN
             (SELECT c.oid
              FROM pg_catalog.pg_class c
              JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
              WHERE n.nspname NOT IN ('pg_catalog','information_schema')))
ORDER BY dependent_object,referenced_object
LIMIT 2000;
COMMIT;
