-- Title: Sequence inventory context
-- Description: Show sequence bounds, increments, cycle and cache settings separately from current headroom.
-- Postgres: 14–18 (verificato)
-- Privilege: CONNECT
-- Risk: read-only
-- Source: original; https://www.postgresql.org/docs/18/view-pg-sequences.html
-- Runbook: procedures/triage.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Interpretazione e limiti: la configurazione non mostra la velocità di consumo. last_value è omesso; usare la query sul margine solo se i privilegi lo consentono.
SELECT schemaname,sequencename,data_type,start_value,min_value,max_value,increment_by,cycle,cache_size
FROM pg_catalog.pg_sequences
ORDER BY schemaname,sequencename;
COMMIT;
