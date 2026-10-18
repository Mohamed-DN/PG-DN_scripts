-- Title: Standby receiver health
-- Description: Show current receiver state, received LSNs and message recency on a standby.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_monitor
-- Risk: read-only
-- Source: original; https://www.postgresql.org/docs/18/monitoring-stats.html
-- Runbook: procedures/replication-lag.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Interpretazione e limiti: la vista è vuota sul primary; la ricezione non prova che il WAL sia stato riprodotto.
SELECT pid,status,last_msg_send_time,last_msg_receipt_time,
       clock_timestamp() - last_msg_receipt_time AS receipt_age, latest_end_lsn,latest_end_time,slot_name,sender_host,sender_port
FROM pg_catalog.pg_stat_wal_receiver;
COMMIT;
