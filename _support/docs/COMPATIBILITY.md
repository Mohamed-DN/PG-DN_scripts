# Compatibilità PostgreSQL

[← Home](../../README.md) · [Verifiche](VALIDATION.md)

Ogni script riporta una sola riga discreta nell'header, per esempio:

```sql
-- Postgres: 14–18 (verificato)
```

Il range indica le major verificate, estremi inclusi. `16–18` significa PostgreSQL 16, 17 e 18; non estende automaticamente la compatibilità alla 19. La versione del server si controlla con `SHOW server_version;`.

Le versioni **8.x–13 non sono verificate** da questa raccolta. Il limite inferiore del range è il limite delle prove disponibili, non necessariamente la prima versione capace di eseguire una singola query. Per una versione precedente servono verifica delle funzioni, delle colonne e dei privilegi, quindi una prova dedicata.

Gli script che richiedono viste recenti controllano la major prima della query: `pg_stat_io` è stata introdotta in [PostgreSQL 16](https://www.postgresql.org/docs/16/release-16.html); `pg_stat_checkpointer` è stata separata da `pg_stat_bgwriter` in [PostgreSQL 17](https://www.postgresql.org/docs/17/release-17.html). Sulle versioni precedenti il controllo termina con un messaggio: non è una diagnosi eseguita.

Il range non sostituisce i campi `Privilege` e le note sulle estensioni: anche sulla major corretta, servono i prerequisiti indicati nel file. Gli originali in `_support/upstream/` mantengono le indicazioni dei rispettivi autori e non ereditano la compatibilità delle query curate.
