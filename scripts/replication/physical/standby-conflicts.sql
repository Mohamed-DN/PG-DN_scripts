-- Title: Standby recovery conflicts
-- Description: Show cumulative standby conflict cancellations by conflict class and database.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_monitor
-- Risk: read-only
-- Source: original; https://www.postgresql.org/docs/18/monitoring-stats.html
-- Runbook: procedures/replication-lag.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Interpretazione e limiti: i contatori non identificano le query cancellate; correlare con log e policy di replay dello standby.
SELECT c.datname,c.confl_tablespace,c.confl_lock,c.confl_snapshot,c.confl_bufferpin, c.confl_deadlock,
       d.stats_reset
FROM pg_catalog.pg_stat_database_conflicts c
LEFT JOIN pg_catalog.pg_stat_database d ON d.datid = c.datid
ORDER BY c.confl_tablespace + c.confl_lock + c.confl_snapshot + c.confl_bufferpin + c.confl_deadlock DESC;
COMMIT;
