-- Title: I/O by backend and context
-- Description: Inspect cumulative I/O counters; correlate them with operating system metrics.
-- Postgres: 16–18 (verificato)
-- Privilege: pg_read_all_stats; PostgreSQL 16+
-- Risk: read-only
-- Source: user:script 4
-- Runbook: procedures/monitoring.md
-- Usarla su PostgreSQL 16+ per ripartire I/O per tipo backend, oggetto e contesto.
-- reads/writes/extends sono conteggi; i campi *_time sono cumulativi e stats_reset ancora la finestra.
-- Non misura direttamente latenza dispositivo: confrontare delta e metriche host, considerando cache e contesto.
\set ON_ERROR_STOP on
\pset pager off
SELECT (current_setting('server_version_num')::integer >= 160000) AS pg_version_supported \gset
\if :pg_version_supported
\else
\echo PostgreSQL 16+ is required.
\quit
\endif
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT backend_type,object,context,reads,read_time,writes,write_time,extends,extend_time,stats_reset
FROM pg_catalog.pg_stat_io
ORDER BY reads + writes + extends DESC NULLS LAST
LIMIT 200;
COMMIT;
