-- For inspiration: https://gist.github.com/ruckus/5718112

-- see how well your tables are cached
SELECT relname, 100 * heap_blks_hit :: FLOAT / (heap_blks_hit + heap_blks_read) AS cache_hit_pct FROM pg_statio_user_tables;
