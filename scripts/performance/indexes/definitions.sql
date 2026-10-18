-- Title: Index definitions
-- Description: List index definitions for review.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT
-- Risk: read-only
-- Source: user:script 2.txt
-- Runbook: procedures/slow-queries.md
-- Usarla per rivedere definizioni, tablespace e associazione degli indici a schema e tabella.
-- indexdef è la definizione ricostruita dal catalogo; l'output è limitato a 500 righe.
-- Non verifica uso, validità o costo dell'indice; nomi e predicati possono rivelare dettagli dello schema.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT schemaname,tablename,indexname,tablespace,indexdef
FROM pg_catalog.pg_indexes
ORDER BY schemaname,tablename,indexname
LIMIT 500;
COMMIT;
