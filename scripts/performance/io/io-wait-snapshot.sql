-- Title: Current I/O wait snapshot
-- Description: Summarize active sessions currently waiting on I/O by event and backend type.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_read_all_stats
-- Risk: read-only
-- Source: original; https://www.postgresql.org/docs/18/monitoring-stats.html
-- Runbook: procedures/monitoring.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Interpretazione e limiti: è uno snapshot istantaneo; raccogliere più campioni e correlare con metriche del sistema operativo.
SELECT backend_type,wait_event_type,wait_event,count(*) AS waiting_backends,
       max(clock_timestamp() - query_start) AS oldest_query_age
FROM pg_catalog.pg_stat_activity
WHERE state = 'active'
    AND wait_event_type = 'IO'
GROUP BY backend_type,wait_event_type,wait_event
ORDER BY waiting_backends DESC;
COMMIT;
