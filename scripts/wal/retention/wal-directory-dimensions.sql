-- Title: WAL directory dimensions
-- Description: Count WAL segment-shaped files and measure observed sizes and modification times.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_monitor
-- Risk: read-only
-- Source: original; https://www.postgresql.org/docs/18/functions-admin.html
-- Runbook: procedures/wal-growth.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Interpretazione e limiti: misura solo i file locali visibili; la dimensione non identifica il meccanismo che li trattiene. I segmenti vanno misurati, non presunti.
SELECT count(*) FILTER(
                       WHERE name ~ '^[0-9A-F]{24}([.]partial)?$') AS wal_file_count,count(*) FILTER(
                                                                                                     WHERE name ~ '^[0-9A-F]{24}$') AS complete_segment_count,
       count(*) FILTER(
                       WHERE name ~ '[.]partial$') AS partial_count,sum(size) FILTER(
                                                                                     WHERE name ~ '^[0-9A-F]{24}([.]partial)?$') AS total_bytes,
       min(size) FILTER(
                        WHERE name ~ '^[0-9A-F]{24}$') AS min_complete_bytes,max(size) FILTER(
                                                                                              WHERE name ~ '^[0-9A-F]{24}$') AS max_complete_bytes,
       min(modification) AS oldest_seen,max(modification) AS newest_seen
FROM pg_catalog.pg_ls_waldir();
COMMIT;
