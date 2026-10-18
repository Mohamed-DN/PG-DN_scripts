# Bloat

[← Home](../../../README.md) · [Come eseguire gli script](../../../_support/docs/QUICKSTART.md) · [Sicurezza e privilegi](../../../_support/docs/SAFETY.md)

**2 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. I contatori di attività sono cumulativi: un valore isolato non giustifica un’azione correttiva.

<details>
<summary>🗂️ Mappa della libreria · apri / chiudi</summary>

```text
bloat/
|
+-- relation-size-breakdown.sql                      ← Relation size breakdown
+-- toast-breakdown.sql                              ← TOAST storage breakdown
```

</details>

## Scegli uno script

Trova il controllo nella tabella, apri il file e leggi scopo, versione e privilegi. La colonna **Procedura** spiega come interpretare il risultato e scegliere il passo successivo.

| Script | Scopo | PostgreSQL | Privilegi | Procedura |
| :-- | :-- | :-- | :-- | :-- |
| [relation-size-breakdown.sql](relation-size-breakdown.sql) | Compare heap, indexes and total allocated size; these are not direct bloat estimates. | 14–18 (verificato) | database CONNECT | [Apri](../../../procedures/vacuum-bloat.md) |
| [toast-breakdown.sql](toast-breakdown.sql) | Show heap, index and TOAST allocation for larger user tables. | 14–18 (verificato) | database CONNECT | [Apri](../../../procedures/vacuum-bloat.md) |

> Indice generato da `python _support/tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
