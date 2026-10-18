# Activity

[← Home](../../../README.md) · [Sicurezza e privilegi](../../../_support/docs/SAFETY.md)

**8 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. I contatori di attività sono cumulativi: un valore isolato non giustifica un’azione correttiva.

## 🗂️ Mappa della libreria

```text
activity/
|
+-- advisory-locks.sql                               ← Advisory lock summary
+-- blocking-impact.sql                              ← Blocking impact by backend
+-- blocking-sessions.sql                            ← Blocking sessions
+-- long-running.sql                                 ← Long-running queries
+-- prepared-transactions.sql                        ← Prepared transactions
+-- ssl-connections.sql                              ← SSL connection summary
+-- wait-summary.sql                                 ← Wait event summary
+-- waiting-locks-by-relation.sql                    ← Waiting locks by relation
```

```console
psql -X -v ON_ERROR_STOP=1 -f scripts/monitoring/activity/advisory-locks.sql
```

Comando da eseguire dalla radice del checkout.

| Script | Scopo | PostgreSQL | Privilegi | Procedura |
| :-- | :-- | :-- | :-- | :-- |
| [advisory-locks.sql](advisory-locks.sql) | List advisory lock ownership and wait state without exposing session query text. | 14–18 (verificato) | pg_read_all_stats for complete session details | [Apri](../../../procedures/locks.md) |
| [blocking-impact.sql](blocking-impact.sql) | Rank immediate blockers by number of waiting sessions in the current database. | 14–18 (verificato) | pg_read_all_stats for complete session metadata | [Apri](../../../procedures/locks.md) |
| [blocking-sessions.sql](blocking-sessions.sql) | Show one row per blocked session and blocking PID; a zero PID denotes a prepared transaction. | 14–18 (verificato) | pg_read_all_stats for complete activity | [Apri](../../../procedures/locks.md) |
| [long-running.sql](long-running.sql) | Find active queries older than one minute; query text may contain sensitive literals. | 14–18 (verificato) | pg_read_all_stats for complete details | [Apri](../../../procedures/slow-queries.md) |
| [prepared-transactions.sql](prepared-transactions.sql) | List two-phase transactions; resolution belongs to the transaction coordinator. | 14–18 (verificato) | database CONNECT | [Apri](../../../procedures/locks.md) |
| [ssl-connections.sql](ssl-connections.sql) | Show TLS use and negotiated parameters without client or issuer distinguished names. | 14–18 (verificato) | pg_read_all_stats for complete visibility | [Apri](../../../procedures/security.md) |
| [wait-summary.sql](wait-summary.sql) | Summarize sessions by backend type, state and wait event. | 14–18 (verificato) | pg_read_all_stats for complete details | [Apri](../../../procedures/triage.md) |
| [waiting-locks-by-relation.sql](waiting-locks-by-relation.sql) | Count waiting sessions and lock requests per relation and lock type in the current database. | 14–18 (verificato) | pg_read_all_stats for complete session metadata | [Apri](../../../procedures/locks.md) |

> Indice generato da `python _support/tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
