-- Title: Archive status
-- Description: Inspect cumulative archive success and failure counters; archive ordering can have exceptions.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT
-- Risk: read-only
-- Source: user:PROBLEMA_WAL_POSTGRES.sql
-- Runbook: procedures/wal-growth.md
-- Usarla per controllare contatori cumulativi di successo e fallimento dell'archiver.
-- archived_count/failed_count sono contatori; last_* indica ultimo file e timestamp registrati e stats_reset delimita la finestra.
-- I successi non provano assenza di buchi né presenza di ogni file nella destinazione: confrontare con marker e archivio.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT archived_count,last_archived_wal,last_archived_time,failed_count,last_failed_wal,last_failed_time,
       stats_reset
FROM pg_catalog.pg_stat_archiver;
COMMIT;
