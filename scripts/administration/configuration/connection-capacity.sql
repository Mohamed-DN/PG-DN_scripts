-- Title: Connection capacity
-- Description: Compare configured connection limit with visible client backends; poolers and reserved slots affect capacity.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_read_all_stats for full count
-- Risk: read-only
-- Source: user:+Postgres_Comandi_Principali_Diagnostica_Stats_Ruoli.sql
-- Runbook: procedures/monitoring.md
-- Utile in pre-triage per confrontare il limite configurato con i backend client visibili in questo istante.
-- max_connections è il tetto; visible_client_backends e visible_active sono conteggi filtrati, non posti liberi garantiti.
-- Pooler e reserved slots alterano la capacità effettiva; ripetere durante il picco e valutare il pooler separatamente.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT current_setting('max_connections')::integer AS max_connections,count(*) FILTER(
                                                                                      WHERE backend_type = 'client backend') AS visible_client_backends,
       count(*) FILTER(
                       WHERE state = 'active') AS visible_active
FROM pg_catalog.pg_stat_activity;
COMMIT;
