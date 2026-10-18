-- Title: Deadlocks and standby conflicts
-- Description: Review cumulative deadlock and recovery-conflict counters by database.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_monitor for complete statistics visibility
-- Risk: read-only
-- Source: original; https://github.com/andyatkinson/pg_scripts/blob/b7736708e0cfa5b8a3e88df8b1704a80b3566896/pg_stat_database.sql; https://www.postgresql.org/docs/18/monitoring-stats.html
-- Runbook: procedures/locks.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Deadlocks sono rilevati e risolti automaticamente dal server, ma il contatore non indica quali
-- sessioni o tabelle fossero coinvolte. I conflicts sono cancellazioni dovute al recovery su standby.
-- stats_reset serve a distinguere una crescita recente da contatori storici.
SELECT d.datname,d.stats_reset,d.deadlocks,d.conflicts,
       pg_catalog.pg_size_pretty(d.temp_bytes) AS temp_bytes_since_reset
FROM pg_catalog.pg_stat_database d
WHERE d.datname IS NOT NULL
    AND (d.deadlocks > 0
         OR d.conflicts > 0)
ORDER BY d.deadlocks DESC,d.conflicts DESC,d.datname
LIMIT 100;
COMMIT;
