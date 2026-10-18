# pgexperts/pgx_scripts - materiale upstream

Query e piccoli strumenti per bloat, indici, lock, vacuum, sessioni inattive e PgBouncer; alcuni script sono storici e richiedono compatibilità/versioni da controllare.

- Fonte: [pgexperts/pgx_scripts](https://github.com/pgexperts/pgx_scripts)
- Revisione acquisita: `e4f312d37b5fcf8a9f18fe857cee00ece13a387d` (branch al clone: `master`)
- Licenza verificata: BSD-3-Clause (testo riportato nel LICENSE upstream) - [testo originale](https://github.com/pgexperts/pgx_scripts/blob/e4f312d37b5fcf8a9f18fe857cee00ece13a387d/LICENSE) e copia preservata nel repository
- Contenuto importato: albero tracciato; README root preservato come README.upstream.md; submodule non inizializzati esclusi
- File di origine importati: 26; dettagli, permalink e SHA-256 in [manifest.json](manifest.json)
- Rischio euristico: read-only 13, non-read-only 3, review-required 10

Questa raccolta e solo reference esterna: non e stata sottoposta a verifica funzionale o di sicurezza, non entra nello smoke e non va eseguita senza revisione. Gli script shell non sono stati eseguiti. Per i file classificati read-only, l'etichetta descrive solo le istruzioni testuali riconosciute e non garantisce l'assenza di effetti.

## File upstream importati

| File | Categoria preliminare |
|---|---|
| `bloat/index_bloat_check.sql` | [read-only](https://github.com/pgexperts/pgx_scripts/blob/e4f312d37b5fcf8a9f18fe857cee00ece13a387d/bloat/index_bloat_check.sql) |
| `bloat/table_bloat_check.sql` | [non-read-only](https://github.com/pgexperts/pgx_scripts/blob/e4f312d37b5fcf8a9f18fe857cee00ece13a387d/bloat/table_bloat_check.sql) |
| `columns/integer_usage.py` | [review-required](https://github.com/pgexperts/pgx_scripts/blob/e4f312d37b5fcf8a9f18fe857cee00ece13a387d/columns/integer_usage.py) |
| `columns/missing_PKs.sql` | [read-only](https://github.com/pgexperts/pgx_scripts/blob/e4f312d37b5fcf8a9f18fe857cee00ece13a387d/columns/missing_PKs.sql) |
| `duplicate_indexes/duplicate_indexes.sql` | [read-only](https://github.com/pgexperts/pgx_scripts/blob/e4f312d37b5fcf8a9f18fe857cee00ece13a387d/duplicate_indexes/duplicate_indexes.sql) |
| `duplicate_indexes/readme.md` | [review-required](https://github.com/pgexperts/pgx_scripts/blob/e4f312d37b5fcf8a9f18fe857cee00ece13a387d/duplicate_indexes/readme.md) |
| `indexes/duplicate_indexes_fuzzy.sql` | [read-only](https://github.com/pgexperts/pgx_scripts/blob/e4f312d37b5fcf8a9f18fe857cee00ece13a387d/indexes/duplicate_indexes_fuzzy.sql) |
| `indexes/fk_no_index.sql` | [read-only](https://github.com/pgexperts/pgx_scripts/blob/e4f312d37b5fcf8a9f18fe857cee00ece13a387d/indexes/fk_no_index.sql) |
| `indexes/needed_indexes.sql` | [read-only](https://github.com/pgexperts/pgx_scripts/blob/e4f312d37b5fcf8a9f18fe857cee00ece13a387d/indexes/needed_indexes.sql) |
| `indexes/unused_indexes.sql` | [read-only](https://github.com/pgexperts/pgx_scripts/blob/e4f312d37b5fcf8a9f18fe857cee00ece13a387d/indexes/unused_indexes.sql) |
| `kill_idle/kill_idle_93_table.sql` | [review-required](https://github.com/pgexperts/pgx_scripts/blob/e4f312d37b5fcf8a9f18fe857cee00ece13a387d/kill_idle/kill_idle_93_table.sql) |
| `kill_idle/kill_idle_xact_91.sh` | [review-required](https://github.com/pgexperts/pgx_scripts/blob/e4f312d37b5fcf8a9f18fe857cee00ece13a387d/kill_idle/kill_idle_xact_91.sh) |
| `kill_idle/kill_idle_xact_93.sh` | [review-required](https://github.com/pgexperts/pgx_scripts/blob/e4f312d37b5fcf8a9f18fe857cee00ece13a387d/kill_idle/kill_idle_xact_93.sh) |
| `locks/README.rst` | [review-required](https://github.com/pgexperts/pgx_scripts/blob/e4f312d37b5fcf8a9f18fe857cee00ece13a387d/locks/README.rst) |
| `locks/lock_tables.sql` | [non-read-only](https://github.com/pgexperts/pgx_scripts/blob/e4f312d37b5fcf8a9f18fe857cee00ece13a387d/locks/lock_tables.sql) |
| `locks/log_locks.sh` | [review-required](https://github.com/pgexperts/pgx_scripts/blob/e4f312d37b5fcf8a9f18fe857cee00ece13a387d/locks/log_locks.sh) |
| `pgbouncer/log_pgbouncer_stats.sh` | [review-required](https://github.com/pgexperts/pgx_scripts/blob/e4f312d37b5fcf8a9f18fe857cee00ece13a387d/pgbouncer/log_pgbouncer_stats.sh) |
| `slony/log_slony_status.sh` | [review-required](https://github.com/pgexperts/pgx_scripts/blob/e4f312d37b5fcf8a9f18fe857cee00ece13a387d/slony/log_slony_status.sh) |
| `slony/see_replication_config.sql` | [read-only](https://github.com/pgexperts/pgx_scripts/blob/e4f312d37b5fcf8a9f18fe857cee00ece13a387d/slony/see_replication_config.sql) |
| `vacuum/database_xid_age.sql` | [read-only](https://github.com/pgexperts/pgx_scripts/blob/e4f312d37b5fcf8a9f18fe857cee00ece13a387d/vacuum/database_xid_age.sql) |
| `vacuum/last_autovacuum.sql` | [non-read-only](https://github.com/pgexperts/pgx_scripts/blob/e4f312d37b5fcf8a9f18fe857cee00ece13a387d/vacuum/last_autovacuum.sql) |
| `vacuum/last_autovacuum_and_autoanalyze.sql` | [read-only](https://github.com/pgexperts/pgx_scripts/blob/e4f312d37b5fcf8a9f18fe857cee00ece13a387d/vacuum/last_autovacuum_and_autoanalyze.sql) |
| `vacuum/no_stats_table_check.sql` | [read-only](https://github.com/pgexperts/pgx_scripts/blob/e4f312d37b5fcf8a9f18fe857cee00ece13a387d/vacuum/no_stats_table_check.sql) |
| `vacuum/table_xid_age.sql` | [read-only](https://github.com/pgexperts/pgx_scripts/blob/e4f312d37b5fcf8a9f18fe857cee00ece13a387d/vacuum/table_xid_age.sql) |

## Documentazione e attribuzioni originali

Il [README upstream originale](README.upstream.md) è conservato senza modifiche, comprese le attribuzioni dei contributori. Questo README italiano è un indice locale.
