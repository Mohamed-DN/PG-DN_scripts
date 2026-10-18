# Archive

[← Home](../../../README.md) · [Come eseguire gli script](../../../_support/docs/QUICKSTART.md) · [Sicurezza e privilegi](../../../_support/docs/SAFETY.md)

**2 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. I contatori di attività sono cumulativi: un valore isolato non giustifica un’azione correttiva.

<details>
<summary>🗂️ Mappa della libreria · apri / chiudi</summary>

```text
archive/
|
+-- archive-status.sql                               ← Archive status
+-- ready-files.sql                                  ← Ready WAL archive files
```

</details>

## Scegli uno script

Trova il controllo nella tabella, apri il file e leggi scopo, versione e privilegi. La colonna **Procedura** spiega come interpretare il risultato e scegliere il passo successivo.

| Script | Scopo | PostgreSQL | Privilegi | Procedura |
| :-- | :-- | :-- | :-- | :-- |
| [archive-status.sql](archive-status.sql) | Inspect cumulative archive success and failure counters; archive ordering can have exceptions. | 14–18 (verificato) | database CONNECT | [Apri](../../../procedures/wal-growth.md) |
| [ready-files.sql](ready-files.sql) | Count .ready/.done marker files in pg_wal/archive_status; marker sizes are not WAL sizes. | 14–18 (verificato) | pg_monitor or EXECUTE on pg_ls_archive_statusdir | [Apri](../../../procedures/wal-growth.md) |

> Indice generato da `python _support/tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
