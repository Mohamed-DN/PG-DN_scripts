-- Title: Index build progress
-- Description: Show active index build progress; no cancellation or mutation is performed.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_read_all_stats for full visibility
-- Risk: read-only
-- Source: user:script 4
-- Runbook: procedures/slow-queries.md
-- Usarla durante CREATE INDEX o REINDEX per identificare relazione e fase corrente.
-- blocks_done/blocks_total e tuples_done/tuples_total sono contatori di fase; index_name indica l'indice quando disponibile.
-- Denominatori e contatori cambiano al cambio fase: sono snapshot e non una previsione lineare del tempo residuo.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT pid,datname,relid::regclass AS relation,index_relid::regclass AS index_name,command,phase,
       blocks_total,blocks_done,tuples_total,tuples_done
FROM pg_catalog.pg_stat_progress_create_index
WHERE datid =
        (SELECT oid
         FROM pg_catalog.pg_database
         WHERE datname = current_database())
ORDER BY pid
LIMIT 100;
COMMIT;
