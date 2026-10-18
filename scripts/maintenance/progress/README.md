# Progress

[← Home](../../../README.md) · [Sicurezza e privilegi](../../../docs/SAFETY.md)

**3 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. Le statistiche sono cumulative: un valore isolato non giustifica un’azione correttiva.

```console
python tools/pgdn.py run scripts/maintenance/progress/analyze.sql
```

Comando da eseguire dalla radice del checkout.

| Script | Scopo | PostgreSQL | Privilegi |
| :-- | :-- | :-- | :-- |
| [analyze.sql](analyze.sql) | Show active ANALYZE progress counters. | 14+ | pg_read_all_stats for full visibility |
| [create-index.sql](create-index.sql) | Show active index build progress; no cancellation or mutation is performed. | 14+ | pg_read_all_stats for full visibility |
| [vacuum.sql](vacuum.sql) | Show active vacuum phase and block counters common to PostgreSQL 14-18. | 14+ | pg_read_all_stats for full visibility |

> Indice generato da `python tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
