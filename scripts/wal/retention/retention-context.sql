-- Title: WAL retention context
-- Description: Summarize slots, senders and retention settings that may influence pg_wal growth.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT; settings visibility may require pg_read_all_settings
-- Risk: read-only
-- Source: user:PROBLEMA_WAL_POSTGRES.sql
-- Runbook: procedures/wal-growth.md
-- Usarla come riepilogo iniziale di slot, sender e impostazioni che possono influenzare la crescita di pg_wal.
-- slots e senders sono conteggi; max_wal_size, wal_keep_size e max_slot_wal_keep_size sono valori di configurazione.
-- Non mostra lo slot più vecchio né il WAL trattenuto effettivo: affiancare il dettaglio degli slot e verificare visibilità settings.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT
    (SELECT count(*)
     FROM pg_catalog.pg_replication_slots) AS slots,
    (SELECT count(*)
     FROM pg_catalog.pg_stat_replication) AS senders,
       current_setting('max_wal_size') AS max_wal_size,current_setting('wal_keep_size') AS wal_keep_size,
       current_setting('max_slot_wal_keep_size') AS max_slot_wal_keep_size;
COMMIT;
