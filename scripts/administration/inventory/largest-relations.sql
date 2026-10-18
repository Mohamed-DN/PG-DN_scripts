-- Title: Largest relations
-- Description: Rank user tables by total allocated bytes including indexes and TOAST.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT
-- Risk: read-only
-- Source: user:+Postgres_Comandi_Principali_Diagnostica_Stats_Ruoli.sql
-- Runbook: procedures/monitoring.md
-- Usarla per trovare le tabelle utente con maggiore allocazione complessiva, inclusi indici e TOAST.
-- total_bytes è la misura numerica ordinabile e total_size la sua resa leggibile; il filtro include relazioni partizionate.
-- Spazio allocato non equivale a bloat; un parent partizionato può avere poca allocazione propria, quindi valutare i figli.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT n.nspname AS schema_name,c.relname,pg_catalog.pg_total_relation_size(c.oid) AS total_bytes,
       pg_catalog.pg_size_pretty(pg_catalog.pg_total_relation_size(c.oid)) AS total_size
FROM pg_catalog.pg_class c
JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
WHERE c.relkind IN ('r','p')
    AND n.nspname !~ '^pg_'
    AND n.nspname <> 'information_schema'
ORDER BY total_bytes DESC
LIMIT 50;
COMMIT;
