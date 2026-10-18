-- Title: Logical publication table mapping
-- Description: List tables included in each publication, including all-table membership.
-- Postgres: 14–18 (verificato)
-- Privilege: CONNECT
-- Risk: read-only
-- Source: original; https://www.postgresql.org/docs/18/view-pg-publication-tables.html
-- Runbook: procedures/replication-lag.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Interpretazione e limiti: sono selezionati solo campi comuni a PostgreSQL 14–18; non vengono mostrati valori di riga o filtri.
SELECT pubname,schemaname,tablename
FROM pg_catalog.pg_publication_tables
ORDER BY pubname,schemaname,tablename;
COMMIT;
