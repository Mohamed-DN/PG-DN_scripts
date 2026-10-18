# Statistics

[← Home](../../../README.md) · [Sicurezza e privilegi](../../../_support/docs/SAFETY.md)

**8 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. I contatori di attività sono cumulativi: un valore isolato non giustifica un’azione correttiva.

## 🗂️ Mappa della libreria

```text
statistics/
|
+-- analyze-freshness.sql                            ← Analyze freshness
+-- column-skew-metadata.sql                         ← Column skew metadata
+-- null-fractions.sql                               ← Column null fraction metadata
+-- partition-hierarchy.sql                          ← Partition hierarchy
+-- partition-index-attachments.sql                  ← Partition index attachments
+-- physical-correlation.sql                         ← Column physical correlation
+-- sequence-context.sql                             ← Sequence inventory context
+-- sequence-headroom.sql                            ← Sequence exhaustion headroom
```

```console
psql -X -v ON_ERROR_STOP=1 -f scripts/performance/statistics/analyze-freshness.sql
```

Comando da eseguire dalla radice del checkout.

| Script | Scopo | PostgreSQL | Privilegi | Procedura |
| :-- | :-- | :-- | :-- | :-- |
| [analyze-freshness.sql](analyze-freshness.sql) | Compare estimated modified tuples to live rows and latest ANALYZE timestamps. | 14–18 (verificato) | pg_monitor for complete statistics visibility | [Apri](../../../procedures/slow-queries.md) |
| [column-skew-metadata.sql](column-skew-metadata.sql) | Show estimated distinctness and MCV array size without returning sensitive MCV values. | 14–18 (verificato) | CONNECT and SELECT on analyzed columns | [Apri](../../../procedures/slow-queries.md) |
| [null-fractions.sql](null-fractions.sql) | Rank analyzed columns by estimated null fraction and show analysis context. | 14–18 (verificato) | CONNECT and SELECT on analyzed columns; pg_monitor does not bypass pg_stats visibility | [Apri](../../../procedures/slow-queries.md) |
| [partition-hierarchy.sql](partition-hierarchy.sql) | Show direct parent-child table edges and partition bounds. | 14–18 (verificato) | CONNECT | [Apri](../../../procedures/slow-queries.md) |
| [partition-index-attachments.sql](partition-index-attachments.sql) | Find parent indexes and attached child indexes across partition hierarchy. | 14–18 (verificato) | pg_monitor for complete relation visibility | [Apri](../../../procedures/slow-queries.md) |
| [physical-correlation.sql](physical-correlation.sql) | Review planner correlation estimates with analysis timestamps. | 14–18 (verificato) | CONNECT and SELECT on analyzed columns; pg_monitor does not bypass pg_stats visibility | [Apri](../../../procedures/slow-queries.md) |
| [sequence-context.sql](sequence-context.sql) | Show sequence bounds, increments, cycle and cache settings separately from current headroom. | 14–18 (verificato) | CONNECT | [Apri](../../../procedures/triage.md) |
| [sequence-headroom.sql](sequence-headroom.sql) | Estimate remaining sequence increments from current last value to the configured bound. | 14–18 (verificato) | CONNECT and USAGE or SELECT on each sequence | [Apri](../../../procedures/triage.md) |

> Indice generato da `python _support/tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
