-- Title: Database transaction ID age
-- Description: Rank databases by frozen transaction ID age and report the configured wraparound threshold.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT; pg_monitor recommended for cluster-wide statistics
-- Risk: read-only
-- Source: original; https://github.com/andyatkinson/pg_scripts/blob/b7736708e0cfa5b8a3e88df8b1704a80b3566896/detect_transaction_id_wraparound.sql; https://www.postgresql.org/docs/18/routine-vacuuming.html
-- Runbook: procedures/vacuum-bloat.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- age(datfrozenxid) è una misura di distanza dal freeze horizon, non un tempo in giorni.
-- Il valore è cluster-wide per database; usare anche la diagnostica per tabelle per localizzare
-- il responsabile. autovacuum_freeze_max_age fornisce un riferimento configurato, non una scadenza.
SELECT d.datname,pg_catalog.age(d.datfrozenxid) AS xid_age,
       current_setting('autovacuum_freeze_max_age')::bigint AS configured_freeze_max_age,
       round(100.0 * pg_catalog.age(d.datfrozenxid) / NULLIF(current_setting('autovacuum_freeze_max_age')::bigint,
                                                          0), 1) AS percent_of_threshold, d.datallowconn
FROM pg_catalog.pg_database d
WHERE d.datname IS NOT NULL
ORDER BY pg_catalog.age(d.datfrozenxid) DESC
LIMIT 100;
COMMIT;
