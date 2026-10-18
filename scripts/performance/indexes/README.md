# Indexes

[← Home](../../../README.md) · [Sicurezza e privilegi](../../../_support/docs/SAFETY.md)

**12 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. I contatori di attività sono cumulativi: un valore isolato non giustifica un’azione correttiva.

## 🗂️ Mappa della libreria

```text
indexes/
|
+-- access-methods.sql                               ← Index access methods
+-- constraint-index-signatures.sql                  ← Constraint index signatures
+-- definitions.sql                                  ← Index definitions
+-- duplicate-candidates.sql                         ← Duplicate index candidates
+-- foreign-keys-without-index.sql                   ← Foreign keys without leading index
+-- index-usage-context.sql                          ← Index usage counter context
+-- index-validity-state.sql                         ← Index validity state
+-- invalid-indexes.sql                              ← Invalid indexes
+-- key-included-columns.sql                         ← Index keys and included columns
+-- unused-candidates.sql                            ← Unused index candidates
+-- usage-by-table.sql                               ← Index usage by table
+-- write-pressure.sql                               ← Index write pressure context
```

```console
psql -X -v ON_ERROR_STOP=1 -f scripts/performance/indexes/access-methods.sql
```

Comando da eseguire dalla radice del checkout.

| Script | Scopo | PostgreSQL | Privilegi | Procedura |
| :-- | :-- | :-- | :-- | :-- |
| [access-methods.sql](access-methods.sql) | Inventory index access methods, capabilities and validity state. | 14–18 (verificato) | pg_monitor for complete relation visibility | [Apri](../../../procedures/slow-queries.md) |
| [constraint-index-signatures.sql](constraint-index-signatures.sql) | Map unique and primary-key constraints to their supporting index definitions and size. | 14–18 (verificato) | CONNECT | [Apri](../../../procedures/slow-queries.md) |
| [definitions.sql](definitions.sql) | List index definitions for review. | 14–18 (verificato) | database CONNECT | [Apri](../../../procedures/slow-queries.md) |
| [duplicate-candidates.sql](duplicate-candidates.sql) | Find exact-signature index pairs for manual review, comparing keys, expressions, predicates, opclasses, collations and storage options; no index is removed. | 14–18 (verificato) | database CONNECT | [Apri](../../../procedures/slow-queries.md) |
| [foreign-keys-without-index.sql](foreign-keys-without-index.sql) | Find foreign-key columns not covered by a valid, non-partial index whose leading key set covers the FK columns. | 14–18 (verificato) | pg_monitor for complete relation visibility | [Apri](../../../procedures/slow-queries.md) |
| [index-usage-context.sql](index-usage-context.sql) | Compare cumulative index usage counters, size and reset timestamp. | 14–18 (verificato) | pg_monitor for complete statistics visibility | [Apri](../../../procedures/slow-queries.md) |
| [index-validity-state.sql](index-validity-state.sql) | List indexes that are invalid, not ready or not live for manual recovery review. | 14–18 (verificato) | pg_monitor for complete relation visibility | [Apri](../../../procedures/slow-queries.md) |
| [invalid-indexes.sql](invalid-indexes.sql) | Identify indexes marked invalid or not ready for DBA investigation. | 14–18 (verificato) | database CONNECT | [Apri](../../../procedures/slow-queries.md) |
| [key-included-columns.sql](key-included-columns.sql) | Distinguish index search keys from INCLUDE payload and report size. | 14–18 (verificato) | pg_monitor for complete relation visibility | [Apri](../../../procedures/slow-queries.md) |
| [unused-candidates.sql](unused-candidates.sql) | Find valid large indexes with zero scans; review workload cycles before any decision and never auto-drop. | 14–18 (verificato) | database CONNECT | [Apri](../../../procedures/slow-queries.md) |
| [usage-by-table.sql](usage-by-table.sql) | Compare sequential and index scans and tuple fetches; counters can reset. | 14–18 (verificato) | database CONNECT | [Apri](../../../procedures/slow-queries.md) |
| [write-pressure.sql](write-pressure.sql) | Compare cumulative table writes, HOT updates, index count and index bytes. | 14–18 (verificato) | pg_monitor for complete statistics visibility | [Apri](../../../procedures/slow-queries.md) |

> Indice generato da `python _support/tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
