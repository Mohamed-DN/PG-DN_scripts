-- Title: Column skew metadata
-- Description: Show estimated distinctness and MCV array size without returning sensitive MCV values.
-- Postgres: 14–18 (verificato)
-- Privilege: CONNECT and SELECT on analyzed columns
-- Risk: read-only
-- Source: original; https://www.postgresql.org/docs/18/view-pg-stats.html
-- Runbook: procedures/slow-queries.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Interpretazione e limiti: n_distinct negativo è relativo alle righe stimate; array MCV è campionato e limitato dal target di statistiche, non mostra la distribuzione completa.
SELECT schemaname,tablename,attname,null_frac,n_distinct,correlation,
       array_length(most_common_freqs, 1) AS mcv_slots, most_common_freqs[1] AS largest_mcv_frequency,
       pg_catalog.has_column_privilege(current_user,
                      pg_catalog.format('%I.%I',
                                     schemaname, tablename), attname, 'SELECT') AS can_select_column
FROM pg_catalog.pg_stats
WHERE schemaname !~ '^pg_'
    AND schemaname <> 'information_schema'
ORDER BY abs(n_distinct),largest_mcv_frequency DESC NULLS LAST
LIMIT 300;
COMMIT;
