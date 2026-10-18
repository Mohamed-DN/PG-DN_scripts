# Queries

[← Home](../../../README.md) · [Sicurezza e privilegi](../../../docs/SAFETY.md)

**3 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. Le statistiche sono cumulative: un valore isolato non giustifica un’azione correttiva.

```console
python tools/pgdn.py run scripts/performance/queries/top-mean-time.sql
```

Comando da eseguire dalla radice del checkout.

| Script | Scopo | PostgreSQL | Privilegi |
| :-- | :-- | :-- | :-- |
| [top-mean-time.sql](top-mean-time.sql) | Rank normalized statements by mean time; low call counts may skew results. | 14+ | pg_read_all_stats; extension already installed |
| [top-temp-blocks.sql](top-temp-blocks.sql) | Find statements with cumulative temporary block writes; compare snapshots for rates. | 14+ | pg_read_all_stats; extension already installed |
| [top-total-time.sql](top-total-time.sql) | Rank pg_stat_statements by cumulative execution time; extension must already be available. | 14+ | pg_read_all_stats; extension already installed |

> Indice generato da `python tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
