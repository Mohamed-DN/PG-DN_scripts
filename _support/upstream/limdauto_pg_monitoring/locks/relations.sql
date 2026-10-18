-- see total blocked connections
SELECT COUNT(DISTINCT pid) AS count FROM pg_locks WHERE NOT GRANTED;

-- monitor locks by relation
SELECT relation::regclass, COUNT(*) AS count FROM pg_locks WHERE NOT GRANTED GROUP BY 1;
