-- Title: Tablespace inventory
-- Description: List tablespace names and configured paths; filesystem free space is not included.
-- Postgres: 14+
-- Privilege: database CONNECT
-- Risk: read-only
-- Source: user:+Postgres_Comandi_Principali_Diagnostica_Stats_Ruoli.sql
-- Runbook: runbooks/monitoring.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT spcname,pg_catalog.pg_get_userbyid(spcowner) AS owner,pg_catalog.pg_tablespace_location(oid) AS location FROM pg_catalog.pg_tablespace ORDER BY spcname LIMIT 100;
COMMIT;
