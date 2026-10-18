-- Title: Relation size breakdown
-- Description: Compare heap, indexes and total allocated size; these are not direct bloat estimates.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT
-- Risk: read-only
-- Source: user:+Postgres_Main_commands.sql
-- Runbook: procedures/vacuum-bloat.md
-- Usarla per separare allocazione heap, indici e totale delle relazioni utente più grandi.
-- heap_bytes esclude gli indici, index_bytes li somma e total_bytes restituisce la dimensione complessiva della relazione.
-- Sono misure di spazio allocato, non una stima di bloat o spazio restituibile; include anche materialized e partitioned tables.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT n.nspname,c.relname,pg_catalog.pg_relation_size(c.oid) AS heap_bytes,
       pg_catalog.pg_indexes_size(c.oid) AS index_bytes,pg_catalog.pg_total_relation_size(c.oid) AS total_bytes
FROM pg_catalog.pg_class c
JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
WHERE c.relkind IN ('r','m','p')
    AND n.nspname !~ '^pg_'
ORDER BY total_bytes DESC
LIMIT 100;
COMMIT;
