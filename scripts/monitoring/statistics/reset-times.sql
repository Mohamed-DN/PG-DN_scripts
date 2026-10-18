-- Title: Statistics reset times
-- Description: Show database statistics reset timestamps to interpret cumulative counters.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT
-- Risk: read-only
-- Source: user:POSTGRES_STATS.Sql
-- Runbook: procedures/monitoring.md
-- Usarla prima di confrontare statistiche per conoscere l'ultimo reset registrato per database.
-- stats_reset è il riferimento temporale per i contatori di pg_stat_database; NULL significa che il reset time non è noto.
-- Non misura traffico o salute: va affiancata ai contatori e usata per delimitare la finestra di confronto.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT datname,stats_reset
FROM pg_catalog.pg_stat_database
ORDER BY datname
LIMIT 100;
COMMIT;
