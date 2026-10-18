-- Title: Schema ACL
-- Description: List schema ACLs; role membership and ownership affect effective privileges.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT
-- Risk: read-only
-- Source: user:+Postgres_Comandi_Principali_Diagnostica_Stats_Ruoli.sql
-- Runbook: procedures/security.md
-- Usarla per rivedere grants ACL sui namespace applicativi, inclusi privilegi predefiniti.
-- Quando nspacl è NULL si applica acldefault; PUBLIC viene reso esplicito e is_grantable indica delegabilità.
-- Non espande membership né determina da sola l'accesso effettivo agli oggetti dello schema.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SELECT n.nspname,
       CASE WHEN x.grantee = 0 THEN 'PUBLIC' ELSE pg_catalog.pg_get_userbyid(x.grantee)
       END AS grantee,x.privilege_type,x.is_grantable
FROM pg_catalog.pg_namespace n
CROSS JOIN LATERAL pg_catalog.aclexplode(coalesce(n.nspacl,
                                             pg_catalog.acldefault('n',
                                                            n.nspowner))) x
WHERE n.nspname !~ '^pg_'
    AND n.nspname <> 'information_schema'
ORDER BY 1,2,3
LIMIT 2000;
COMMIT;
