-- For inspiration: https://russ.garrett.co.uk/2015/10/02/postgres-monitoring-cheatsheet/
-- http://www.postgresql.org/docs/current/static/monitoring-stats.html#PG-STAT-ACTIVITY-VIEW

-- see number of connections
SELECT COUNT(*) FROM pg_stat_activity;

-- see number of connections by state
SELECT state, COUNT(*) FROM pg_stat_activity GROUP BY state;

-- see number of connections waiting for a lock
SELECT COUNT(DISTINCT pid) FROM pg_locks WHERE granted = false;

-- see maximum transaction age
-- should be kept below 1 min
SELECT MAX(NOW() - xact_start) FROM pg_stat_activity WHERE state IN ('idle in transaction', 'active');

