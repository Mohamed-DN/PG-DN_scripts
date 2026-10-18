-- Title: Logical replication workers
-- Description: Show logical replication worker state and bounded query prefixes.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_read_all_stats
-- Risk: read-only
-- Source: user:script 3
-- Runbook: procedures/replication-lag.md
-- Usarla per osservare worker di replica logica attivi, stato e attese al momento del campione.
-- age parte dall'avvio backend; wait_event e query_prefix aiutano a distinguere lavoro da attesa.
-- Il prefisso può contenere dati applicativi; nessuna riga non prova che le subscription siano sane o abilitate.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT pid,backend_type,datname,usename,application_name,state,wait_event_type,wait_event,
       clock_timestamp() - backend_start AS age,left(query,
                                                    300) AS query_prefix
FROM pg_catalog.pg_stat_activity
WHERE backend_type LIKE '%logical replication%'
ORDER BY backend_start
LIMIT 100;
COMMIT;
