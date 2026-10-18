# Connections

[← Home](../../../README.md) · [Come eseguire gli script](../../../_support/docs/QUICKSTART.md) · [Sicurezza e privilegi](../../../_support/docs/SAFETY.md)

**6 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. I contatori di attività sono cumulativi: un valore isolato non giustifica un’azione correttiva.

<details>
<summary>🗂️ Mappa della libreria · apri / chiudi</summary>

```text
connections/
|
+-- active.sql                                       ← Active sessions
+-- backend-detail.sql                               ← Backend session detail
+-- by-state.sql                                     ← Connections by state
+-- idle-in-transaction.sql                          ← Idle transactions
+-- oldest-backend-transactions.sql                  ← Oldest active backend transactions
+-- xid-holding-backends.sql                         ← Sessions holding old transaction horizons
```

</details>

## Scegli uno script

Trova il controllo nella tabella, apri il file e leggi scopo, versione e privilegi. La colonna **Procedura** spiega come interpretare il risultato e scegliere il passo successivo.

| Script | Scopo | PostgreSQL | Privilegi | Procedura |
| :-- | :-- | :-- | :-- | :-- |
| [active.sql](active.sql) | Show active sessions, age, waits and bounded query prefix; query text may contain sensitive values. | 14–18 (verificato) | pg_read_all_stats; otherwise own sessions | [Apri](../../../procedures/triage.md) |
| [backend-detail.sql](backend-detail.sql) | Summarize visible backends by database, user, application, client and state. | 14–18 (verificato) | pg_read_all_stats for complete session metadata visibility | [Apri](../../../procedures/triage.md) |
| [by-state.sql](by-state.sql) | Summarize visible sessions by database, role, state and wait class. | 14–18 (verificato) | pg_read_all_stats for complete details | [Apri](../../../procedures/triage.md) |
| [idle-in-transaction.sql](idle-in-transaction.sql) | Find idle-in-transaction sessions and transaction age. | 14–18 (verificato) | pg_read_all_stats; otherwise own sessions | [Apri](../../../procedures/locks.md) |
| [oldest-backend-transactions.sql](oldest-backend-transactions.sql) | Rank visible sessions by transaction age and identify idle-in-transaction blockers. | 14–18 (verificato) | pg_read_all_stats for complete session visibility | [Apri](../../../procedures/locks.md) |
| [xid-holding-backends.sql](xid-holding-backends.sql) | Rank sessions by backend xmin, the reported visibility horizon relevant to vacuum cleanup. | 14–18 (verificato) | pg_read_all_stats for complete session visibility | [Apri](../../../procedures/vacuum-bloat.md) |

> Indice generato da `python _support/tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
