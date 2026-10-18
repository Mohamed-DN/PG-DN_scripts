-- Title: Column definitions inventory
-- Description: List visible user relation columns, types, nullability, defaults and identity/generated markers.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT; metadata visibility follows object visibility
-- Risk: read-only
-- Source: original; https://github.com/andyatkinson/pg_scripts/blob/b7736708e0cfa5b8a3e88df8b1704a80b3566896/list_comments.sql; https://www.postgresql.org/docs/18/catalog-pg-attribute.html
-- Runbook: procedures/triage.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Le righe dropped hanno atttypid=0 e vengono escluse; attnum conserva i buchi lasciati da ALTER TABLE.
-- pg_get_expr rende leggibili i default ma non li valuta. La query non legge righe applicative;
-- il risultato è limitato a 2000 colonne per rendere gestibile l'inventario in database estesi.
SELECT n.nspname AS schema_name, c.relname AS relation_name, a.attnum AS ordinal_position, a.attname AS column_name,
       pg_catalog.format_type(a.atttypid, a.atttypmod) AS data_type, NOT a.attnotnull AS nullable,
                                                                         pg_catalog.pg_get_expr(d.adbin,
                                                                                        d.adrelid) AS default_expression,
                                                                         a.attidentity AS identity_kind,
                                                                         a.attgenerated AS generated_kind,
                                                                         pg_catalog.col_description(c.oid,
                                                                                        a.attnum) AS column_comment
FROM pg_catalog.pg_attribute AS a
JOIN pg_catalog.pg_class AS c ON c.oid = a.attrelid
JOIN pg_catalog.pg_namespace AS n ON n.oid = c.relnamespace
LEFT JOIN pg_catalog.pg_attrdef AS d ON d.adrelid = a.attrelid
AND d.adnum = a.attnum
WHERE a.attnum > 0
    AND NOT a.attisdropped
    AND c.relkind IN ('r','p','v','m','f')
    AND n.nspname NOT IN ('pg_catalog','information_schema')
    AND n.nspname !~ '^pg_toast'
ORDER BY n.nspname,c.relname,a.attnum
LIMIT 2000;
COMMIT;
