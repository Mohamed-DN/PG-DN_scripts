-- Title: Trigger inventory
-- Description: List enabled state, firing events and target routine for user-table triggers.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT; metadata visibility follows object visibility
-- Risk: read-only
-- Source: original; https://github.com/andyatkinson/pg_scripts/blob/b7736708e0cfa5b8a3e88df8b1704a80b3566896/list_table_object_dependencies.sql; https://www.postgresql.org/docs/18/catalog-pg-trigger.html
-- Runbook: procedures/triage.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- pg_get_triggerdef restituisce la definizione leggibile. I trigger interni (es. FK) sono segnalati
-- separatamente perché non sono trigger applicativi da abilitare/disabilitare manualmente.
-- Su partizioni possono comparire cloni: tgparentid aiuta a distinguerli dal trigger radice.
SELECT n.nspname AS schema_name,c.relname AS relation_name,t.tgname AS trigger_name, t.tgenabled AS enabled_code,
       t.tgisinternal AS internal_trigger, NULLIF(t.tgparentid,
                                               0) AS parent_trigger_oid, pn.nspname AS routine_schema,
       p.proname AS routine_name, pg_catalog.pg_get_triggerdef(t.oid,
                                                 true) AS definition
FROM pg_catalog.pg_trigger AS t
JOIN pg_catalog.pg_class AS c ON c.oid = t.tgrelid
JOIN pg_catalog.pg_namespace AS n ON n.oid = c.relnamespace
JOIN pg_catalog.pg_proc AS p ON p.oid = t.tgfoid
JOIN pg_catalog.pg_namespace AS pn ON pn.oid = p.pronamespace
WHERE n.nspname NOT IN ('pg_catalog','information_schema')
    AND n.nspname !~ '^pg_toast'
ORDER BY n.nspname,c.relname,t.tgname
LIMIT 1000;
COMMIT;
