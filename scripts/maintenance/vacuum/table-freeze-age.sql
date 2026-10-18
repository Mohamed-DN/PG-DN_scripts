-- Title: Table freeze age
-- Description: Rank relations by frozen XID age and configured autovacuum horizon.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_monitor for complete relation visibility
-- Risk: read-only
-- Source: original; https://www.postgresql.org/docs/18/routine-vacuuming.html
-- Runbook: procedures/vacuum-bloat.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Interpretazione e limiti: Età e soglia configurata non sono scadenze uniformi; correlare con avanzamento vacuum, dimensione e workload.
SELECT n.nspname,c.relname,age(c.relfrozenxid) AS xid_age,
       current_setting('autovacuum_freeze_max_age')::bigint AS freeze_max_age,
       round(100.0 * age(c.relfrozenxid) / nullif(current_setting('autovacuum_freeze_max_age')::bigint,
                                               0), 2) AS pct_limit,s.n_live_tup,s.last_autovacuum,c.reloptions
FROM pg_catalog.pg_class c
JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
LEFT JOIN pg_catalog.pg_stat_user_tables s ON s.relid = c.oid
WHERE c.relkind IN ('r','m')
    AND n.nspname !~ '^pg_'
    AND n.nspname <> 'information_schema'
ORDER BY xid_age DESC
LIMIT 250;
COMMIT;
