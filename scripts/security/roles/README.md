# Roles

[← Home](../../../README.md) · [Sicurezza e privilegi](../../../docs/SAFETY.md)

**3 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. Le statistiche sono cumulative: un valore isolato non giustifica un’azione correttiva.

```console
python tools/pgdn.py run scripts/security/roles/expiring-logins.sql
```

Comando da eseguire dalla radice del checkout.

| Script | Scopo | PostgreSQL | Privilegi |
| :-- | :-- | :-- | :-- |
| [expiring-logins.sql](expiring-logins.sql) | Identify login roles expired or expiring in 30 days. | 14+ | database CONNECT |
| [membership.sql](membership.sql) | Show granted membership and delegation options. | 16+ | database CONNECT |
| [role-inventory.sql](role-inventory.sql) | List role attributes and validity without password hashes. | 14+ | database CONNECT |

> Indice generato da `python tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
