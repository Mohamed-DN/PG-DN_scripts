# Connections

[← Home](../../../README.md) · [Sicurezza e privilegi](../../../docs/SAFETY.md)

**3 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. Le statistiche sono cumulative: un valore isolato non giustifica un’azione correttiva.

```console
python tools/pgdn.py run scripts/administration/connections/active.sql
```

Comando da eseguire dalla radice del checkout.

| Script | Scopo | PostgreSQL | Privilegi |
| :-- | :-- | :-- | :-- |
| [active.sql](active.sql) | Show active sessions, age, waits and bounded query prefix; query text may contain sensitive values. | 14+ | pg_read_all_stats; otherwise own sessions |
| [by-state.sql](by-state.sql) | Summarize visible sessions by database, role, state and wait class. | 14+ | pg_read_all_stats for complete details |
| [idle-in-transaction.sql](idle-in-transaction.sql) | Find idle-in-transaction sessions and transaction age. | 14+ | pg_read_all_stats; otherwise own sessions |

> Indice generato da `python tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
