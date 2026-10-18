# Io

[← Home](../../../README.md) · [Sicurezza e privilegi](../../../docs/SAFETY.md)

**3 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. Le statistiche sono cumulative: un valore isolato non giustifica un’azione correttiva.

```console
python tools/pgdn.py run scripts/performance/io/buffercache-summary.sql
```

Comando da eseguire dalla radice del checkout.

| Script | Scopo | PostgreSQL | Privilegi |
| :-- | :-- | :-- | :-- |
| [buffercache-summary.sql](buffercache-summary.sql) | Summarize shared-buffer usage only when pg_buffercache is already installed; extension schema is discovered and quoted safely. | 16+ | pg_monitor; function EXECUTE may be granted separately |
| [database-io-timing.sql](database-io-timing.sql) | Show cumulative block timings; zero can mean track_io_timing was disabled. | 14+ | pg_read_all_stats |
| [pg-stat-io.sql](pg-stat-io.sql) | Inspect cumulative I/O counters; correlate them with operating system metrics. | 16+ | pg_read_all_stats; PostgreSQL 16+ |

> Indice generato da `python tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
