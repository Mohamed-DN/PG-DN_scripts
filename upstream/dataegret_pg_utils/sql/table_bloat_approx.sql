\prompt 'This utility will read tables with given mask using pgstattuple extension and return top 20 bloated tables.\nWARNING: without table mask query will read all available tables which could cause I/O spikes.\nPlease enter mask for table name (check all tables if nothing is specified): ' tablename
--faster version of table_bloat.sql which returns approximate results and doesn't read whole table (but reads toast tables)
--pgstattuple v1.3+ extension required (available since postgresql 9.5)
--WARNING: without table name/mask query will read all available tables which could cause I/O spikes
select table_name,
pg_size_pretty(relation_size + toast_relation_size) as total_size,
pg_size_pretty(toast_relation_size) as toast_size,
round(greatest(((relation_size * fillfactor/100)::numeric - tuple_len) / greatest((relation_size * fillfactor/100)::numeric, 1) * 100, 0)::numeric, 1) AS table_waste_percent,
pg_size_pretty((relation_size * fillfactor/100 - tuple_len)::bigint) AS table_waste,
round((((relation_size * fillfactor/100) + toast_relation_size - (tuple_len + toast_tuple_len))::numeric / greatest((relation_size * fillfactor/100) + toast_relation_size, 1)::numeric) * 100, 1) AS total_waste_percent,
pg_size_pretty(((relation_size * fillfactor/100) + toast_relation_size - (tuple_len + toast_tuple_len))::bigint) AS total_waste
from (
    select
    (case when n.nspname = 'public' then format('%I', c.relname) else format('%I.%I', n.nspname, c.relname) end) as table_name,
    (select  approx_tuple_len  from pgstattuple_approx(c.oid)) as tuple_len,
    pg_relation_size(c.oid) as relation_size,
    (case when reltoastrelid = 0 then 0 else (select  approx_tuple_len  from pgstattuple_approx(c.reltoastrelid)) end) as toast_tuple_len,
    coalesce(pg_relation_size(c.reltoastrelid), 0) as toast_relation_size,
    coalesce((SELECT (regexp_matches(reloptions::text, E'.*fillfactor=(\\d+).*'))[1]),'100')::real AS fillfactor
    from pg_class c
    left join pg_namespace n on (n.oid = c.relnamespace)
    where nspname not in ('pg_catalog', 'information_schema')
    and nspname !~ '^pg_toast' and nspname !~ '^pg_temp' and relkind in ('r', 'm') and (relpersistence = 'p' or not pg_is_in_recovery())
    --put your table name/mask here
    and relname ~ :'tablename'
) t
order by total_waste_percent desc
limit 20;