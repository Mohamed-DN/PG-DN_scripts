-- Title: Active sessions
-- Description: Show active sessions, age, waits and bounded query prefix; query text may contain sensitive values.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_read_all_stats; otherwise own sessions
-- Risk: read-only
-- Source: user:+Postgres_Main_commands.sql
-- Runbook: procedures/triage.md
-- Usarla nel triage per vedere query attive, durata e attesa associata.
-- age è il tempo da query_start; wait_event_type/event distinguono attese, mentre query_prefix è solo un prefisso.
-- È uno snapshot e il testo può contenere valori sensibili; i dettagli completi richiedono visibilità adeguata.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT pid,datname,usename,application_name,client_addr,state,wait_event_type,wait_event,
       clock_timestamp() - query_start AS age,left(query,
                                                  400) AS query_prefix
FROM pg_catalog.pg_stat_activity
WHERE state = 'active'
    AND pid <> pg_catalog.pg_backend_pid()
ORDER BY query_start NULLS LAST
LIMIT 100;
COMMIT;
