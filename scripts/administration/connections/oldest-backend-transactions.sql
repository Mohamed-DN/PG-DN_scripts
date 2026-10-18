-- Title: Oldest active backend transactions
-- Description: Rank visible sessions by transaction age and identify idle-in-transaction blockers.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_read_all_stats for complete session visibility
-- Risk: read-only
-- Source: original; https://github.com/Azmodey/pg_dba_scripts/blob/3ff7a9041e5a6a78a91bb222c962f76e30c1d3ab/scripts/pg_database_activity.sh; https://www.postgresql.org/docs/18/monitoring-stats.html
-- Runbook: procedures/locks.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- xact_start NULL significa nessuna transazione aperta; l'età non equivale automaticamente a lock.
-- query text è troncato a 250 caratteri e può comunque contenere dati sensibili: condividere con cautela.
-- I backend propri e privilegi pg_read_all_stats determinano quali dettagli sono visibili.
SELECT pid,datname,usename,application_name,state, clock_timestamp() - xact_start AS transaction_age,
       clock_timestamp() - state_change AS time_in_state, wait_event_type,wait_event,left(query,
                                                                                         250) AS query_sample
FROM pg_catalog.pg_stat_activity
WHERE xact_start IS NOT NULL
    AND pid <> pg_catalog.pg_backend_pid()
ORDER BY xact_start
LIMIT 100;
COMMIT;
