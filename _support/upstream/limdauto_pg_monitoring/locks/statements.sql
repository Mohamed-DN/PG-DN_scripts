-- see what statements are locking up the db and how long (in seconds) have they been blocking the db
SELECT TRIM(TRAILING ';' FROM a.query) AS blocking_statement, \
       EXTRACT('epoch' FROM NOW() - a.query_start) AS blocking_duration \
  FROM pg_locks bl JOIN pg_stat_activity a \
    ON a.pid = bl.pid \
 WHERE NOT bl.GRANTED;
