-- Title: Analyze progress
-- Description: Show active ANALYZE progress counters.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_read_all_stats for full visibility
-- Risk: read-only
-- Source: user:script 4
-- Runbook: procedures/vacuum-bloat.md
-- Usarla mentre ANALYZE è in corso per vedere fase e avanzamento del campionamento.
-- sample_blks_scanned rispetto a sample_blks_total indica il progresso dei blocchi; i campi ext_stats seguono statistiche estese.
-- La vista mostra solo operazioni attive; fase e denominatore possono cambiare e un'operazione breve può sparire tra campioni.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT pid,datname,relid::regclass AS relation,phase,sample_blks_total,sample_blks_scanned,
       ext_stats_total,ext_stats_computed,child_tables_total,child_tables_done
FROM pg_catalog.pg_stat_progress_analyze
WHERE datid =
        (SELECT oid
         FROM pg_catalog.pg_database
         WHERE datname = current_database())
ORDER BY pid
LIMIT 100;
COMMIT;
