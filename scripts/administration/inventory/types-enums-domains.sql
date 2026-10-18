-- Title: Enum and domain type inventory
-- Description: Inspect enum labels and domain base type, nullability and check constraints.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT; visible type metadata
-- Risk: read-only
-- Source: original; https://github.com/andyatkinson/pg_scripts/blob/b7736708e0cfa5b8a3e88df8b1704a80b3566896/list_enums.sql; https://www.postgresql.org/docs/18/catalog-pg-type.html
-- Runbook: procedures/triage.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Unisce due viste descrittive per evitare di ripetere righe: labels contiene un array ordinato
-- per sort order, mentre i campi domain_* sono NULL per i tipi che non sono domini.
-- Le espressioni dei check sono testo catalogo e non vengono eseguite da questa query.
SELECT n.nspname AS schema_name,t.typname AS type_name,
       CASE WHEN t.typtype = 'e' THEN 'enum' WHEN t.typtype = 'd' THEN 'domain'
       END AS type_kind, bt.typname AS domain_base_type, t.typnotnull AS domain_not_null,

    (SELECT array_agg(e.enumlabel
                      ORDER BY e.enumsortorder)
     FROM pg_catalog.pg_enum e
     WHERE e.enumtypid = t.oid) AS enum_labels,

    (SELECT array_agg(pg_catalog.pg_get_constraintdef(c.oid,
                                     true)
                      ORDER BY c.conname)
     FROM pg_catalog.pg_constraint c
     WHERE c.contypid = t.oid) AS domain_checks
FROM pg_catalog.pg_type t
JOIN pg_catalog.pg_namespace n ON n.oid = t.typnamespace
LEFT JOIN pg_catalog.pg_type bt ON bt.oid = t.typbasetype
WHERE t.typtype IN ('e','d')
    AND n.nspname NOT IN ('pg_catalog','information_schema')
ORDER BY n.nspname,t.typname
LIMIT 1000;
COMMIT;
