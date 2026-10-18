-- Title: Collation provider and recorded versions
-- Description: Compare recorded and currently available collation versions to identify refresh review candidates.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT; visible collation metadata
-- Risk: read-only
-- Source: original; https://github.com/andyatkinson/pg_scripts/blob/b7736708e0cfa5b8a3e88df8b1704a80b3566896/list_collations.sql; https://www.postgresql.org/docs/18/catalog-pg-collation.html
-- Runbook: procedures/triage.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- La versione registrata può differire dopo un aggiornamento del sistema operativo o provider.
-- Una differenza richiede analisi degli indici dipendenti: questa query non esegue REFRESH VERSION
-- e non certifica che ogni indice interessato sia corrotto o debba essere ricostruito.
SELECT n.nspname AS schema_name,c.collname AS collation_name,c.collprovider AS provider,
       c.collisdeterministic AS deterministic,c.collencoding, c.collversion AS recorded_version,
       pg_catalog.pg_collation_actual_version(c.oid) AS actual_version, c.collversion IS DISTINCT
FROM pg_catalog.pg_collation_actual_version(c.oid) AS version_mismatch
FROM pg_catalog.pg_collation c
JOIN pg_catalog.pg_namespace n ON n.oid = c.collnamespace -- Le collations standard sono in pg_catalog: non escluderle dopo upgrade di libc/ICU.
-- Il provider database-default non rappresenta una collation versionata indipendente.

WHERE n.nspname <> 'information_schema'
    AND c.collprovider <> 'd'
ORDER BY version_mismatch DESC,n.nspname,c.collname
LIMIT 1000;
COMMIT;
