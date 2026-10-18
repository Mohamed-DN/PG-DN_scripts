-- Title: Role membership edges with portable attributes
-- Description: Show granted role edges and legacy-compatible admin option without relying on PG16 fields.
-- Postgres: 14–18 (verificato)
-- Privilege: database CONNECT; membership metadata visibility follows role visibility
-- Risk: read-only
-- Source: original; https://github.com/Azmodey/pg_dba_scripts/blob/3ff7a9041e5a6a78a91bb222c962f76e30c1d3ab/scripts/pg_database_information.sh; https://www.postgresql.org/docs/14/catalog-pg-auth-members.html
-- Runbook: procedures/security.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- PG14 e PG15 non hanno inherit_option e set_option in pg_auth_members; usare solo colonne comuni.
-- L'arco indica grantor, membership e admin_option. Per capire accesso effettivo servono anche
-- INHERIT/NOINHERIT, SET ROLE e membership transitivi: consultare anche pg_has_role per il caso concreto.
SELECT granted.rolname AS granted_role,member.rolname AS member_role, grantor.rolname AS grantor_role,m.admin_option
FROM pg_catalog.pg_auth_members m
JOIN pg_catalog.pg_roles granted ON granted.oid = m.roleid
JOIN pg_catalog.pg_roles member ON member.oid = m.member
JOIN pg_catalog.pg_roles grantor ON grantor.oid = m.grantor
ORDER BY granted.rolname,member.rolname
LIMIT 1000;
COMMIT;
