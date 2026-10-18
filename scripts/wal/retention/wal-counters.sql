-- Title: WAL counters
-- Description: Show cumulative WAL byte and record counters; compare snapshots for rates.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_read_all_stats
-- Risk: read-only
-- Source: user:PROBLEMA_WAL_POSTGRES.sql
-- Runbook: procedures/wal-growth.md
-- Usarla per osservare produzione WAL e full-page image cumulative.
-- wal_bytes misura byte generati; wal_records e wal_fpi contano record e immagini, wal_buffers_full registra buffer WAL pieni.
-- I valori decorrono da stats_reset: usare differenze su intervalli comparabili per ricavare rate e correlare con picchi applicativi.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT wal_records,wal_fpi,wal_bytes,wal_buffers_full,stats_reset
FROM pg_catalog.pg_stat_wal;
COMMIT;
