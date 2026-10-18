# Capacity

[← Home](../../../README.md) · [Come eseguire gli script](../../../_support/docs/QUICKSTART.md) · [Sicurezza e privilegi](../../../_support/docs/SAFETY.md)

**2 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. I contatori di attività sono cumulativi: un valore isolato non giustifica un’azione correttiva.

<details>
<summary>🗂️ Mappa della libreria · apri / chiudi</summary>

```text
capacity/
|
+-- database-sizes.sql                               ← Database sizes
+-- tablespace-inventory.sql                         ← Tablespace inventory
```

</details>

## Scegli uno script

Trova il controllo nella tabella, apri il file e leggi scopo, versione e privilegi. La colonna **Procedura** spiega come interpretare il risultato e scegliere il passo successivo.

| Script | Scopo | PostgreSQL | Privilegi | Procedura |
| :-- | :-- | :-- | :-- | :-- |
| [database-sizes.sql](database-sizes.sql) | Rank connectable databases by allocated size. | 14–18 (verificato) | database CONNECT | [Apri](../../../procedures/monitoring.md) |
| [tablespace-inventory.sql](tablespace-inventory.sql) | List tablespace names and configured paths; filesystem free space is not included. | 14–18 (verificato) | database CONNECT | [Apri](../../../procedures/monitoring.md) |

> Indice generato da `python _support/tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
