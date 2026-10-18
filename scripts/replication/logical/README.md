# Logical

[← Home](../../../README.md) · [Sicurezza e privilegi](../../../_support/docs/SAFETY.md)

**5 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. I contatori di attività sono cumulativi: un valore isolato non giustifica un’azione correttiva.

## 🗂️ Mappa della libreria

```text
logical/
|
+-- publication-tables.sql                           ← Logical publication table mapping
+-- publications.sql                                 ← Logical publication configuration
+-- subscriptions.sql                                ← Logical subscriptions
+-- table-sync-state.sql                             ← Logical table synchronization state
+-- workers.sql                                      ← Logical replication workers
```

```console
psql -X -v ON_ERROR_STOP=1 -f scripts/replication/logical/publication-tables.sql
```

Comando da eseguire dalla radice del checkout.

| Script | Scopo | PostgreSQL | Privilegi | Procedura |
| :-- | :-- | :-- | :-- | :-- |
| [publication-tables.sql](publication-tables.sql) | List tables included in each publication, including all-table membership. | 14–18 (verificato) | CONNECT | [Apri](../../../procedures/replication-lag.md) |
| [publications.sql](publications.sql) | Inventory publication operations and partition-root setting. | 14–18 (verificato) | CONNECT | [Apri](../../../procedures/replication-lag.md) |
| [subscriptions.sql](subscriptions.sql) | List subscriptions without connection strings or credentials. | 14–18 (verificato) | database owner or pg_read_all_stats | [Apri](../../../procedures/replication-lag.md) |
| [table-sync-state.sql](table-sync-state.sql) | Show per-table subscription initialization state and associated worker. | 14–18 (verificato) | pg_read_all_stats | [Apri](../../../procedures/replication-lag.md) |
| [workers.sql](workers.sql) | Show logical replication worker state and bounded query prefixes. | 14–18 (verificato) | pg_read_all_stats | [Apri](../../../procedures/replication-lag.md) |

> Indice generato da `python _support/tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
