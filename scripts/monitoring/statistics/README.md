# Statistics

[← Home](../../../README.md) · [Sicurezza e privilegi](../../../_support/docs/SAFETY.md)

**16 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. I contatori di attività sono cumulativi: un valore isolato non giustifica un’azione correttiva.

## 🗂️ Mappa della libreria

```text
statistics/
|
+-- checkpointer-activity.sql                        ← Checkpointer activity counters
+-- checkpointer.sql                                 ← Checkpointer counters
+-- database-age.sql                                 ← Database transaction ID age
+-- database-cache-hit.sql                           ← Database shared-buffer hit ratio
+-- database-counters.sql                            ← Database counters
+-- database-transaction-ratio.sql                   ← Database commit and rollback ratio
+-- database-work-counters.sql                       ← Database workload counters
+-- deadlocks-and-conflicts.sql                      ← Deadlocks and standby conflicts
+-- io-by-backend.sql                                ← I/O statistics by backend
+-- relation-block-io.sql                            ← Relation block I/O counters
+-- reset-times.sql                                  ← Statistics reset times
+-- slru-counters.sql                                ← SLRU activity counters
+-- table-activity.sql                               ← Table activity
+-- table-hot-updates.sql                            ← Table HOT update ratios
+-- table-statistics-coverage.sql                    ← Table statistics coverage
+-- temporary-files.sql                              ← Temporary file counters by database
```

```console
psql -X -v ON_ERROR_STOP=1 -f scripts/monitoring/statistics/checkpointer-activity.sql
```

Comando da eseguire dalla radice del checkout.

| Script | Scopo | PostgreSQL | Privilegi | Procedura |
| :-- | :-- | :-- | :-- | :-- |
| [checkpointer-activity.sql](checkpointer-activity.sql) | Inspect PostgreSQL 17+ checkpointer counters including timed/requested checkpoints and write time. | 17–18 (verificato; pg_stat_checkpointer separata da pg_stat_bgwriter in PostgreSQL 17) | pg_monitor for complete cluster statistics visibility | [Apri](../../../procedures/monitoring.md) |
| [checkpointer.sql](checkpointer.sql) | Show checkpoint and restartpoint counters on PostgreSQL 17+; cumulative counters need delta snapshots. | 17–18 (verificato) | pg_read_all_stats | [Apri](../../../procedures/monitoring.md) |
| [database-age.sql](database-age.sql) | Rank databases by frozen transaction ID age and report the configured wraparound threshold. | 14–18 (verificato) | database CONNECT; pg_monitor recommended for cluster-wide statistics | [Apri](../../../procedures/vacuum-bloat.md) |
| [database-cache-hit.sql](database-cache-hit.sql) | Calculate cumulative shared-buffer hit ratios by database since statistics reset. | 14–18 (verificato) | pg_monitor for all databases; otherwise visible statistics only | [Apri](../../../procedures/monitoring.md) |
| [database-counters.sql](database-counters.sql) | Show cumulative transaction, deadlock, temp and block counters; use snapshot deltas for rates. | 14–18 (verificato) | pg_read_all_stats | [Apri](../../../procedures/monitoring.md) |
| [database-transaction-ratio.sql](database-transaction-ratio.sql) | Calculate cumulative committed versus rolled-back transaction counts per database. | 14–18 (verificato) | pg_monitor for complete statistics visibility | [Apri](../../../procedures/monitoring.md) |
| [database-work-counters.sql](database-work-counters.sql) | Compare transaction, tuple, temporary-file, conflict and deadlock counters by database. | 14–18 (verificato) | pg_monitor for complete visibility; otherwise visible databases only | [Apri](../../../procedures/monitoring.md) |
| [deadlocks-and-conflicts.sql](deadlocks-and-conflicts.sql) | Review cumulative deadlock and recovery-conflict counters by database. | 14–18 (verificato) | pg_monitor for complete statistics visibility | [Apri](../../../procedures/locks.md) |
| [io-by-backend.sql](io-by-backend.sql) | Summarize common PostgreSQL 16+ pg_stat_io counters by backend, object and I/O context. | 16–18 (verificato; pg_stat_io introdotta in PostgreSQL 16) | pg_monitor for complete cluster statistics visibility | [Apri](../../../procedures/monitoring.md) |
| [relation-block-io.sql](relation-block-io.sql) | Compare cumulative heap, index and toast block read/hit counters for user tables. | 14–18 (verificato) | pg_monitor for complete statistics visibility; database CONNECT | [Apri](../../../procedures/monitoring.md) |
| [reset-times.sql](reset-times.sql) | Show database statistics reset timestamps to interpret cumulative counters. | 14–18 (verificato) | database CONNECT | [Apri](../../../procedures/monitoring.md) |
| [slru-counters.sql](slru-counters.sql) | Inspect SLRU hit, read, write and eviction counters with reset timestamp. | 14–18 (verificato) | pg_monitor for complete cluster statistics visibility | [Apri](../../../procedures/monitoring.md) |
| [table-activity.sql](table-activity.sql) | Show scans, estimated tuples and last maintenance timestamps. | 14–18 (verificato) | database CONNECT; estimates and visibility vary | [Apri](../../../procedures/monitoring.md) |
| [table-hot-updates.sql](table-hot-updates.sql) | Identify tables where updates often avoid creating new index entries through HOT updates. | 14–18 (verificato) | pg_monitor for complete statistics; database CONNECT | [Apri](../../../procedures/monitoring.md) |
| [table-statistics-coverage.sql](table-statistics-coverage.sql) | Find user tables with no recorded analyze or vacuum and report dead/live estimates. | 14–18 (verificato) | pg_monitor for complete statistics visibility; database CONNECT | [Apri](../../../procedures/monitoring.md) |
| [temporary-files.sql](temporary-files.sql) | Rank databases by cumulative temporary-file count and bytes written. | 14–18 (verificato) | pg_monitor for complete database statistics visibility | [Apri](../../../procedures/monitoring.md) |

> Indice generato da `python _support/tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
