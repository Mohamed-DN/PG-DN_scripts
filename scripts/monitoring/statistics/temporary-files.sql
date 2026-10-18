-- Title: Temporary file counters by database
-- Description: Rank databases by cumulative temporary-file count and bytes written.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_monitor for complete database statistics visibility
-- Risk: read-only
-- Source: original; https://github.com/andyatkinson/pg_scripts/blob/b7736708e0cfa5b8a3e88df8b1704a80b3566896/pg_stat_database.sql; https://www.postgresql.org/docs/18/monitoring-stats.html
-- Runbook: procedures/monitoring.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- temp_bytes è il volume scritto dall'ultimo reset, non la dimensione corrente dei file temporanei.
-- Confrontare due campioni con stats_reset stabile per stimare il tasso; identificare le query
-- specifiche tramite pg_stat_statements o log se già abilitati, senza installare estensioni qui.
SELECT datname,stats_reset,temp_files,temp_bytes,
       pg_catalog.pg_size_pretty(temp_bytes) AS temp_bytes_pretty
FROM pg_catalog.pg_stat_database
WHERE datname IS NOT NULL
    AND temp_files > 0
ORDER BY temp_bytes DESC,datname
LIMIT 100;
COMMIT;
