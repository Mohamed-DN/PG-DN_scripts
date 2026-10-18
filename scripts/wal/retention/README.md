# Retention

[← Home](../../../README.md) · [Sicurezza e privilegi](../../../docs/SAFETY.md)

**2 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. Le statistiche sono cumulative: un valore isolato non giustifica un’azione correttiva.

```console
python tools/pgdn.py run scripts/wal/retention/retention-context.sql
```

Comando da eseguire dalla radice del checkout.

| Script | Scopo | PostgreSQL | Privilegi |
| :-- | :-- | :-- | :-- |
| [retention-context.sql](retention-context.sql) | Summarize slots, senders and retention settings that may influence pg_wal growth. | 14+ | database CONNECT; settings visibility may require pg_read_all_settings |
| [wal-counters.sql](wal-counters.sql) | Show cumulative WAL byte and record counters; compare snapshots for rates. | 14+ | pg_read_all_stats |

> Indice generato da `python tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
