# dataegret/pg-utils - materiale upstream

Ampia raccolta di query DBA, audit, statistiche, replica, indici, bloat e utility; contiene anche strumenti shell e materiale Slony.

- Fonte: [dataegret/pg-utils](https://github.com/dataegret/pg-utils)
- Revisione acquisita: `0835aa25b815b0589cf66f88537bb7952fb50543` (branch al clone: `master`)
- Licenza verificata: Permesso custom nel LICENSE.md upstream - [testo originale](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/LICENSE.md) e copia preservata nel repository
- Contenuto importato: albero tracciato; README root preservato come README.upstream.md; submodule non inizializzati esclusi
- File di origine importati: 110; dettagli, permalink e SHA-256 in [manifest.json](manifest.json)
- Rischio euristico: read-only 58, non-read-only 20, review-required 32

Questa raccolta e solo reference esterna: non e stata sottoposta a verifica funzionale o di sicurezza, non entra nello smoke e non va eseguita senza revisione. Gli script shell non sono stati eseguiti. Per i file classificati read-only, l'etichetta descrive solo le istruzioni testuali riconosciute e non garantisce l'assenza di effetti.

Nota: il repository upstream registra il submodule `pg_index_watch`, ma il suo contenuto non e stato inizializzato ne importato.

## File upstream importati

| File | Categoria preliminare |
|---|---|
| `.gitmodules` | [review-required](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/.gitmodules) |
| `bin/README.md` | [review-required](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/bin/README.md) |
| `bin/check_replication_lag.pl` | [review-required](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/bin/check_replication_lag.pl) |
| `bin/generate_pgbouncer_userlist.sh` | [review-required](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/bin/generate_pgbouncer_userlist.sh) |
| `bin/log_check.sh` | [review-required](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/bin/log_check.sh) |
| `bin/makecron.sh` | [review-required](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/bin/makecron.sh) |
| `bin/offlag.sh` | [review-required](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/bin/offlag.sh) |
| `bin/pg_log_search.pl` | [review-required](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/bin/pg_log_search.pl) |
| `bin/postgresql-audit.sh` | [review-required](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/bin/postgresql-audit.sh) |
| `bin/server-audit.sh` | [review-required](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/bin/server-audit.sh) |
| `bin/server-checklist.sh` | [review-required](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/bin/server-checklist.sh) |
| `bin/slony_extract_schema_to_file.sh` | [review-required](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/bin/slony_extract_schema_to_file.sh) |
| `bin/stuff-update.sh` | [review-required](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/bin/stuff-update.sh) |
| `loganalyze/log_analyze.pl` | [review-required](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/loganalyze/log_analyze.pl) |
| `slonik_template/cluster_config.slonik.template` | [review-required](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/slonik_template/cluster_config.slonik.template) |
| `slonik_template/create_set.slonik` | [review-required](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/slonik_template/create_set.slonik) |
| `slonik_template/create_slave_node.slonik` | [review-required](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/slonik_template/create_slave_node.slonik) |
| `slonik_template/drop_set.slonik` | [review-required](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/slonik_template/drop_set.slonik) |
| `slonik_template/drop_slave_node.slonik` | [review-required](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/slonik_template/drop_slave_node.slonik) |
| `slonik_template/execute_script.slonik` | [review-required](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/slonik_template/execute_script.slonik) |
| `slonik_template/init_cluster.slonik` | [review-required](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/slonik_template/init_cluster.slonik) |
| `slonik_template/populate_set.slonik.template` | [review-required](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/slonik_template/populate_set.slonik.template) |
| `slonik_template/populate_set.slonik_footer` | [review-required](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/slonik_template/populate_set.slonik_footer) |
| `slonik_template/populate_set.slonik_header` | [review-required](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/slonik_template/populate_set.slonik_header) |
| `slonik_template/set_drop_items.slonik` | [review-required](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/slonik_template/set_drop_items.slonik) |
| `slonik_template/setup_cluster.slonik` | [review-required](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/slonik_template/setup_cluster.slonik) |
| `slonik_template/slon.conf.template` | [review-required](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/slonik_template/slon.conf.template) |
| `slonik_template/store_path.slonik` | [review-required](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/slonik_template/store_path.slonik) |
| `slonik_template/subscribe_set.slonik` | [review-required](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/slonik_template/subscribe_set.slonik) |
| `slonik_template/switchover.slonik` | [review-required](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/slonik_template/switchover.slonik) |
| `sql/83compat.sql` | [non-read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/83compat.sql) |
| `sql/amcheck_indexes.sql` | [non-read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/amcheck_indexes.sql) |
| `sql/cache_stat.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/cache_stat.sql) |
| `sql/check_all_tables_have_pk.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/check_all_tables_have_pk.sql) |
| `sql/check_are_all_subscribed.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/check_are_all_subscribed.sql) |
| `sql/check_config.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/check_config.sql) |
| `sql/check_missing_grants.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/check_missing_grants.sql) |
| `sql/check_strange_fk.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/check_strange_fk.sql) |
| `sql/check_uniq_indexes.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/check_uniq_indexes.sql) |
| `sql/create_db_activity_view.sql` | [non-read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/create_db_activity_view.sql) |
| `sql/create_db_activity_view9.2.sql` | [non-read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/create_db_activity_view9.2.sql) |
| `sql/create_query_stat_cpu_time_view.sql` | [non-read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/create_query_stat_cpu_time_view.sql) |
| `sql/create_query_stat_io_time_view.sql` | [non-read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/create_query_stat_io_time_view.sql) |
| `sql/create_query_stat_log.sql` | [non-read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/create_query_stat_log.sql) |
| `sql/create_query_stat_time_view.sql` | [non-read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/create_query_stat_time_view.sql) |
| `sql/create_repl_activity_view9.5.sql` | [non-read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/create_repl_activity_view9.5.sql) |
| `sql/create_slonik_set_full.sql` | [non-read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/create_slonik_set_full.sql) |
| `sql/create_slonik_set_incremental.sql` | [non-read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/create_slonik_set_incremental.sql) |
| `sql/create_xlog_math_procedures.sql` | [non-read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/create_xlog_math_procedures.sql) |
| `sql/db_activity.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/db_activity.sql) |
| `sql/db_activity9.2.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/db_activity9.2.sql) |
| `sql/db_activity9.6.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/db_activity9.6.sql) |
| `sql/dirty_to_read_stat.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/dirty_to_read_stat.sql) |
| `sql/generate_drop_items.sql` | [non-read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/generate_drop_items.sql) |
| `sql/global_reports/query_stat_cpu_time.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/global_reports/query_stat_cpu_time.sql) |
| `sql/global_reports/query_stat_io_time.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/global_reports/query_stat_io_time.sql) |
| `sql/global_reports/query_stat_total.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/global_reports/query_stat_total.sql) |
| `sql/global_reports/query_stat_total_10.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/global_reports/query_stat_total_10.sql) |
| `sql/global_reports/query_stat_total_11.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/global_reports/query_stat_total_11.sql) |
| `sql/global_reports/query_stat_total_13.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/global_reports/query_stat_total_13.sql) |
| `sql/global_reports/query_stat_total_14.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/global_reports/query_stat_total_14.sql) |
| `sql/global_reports/query_stat_total_15.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/global_reports/query_stat_total_15.sql) |
| `sql/global_reports/query_stat_total_16.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/global_reports/query_stat_total_16.sql) |
| `sql/global_reports/query_stat_total_17.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/global_reports/query_stat_total_17.sql) |
| `sql/global_reports/query_stat_total_18.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/global_reports/query_stat_total_18.sql) |
| `sql/index_bloat.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/index_bloat.sql) |
| `sql/index_candidates_from_ssd.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/index_candidates_from_ssd.sql) |
| `sql/index_candidates_to_deduplicate.sql` | [non-read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/index_candidates_to_deduplicate.sql) |
| `sql/index_candidates_to_partial.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/index_candidates_to_partial.sql) |
| `sql/index_candidates_to_ssd.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/index_candidates_to_ssd.sql) |
| `sql/index_disk_activity.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/index_disk_activity.sql) |
| `sql/indexes_with_nulls.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/indexes_with_nulls.sql) |
| `sql/indexing_progress.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/indexing_progress.sql) |
| `sql/locktree.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/locktree.sql) |
| `sql/low_used_indexes.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/low_used_indexes.sql) |
| `sql/low_used_indexes_with_replica.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/low_used_indexes_with_replica.sql) |
| `sql/master_wal_position.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/master_wal_position.sql) |
| `sql/old/create_db_activity_view_old.sql` | [non-read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/old/create_db_activity_view_old.sql) |
| `sql/old/table_disk_activity.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/old/table_disk_activity.sql) |
| `sql/query_stat_counts.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/query_stat_counts.sql) |
| `sql/query_stat_cpu_time.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/query_stat_cpu_time.sql) |
| `sql/query_stat_io_time.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/query_stat_io_time.sql) |
| `sql/query_stat_rows.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/query_stat_rows.sql) |
| `sql/query_stat_time.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/query_stat_time.sql) |
| `sql/query_stat_total_single_db.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/query_stat_total_single_db.sql) |
| `sql/redundant_indexes.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/redundant_indexes.sql) |
| `sql/reindex_non_btree_indexes.sql` | [non-read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/reindex_non_btree_indexes.sql) |
| `sql/replication_pretty.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/replication_pretty.sql) |
| `sql/seq_scan_tables.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/seq_scan_tables.sql) |
| `sql/seq_scan_tables_with_replica.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/seq_scan_tables_with_replica.sql) |
| `sql/set_default_grants.sql` | [non-read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/set_default_grants.sql) |
| `sql/set_missing_grants.sql` | [non-read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/set_missing_grants.sql) |
| `sql/slave_wal_position.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/slave_wal_position.sql) |
| `sql/slony/temp.txt` | [review-required](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/slony/temp.txt) |
| `sql/slony_tables.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/slony_tables.sql) |
| `sql/sync_tablespaces.sql` | [non-read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/sync_tablespaces.sql) |
| `sql/table_bloat.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/table_bloat.sql) |
| `sql/table_bloat_approx.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/table_bloat_approx.sql) |
| `sql/table_bloat_approx12.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/table_bloat_approx12.sql) |
| `sql/table_candidates_from_ssd.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/table_candidates_from_ssd.sql) |
| `sql/table_candidates_to_ssd.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/table_candidates_to_ssd.sql) |
| `sql/table_index_write_activity.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/table_index_write_activity.sql) |
| `sql/table_write_activity.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/table_write_activity.sql) |
| `sql/top_databases.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/top_databases.sql) |
| `sql/top_tables.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/top_tables.sql) |
| `sql/vacuum_progress.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/vacuum_progress.sql) |
| `sql/vacuum_truncate_speedup.sql` | [non-read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/vacuum_truncate_speedup.sql) |
| `sql/versions_check.sql` | [read-only](https://github.com/dataegret/pg-utils/blob/0835aa25b815b0589cf66f88537bb7952fb50543/sql/versions_check.sql) |

## Documentazione e attribuzioni originali

Il [README upstream originale](README.upstream.md) è conservato senza modifiche, comprese le attribuzioni dei contributori. Questo README italiano è un indice locale.
