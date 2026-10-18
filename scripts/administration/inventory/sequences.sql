-- Title: Sequence inventory
-- Description: List sequence ownership and bounds without exposing current sequence values.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT; sequence metadata visibility depends on privileges
-- Risk: read-only
-- Source: user:script 3.txt
-- Runbook: procedures/monitoring.md
-- Usarla per censire sequenze e configurazione di incremento, limiti, cache e ciclo.
-- start_value e min/max descrivono la definizione; cycle indica se il contatore può ripartire dal limite.
-- Il valore corrente non viene letto; pg_sequences può restituire NULL per metadati non visibili o sequenze mai usate.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT schemaname AS schema_name,sequencename AS sequence_name,sequenceowner AS owner,data_type,start_value,min_value,
       max_value,increment_by,cycle,cache_size
FROM pg_catalog.pg_sequences
ORDER BY schemaname,sequencename
LIMIT 1000;
COMMIT;
