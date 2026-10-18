-- Title: Backend session detail
-- Description: Summarize visible backends by database, user, application, client and state.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_read_all_stats for complete session metadata visibility
-- Risk: read-only
-- Source: original; https://github.com/Azmodey/pg_dba_scripts/blob/3ff7a9041e5a6a78a91bb222c962f76e30c1d3ab/scripts/pg_database_activity.sh; https://www.postgresql.org/docs/18/monitoring-stats.html
-- Runbook: procedures/triage.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Raggruppare riduce la possibile esposizione di identificativi client e query testuali.
-- application_name e client_addr arrivano dal client e possono essere vuoti o non affidabili.
-- Il conteggio è limitato alle righe visibili: senza pg_read_all_stats non rappresenta l'intero server.
SELECT datname,usename,application_name,client_addr,state,wait_event_type,count(*) AS backend_count
FROM pg_catalog.pg_stat_activity
WHERE backend_type = 'client backend'
GROUP BY datname,usename,application_name,client_addr,state,wait_event_type
ORDER BY backend_count DESC,datname,usename
LIMIT 500;
COMMIT;
