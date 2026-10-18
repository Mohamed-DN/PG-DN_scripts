-- Title: Logical publication configuration
-- Description: Inventory publication operations and partition-root setting.
-- Postgres: 14–18 (verificato)
-- Privilege: CONNECT
-- Risk: read-only
-- Source: original; https://www.postgresql.org/docs/18/catalog-pg-publication.html
-- Runbook: procedures/replication-lag.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Interpretazione e limiti: una publication non prova che esista una subscription attiva o sincronizzata.
SELECT pubname,pubowner::regrole AS owner,puballtables,pubinsert,pubupdate,pubdelete,pubtruncate,
       pubviaroot
FROM pg_catalog.pg_publication
ORDER BY pubname;
COMMIT;
