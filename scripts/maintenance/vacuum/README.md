# Vacuum

[← Home](../../../README.md) · [Sicurezza e privilegi](../../../docs/SAFETY.md)

**3 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. Le statistiche sono cumulative: un valore isolato non giustifica un’azione correttiva.

```console
python tools/pgdn.py run scripts/maintenance/vacuum/dead-tuples.sql
```

Comando da eseguire dalla radice del checkout.

| Script | Scopo | PostgreSQL | Privilegi |
| :-- | :-- | :-- | :-- |
| [dead-tuples.sql](dead-tuples.sql) | Rank user tables by estimated dead tuples and show last maintenance times. | 14+ | database CONNECT; statistics may be stale |
| [oldest-transactions.sql](oldest-transactions.sql) | Inspect backends with open transactions; long transactions can delay cleanup. | 14+ | pg_read_all_stats for complete details |
| [wraparound-risk.sql](wraparound-risk.sql) | Compare database XID and multixact ages with configured autovacuum thresholds; investigate trends before acting. | 14+ | CONNECT |

> Indice generato da `python tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
