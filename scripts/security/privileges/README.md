# Privileges

[← Home](../../../README.md) · [Come eseguire gli script](../../../_support/docs/QUICKSTART.md) · [Sicurezza e privilegi](../../../_support/docs/SAFETY.md)

**11 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. I contatori di attività sono cumulativi: un valore isolato non giustifica un’azione correttiva.

<details>
<summary>🗂️ Mappa della libreria · apri / chiudi</summary>

```text
privileges/
|
+-- database-acl.sql                                 ← Database ACL
+-- effective-database-privileges.sql                ← Effective database privileges for roles
+-- hba-rule-health.sql                              ← HBA rule health
+-- public-schema-grants.sql                         ← PUBLIC schema and relation grants
+-- relation-acl.sql                                 ← Relation ACL
+-- rls-enabled-without-policy.sql                   ← RLS-enabled relations without visible policies
+-- rls-policies.sql                                 ← Row-level security policy inventory
+-- routine-execute-grants.sql                       ← Routine EXECUTE grants
+-- routine-security-definer.sql                     ← SECURITY DEFINER routine inventory
+-- schema-acl.sql                                   ← Schema ACL
+-- schema-effective-privileges.sql                  ← Effective schema privileges
```

</details>

## Scegli uno script

Trova il controllo nella tabella, apri il file e leggi scopo, versione e privilegi. La colonna **Procedura** spiega come interpretare il risultato e scegliere il passo successivo.

| Script | Scopo | PostgreSQL | Privilegi | Procedura |
| :-- | :-- | :-- | :-- | :-- |
| [database-acl.sql](database-acl.sql) | Expand database ACL entries; null ACLs use built-in defaults. | 14–18 (verificato) | database CONNECT | [Apri](../../../procedures/security.md) |
| [effective-database-privileges.sql](effective-database-privileges.sql) | Evaluate CONNECT, CREATE and TEMPORARY rights for a bounded set of database roles. | 14–18 (verificato) | database CONNECT; visible database and role names | [Apri](../../../procedures/security.md) |
| [hba-rule-health.sql](hba-rule-health.sql) | Show parse health for pg_hba.conf rules without exposing databases, users, addresses or authentication options. | 14–18 (verificato) | superuser by default; an administrator can grant SELECT on the view | [Apri](../../../procedures/security.md) |
| [public-schema-grants.sql](public-schema-grants.sql) | Find explicit grants to PUBLIC on schemas and relations in the current database. | 14–18 (verificato) | database CONNECT; visible object metadata | [Apri](../../../procedures/security.md) |
| [relation-acl.sql](relation-acl.sql) | Inspect explicit ACL entries for user relations. | 14–18 (verificato) | database CONNECT | [Apri](../../../procedures/security.md) |
| [rls-enabled-without-policy.sql](rls-enabled-without-policy.sql) | Find application relations with row security enabled but no catalog-visible policy. | 14–18 (verificato) | database CONNECT; metadata visibility follows object visibility | [Apri](../../../procedures/security.md) |
| [rls-policies.sql](rls-policies.sql) | List user tables' RLS flags and policy names, modes, commands and roles; policy expressions are excluded. | 14–18 (verificato) | database CONNECT; metadata visibility depends on ownership/privileges | [Apri](../../../procedures/security.md) |
| [routine-execute-grants.sql](routine-execute-grants.sql) | List explicit EXECUTE ACL entries on visible application routines, including grantee and grant option. | 14–18 (verificato) | database CONNECT; visible routine metadata | [Apri](../../../procedures/security.md) |
| [routine-security-definer.sql](routine-security-definer.sql) | Locate routines running with owner privileges and expose their owner and configuration metadata. | 14–18 (verificato) | database CONNECT; visible routine metadata | [Apri](../../../procedures/security.md) |
| [schema-acl.sql](schema-acl.sql) | List schema ACLs; role membership and ownership affect effective privileges. | 14–18 (verificato) | database CONNECT | [Apri](../../../procedures/security.md) |
| [schema-effective-privileges.sql](schema-effective-privileges.sql) | Evaluate USAGE and CREATE privileges for visible application schemas and login roles. | 14–18 (verificato) | database CONNECT; metadata visibility follows object visibility | [Apri](../../../procedures/security.md) |

> Indice generato da `python _support/tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
