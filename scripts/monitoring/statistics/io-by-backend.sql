-- Title: I/O statistics by backend
-- Description: Summarize common PostgreSQL 16+ pg_stat_io counters by backend, object and I/O context.
-- Postgres: 16–18 (verificato; pg_stat_io introdotta in PostgreSQL 16)
-- Privilege: pg_monitor for complete cluster statistics visibility
-- Risk: read-only
-- Source: original; https://github.com/andyatkinson/pg_scripts/blob/b7736708e0cfa5b8a3e88df8b1704a80b3566896/hunting_iops.sql; https://www.postgresql.org/docs/18/monitoring-stats.html
-- Runbook: procedures/monitoring.md
\set ON_ERROR_STOP on
\pset pager off
SELECT current_setting('server_version_num')::integer >= 160000 AS version_supported \gset
\if :version_supported
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Da usare solo su PostgreSQL 16 o successivo: pg_stat_io non esiste nelle release 14–15.
-- I contatori hanno granularità per backend/object/context e restano cumulativi dall'ultimo reset;
-- i byte per operazione sono cambiati tra release, quindi questa query usa solo colonne condivise.
-- Correlare con finestre temporali e metriche OS: le durate dipendono dall'abilitazione I/O timing.
SELECT backend_type,object,context,reads,read_time,writes,write_time, extends,evictions,fsyncs,stats_reset
FROM pg_catalog.pg_stat_io
ORDER BY reads DESC NULLS LAST,writes DESC NULLS LAST
LIMIT 500;
COMMIT;
\else
\echo PostgreSQL 16+ is required; query skipped.
\endif
