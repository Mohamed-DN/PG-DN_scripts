-- Title: Table multixact age
-- Description: Rank relations by multixact horizon age with configured limit context.
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
-- Interpretazione e limiti: l'età MXID è distinta dall'età XID; carico di row lock e avanzamento VACUUM ne determinano la rilevanza.
SELECT n.nspname,c.relname,pg_catalog.mxid_age(c.relminmxid) AS multixact_age,
       current_setting('autovacuum_multixact_freeze_max_age')::bigint AS configured_limit,
       round(100.0 * pg_catalog.mxid_age(c.relminmxid) / nullif(current_setting('autovacuum_multixact_freeze_max_age')::bigint,
                                                             0), 2) AS pct_limit,s.n_live_tup,s.last_autovacuum,c.reloptions
FROM pg_catalog.pg_class c
JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
LEFT JOIN pg_catalog.pg_stat_user_tables s ON s.relid = c.oid
WHERE c.relkind IN ('r','m')
    AND n.nspname !~ '^pg_'
    AND n.nspname <> 'information_schema'
ORDER BY multixact_age DESC
LIMIT 250;
COMMIT;
