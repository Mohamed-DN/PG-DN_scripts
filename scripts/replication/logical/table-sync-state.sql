-- Title: Logical table synchronization state
-- Description: Show per-table subscription initialization state and associated worker.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_read_all_stats
-- Risk: read-only
-- Source: original; https://www.postgresql.org/docs/18/catalog-pg-subscription-rel.html
-- Runbook: procedures/replication-lag.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Interpretazione e limiti: lo stato riguarda la sincronizzazione iniziale della tabella e non misura la latenza della replica a regime.
SELECT s.subname,r.srrelid::regclass AS relation,r.srsubstate,r.srsublsn,w.pid AS worker_pid,
       w.received_lsn,w.latest_end_lsn,w.last_msg_receipt_time
FROM pg_catalog.pg_subscription_rel r
JOIN pg_catalog.pg_subscription s ON s.oid = r.srsubid
LEFT JOIN pg_catalog.pg_stat_subscription w ON w.subid = r.srsubid
AND w.relid = r.srrelid
ORDER BY s.subname,relation;
COMMIT;
