# NikolayS/postgres_dba - materiale upstream

Raccolta di report diagnostici per psql su attivita, lock, bloat, indici, vacuum, corruzione e statistiche; richiede revisione per ogni report e attenzione alle estensioni/privilegi opzionali.

- Fonte: [NikolayS/postgres_dba](https://github.com/NikolayS/postgres_dba)
- Revisione acquisita: `455c2f69aae37fc679c763f8de0952bdd5517a1b` (branch al clone: `master`)
- Licenza verificata: BSD-3-Clause - [testo originale](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/LICENSE) e copia preservata nel repository
- Contenuto importato: albero tracciato; README root preservato come README.upstream.md; submodule non inizializzati esclusi
- File di origine importati: 53; dettagli, permalink e SHA-256 in [manifest.json](manifest.json)
- Rischio euristico: read-only 21, non-read-only 20, review-required 12

Questa raccolta e solo reference esterna: non e stata sottoposta a verifica funzionale o di sicurezza, non entra nello smoke e non va eseguita senza revisione. Gli script shell non sono stati eseguiti. Per i file classificati read-only, l'etichetta descrive solo le istruzioni testuali riconosciute e non garantisce l'assenza di effetti.

## File upstream importati

| File | Categoria preliminare |
|---|---|
| `.cursor/rules/sql-style.mdc` | [review-required](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/.cursor/rules/sql-style.mdc) |
| `.github/workflows/claude-code-review.yml` | [review-required](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/.github/workflows/claude-code-review.yml) |
| `.github/workflows/claude.yml` | [review-required](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/.github/workflows/claude.yml) |
| `.github/workflows/test.yml` | [review-required](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/.github/workflows/test.yml) |
| `.gitignore` | [review-required](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/.gitignore) |
| `CLAUDE.md` | [review-required](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/CLAUDE.md) |
| `RELEASE_NOTES.md` | [review-required](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/RELEASE_NOTES.md) |
| `init/generate.sh` | [review-required](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/init/generate.sh) |
| `matviews/refresh_all.sql` | [non-read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/matviews/refresh_all.sql) |
| `misc/generate_password.sql` | [read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/misc/generate_password.sql) |
| `roles/alter_user_with_random_password.psql` | [non-read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/roles/alter_user_with_random_password.psql) |
| `roles/create_user_with_random_password.psql` | [non-read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/roles/create_user_with_random_password.psql) |
| `sql/0_node.sql` | [read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/sql/0_node.sql) |
| `sql/1_databases.sql` | [read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/sql/1_databases.sql) |
| `sql/2_table_sizes.sql` | [read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/sql/2_table_sizes.sql) |
| `sql/3_load_profiles.sql` | [non-read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/sql/3_load_profiles.sql) |
| `sql/a1_activity.sql` | [read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/sql/a1_activity.sql) |
| `sql/b1_table_estimation.sql` | [non-read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/sql/b1_table_estimation.sql) |
| `sql/b2_btree_estimation.sql` | [read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/sql/b2_btree_estimation.sql) |
| `sql/b3_table_pgstattuple.sql` | [read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/sql/b3_table_pgstattuple.sql) |
| `sql/b4_btree_pgstattuple.sql` | [read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/sql/b4_btree_pgstattuple.sql) |
| `sql/b5_tables_no_stats.sql` | [read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/sql/b5_tables_no_stats.sql) |
| `sql/c1_amcheck_indexes.sql` | [non-read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/sql/c1_amcheck_indexes.sql) |
| `sql/c2_amcheck_heap.sql` | [non-read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/sql/c2_amcheck_heap.sql) |
| `sql/c3_amcheck_parent.sql` | [non-read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/sql/c3_amcheck_parent.sql) |
| `sql/c4_amcheck_full.sql` | [non-read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/sql/c4_amcheck_full.sql) |
| `sql/e1_extensions.sql` | [read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/sql/e1_extensions.sql) |
| `sql/i1_rare_indexes.sql` | [read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/sql/i1_rare_indexes.sql) |
| `sql/i2_redundant_indexes.sql` | [non-read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/sql/i2_redundant_indexes.sql) |
| `sql/i3_non_indexed_fks.sql` | [read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/sql/i3_non_indexed_fks.sql) |
| `sql/i4_invalid_indexes.sql` | [non-read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/sql/i4_invalid_indexes.sql) |
| `sql/i5_indexes_migration.sql` | [non-read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/sql/i5_indexes_migration.sql) |
| `sql/l1_lock_trees.sql` | [read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/sql/l1_lock_trees.sql) |
| `sql/l2_lock_trees.sql` | [read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/sql/l2_lock_trees.sql) |
| `sql/m1_buffercache.sql` | [read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/sql/m1_buffercache.sql) |
| `sql/p1_index_create_progress.sql` | [non-read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/sql/p1_index_create_progress.sql) |
| `sql/r1_create_user_with_random_password.sql` | [non-read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/sql/r1_create_user_with_random_password.sql) |
| `sql/r2_alter_user_with_random_password.sql` | [non-read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/sql/r2_alter_user_with_random_password.sql) |
| `sql/s1_pg_stat_statements_top_total.sql` | [read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/sql/s1_pg_stat_statements_top_total.sql) |
| `sql/s2_pg_stat_statements_report.sql` | [read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/sql/s2_pg_stat_statements_report.sql) |
| `sql/s3_pg_stat_statements_workload.sql` | [non-read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/sql/s3_pg_stat_statements_workload.sql) |
| `sql/t1_tuning.sql` | [non-read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/sql/t1_tuning.sql) |
| `sql/t2_storage_parameters.sql` | [read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/sql/t2_storage_parameters.sql) |
| `sql/v1_vacuum_activity.sql` | [non-read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/sql/v1_vacuum_activity.sql) |
| `sql/v2_autovacuum_progress_and_queue.sql` | [non-read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/sql/v2_autovacuum_progress_and_queue.sql) |
| `sql/x1_alignment_padding.sql` | [read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/sql/x1_alignment_padding.sql) |
| `start.psql` | [non-read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/start.psql) |
| `test/regression/0_node.out` | [review-required](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/test/regression/0_node.out) |
| `test/regression/a1_activity.out` | [review-required](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/test/regression/a1_activity.out) |
| `test/regression/p1_alignment_padding.out` | [review-required](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/test/regression/p1_alignment_padding.out) |
| `warmup.psql` | [read-only](https://github.com/NikolayS/postgres_dba/blob/455c2f69aae37fc679c763f8de0952bdd5517a1b/warmup.psql) |

## Documentazione e attribuzioni originali

Il [README upstream originale](README.upstream.md) è conservato senza modifiche, comprese le attribuzioni dei contributori. Questo README italiano è un indice locale.
