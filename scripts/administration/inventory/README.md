# Inventory

[← Home](../../../README.md) · [Come eseguire gli script](../../../_support/docs/QUICKSTART.md) · [Sicurezza e privilegi](../../../_support/docs/SAFETY.md)

**21 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. I contatori di attività sono cumulativi: un valore isolato non giustifica un’azione correttiva.

<details>
<summary>🗂️ Mappa della libreria · apri / chiudi</summary>

```text
inventory/
|
+-- collation-versions.sql                           ← Collation provider and recorded versions
+-- columns.sql                                      ← Column definitions inventory
+-- constraints.sql                                  ← Constraint inventory
+-- databases.sql                                    ← Database inventory
+-- extensions-dependencies.sql                      ← Extension-owned object dependencies
+-- extensions.sql                                   ← Installed extensions
+-- fdw-metadata.sql                                 ← Foreign data wrapper metadata
+-- largest-relations.sql                            ← Largest relations
+-- materialized-views.sql                           ← Materialized view inventory
+-- object-dependencies.sql                          ← Direct object dependencies
+-- ownership.sql                                    ← Application object ownership
+-- partition-tree.sql                               ← Partition hierarchy
+-- relations-detailed.sql                           ← Relation inventory with storage and state
+-- routines.sql                                     ← Routine inventory
+-- schemas.sql                                      ← Schema inventory
+-- sequences.sql                                    ← Sequence inventory
+-- server-info.sql                                  ← Server identity
+-- triggers.sql                                     ← Trigger inventory
+-- types-enums-domains.sql                          ← Enum and domain type inventory
+-- unvalidated-constraints.sql                      ← Unvalidated constraints
+-- views-and-definitions.sql                        ← View inventory with options
```

</details>

## Scegli uno script

Trova il controllo nella tabella, apri il file e leggi scopo, versione e privilegi. La colonna **Procedura** spiega come interpretare il risultato e scegliere il passo successivo.

| Script | Scopo | PostgreSQL | Privilegi | Procedura |
| :-- | :-- | :-- | :-- | :-- |
| [collation-versions.sql](collation-versions.sql) | Compare recorded and currently available collation versions to identify refresh review candidates. | 14–18 (verificato) | database CONNECT; visible collation metadata | [Apri](../../../procedures/triage.md) |
| [columns.sql](columns.sql) | List visible user relation columns, types, nullability, defaults and identity/generated markers. | 14–18 (verificato) | database CONNECT; metadata visibility follows object visibility | [Apri](../../../procedures/triage.md) |
| [constraints.sql](constraints.sql) | Show constraint type, validation/deferral state and definition for application relations. | 14–18 (verificato) | database CONNECT; metadata visibility follows object visibility | [Apri](../../../procedures/triage.md) |
| [databases.sql](databases.sql) | List non-template databases, owners, connection limits and allocated size. | 14–18 (verificato) | database CONNECT | [Apri](../../../procedures/monitoring.md) |
| [extensions-dependencies.sql](extensions-dependencies.sql) | Show objects that PostgreSQL marks as extension members and their owning extension. | 14–18 (verificato) | database CONNECT; visible object metadata | [Apri](../../../procedures/triage.md) |
| [extensions.sql](extensions.sql) | Show extensions installed in this database; no installation or update is performed. | 14–18 (verificato) | database CONNECT | [Apri](../../../procedures/monitoring.md) |
| [fdw-metadata.sql](fdw-metadata.sql) | Inventory FDWs, servers, foreign tables and mapping identities without exposing option values. | 14–18 (verificato) | database CONNECT; metadata visibility follows object visibility | [Apri](../../../procedures/triage.md) |
| [largest-relations.sql](largest-relations.sql) | Rank user tables by total allocated bytes including indexes and TOAST. | 14–18 (verificato) | database CONNECT | [Apri](../../../procedures/monitoring.md) |
| [materialized-views.sql](materialized-views.sql) | List materialized view ownership, tablespace and population state without exposing view definitions. | 14–18 (verificato) | database CONNECT | [Apri](../../../procedures/monitoring.md) |
| [object-dependencies.sql](object-dependencies.sql) | Show direct catalog dependency links among user relations, views, routines and types. | 14–18 (verificato) | database CONNECT; visible object metadata | [Apri](../../../procedures/triage.md) |
| [ownership.sql](ownership.sql) | Inventory relation owners to find objects owned by unexpected or retired roles. | 14–18 (verificato) | database CONNECT; metadata visibility follows object visibility | [Apri](../../../procedures/security.md) |
| [partition-tree.sql](partition-tree.sql) | List partition parents and children using catalog inheritance links, without scanning table data. | 14–18 (verificato) | CONNECT | [Apri](../../../procedures/triage.md) |
| [relations-detailed.sql](relations-detailed.sql) | Catalog inventory of user relations, kinds, persistence, size and maintenance flags. | 14–18 (verificato) | database CONNECT; pg_read_all_stats for complete statistics visibility | [Apri](../../../procedures/triage.md) |
| [routines.sql](routines.sql) | List function and procedure metadata without exposing routine source text or bodies. | 14–18 (verificato) | database CONNECT; routine metadata visibility depends on privileges | [Apri](../../../procedures/monitoring.md) |
| [schemas.sql](schemas.sql) | List non-system schemas and owners. | 14–18 (verificato) | database CONNECT | [Apri](../../../procedures/monitoring.md) |
| [sequences.sql](sequences.sql) | List sequence ownership and bounds without exposing current sequence values. | 14–18 (verificato) | database CONNECT; sequence metadata visibility depends on privileges | [Apri](../../../procedures/monitoring.md) |
| [server-info.sql](server-info.sql) | Identify database, role, server version, startup and primary or standby state before diagnosis. | 14–18 (verificato) | CONNECT | [Apri](../../../procedures/triage.md) |
| [triggers.sql](triggers.sql) | List enabled state, firing events and target routine for user-table triggers. | 14–18 (verificato) | database CONNECT; metadata visibility follows object visibility | [Apri](../../../procedures/triage.md) |
| [types-enums-domains.sql](types-enums-domains.sql) | Inspect enum labels and domain base type, nullability and check constraints. | 14–18 (verificato) | database CONNECT; visible type metadata | [Apri](../../../procedures/triage.md) |
| [unvalidated-constraints.sql](unvalidated-constraints.sql) | Focus on constraints whose existing rows have not been fully checked by PostgreSQL. | 14–18 (verificato) | database CONNECT; metadata visibility follows object visibility | [Apri](../../../procedures/triage.md) |
| [views-and-definitions.sql](views-and-definitions.sql) | List user views, security-barrier/check options, owner and normalized SQL definition. | 14–18 (verificato) | database CONNECT; metadata visibility follows object visibility | [Apri](../../../procedures/triage.md) |

> Indice generato da `python _support/tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
