-- Title: View inventory with options
-- Description: List user views, security-barrier/check options, owner and normalized SQL definition.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT; metadata visibility follows object visibility
-- Risk: read-only
-- Source: original; https://github.com/andyatkinson/pg_scripts/blob/b7736708e0cfa5b8a3e88df8b1704a80b3566896/list_db_views.sql; https://www.postgresql.org/docs/18/catalog-pg-class.html
-- Runbook: procedures/triage.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- La query è ricostruita con pg_get_viewdef e non è un dump completo: commenti, grants e dipendenze
-- restano separati. Le definizioni possono contenere nomi o logica aziendale; valutare l'accesso
-- al risultato prima di condividerlo e verificare security_invoker/barrier prima di audit RLS.
SELECT n.nspname AS schema_name,c.relname AS view_name, pg_catalog.pg_get_userbyid(c.relowner) AS owner_role,
       c.reloptions, pg_catalog.pg_get_viewdef(c.oid,
                                    true) AS definition
FROM pg_catalog.pg_class c
JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
WHERE c.relkind = 'v'
    AND n.nspname NOT IN ('pg_catalog','information_schema')
ORDER BY n.nspname,c.relname
LIMIT 500;
COMMIT;
