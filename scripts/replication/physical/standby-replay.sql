-- Title: Standby replay status
-- Description: Estimate received-but-not-replayed bytes and time since last replay; time can mislead when idle.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT
-- Risk: read-only
-- Source: user:PROBLEMA_WAL_POSTGRES.sql
-- Runbook: procedures/replication-lag.md
-- Usarla sullo standby per confrontare gli LSN ricevuti e riprodotti e leggere l'ultimo commit replayato.
-- lag_bytes è il divario LSN presente; time_since_last_commit deriva dal timestamp dell'ultima transazione riprodotta.
-- Quando non arrivano transazioni il timestamp invecchia e non misura lag: valutare LSN e trend su più campioni.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT pg_catalog.pg_last_wal_receive_lsn() AS received_lsn,pg_catalog.pg_last_wal_replay_lsn() AS replayed_lsn,
       pg_catalog.pg_wal_lsn_diff(pg_catalog.pg_last_wal_receive_lsn(),
                      pg_catalog.pg_last_wal_replay_lsn()) AS lag_bytes,pg_catalog.pg_last_xact_replay_timestamp() AS last_commit,
       clock_timestamp() - pg_catalog.pg_last_xact_replay_timestamp() AS time_since_last_commit;
COMMIT;
