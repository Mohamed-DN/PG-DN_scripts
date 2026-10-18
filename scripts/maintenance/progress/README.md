# Progress

[← Home](../../../README.md) · [Come eseguire gli script](../../../_support/docs/QUICKSTART.md) · [Sicurezza e privilegi](../../../_support/docs/SAFETY.md)

**6 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. I contatori di attività sono cumulativi: un valore isolato non giustifica un’azione correttiva.

<details>
<summary>🗂️ Mappa della libreria · apri / chiudi</summary>

```text
progress/
|
+-- analyze.sql                                      ← Analyze progress
+-- cluster-rewrite.sql                              ← CLUSTER and rewrite progress
+-- copy.sql                                         ← COPY progress
+-- create-index.sql                                 ← Index build progress
+-- index-build.sql                                  ← Index build progress detail
+-- vacuum.sql                                       ← Vacuum progress
```

</details>

## Scegli uno script

Trova il controllo nella tabella, apri il file e leggi scopo, versione e privilegi. La colonna **Procedura** spiega come interpretare il risultato e scegliere il passo successivo.

| Script | Scopo | PostgreSQL | Privilegi | Procedura |
| :-- | :-- | :-- | :-- | :-- |
| [analyze.sql](analyze.sql) | Show active ANALYZE progress counters. | 14–18 (verificato) | pg_read_all_stats for full visibility | [Apri](../../../procedures/vacuum-bloat.md) |
| [cluster-rewrite.sql](cluster-rewrite.sql) | Show progress for CLUSTER and VACUUM FULL rewrites. | 14–18 (verificato) | pg_read_all_stats | [Apri](../../../procedures/triage.md) |
| [copy.sql](copy.sql) | Show COPY phase counters and completion estimate when total bytes are known. | 14–18 (verificato) | pg_read_all_stats | [Apri](../../../procedures/triage.md) |
| [create-index.sql](create-index.sql) | Show active index build progress; no cancellation or mutation is performed. | 14–18 (verificato) | pg_read_all_stats for full visibility | [Apri](../../../procedures/slow-queries.md) |
| [index-build.sql](index-build.sql) | Show phase, locker, block and tuple counters for index builds. | 14–18 (verificato) | pg_read_all_stats | [Apri](../../../procedures/triage.md) |
| [vacuum.sql](vacuum.sql) | Show active vacuum phase and block counters common to PostgreSQL 14-18. | 14–18 (verificato) | pg_read_all_stats for full visibility | [Apri](../../../procedures/vacuum-bloat.md) |

> Indice generato da `python _support/tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
