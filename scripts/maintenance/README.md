# Manutenzione

[← Home](../../README.md) · [Sicurezza e privilegi](../../docs/SAFETY.md)

**8 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. Le statistiche sono cumulative: un valore isolato non giustifica un’azione correttiva.

[bloat](bloat/README.md) · [progress](progress/README.md) · [vacuum](vacuum/README.md)

```mermaid
flowchart TD
    root["Manutenzione"]
    root --> c0["bloat · 2 query"]
    root --> c1["progress · 3 query"]
    root --> c2["vacuum · 3 query"]
```

```console
python tools/pgdn.py run scripts/maintenance/bloat/relation-size-breakdown.sql
```

Comando da eseguire dalla radice del checkout.

| Script | Scopo | PostgreSQL | Privilegi |
| :-- | :-- | :-- | :-- |
| [relation-size-breakdown.sql](bloat/relation-size-breakdown.sql) | Compare heap, indexes and total allocated size; these are not direct bloat estimates. | 14+ | database CONNECT |
| [toast-breakdown.sql](bloat/toast-breakdown.sql) | Show heap, index and TOAST allocation for larger user tables. | 14+ | database CONNECT |
| [analyze.sql](progress/analyze.sql) | Show active ANALYZE progress counters. | 14+ | pg_read_all_stats for full visibility |
| [create-index.sql](progress/create-index.sql) | Show active index build progress; no cancellation or mutation is performed. | 14+ | pg_read_all_stats for full visibility |
| [vacuum.sql](progress/vacuum.sql) | Show active vacuum phase and block counters common to PostgreSQL 14-18. | 14+ | pg_read_all_stats for full visibility |
| [dead-tuples.sql](vacuum/dead-tuples.sql) | Rank user tables by estimated dead tuples and show last maintenance times. | 14+ | database CONNECT; statistics may be stale |
| [oldest-transactions.sql](vacuum/oldest-transactions.sql) | Inspect backends with open transactions; long transactions can delay cleanup. | 14+ | pg_read_all_stats for complete details |
| [wraparound-risk.sql](vacuum/wraparound-risk.sql) | Compare database XID and multixact ages with configured autovacuum thresholds; investigate trends before acting. | 14+ | CONNECT |

> Indice generato da `python tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
