# Retention

[← Home](../../../README.md) · [Come eseguire gli script](../../../_support/docs/QUICKSTART.md) · [Sicurezza e privilegi](../../../_support/docs/SAFETY.md)

**4 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. I contatori di attività sono cumulativi: un valore isolato non giustifica un’azione correttiva.

<details>
<summary>🗂️ Mappa della libreria · apri / chiudi</summary>

```text
retention/
|
+-- checkpoint-counters-common.sql                   ← Checkpoint counters
+-- retention-context.sql                            ← WAL retention context
+-- wal-counters.sql                                 ← WAL counters
+-- wal-directory-dimensions.sql                     ← WAL directory dimensions
```

</details>

## Scegli uno script

Trova il controllo nella tabella, apri il file e leggi scopo, versione e privilegi. La colonna **Procedura** spiega come interpretare il risultato e scegliere il passo successivo.

| Script | Scopo | PostgreSQL | Privilegi | Procedura |
| :-- | :-- | :-- | :-- | :-- |
| [checkpoint-counters-common.sql](checkpoint-counters-common.sql) | Show checkpoint and background writer counters common across PostgreSQL 14–18. | 14–18 (verificato) | pg_monitor | [Apri](../../../procedures/wal-growth.md) |
| [retention-context.sql](retention-context.sql) | Summarize slots, senders and retention settings that may influence pg_wal growth. | 14–18 (verificato) | database CONNECT; settings visibility may require pg_read_all_settings | [Apri](../../../procedures/wal-growth.md) |
| [wal-counters.sql](wal-counters.sql) | Show cumulative WAL byte and record counters; compare snapshots for rates. | 14–18 (verificato) | pg_read_all_stats | [Apri](../../../procedures/wal-growth.md) |
| [wal-directory-dimensions.sql](wal-directory-dimensions.sql) | Count WAL segment-shaped files and measure observed sizes and modification times. | 14–18 (verificato) | pg_monitor | [Apri](../../../procedures/wal-growth.md) |

> Indice generato da `python _support/tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
