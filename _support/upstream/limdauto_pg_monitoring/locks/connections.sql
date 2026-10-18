-- see total blocked connections
SELECT COUNT(DISTINCT pid) AS count FROM pg_locks WHERE NOT GRANTED;

