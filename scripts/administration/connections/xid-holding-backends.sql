-- Title: Sessions holding old transaction horizons
-- Description: Rank sessions by backend xmin, the reported visibility horizon relevant to vacuum cleanup.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_read_all_stats for complete session visibility
-- Risk: read-only
-- Source: original; https://github.com/andyatkinson/pg_scripts/blob/b7736708e0cfa5b8a3e88df8b1704a80b3566896/idle_transactions.sql; https://www.postgresql.org/docs/18/monitoring-stats.html
-- Runbook: procedures/vacuum-bloat.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- backend_xmin è l'horizon riportato dal backend, non è sempre valorizzato e non prova da solo
-- che quel processo stia impedendo VACUUM. L'età XID cresce rispetto al contatore corrente;
-- correlare con oldest transaction, replica slot e progresso autovacuum prima di intervenire.
SELECT pid,datname,usename,application_name,state, backend_xmin,
       pg_catalog.age(backend_xmin) AS xmin_age, clock_timestamp() - xact_start AS transaction_age, wait_event_type,wait_event
FROM pg_catalog.pg_stat_activity
WHERE backend_xmin IS NOT NULL
ORDER BY pg_catalog.age(backend_xmin) DESC
LIMIT 100;
COMMIT;
