-- Title: Role memberships
-- Description: Show granted membership and delegation options.
-- Postgres: 16+
-- Privilege: database CONNECT
-- Risk: read-only
-- Source: original + https://www.postgresql.org/docs/16/catalog-pg-auth-members.html
-- Runbook: runbooks/security.md
\set ON_ERROR_STOP on
\pset pager off
SELECT (current_setting('server_version_num')::integer >= 160000) AS pg_version_supported \gset
\if :pg_version_supported
\else
\echo PostgreSQL 16+ is required.
\quit
\endif
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT g.rolname AS granted_role,mr.rolname AS member_role,m.admin_option,m.inherit_option,m.set_option FROM pg_catalog.pg_auth_members m JOIN pg_catalog.pg_roles g ON g.oid=m.roleid JOIN pg_catalog.pg_roles mr ON mr.oid=m.member ORDER BY 1,2 LIMIT 1000;
COMMIT;
