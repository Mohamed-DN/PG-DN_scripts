-- Title: Blocking impact by backend
-- Description: Rank immediate blockers by number of waiting sessions in the current database.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_read_all_stats for complete session metadata
-- Risk: read-only
-- Source: adapted from https://github.com/limdauto/pg-monitoring/blob/1cb18cbecc8d1f67ea1d3e8f141cbd4e012a1efe/locks/statements.sql; https://www.postgresql.org/docs/18/functions-info.html
-- Runbook: procedures/locks.md
-- Copyright (c) 2016 Nghia (lim) Hoang. MIT; notice preserved in _support/upstream/limdauto_pg_monitoring/LICENSE.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Individua quali backend hanno l'impatto più ampio sulla coda, prima di scegliere un intervento.
-- pg_locks non concesso identifica chi attende, non chi blocca: la relazione si ricava da pg_blocking_pids.
-- La durata della query non è la durata del blocco. PID 0 rappresenta una transazione preparata;
-- i blocchi qui sono immediati, non una ricostruzione transitiva della catena completa.
WITH edges AS
    (SELECT a.pid AS waiting_pid, a.query_start, b.blocker_pid
     FROM pg_catalog.pg_stat_activity AS a
     CROSS JOIN LATERAL unnest(pg_catalog.pg_blocking_pids(a.pid)) AS b(blocker_pid)
     WHERE a.datname = current_database())
SELECT e.blocker_pid, a.usename AS blocker_role, a.state AS blocker_state,
       count(DISTINCT e.waiting_pid) AS waiting_sessions, max(clock_timestamp() - e.query_start) AS oldest_waiting_query_age,
       a.xact_start AS blocker_transaction_start
FROM edges AS e
LEFT JOIN pg_catalog.pg_stat_activity AS a ON a.pid = e.blocker_pid
GROUP BY e.blocker_pid,a.usename,a.state,a.xact_start
ORDER BY waiting_sessions DESC,e.blocker_pid
LIMIT 100;
COMMIT;
