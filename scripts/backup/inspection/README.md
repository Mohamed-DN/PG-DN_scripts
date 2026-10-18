# Inspection

[← Home](../../../README.md) · [Sicurezza e privilegi](../../../docs/SAFETY.md)

**2 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. Le statistiche sono cumulative: un valore isolato non giustifica un’azione correttiva.

```console
python tools/pgdn.py run scripts/backup/inspection/active-backup-senders.sql
```

Comando da eseguire dalla radice del checkout.

| Script | Scopo | PostgreSQL | Privilegi |
| :-- | :-- | :-- | :-- |
| [active-backup-senders.sql](active-backup-senders.sql) | Show current walsender activity as clues for a physical backup; validate against backup tooling. | 14+ | pg_read_all_stats |
| [recovery-state.sql](recovery-state.sql) | Report recovery state and system identifier/timeline; control data access may require elevated privileges. | 14+ | pg_monitor; control functions may need elevated rights |

> Indice generato da `python tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
