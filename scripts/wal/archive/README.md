# Archive

[← Home](../../../README.md) · [Sicurezza e privilegi](../../../docs/SAFETY.md)

**2 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. Le statistiche sono cumulative: un valore isolato non giustifica un’azione correttiva.

```console
python tools/pgdn.py run scripts/wal/archive/archive-status.sql
```

Comando da eseguire dalla radice del checkout.

| Script | Scopo | PostgreSQL | Privilegi |
| :-- | :-- | :-- | :-- |
| [archive-status.sql](archive-status.sql) | Inspect cumulative archive success and failure counters; archive ordering can have exceptions. | 14+ | database CONNECT |
| [ready-files.sql](ready-files.sql) | Count .ready/.done marker files in pg_wal/archive_status; marker sizes are not WAL sizes. | 14+ | pg_monitor or EXECUTE on pg_ls_archive_statusdir |

> Indice generato da `python tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
