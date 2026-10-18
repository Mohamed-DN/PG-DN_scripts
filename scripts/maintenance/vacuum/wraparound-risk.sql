-- Title: Transaction and multixact age
-- Description: Compare database XID and multixact ages with configured autovacuum thresholds; investigate trends before acting.
-- Postgres: 14+
-- Privilege: CONNECT
-- Risk: read-only
-- Source: original; https://www.postgresql.org/docs/18/routine-vacuuming.html
-- Runbook: runbooks/vacuum-bloat.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT datname, age(datfrozenxid) AS xid_age, mxid_age(datminmxid) AS multixact_age,
       current_setting('autovacuum_freeze_max_age')::bigint AS autovacuum_freeze_max_age,
       current_setting('autovacuum_multixact_freeze_max_age')::bigint AS multixact_freeze_max_age,
       round(100.0*age(datfrozenxid)/nullif(current_setting('autovacuum_freeze_max_age')::bigint,0),2)
         AS pct_autovacuum_freeze_threshold
FROM pg_catalog.pg_database
ORDER BY age(datfrozenxid) DESC;
COMMIT;
