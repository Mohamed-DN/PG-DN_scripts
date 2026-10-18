-- Title: Foreign data wrapper metadata
-- Description: Inventory FDWs, servers, foreign tables and mapping identities without exposing option values.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT; metadata visibility follows object visibility
-- Risk: read-only
-- Source: original; https://github.com/andyatkinson/pg_scripts/blob/b7736708e0cfa5b8a3e88df8b1704a80b3566896/view_extensions.sql; https://www.postgresql.org/docs/18/foreign-data.html
-- Runbook: procedures/triage.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Non legge pg_foreign_server.srvoptions né pg_user_mapping.umoptions: lì possono comparire
-- endpoint, opzioni di connessione o segreti impostati dall'utente. Qui si riportano solo i nomi
-- del wrapper/server, owner, mapping role e conteggio di tabelle remote.
SELECT w.fdwname AS wrapper_name,s.srvname AS server_name, pg_catalog.pg_get_userbyid(s.srvowner) AS server_owner,
       um.usename AS mapped_role, count(DISTINCT ft.ftrelid) AS foreign_table_count
FROM pg_catalog.pg_foreign_server s
JOIN pg_catalog.pg_foreign_data_wrapper w ON w.oid = s.srvfdw
LEFT JOIN pg_catalog.pg_user_mappings um ON um.srvid = s.oid
LEFT JOIN pg_catalog.pg_foreign_table ft ON ft.ftserver = s.oid
GROUP BY w.fdwname,s.srvname,s.srvowner,um.usename
ORDER BY w.fdwname,s.srvname,um.usename
LIMIT 500;
COMMIT;
