-- Title: Extension-owned object dependencies
-- Description: Show objects that PostgreSQL marks as extension members and their owning extension.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT; visible object metadata
-- Risk: read-only
-- Source: original; https://github.com/andyatkinson/pg_scripts/blob/b7736708e0cfa5b8a3e88df8b1704a80b3566896/view_extensions.sql; https://www.postgresql.org/docs/18/catalog-pg-depend.html
-- Runbook: procedures/triage.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Deptype e identifica appartenenza a un'estensione: l'oggetto non va gestito come oggetto
-- indipendente senza considerare il ciclo di vita dell'estensione. Non esegue ALTER EXTENSION.
SELECT e.extname AS extension_name, pg_catalog.pg_describe_object(d.classid,
                                                   d.objid, d.objsubid) AS member_object,
       e.extversion AS installed_version
FROM pg_catalog.pg_depend d
JOIN pg_catalog.pg_extension e ON d.refclassid = 'pg_catalog.pg_extension'::regclass
AND d.refobjid = e.oid
WHERE d.deptype = 'e'
ORDER BY e.extname,member_object
LIMIT 2000;
COMMIT;
