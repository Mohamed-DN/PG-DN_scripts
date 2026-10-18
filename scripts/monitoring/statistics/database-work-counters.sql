-- Title: Database workload counters
-- Description: Compare transaction, tuple, temporary-file, conflict and deadlock counters by database.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_monitor for complete visibility; otherwise visible databases only
-- Risk: read-only
-- Source: original; https://github.com/andyatkinson/pg_scripts/blob/b7736708e0cfa5b8a3e88df8b1704a80b3566896/pg_stat_database.sql; https://www.postgresql.org/docs/18/monitoring-stats.html
-- Runbook: procedures/monitoring.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Sono contatori cumulativi tra stats_reset; confrontare campioni successivi per stimare il tasso.
-- temp_bytes indica dati scritti in file temporanei, non necessariamente spazio ancora occupato.
-- conflicts è soprattutto rilevante sulle standby; deadlocks è cumulativo, non un conteggio recente.
SELECT datname,stats_reset,numbackends,xact_commit,xact_rollback, tup_returned,tup_fetched,tup_inserted,
       tup_updated,tup_deleted, temp_files,pg_catalog.pg_size_pretty(temp_bytes) AS temp_written, deadlocks,
       conflicts
FROM pg_catalog.pg_stat_database
WHERE datname IS NOT NULL
ORDER BY deadlocks DESC,temp_bytes DESC,datname
LIMIT 100;
COMMIT;
