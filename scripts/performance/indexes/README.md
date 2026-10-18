# Indexes

[← Home](../../../README.md) · [Sicurezza e privilegi](../../../docs/SAFETY.md)

**5 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. Le statistiche sono cumulative: un valore isolato non giustifica un’azione correttiva.

```console
python tools/pgdn.py run scripts/performance/indexes/definitions.sql
```

Comando da eseguire dalla radice del checkout.

| Script | Scopo | PostgreSQL | Privilegi |
| :-- | :-- | :-- | :-- |
| [definitions.sql](definitions.sql) | List index definitions for review. | 14+ | database CONNECT |
| [duplicate-candidates.sql](duplicate-candidates.sql) | Find exact-signature index pairs for manual review, comparing keys, expressions, predicates, opclasses, collations and storage options; no index is removed. | 14+ | database CONNECT |
| [invalid-indexes.sql](invalid-indexes.sql) | Identify indexes marked invalid or not ready for DBA investigation. | 14+ | database CONNECT |
| [unused-candidates.sql](unused-candidates.sql) | Find valid large indexes with zero scans; review workload cycles before any decision and never auto-drop. | 14+ | database CONNECT |
| [usage-by-table.sql](usage-by-table.sql) | Compare sequential and index scans and tuple fetches; counters can reset. | 14+ | database CONNECT |

> Indice generato da `python tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
