# Physical

[← Home](../../../README.md) · [Sicurezza e privilegi](../../../_support/docs/SAFETY.md)

**5 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. I contatori di attività sono cumulativi: un valore isolato non giustifica un’azione correttiva.

## 🗂️ Mappa della libreria

```text
physical/
|
+-- primary-senders.sql                              ← Physical replication senders
+-- standby-conflicts.sql                            ← Standby recovery conflicts
+-- standby-receiver-health.sql                      ← Standby receiver health
+-- standby-receiver.sql                             ← Standby WAL receiver
+-- standby-replay.sql                               ← Standby replay status
```

```console
psql -X -v ON_ERROR_STOP=1 -f scripts/replication/physical/primary-senders.sql
```

Comando da eseguire dalla radice del checkout.

| Script | Scopo | PostgreSQL | Privilegi | Procedura |
| :-- | :-- | :-- | :-- | :-- |
| [primary-senders.sql](primary-senders.sql) | On primary show sender state and byte lag; time lag is approximate and may be NULL. | 14–18 (verificato) | pg_read_all_stats for full visibility | [Apri](../../../procedures/replication-lag.md) |
| [standby-conflicts.sql](standby-conflicts.sql) | Show cumulative standby conflict cancellations by conflict class and database. | 14–18 (verificato) | pg_monitor | [Apri](../../../procedures/replication-lag.md) |
| [standby-receiver-health.sql](standby-receiver-health.sql) | Show current receiver state, received LSNs and message recency on a standby. | 14–18 (verificato) | pg_monitor | [Apri](../../../procedures/replication-lag.md) |
| [standby-receiver.sql](standby-receiver.sql) | On standby inspect receiver state; connection string is omitted to avoid credentials. | 14–18 (verificato) | database CONNECT | [Apri](../../../procedures/replication-lag.md) |
| [standby-replay.sql](standby-replay.sql) | Estimate received-but-not-replayed bytes and time since last replay; time can mislead when idle. | 14–18 (verificato) | database CONNECT | [Apri](../../../procedures/replication-lag.md) |

> Indice generato da `python _support/tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
