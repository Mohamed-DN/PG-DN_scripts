# Baseline e monitoraggio PostgreSQL

Questa procedura aiuta a stabilire una baseline e leggere gli allarmi senza trasformare valori istantanei in diagnosi. Usare soglie concordate con servizio e workload, non numeri universali.

## Percorso operativo

1. Eseguire [database-sizes.sql](../scripts/monitoring/capacity/database-sizes.sql) e annotare database/byte allocati. `pg_database_size` non stima spazio recuperabile; se cresce un filesystem, confrontare mount, host e tablespace.
2. Eseguire [database-counters.sql](../scripts/monitoring/statistics/database-counters.sql) e registrare `stats_reset`; confrontare un secondo campione a intervallo noto. Deadlock, `temp_bytes` e blocchi sono cumulativi, non tassi istantanei.
3. Se sessioni o attese sono anomale, eseguire [wait-summary.sql](../scripts/monitoring/activity/wait-summary.sql); lock persistenti portano a [locks.md](locks.md). `sessions` riflette la visibilità del ruolo e il campione non conserva cronologia.
4. Se il rischio riguarda XID, eseguire [database-age.sql](../scripts/monitoring/statistics/database-age.sql) e confrontare `xid_age` con soglia e trend; in crescita verso il limite, seguire [vacuum-bloat.md](vacuum-bloat.md) e allertare DBA. L'età XID è un conteggio transazioni, non durata.
5. Associare anomalia a owner, soglia, finestra e procedura; verificare sul campione successivo il trend, annotando reset, host e workload. Se la telemetria manca o i valori peggiorano, escalare senza modificare parametri per conformare il grafico.

## Precheck

Confermare primary/standby, major, host e timezone. Annotare reset delle statistiche, manutenzioni o riavvii recenti. Definire le soglie del servizio per disponibilità, latenza, spazio, replica, backup e wraparound. Le statistiche cumulative sono soggette a reset e alcune informazioni richiedono privilegi ulteriori.

## Campione SQL

```sql
SELECT clock_timestamp() AS sampled_at, version(), pg_is_in_recovery(),
       current_setting('max_connections') AS max_connections,
       current_setting('shared_buffers') AS shared_buffers,
       pg_postmaster_start_time() AS started_at;
SELECT datname, numbackends, xact_commit, xact_rollback, deadlocks,
       temp_files, temp_bytes, blks_read, blks_hit, stats_reset
FROM pg_stat_database ORDER BY datname;
SELECT state, wait_event_type, wait_event, count(*) AS sessions
FROM pg_stat_activity GROUP BY 1,2,3 ORDER BY sessions DESC;
SELECT datname, age(datfrozenxid) AS xid_age
FROM pg_database ORDER BY xid_age DESC;
SELECT * FROM pg_stat_archiver;
```

Le statistiche di `pg_stat_database` si interpretano come delta tra campioni e con il rispettivo `stats_reset`. Una cache hit ratio alta non prova che il database sia sano; `temp_bytes` e I/O richiedono differenze nel tempo e confronto con host. Su PostgreSQL 16+ si può integrare `pg_stat_io`; verificare schema/colonne sul manuale della major. I grafici host devono includere CPU, memoria/swap, latenza e coda dei dischi, spazio per ogni filesystem (inclusi WAL, backup e tablespace), errori kernel/storage e rete.

## Interpretazione e risposta agli allarmi

Per ogni metrica registrare definizione, unità, frequenza, soglia, owner, pagina/escalation e procedura associata. Correlare finestre temporali e non sommare statistiche resettate. Distinguere saturazione attuale, trend e capacità residua. Associare un allarme alle procedure: lock, WAL, replica, vacuum, query lenta, backup o sicurezza.

Non modificare parametri per far tornare un grafico al valore atteso senza identificare la causa. Incrementi di connessioni o buffer, cambi ai checkpoint e alla retention devono essere valutati con memoria totale, workload, failover, spazio e RPO/RTO. Evitare raccolta ad alta frequenza o logging SQL indiscriminato: valutare costo e esposizione dei dati.

## Successo, rollback ed escalation

Baseline utile quando i campioni sono timestampati, denominatori e reset noti, metriche DB correlate a host, allarmi azionabili e owner assegnati. Quando si modifica il monitoraggio, verificare falsi positivi e costo della raccolta; ripristinare configurazione precedente se cresce overhead o si espongono dati. Escalare a DBA/platform se telemetria non è disponibile durante un incidente, filesystem o XID si avvicinano al limite operativo, oppure soglie non corrispondono a RPO/RTO.

Fonti: [sistema statistiche](https://www.postgresql.org/docs/current/monitoring-stats.html), [progresso comandi](https://www.postgresql.org/docs/current/progress-reporting.html), [configurazione runtime](https://www.postgresql.org/docs/current/runtime-config.html).
