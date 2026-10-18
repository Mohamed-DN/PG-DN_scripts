-- Title: TOAST storage breakdown
-- Description: Show heap, index and TOAST allocation for larger user tables.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT
-- Risk: read-only
-- Source: user:+Postgres_Comandi_Principali_Diagnostica_Stats_Ruoli.sql
-- Runbook: procedures/vacuum-bloat.md
-- Usarla quando colonne con valori larghi potrebbero contribuire molto all'occupazione delle tabelle.
-- toast_bytes misura l'albero TOAST associato; index_bytes e total_bytes forniscono il confronto con indici e allocazione totale.
-- Non stima bloat recuperabile e non dettaglia le singole relazioni TOAST sottostanti.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT n.nspname,c.relname,pg_catalog.pg_relation_size(c.oid) AS heap_bytes,
       pg_catalog.pg_indexes_size(c.oid) AS index_bytes,
       CASE WHEN c.reltoastrelid = 0 THEN 0 ELSE pg_catalog.pg_total_relation_size(c.reltoastrelid)
       END AS toast_bytes,pg_catalog.pg_total_relation_size(c.oid) AS total_bytes
FROM pg_catalog.pg_class c
JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
WHERE c.relkind IN ('r','m','p')
    AND n.nspname !~ '^pg_'
ORDER BY total_bytes DESC
LIMIT 100;
COMMIT;
