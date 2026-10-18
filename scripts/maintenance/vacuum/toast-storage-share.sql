-- Title: TOAST storage candidates
-- Description: Rank tables by TOAST relation storage and display update estimates.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_monitor for complete relation visibility
-- Risk: read-only
-- Source: original; https://www.postgresql.org/docs/18/storage-toast.html
-- Runbook: procedures/vacuum-bloat.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Interpretazione e limiti: i byte TOAST descrivono valori conservati fuori riga e non stimano spazio sprecato o bloat.
SELECT n.nspname,c.relname,pg_catalog.pg_total_relation_size(c.oid) AS total_bytes,
       pg_catalog.pg_table_size(c.oid) AS table_bytes,pg_catalog.pg_indexes_size(c.oid) AS index_bytes,
       CASE WHEN c.reltoastrelid = 0 THEN 0 ELSE pg_catalog.pg_total_relation_size(c.reltoastrelid)
       END AS toast_bytes, s.n_live_tup,s.n_tup_upd
FROM pg_catalog.pg_class c
JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
LEFT JOIN pg_catalog.pg_stat_user_tables s ON s.relid = c.oid
WHERE c.relkind IN ('r','m')
    AND n.nspname !~ '^pg_'
    AND n.nspname <> 'information_schema'
ORDER BY toast_bytes DESC
LIMIT 200;
COMMIT;
