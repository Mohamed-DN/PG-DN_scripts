-- Title: Logical subscriptions
-- Description: List subscriptions without connection strings or credentials.
-- Postgres: 14–18 (verificato)
-- Privilege: database owner or pg_read_all_stats
-- Risk: read-only
-- Source: user:script 3
-- Runbook: procedures/replication-lag.md
-- Usarla sul subscriber per inventariare subscription logiche e stato abilitato.
-- subslotname collega la subscription allo slot; subpublications elenca le publication configurate e subbinary la modalità binaria.
-- È metadato di configurazione, non prova che il worker replichi o sia aggiornato; le credenziali non sono mostrate.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT subname,subenabled,subslotname,subpublications,subbinary
FROM pg_catalog.pg_subscription
ORDER BY subname
LIMIT 200;
COMMIT;
