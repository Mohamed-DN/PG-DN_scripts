-- Title: Sequence inventory
-- Description: List sequence ownership and bounds without exposing current sequence values.
-- Postgres: 14+
-- Privilege: database CONNECT; sequence metadata visibility depends on privileges
-- Risk: read-only
-- Source: user:script 3.txt
-- Runbook: runbooks/monitoring.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT schemaname AS schema_name,sequencename AS sequence_name,sequenceowner AS owner,data_type,start_value,min_value,max_value,increment_by,cycle,cache_size FROM pg_catalog.pg_sequences ORDER BY schemaname,sequencename LIMIT 1000;
COMMIT;
