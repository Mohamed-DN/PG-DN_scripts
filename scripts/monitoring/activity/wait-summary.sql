-- Title: Wait event summary
-- Description: Summarize sessions by backend type, state and wait event.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_read_all_stats for complete details
-- Risk: read-only
-- Source: user:script 4
-- Runbook: procedures/triage.md
-- Usarla per aggregare sessioni per backend, stato e wait event durante un triage.
-- sessions conta sessioni visibili; wait_event NULL è comune quando il backend non attende un evento tracciato.
-- È una fotografia senza cronologia: confrontare campioni successivi per distinguere un picco da un'attesa persistente.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT backend_type,state,wait_event_type,wait_event,count(*) AS sessions
FROM pg_catalog.pg_stat_activity
GROUP BY backend_type,state,wait_event_type,wait_event
ORDER BY sessions DESC
LIMIT 100;
COMMIT;
