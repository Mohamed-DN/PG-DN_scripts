-- Title: Foreign keys without leading index
-- Description: Find foreign-key columns not covered by a valid, non-partial index whose leading key set covers the FK columns.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_monitor for complete relation visibility
-- Risk: read-only
-- Source: original; https://www.postgresql.org/docs/18/catalog-pg-constraint.html
-- Runbook: procedures/slow-queries.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Interpretazione e limiti: si confrontano come insieme le prime N chiavi, perché la FK genera uguaglianze su tutte le colonne; le colonne INCLUDE non contano. Gli indici parziali non sono copertura generale. Valutare carico sul padre e dimensioni prima di progettare un indice.
WITH f AS
    (SELECT c.oid,c.conrelid,c.conname,c.conkey,n.nspname,t.relname
     FROM pg_catalog.pg_constraint c
     JOIN pg_catalog.pg_class t ON t.oid = c.conrelid
     JOIN pg_catalog.pg_namespace n ON n.oid = t.relnamespace
     WHERE c.contype = 'f'
         AND n.nspname !~ '^pg_'
         AND n.nspname <> 'information_schema')
SELECT f.nspname AS schema_name,f.relname AS table_name,f.conname,
       pg_catalog.pg_get_constraintdef(f.oid, true) AS definition
FROM f
WHERE NOT EXISTS
        (SELECT 1
         FROM pg_catalog.pg_index i
         JOIN pg_catalog.pg_class ix ON ix.oid = i.indexrelid
         JOIN pg_catalog.pg_am am ON am.oid = ix.relam
         WHERE i.indrelid = f.conrelid
             AND i.indisvalid
             AND i.indisready
             AND i.indislive
             AND i.indpred IS NULL
             AND am.amname IN ('btree','hash')
             AND i.indnkeyatts >= cardinality(f.conkey)
             AND
                 (SELECT array_agg(k.attnum
                                   ORDER BY k.attnum)
                  FROM unnest(i.indkey::smallint[]) WITH
                  ORDINALITY AS k(attnum, ord)
                  WHERE k.ord <= cardinality(f.conkey)) =
                 (SELECT array_agg(attnum
                                   ORDER BY attnum)
                  FROM unnest(f.conkey) AS fk(attnum)))
ORDER BY 1,2,3;
COMMIT;
