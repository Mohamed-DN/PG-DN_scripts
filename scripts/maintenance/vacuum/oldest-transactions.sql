-- Title: Old transactions
-- Description: Inspect backends with open transactions; long transactions can delay cleanup.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_read_all_stats for complete details
-- Risk: read-only
-- Source: user:+Postgres_Troubleshooting_WAL_Replica_Vacuum_Bloat.sql
-- Runbook: procedures/vacuum-bloat.md
-- Usarla per individuare transazioni aperte a lungo che possono trattenere snapshot e ritardare il cleanup.
-- age parte da xact_start; backend_xid/backend_xmin aiutano a valutare gli orizzonti, mentre wait_event mostra attese.
-- Il query_prefix può contenere dati sensibili; xmin NULL non esclude altre cause di retention e la query non termina sessioni.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT pid,datname,usename,state,clock_timestamp() - xact_start AS age,backend_xid,backend_xmin,
       wait_event_type,wait_event,left(query, 300) AS query_prefix
FROM pg_catalog.pg_stat_activity
WHERE xact_start IS NOT NULL
ORDER BY xact_start
LIMIT 100;
COMMIT;
