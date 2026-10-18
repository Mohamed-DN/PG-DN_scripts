# Queries

[← Home](../../../README.md) · [Sicurezza e privilegi](../../../_support/docs/SAFETY.md)

**3 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. I contatori di attività sono cumulativi: un valore isolato non giustifica un’azione correttiva.

## 🗂️ Mappa della libreria

```text
queries/
|
+-- top-mean-time.sql                                ← Statements by mean time
+-- top-temp-blocks.sql                              ← Statements by temporary blocks
+-- top-total-time.sql                               ← Statements by total time
```

```console
psql -X -v ON_ERROR_STOP=1 -f scripts/performance/queries/top-mean-time.sql
```

Comando da eseguire dalla radice del checkout.

| Script | Scopo | PostgreSQL | Privilegi | Procedura |
| :-- | :-- | :-- | :-- | :-- |
| [top-mean-time.sql](top-mean-time.sql) | Rank normalized statements by mean time; low call counts may skew results. | 14–18 (verificato) | pg_read_all_stats; extension already installed | [Apri](../../../procedures/slow-queries.md) |
| [top-temp-blocks.sql](top-temp-blocks.sql) | Find statements with cumulative temporary block writes; compare snapshots for rates. | 14–18 (verificato) | pg_read_all_stats; extension already installed | [Apri](../../../procedures/slow-queries.md) |
| [top-total-time.sql](top-total-time.sql) | Rank pg_stat_statements by cumulative execution time; extension must already be available. | 14–18 (verificato) | pg_read_all_stats; extension already installed | [Apri](../../../procedures/slow-queries.md) |

> Indice generato da `python _support/tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
