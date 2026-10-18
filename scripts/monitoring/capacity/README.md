# Capacity

[← Home](../../../README.md) · [Sicurezza e privilegi](../../../docs/SAFETY.md)

**2 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. Le statistiche sono cumulative: un valore isolato non giustifica un’azione correttiva.

```console
python tools/pgdn.py run scripts/monitoring/capacity/database-sizes.sql
```

Comando da eseguire dalla radice del checkout.

| Script | Scopo | PostgreSQL | Privilegi |
| :-- | :-- | :-- | :-- |
| [database-sizes.sql](database-sizes.sql) | Rank connectable databases by allocated size. | 14+ | database CONNECT |
| [tablespace-inventory.sql](tablespace-inventory.sql) | List tablespace names and configured paths; filesystem free space is not included. | 14+ | database CONNECT |

> Indice generato da `python tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
