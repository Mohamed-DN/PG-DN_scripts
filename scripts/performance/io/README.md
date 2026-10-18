# Io

[← Home](../../../README.md) · [Come eseguire gli script](../../../_support/docs/QUICKSTART.md) · [Sicurezza e privilegi](../../../_support/docs/SAFETY.md)

**6 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. I contatori di attività sono cumulativi: un valore isolato non giustifica un’azione correttiva.

<details>
<summary>🗂️ Mappa della libreria · apri / chiudi</summary>

```text
io/
|
+-- buffercache-summary.sql                          ← Buffer cache summary
+-- checkpoint-settings-context.sql                  ← Checkpoint setting context
+-- database-io-timing.sql                           ← Database I/O timing
+-- database-temp-files.sql                          ← Database temporary file counters
+-- io-wait-snapshot.sql                             ← Current I/O wait snapshot
+-- pg-stat-io.sql                                   ← I/O by backend and context
```

</details>

## Scegli uno script

Trova il controllo nella tabella, apri il file e leggi scopo, versione e privilegi. La colonna **Procedura** spiega come interpretare il risultato e scegliere il passo successivo.

| Script | Scopo | PostgreSQL | Privilegi | Procedura |
| :-- | :-- | :-- | :-- | :-- |
| [buffercache-summary.sql](buffercache-summary.sql) | Summarize shared-buffer usage only when pg_buffercache is already installed; extension schema is discovered and quoted safely. | 16–18 (verificato) | pg_monitor; function EXECUTE may be granted separately | [Apri](../../../procedures/monitoring.md) |
| [checkpoint-settings-context.sql](checkpoint-settings-context.sql) | Show checkpoint and background write settings relevant to observed counter trends. | 14–18 (verificato) | CONNECT | [Apri](../../../procedures/monitoring.md) |
| [database-io-timing.sql](database-io-timing.sql) | Show cumulative block timings; zero can mean track_io_timing was disabled. | 14–18 (verificato) | pg_read_all_stats | [Apri](../../../procedures/monitoring.md) |
| [database-temp-files.sql](database-temp-files.sql) | Rank databases by temporary file volume and count since reset. | 14–18 (verificato) | pg_monitor | [Apri](../../../procedures/monitoring.md) |
| [io-wait-snapshot.sql](io-wait-snapshot.sql) | Summarize active sessions currently waiting on I/O by event and backend type. | 14–18 (verificato) | pg_read_all_stats | [Apri](../../../procedures/monitoring.md) |
| [pg-stat-io.sql](pg-stat-io.sql) | Inspect cumulative I/O counters; correlate them with operating system metrics. | 16–18 (verificato) | pg_read_all_stats; PostgreSQL 16+ | [Apri](../../../procedures/monitoring.md) |

> Indice generato da `python _support/tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
