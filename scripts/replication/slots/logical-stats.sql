-- Title: Logical slot counters
-- Description: Inspect cumulative logical decoding slot statistics.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT
-- Risk: read-only
-- Source: user:script 3
-- Runbook: procedures/replication-lag.md
-- Usarla per individuare slot logici con spill o streaming consistente.
-- spill_* conta transazioni, eventi e byte spillati; stream_* e total_* descrivono attività logica cumulativa.
-- Sono statistiche soggette a reset, non byte WAL trattenuti; per il retained WAL usare la vista degli slot.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT slot_name,spill_txns,spill_count,spill_bytes,stream_txns,stream_count,stream_bytes,total_txns,
       total_bytes
FROM pg_catalog.pg_stat_replication_slots
ORDER BY total_bytes DESC NULLS LAST
LIMIT 200;
COMMIT;
