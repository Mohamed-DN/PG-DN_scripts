-- Title: Duplicate index candidates
-- Description: Find exact-signature index pairs for manual review, comparing keys, expressions, predicates, opclasses, collations and storage options; no index is removed.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT
-- Risk: read-only
-- Source: user:script 4.txt
-- Runbook: procedures/slow-queries.md
-- Usarla per trovare coppie con firma catalogo esattamente uguale da sottoporre a revisione manuale.
-- espressioni e predicate aiutano a leggere la firma; le dimensioni ordinate mostrano l'allocazione coinvolta.
-- Il self-join cresce col numero di indici; candidati non significano rimozione sicura e non catturano ogni effetto applicativo.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT n.nspname AS schema_name,t.relname AS table_name,x1.relname AS index_a,x2.relname AS index_b,
       pg_catalog.pg_relation_size(x1.oid) AS index_a_bytes,pg_catalog.pg_relation_size(x2.oid) AS index_b_bytes,
       pg_catalog.pg_get_expr(i1.indexprs, i1.indrelid) AS expressions,pg_catalog.pg_get_expr(i1.indpred,
                                                                                      i1.indrelid) AS predicate
FROM pg_catalog.pg_index AS i1
JOIN pg_catalog.pg_index AS i2 ON i2.indrelid = i1.indrelid
AND i2.indexrelid > i1.indexrelid
JOIN pg_catalog.pg_class AS t ON t.oid = i1.indrelid
JOIN pg_catalog.pg_class AS x1 ON x1.oid = i1.indexrelid
JOIN pg_catalog.pg_class AS x2 ON x2.oid = i2.indexrelid
JOIN pg_catalog.pg_namespace AS n ON n.oid = t.relnamespace
WHERE n.nspname !~ '^pg_'
    AND n.nspname <> 'information_schema'
    AND i1.indisvalid
    AND i2.indisvalid
    AND i1.indisready
    AND i2.indisready
    AND i1.indislive
    AND i2.indislive
    AND i1.indisunique = i2.indisunique
    AND i1.indisprimary = i2.indisprimary
    AND i1.indisexclusion = i2.indisexclusion
    AND i1.indimmediate = i2.indimmediate
    AND i1.indisclustered = i2.indisclustered
    AND i1.indisreplident = i2.indisreplident
    AND i1.indnkeyatts = i2.indnkeyatts
    AND i1.indnatts = i2.indnatts
    AND i1.indkey = i2.indkey
    AND i1.indclass = i2.indclass
    AND i1.indcollation = i2.indcollation
    AND i1.indoption = i2.indoption
    AND (pg_catalog.to_jsonb(i1) ->> 'indnullsnotdistinct') IS NOT DISTINCT
    FROM (pg_catalog.to_jsonb(i2) ->> 'indnullsnotdistinct')
    AND (pg_catalog.pg_get_expr(i1.indexprs, i1.indrelid)) IS NOT DISTINCT
    FROM (pg_catalog.pg_get_expr(i2.indexprs, i2.indrelid))
    AND (pg_catalog.pg_get_expr(i1.indpred, i1.indrelid)) IS NOT DISTINCT
    FROM (pg_catalog.pg_get_expr(i2.indpred, i2.indrelid))
    AND x1.relam = x2.relam
    AND x1.reltablespace = x2.reltablespace
    AND x1.reloptions IS NOT DISTINCT
    FROM x2.reloptions
ORDER BY pg_catalog.pg_relation_size(x1.oid) + pg_catalog.pg_relation_size(x2.oid) DESC
LIMIT 200;
COMMIT;
