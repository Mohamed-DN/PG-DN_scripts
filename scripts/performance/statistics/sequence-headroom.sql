-- Title: Sequence exhaustion headroom
-- Description: Estimate remaining sequence increments from current last value to the configured bound.
-- Postgres: 14–18 (verificato)
-- Privilege: CONNECT and USAGE or SELECT on each sequence
-- Risk: read-only
-- Source: original; https://www.postgresql.org/docs/18/view-pg-sequences.html
-- Runbook: procedures/triage.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Quando usarla: identificare sequenze con margine residuo ridotto e pianificare verifiche.
-- Interpretazione e limiti: last_value può essere NULL senza permesso di lettura o prima del primo uso. Cache e incrementi rendono la stima approssimativa; la query non consuma valori.
SELECT schemaname,sequencename,data_type,min_value,max_value,increment_by,cycle,cache_size,last_value,
       CASE WHEN last_value IS NULL THEN NULL
           WHEN increment_by > 0 THEN floor((max_value::numeric - last_value::numeric) / increment_by) ELSE floor((last_value::numeric - min_value::numeric) / abs(increment_by::numeric))
       END AS estimated_steps_remaining
FROM pg_catalog.pg_sequences
ORDER BY estimated_steps_remaining NULLS FIRST
LIMIT 200;
COMMIT;
