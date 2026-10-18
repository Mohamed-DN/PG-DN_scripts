# Statistics

[← Home](../../../README.md) · [Sicurezza e privilegi](../../../docs/SAFETY.md)

**4 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. Le statistiche sono cumulative: un valore isolato non giustifica un’azione correttiva.

```console
python tools/pgdn.py run scripts/monitoring/statistics/checkpointer.sql
```

Comando da eseguire dalla radice del checkout.

| Script | Scopo | PostgreSQL | Privilegi |
| :-- | :-- | :-- | :-- |
| [checkpointer.sql](checkpointer.sql) | Show checkpoint and restartpoint counters on PostgreSQL 17+; cumulative counters need delta snapshots. | 17+ | pg_read_all_stats |
| [database-counters.sql](database-counters.sql) | Show cumulative transaction, deadlock, temp and block counters; use snapshot deltas for rates. | 14+ | pg_read_all_stats |
| [reset-times.sql](reset-times.sql) | Show database statistics reset timestamps to interpret cumulative counters. | 14+ | database CONNECT |
| [table-activity.sql](table-activity.sql) | Show scans, estimated tuples and last maintenance timestamps. | 14+ | database CONNECT; estimates and visibility vary |

> Indice generato da `python tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
