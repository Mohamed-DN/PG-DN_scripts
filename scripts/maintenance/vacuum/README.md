# Vacuum

[← Home](../../../README.md) · [Come eseguire gli script](../../../_support/docs/QUICKSTART.md) · [Sicurezza e privilegi](../../../_support/docs/SAFETY.md)

**9 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. I contatori di attività sono cumulativi: un valore isolato non giustifica un’azione correttiva.

<details>
<summary>🗂️ Mappa della libreria · apri / chiudi</summary>

```text
vacuum/
|
+-- dead-tuples.sql                                  ← Dead tuple estimates
+-- hot-update-ratio.sql                             ← HOT update ratio
+-- oldest-transactions.sql                          ← Old transactions
+-- per-table-autovacuum-overrides.sql               ← Per-table autovacuum overrides
+-- table-freeze-age.sql                             ← Table freeze age
+-- table-multixact-age.sql                          ← Table multixact age
+-- toast-storage-share.sql                          ← TOAST storage candidates
+-- vacuum-history.sql                               ← Per-table vacuum history
+-- wraparound-risk.sql                              ← Transaction and multixact age
```

</details>

## Scegli uno script

Trova il controllo nella tabella, apri il file e leggi scopo, versione e privilegi. La colonna **Procedura** spiega come interpretare il risultato e scegliere il passo successivo.

| Script | Scopo | PostgreSQL | Privilegi | Procedura |
| :-- | :-- | :-- | :-- | :-- |
| [dead-tuples.sql](dead-tuples.sql) | Rank user tables by estimated dead tuples and show last maintenance times. | 14–18 (verificato) | database CONNECT; statistics may be stale | [Apri](../../../procedures/vacuum-bloat.md) |
| [hot-update-ratio.sql](hot-update-ratio.sql) | Report HOT updates against total updates with table size context. | 14–18 (verificato) | pg_monitor for complete statistics visibility | [Apri](../../../procedures/vacuum-bloat.md) |
| [oldest-transactions.sql](oldest-transactions.sql) | Inspect backends with open transactions; long transactions can delay cleanup. | 14–18 (verificato) | pg_read_all_stats for complete details | [Apri](../../../procedures/vacuum-bloat.md) |
| [per-table-autovacuum-overrides.sql](per-table-autovacuum-overrides.sql) | List relation-level storage options that override global maintenance settings. | 14–18 (verificato) | CONNECT | [Apri](../../../procedures/vacuum-bloat.md) |
| [table-freeze-age.sql](table-freeze-age.sql) | Rank relations by frozen XID age and configured autovacuum horizon. | 14–18 (verificato) | pg_monitor for complete relation visibility | [Apri](../../../procedures/vacuum-bloat.md) |
| [table-multixact-age.sql](table-multixact-age.sql) | Rank relations by multixact horizon age with configured limit context. | 14–18 (verificato) | pg_monitor for complete relation visibility | [Apri](../../../procedures/vacuum-bloat.md) |
| [toast-storage-share.sql](toast-storage-share.sql) | Rank tables by TOAST relation storage and display update estimates. | 14–18 (verificato) | pg_monitor for complete relation visibility | [Apri](../../../procedures/vacuum-bloat.md) |
| [vacuum-history.sql](vacuum-history.sql) | Compare vacuum counts, latest timestamps and dead tuple estimates by table. | 14–18 (verificato) | pg_monitor for complete statistics visibility | [Apri](../../../procedures/vacuum-bloat.md) |
| [wraparound-risk.sql](wraparound-risk.sql) | Compare database XID and multixact ages with configured autovacuum thresholds; investigate trends before acting. | 14–18 (verificato) | CONNECT | [Apri](../../../procedures/vacuum-bloat.md) |

> Indice generato da `python _support/tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
