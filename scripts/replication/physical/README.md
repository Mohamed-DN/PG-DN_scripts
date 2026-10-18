# Physical

[← Home](../../../README.md) · [Sicurezza e privilegi](../../../docs/SAFETY.md)

**3 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. Le statistiche sono cumulative: un valore isolato non giustifica un’azione correttiva.

```console
python tools/pgdn.py run scripts/replication/physical/primary-senders.sql
```

Comando da eseguire dalla radice del checkout.

| Script | Scopo | PostgreSQL | Privilegi |
| :-- | :-- | :-- | :-- |
| [primary-senders.sql](primary-senders.sql) | On primary show sender state and byte lag; time lag is approximate and may be NULL. | 14+ | pg_read_all_stats for full visibility |
| [standby-receiver.sql](standby-receiver.sql) | On standby inspect receiver state; connection string is omitted to avoid credentials. | 14+ | database CONNECT |
| [standby-replay.sql](standby-replay.sql) | Estimate received-but-not-replayed bytes and time since last replay; time can mislead when idle. | 14+ | database CONNECT |

> Indice generato da `python tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
