-- Title: Database ACL
-- Description: Expand database ACL entries; null ACLs use built-in defaults.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT
-- Risk: read-only
-- Source: user:+Postgres_Comandi_Principali_Diagnostica_Stats_Ruoli.sql
-- Runbook: procedures/security.md
-- Usarla per espandere ACL dei database e vedere grants diretti, incluso PUBLIC.
-- acl_default ricostruisce i privilegi impliciti quando datacl è NULL; is_grantable segnala la delegabilità.
-- Non calcola privilegi effettivi via membership, ownership o superuser: interpretare grants assieme ai ruoli.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT d.datname,
       CASE WHEN x.grantee = 0 THEN 'PUBLIC' ELSE pg_catalog.pg_get_userbyid(x.grantee)
       END AS grantee,x.privilege_type,x.is_grantable
FROM pg_catalog.pg_database d
CROSS JOIN LATERAL pg_catalog.aclexplode(coalesce(d.datacl,
                                             pg_catalog.acldefault('d',
                                                            d.datdba))) x
ORDER BY 1,2,3
LIMIT 1000;
COMMIT;
