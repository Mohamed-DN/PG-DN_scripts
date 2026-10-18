-- Title: Physical replication senders
-- Description: On primary show sender state and byte lag; time lag is approximate and may be NULL.
-- Postgres: 14+
-- Privilege: pg_read_all_stats for full visibility
-- Risk: read-only
-- Source: user:PROBLEMA_WAL_POSTGRES.sql
-- Runbook: runbooks/replication-lag.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT pid,application_name,client_addr,state,sync_state,sent_lsn,write_lsn,flush_lsn,replay_lsn,pg_catalog.pg_wal_lsn_diff(CASE WHEN pg_catalog.pg_is_in_recovery() THEN pg_catalog.pg_last_wal_receive_lsn() ELSE pg_catalog.pg_current_wal_lsn() END,replay_lsn) AS replay_lag_bytes,clock_timestamp()-reply_time AS reply_age FROM pg_catalog.pg_stat_replication ORDER BY replay_lag_bytes DESC NULLS LAST LIMIT 100;
COMMIT;
