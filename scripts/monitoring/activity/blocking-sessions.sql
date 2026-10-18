-- Title: Blocking sessions
-- Description: Show one row per blocked session and blocking PID; a zero PID denotes a prepared transaction.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_read_all_stats for complete activity
-- Risk: read-only
-- Source: original; https://www.postgresql.org/docs/18/functions-info.html
-- Runbook: procedures/locks.md
-- Usarla per trovare sessioni bloccate e i PID che pg_blocking_pids segnala come blocker.
-- Ogni riga è una coppia bloccato/bloccante; blocker_pid=0 rappresenta un prepared transaction senza PID ordinario.
-- Query text e nomi possono essere sensibili; è uno snapshot e query_age può essere NULL per sessioni senza query corrente.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Query text may contain application data. Redact before attaching output to a ticket.
SELECT a.pid AS blocked_pid, b.blocker_pid, a.datname, a.usename, a.wait_event_type, a.wait_event,
       pg_catalog.clock_timestamp() - a.query_start AS query_age, left(a.query,
                                                                      250) AS blocked_query, blocker.state AS blocker_state,
       blocker.xact_start AS blocker_xact_start
FROM pg_catalog.pg_stat_activity AS a
CROSS JOIN LATERAL unnest(pg_catalog.pg_blocking_pids(a.pid)) AS b(blocker_pid)
LEFT JOIN pg_catalog.pg_stat_activity AS blocker ON blocker.pid = b.blocker_pid
ORDER BY a.query_start NULLS LAST, a.pid, b.blocker_pid
LIMIT 100;
COMMIT;
