-- Title: HBA rule health
-- Description: Show parse health for pg_hba.conf rules without exposing databases, users, addresses or authentication options.
-- Postgres: 14–18 (verificato)
-- Privilege: superuser by default; an administrator can grant SELECT on the view
-- Risk: read-only
-- Source: user:script 3.txt
-- Runbook: procedures/security.md
-- Usarla per individuare righe di pg_hba.conf che non sono state interpretate correttamente.
-- line_number localizza la regola, type ne indica la categoria e auth_method il metodo senza esporre indirizzi o utenti.
-- Non determina quale regola selezionerà una connessione né certifica la policy; la vista richiede privilegi amministrativi.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT line_number,type,auth_method,error
FROM pg_catalog.pg_hba_file_rules
ORDER BY line_number NULLS LAST
LIMIT 1000;
COMMIT;
