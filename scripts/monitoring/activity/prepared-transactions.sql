-- Title: Prepared transactions
-- Description: List two-phase transactions; resolution belongs to the transaction coordinator.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT
-- Risk: read-only
-- Source: user:script 3
-- Runbook: procedures/locks.md
-- Usarla per trovare transazioni two-phase rimaste preparate e conoscere GID, database, owner e orario.
-- prepared indica quando il prepare è stato registrato; transaction contiene l'identificatore transazionale.
-- Possono mantenere lock senza backend attivo: commit o rollback va coordinato con il transaction manager.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT transaction,gid,prepared,owner,database
FROM pg_catalog.pg_prepared_xacts
ORDER BY prepared
LIMIT 100;
COMMIT;
