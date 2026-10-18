# Roles

[← Home](../../../README.md) · [Come eseguire gli script](../../../_support/docs/QUICKSTART.md) · [Sicurezza e privilegi](../../../_support/docs/SAFETY.md)

**6 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. I contatori di attività sono cumulativi: un valore isolato non giustifica un’azione correttiva.

<details>
<summary>🗂️ Mappa della libreria · apri / chiudi</summary>

```text
roles/
|
+-- default-acl.sql                                  ← Default privileges inventory
+-- expiring-logins.sql                              ← Expiring login roles
+-- membership.sql                                   ← Role memberships
+-- role-attributes.sql                              ← Role security attributes
+-- role-inventory.sql                               ← Role inventory
+-- role-membership-edges.sql                        ← Role membership edges with portable attributes
```

</details>

## Scegli uno script

Trova il controllo nella tabella, apri il file e leggi scopo, versione e privilegi. La colonna **Procedura** spiega come interpretare il risultato e scegliere il passo successivo.

| Script | Scopo | PostgreSQL | Privilegi | Procedura |
| :-- | :-- | :-- | :-- | :-- |
| [default-acl.sql](default-acl.sql) | Show per-role and per-schema default ACL entries that affect future objects. | 14–18 (verificato) | database CONNECT; visible role and schema metadata | [Apri](../../../procedures/security.md) |
| [expiring-logins.sql](expiring-logins.sql) | Identify login roles expired or expiring in 30 days. | 14–18 (verificato) | database CONNECT | [Apri](../../../procedures/security.md) |
| [membership.sql](membership.sql) | Show granted membership and delegation options. | 16–18 (verificato) | database CONNECT | [Apri](../../../procedures/security.md) |
| [role-attributes.sql](role-attributes.sql) | Review login, superuser, creation and bypass-RLS attributes for roles visible to the caller. | 14–18 (verificato) | database CONNECT; pg_read_all_settings for full visibility of protected role metadata | [Apri](../../../procedures/security.md) |
| [role-inventory.sql](role-inventory.sql) | List role attributes and validity without password hashes. | 14–18 (verificato) | database CONNECT | [Apri](../../../procedures/security.md) |
| [role-membership-edges.sql](role-membership-edges.sql) | Show granted role edges and legacy-compatible admin option without relying on PG16 fields. | 14–18 (verificato) | database CONNECT; membership metadata visibility follows role visibility | [Apri](../../../procedures/security.md) |

> Indice generato da `python _support/tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
