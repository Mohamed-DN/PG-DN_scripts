# Activity

[← Home](../../../README.md) · [Sicurezza e privilegi](../../../docs/SAFETY.md)

**6 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. Le statistiche sono cumulative: un valore isolato non giustifica un’azione correttiva.

```console
python tools/pgdn.py run scripts/monitoring/activity/advisory-locks.sql
```

Comando da eseguire dalla radice del checkout.

| Script | Scopo | PostgreSQL | Privilegi |
| :-- | :-- | :-- | :-- |
| [advisory-locks.sql](advisory-locks.sql) | List advisory lock ownership and wait state without exposing session query text. | 14+ | pg_read_all_stats for complete session details |
| [blocking-sessions.sql](blocking-sessions.sql) | Show one row per blocked session and blocking PID; a zero PID denotes a prepared transaction. | 14+ | pg_read_all_stats for complete activity |
| [long-running.sql](long-running.sql) | Find active queries older than one minute; query text may contain sensitive literals. | 14+ | pg_read_all_stats for complete details |
| [prepared-transactions.sql](prepared-transactions.sql) | List two-phase transactions; resolution belongs to the transaction coordinator. | 14+ | database CONNECT |
| [ssl-connections.sql](ssl-connections.sql) | Show TLS use and negotiated parameters without client or issuer distinguished names. | 14+ | pg_read_all_stats for complete visibility |
| [wait-summary.sql](wait-summary.sql) | Summarize sessions by backend type, state and wait event. | 14+ | pg_read_all_stats for complete details |

> Indice generato da `python tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
