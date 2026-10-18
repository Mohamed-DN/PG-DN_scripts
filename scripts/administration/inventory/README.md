# Inventory

[← Home](../../../README.md) · [Sicurezza e privilegi](../../../docs/SAFETY.md)

**9 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. Le statistiche sono cumulative: un valore isolato non giustifica un’azione correttiva.

```console
python tools/pgdn.py run scripts/administration/inventory/databases.sql
```

Comando da eseguire dalla radice del checkout.

| Script | Scopo | PostgreSQL | Privilegi |
| :-- | :-- | :-- | :-- |
| [databases.sql](databases.sql) | List non-template databases, owners, connection limits and allocated size. | 14+ | database CONNECT |
| [extensions.sql](extensions.sql) | Show extensions installed in this database; no installation or update is performed. | 14+ | database CONNECT |
| [largest-relations.sql](largest-relations.sql) | Rank user tables by total allocated bytes including indexes and TOAST. | 14+ | database CONNECT |
| [materialized-views.sql](materialized-views.sql) | List materialized view ownership, tablespace and population state without exposing view definitions. | 14+ | database CONNECT |
| [partition-tree.sql](partition-tree.sql) | List partition parents and children using catalog inheritance links, without scanning table data. | 14+ | CONNECT |
| [routines.sql](routines.sql) | List function and procedure metadata without exposing routine source text or bodies. | 14+ | database CONNECT; routine metadata visibility depends on privileges |
| [schemas.sql](schemas.sql) | List non-system schemas and owners. | 14+ | database CONNECT |
| [sequences.sql](sequences.sql) | List sequence ownership and bounds without exposing current sequence values. | 14+ | database CONNECT; sequence metadata visibility depends on privileges |
| [server-info.sql](server-info.sql) | Identify database, role, server version, startup and primary or standby state before diagnosis. | 14+ | CONNECT |

> Indice generato da `python tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
