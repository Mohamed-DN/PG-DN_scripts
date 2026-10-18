# Configuration

[← Home](../../../README.md) · [Come eseguire gli script](../../../_support/docs/QUICKSTART.md) · [Sicurezza e privilegi](../../../_support/docs/SAFETY.md)

**4 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. I contatori di attività sono cumulativi: un valore isolato non giustifica un’azione correttiva.

<details>
<summary>🗂️ Mappa della libreria · apri / chiudi</summary>

```text
configuration/
|
+-- connection-capacity.sql                          ← Connection capacity
+-- non-default-settings.sql                         ← Non-default settings
+-- vacuum-settings.sql                              ← Vacuum and autovacuum settings
+-- wal-settings.sql                                 ← WAL and checkpoint settings
```

</details>

## Scegli uno script

Trova il controllo nella tabella, apri il file e leggi scopo, versione e privilegi. La colonna **Procedura** spiega come interpretare il risultato e scegliere il passo successivo.

| Script | Scopo | PostgreSQL | Privilegi | Procedura |
| :-- | :-- | :-- | :-- | :-- |
| [connection-capacity.sql](connection-capacity.sql) | Compare configured connection limit with visible client backends; poolers and reserved slots affect capacity. | 14–18 (verificato) | pg_read_all_stats for full count | [Apri](../../../procedures/monitoring.md) |
| [non-default-settings.sql](non-default-settings.sql) | Show only allowlisted diagnostic settings; connection strings, commands, paths and secrets are excluded. | 14–18 (verificato) | pg_read_all_settings for full view | [Apri](../../../procedures/monitoring.md) |
| [vacuum-settings.sql](vacuum-settings.sql) | Show allowlisted vacuum-related settings; command strings, paths and secrets are excluded. | 14–18 (verificato) | pg_read_all_settings for full values | [Apri](../../../procedures/vacuum-bloat.md) |
| [wal-settings.sql](wal-settings.sql) | Inspect safe WAL retention and archiving settings; command strings, paths and secrets are excluded. | 14–18 (verificato) | pg_read_all_settings for full view | [Apri](../../../procedures/wal-growth.md) |

> Indice generato da `python _support/tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
