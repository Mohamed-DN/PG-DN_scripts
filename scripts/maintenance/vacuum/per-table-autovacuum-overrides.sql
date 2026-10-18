-- Title: Per-table autovacuum overrides
-- Description: List relation-level storage options that override global maintenance settings.
-- Postgres: 14–18 (verificato)
-- Privilege: CONNECT
-- Risk: read-only
-- Source: original; https://www.postgresql.org/docs/18/sql-createtable.html
-- Runbook: procedures/vacuum-bloat.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Interpretazione e limiti: reloptions contiene gli override locali, non la configurazione effettiva combinata; l’assenza di override usa i default.
SELECT n.nspname,c.relname,c.relkind,c.reloptions,
       current_setting('autovacuum') AS cluster_autovacuum_enabled, current_setting('autovacuum_vacuum_threshold') AS vacuum_threshold,
       current_setting('autovacuum_vacuum_scale_factor') AS vacuum_scale_factor, current_setting('autovacuum_analyze_threshold') AS analyze_threshold,
       current_setting('autovacuum_analyze_scale_factor') AS analyze_scale_factor
FROM pg_catalog.pg_class c
JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
WHERE c.relkind IN ('r','m','t')
    AND n.nspname !~ '^pg_'
    AND n.nspname <> 'information_schema'
    AND c.reloptions IS NOT NULL
ORDER BY 1,2;
COMMIT;
