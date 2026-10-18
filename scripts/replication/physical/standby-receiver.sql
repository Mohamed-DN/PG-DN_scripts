-- Title: Standby WAL receiver
-- Description: On standby inspect receiver state; connection string is omitted to avoid credentials.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT
-- Risk: read-only
-- Source: user:PROBLEMA_WAL_POSTGRES.sql
-- Runbook: procedures/replication-lag.md
-- Usarla sullo standby per verificare il WAL receiver e l'endpoint da cui riceve.
-- status descrive lo stato corrente; latest_end_lsn e latest_end_time indicano l'ultimo WAL ricevuto noto.
-- latest_end_time può restare vecchio quando il primary è inattivo: non convertirlo in tempo di lag di replay.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT status,receive_start_lsn,latest_end_lsn,latest_end_time,sender_host,sender_port,slot_name
FROM pg_catalog.pg_stat_wal_receiver;
COMMIT;
