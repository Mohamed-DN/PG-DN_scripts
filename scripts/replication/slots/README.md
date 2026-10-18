# Slots

[← Home](../../../README.md) · [Sicurezza e privilegi](../../../_support/docs/SAFETY.md)

**4 query** · client `psql` · diagnosi in transazione read-only.

Leggere header, versione e privilegi prima dell’esecuzione. I contatori di attività sono cumulativi: un valore isolato non giustifica un’azione correttiva.

## 🗂️ Mappa della libreria

```text
slots/
|
+-- logical-stats.sql                                ← Logical slot counters
+-- retention.sql                                    ← Replication slot retention
+-- wal-limit-headroom.sql                           ← Replication slot WAL limit headroom
+-- xmin-horizons.sql                                ← Replication slot xmin horizons
```

```console
psql -X -v ON_ERROR_STOP=1 -f scripts/replication/slots/logical-stats.sql
```

Comando da eseguire dalla radice del checkout.

| Script | Scopo | PostgreSQL | Privilegi | Procedura |
| :-- | :-- | :-- | :-- | :-- |
| [logical-stats.sql](logical-stats.sql) | Inspect cumulative logical decoding slot statistics. | 14–18 (verificato) | database CONNECT | [Apri](../../../procedures/replication-lag.md) |
| [retention.sql](retention.sql) | Show WAL retained by slots; inactive slots may retain large volumes. | 14–18 (verificato) | database CONNECT | [Apri](../../../procedures/wal-growth.md) |
| [wal-limit-headroom.sql](wal-limit-headroom.sql) | Compare slot safe WAL headroom and retention status without imposing a fixed threshold. | 14–18 (verificato) | pg_monitor | [Apri](../../../procedures/wal-growth.md) |
| [xmin-horizons.sql](xmin-horizons.sql) | Identify replication slots retaining transaction or catalog horizons. | 14–18 (verificato) | pg_monitor | [Apri](../../../procedures/replication-lag.md) |

> Indice generato da `python _support/tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.
