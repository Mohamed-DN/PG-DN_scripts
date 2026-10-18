-- Title: Replication slot retention
-- Description: Show WAL retained by slots; inactive slots may retain large volumes.
-- Postgres: 14+
-- Privilege: database CONNECT
-- Risk: read-only
-- Source: user:PROBLEMA_WAL_POSTGRES.sql
-- Runbook: runbooks/wal-growth.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT slot_name,slot_type,database,active,restart_lsn,confirmed_flush_lsn,pg_catalog.pg_wal_lsn_diff(CASE WHEN pg_catalog.pg_is_in_recovery() THEN pg_catalog.pg_last_wal_receive_lsn() ELSE pg_catalog.pg_current_wal_lsn() END,restart_lsn) AS retained_wal_bytes,wal_status,safe_wal_size FROM pg_catalog.pg_replication_slots ORDER BY retained_wal_bytes DESC NULLS LAST LIMIT 200;
COMMIT;
