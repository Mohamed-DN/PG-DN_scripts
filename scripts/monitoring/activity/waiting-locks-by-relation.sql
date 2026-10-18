-- Title: Waiting locks by relation
-- Description: Count waiting sessions and lock requests per relation and lock type in the current database.
-- Postgres: 14–18 (verificato)
-- Privilege: pg_read_all_stats for complete session metadata
-- Risk: read-only
-- Source: adapted from https://github.com/limdauto/pg-monitoring/blob/1cb18cbecc8d1f67ea1d3e8f141cbd4e012a1efe/locks/relations.sql; https://www.postgresql.org/docs/18/view-pg-locks.html
-- Runbook: procedures/locks.md
-- Copyright (c) 2016 Nghia (lim) Hoang. MIT; notice preserved in _support/upstream/limdauto_pg_monitoring/LICENSE.
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
-- Serve a distinguere una relazione contesa da attese transactionid/advisory prive di relazione.
-- Una sessione può attendere più lock: requests e waiting_sessions hanno significati diversi.
-- Gli OID di relazione sono locali al database: il filtro precede la conversione regclass.
-- Le transazioni preparate non hanno un backend attivo e richiedono il controllo dedicato.
SELECT l.locktype,
       CASE WHEN l.relation IS NOT NULL THEN l.relation::regclass::text ELSE '[transaction or other lock]'
       END AS relation_or_scope, count(*) AS waiting_requests, count(DISTINCT l.pid) AS waiting_sessions,
       min(l.waitstart) AS oldest_wait_started
FROM pg_catalog.pg_locks AS l
JOIN pg_catalog.pg_stat_activity AS a ON a.pid = l.pid
WHERE NOT l.granted
    AND a.datname = current_database()
    AND (l.database IS NULL
         OR l.database =
             (SELECT oid
              FROM pg_catalog.pg_database
              WHERE datname = current_database()))
GROUP BY l.locktype,l.relation
ORDER BY waiting_sessions DESC,oldest_wait_started NULLS LAST
LIMIT 100;
COMMIT;
