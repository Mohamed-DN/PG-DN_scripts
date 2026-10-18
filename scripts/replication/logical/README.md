# Logical

[← Home](../../../README.md) · [Sicurezza e privilegi](../../../docs/SAFETY.md)

**2 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. Le statistiche sono cumulative: un valore isolato non giustifica un’azione correttiva.

```console
python tools/pgdn.py run scripts/replication/logical/subscriptions.sql
```

Comando da eseguire dalla radice del checkout.

| Script | Scopo | PostgreSQL | Privilegi |
| :-- | :-- | :-- | :-- |
| [subscriptions.sql](subscriptions.sql) | List subscriptions without connection strings or credentials. | 14+ | database owner or pg_read_all_stats |
| [workers.sql](workers.sql) | Show logical replication worker state and bounded query prefixes. | 14+ | pg_read_all_stats |

> Indice generato da `python tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
