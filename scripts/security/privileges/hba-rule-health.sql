-- Title: HBA rule health
-- Description: Show parse health for pg_hba.conf rules without exposing databases, users, addresses or authentication options.
-- Postgres: 14+
-- Privilege: superuser by default; an administrator can grant SELECT on the view
-- Risk: read-only
-- Source: user:script 3.txt
-- Runbook: runbooks/security.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT line_number,type,auth_method,error FROM pg_catalog.pg_hba_file_rules ORDER BY line_number NULLS LAST LIMIT 1000;
COMMIT;
