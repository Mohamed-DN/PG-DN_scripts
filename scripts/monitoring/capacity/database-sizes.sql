-- Title: Database sizes
-- Description: Rank connectable databases by allocated size.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT
-- Risk: read-only
-- Source: user:+Postgres_Main_commands.sql
-- Runbook: procedures/monitoring.md
-- Usarla per ordinare database che accettano connessioni in base allo spazio allocato.
-- bytes è il valore numerico usato per l'ordinamento e size la rappresentazione leggibile della stessa misura.
-- pg_database_size non stima lo spazio recuperabile; chiamate ripetute su molti database possono avere un costo misurabile.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT datname,pg_catalog.pg_database_size(datname) AS bytes,
       pg_catalog.pg_size_pretty(pg_catalog.pg_database_size(datname)) AS size
FROM pg_catalog.pg_database
WHERE datallowconn
ORDER BY bytes DESC
LIMIT 100;
COMMIT;
