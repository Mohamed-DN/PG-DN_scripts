-- Title: Replication slot WAL limit headroom
-- Description: Compare slot safe WAL headroom and retention status without imposing a fixed threshold.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_monitor
-- Risk: read-only
-- Source: original; https://www.postgresql.org/docs/18/view-pg-replication-slots.html
-- Runbook: procedures/wal-growth.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Interpretazione e limiti: safe_wal_size può essere NULL se il limite è illimitato o ignoto; valutarlo con wal_status e max_slot_wal_keep_size.
SELECT slot_name,slot_type,database,active,wal_status,restart_lsn,confirmed_flush_lsn,safe_wal_size,
       current_setting('max_slot_wal_keep_size') AS configured_limit
FROM pg_catalog.pg_replication_slots
ORDER BY safe_wal_size NULLS FIRST,slot_name;
COMMIT;
