-- Title: Replication slot xmin horizons
-- Description: Identify replication slots retaining transaction or catalog horizons.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_monitor
-- Risk: read-only
-- Source: original; https://www.postgresql.org/docs/18/view-pg-replication-slots.html
-- Runbook: procedures/replication-lag.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Interpretazione e limiti: gli orizzonti non misurano byte WAL; durata e attività VACUUM determinano l'impatto.
SELECT slot_name,slot_type,database,active,xmin,pg_catalog.age(xmin) AS xmin_age,catalog_xmin,
       pg_catalog.age(catalog_xmin) AS catalog_xmin_age,restart_lsn,confirmed_flush_lsn
FROM pg_catalog.pg_replication_slots
WHERE xmin IS NOT NULL
    OR catalog_xmin IS NOT NULL
ORDER BY greatest(coalesce(pg_catalog.age(xmin), 0), coalesce(pg_catalog.age(catalog_xmin),
                                                         0)) DESC;
COMMIT;
