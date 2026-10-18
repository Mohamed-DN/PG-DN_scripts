# WAL e archiviazione

[← Home](../../README.md) · [Sicurezza e privilegi](../../docs/SAFETY.md)

**4 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. Le statistiche sono cumulative: un valore isolato non giustifica un’azione correttiva.

[archive](archive/README.md) · [retention](retention/README.md)

```mermaid
flowchart TD
    root["WAL e archiviazione"]
    root --> c0["archive · 2 query"]
    root --> c1["retention · 2 query"]
```

```console
python tools/pgdn.py run scripts/wal/archive/archive-status.sql
```

Comando da eseguire dalla radice del checkout.

| Script | Scopo | PostgreSQL | Privilegi |
| :-- | :-- | :-- | :-- |
| [archive-status.sql](archive/archive-status.sql) | Inspect cumulative archive success and failure counters; archive ordering can have exceptions. | 14+ | database CONNECT |
| [ready-files.sql](archive/ready-files.sql) | Count .ready/.done marker files in pg_wal/archive_status; marker sizes are not WAL sizes. | 14+ | pg_monitor or EXECUTE on pg_ls_archive_statusdir |
| [retention-context.sql](retention/retention-context.sql) | Summarize slots, senders and retention settings that may influence pg_wal growth. | 14+ | database CONNECT; settings visibility may require pg_read_all_settings |
| [wal-counters.sql](retention/wal-counters.sql) | Show cumulative WAL byte and record counters; compare snapshots for rates. | 14+ | pg_read_all_stats |

> Indice generato da `python tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
