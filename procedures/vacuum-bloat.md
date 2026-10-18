# Autovacuum, VACUUM e bloat

Usare quando crescono tabelle/indici o spazio, l'autovacuum sembra non recuperare arretrato, o aumentano transazioni lunghe e rischio wraparound. Le stime di bloat non sostituiscono una misura; lo spazio libero dentro la relazione può essere riutilizzato anche se il file non si riduce sul filesystem.

## Percorso operativo

1. Eseguire [dead-tuples.sql](../scripts/maintenance/vacuum/dead-tuples.sql) e ordinare le stime `n_dead_tup`/`dead_pct`, annotando `last_autovacuum` e `last_analyze`. Sono stime: quota alta non prova bloat fisico né spazio restituibile al filesystem.
2. Se vacuum non avanza o le tuple sembrano trattenute, eseguire [oldest-transactions.sql](../scripts/maintenance/vacuum/oldest-transactions.sql). `age`, `backend_xmin` e `backend_xid` aiutano a trovare snapshot longevi; per ogni PID candidato confermare owner e orizzonte prima di intervenire.
3. Se la preoccupazione è wraparound, eseguire [wraparound-risk.sql](../scripts/maintenance/vacuum/wraparound-risk.sql). Confrontare età XID/multixact con soglie e trend; crescita verso soglia richiede piano/escalation, non disabilitazione di autovacuum.
4. Per una manutenzione già avviata, eseguire [vacuum.sql](../scripts/maintenance/progress/vacuum.sql) e leggere fase/contatori come avanzamento del comando, non come misura di spazio recuperato. Se non c'è vacuum attivo, rivalutare carico, finestra e tabella prima del comando mirato descritto sotto.
5. Verificare statistiche aggiornate, log autovacuum, spazio interno riusabile e andamento XID. `VACUUM` ordinario non promette riduzione del file su disco; XID in rapido aumento o spazio critico richiedono escalation immediata.

## Precheck

Verificare versione, database, spazio filesystem, trend dimensioni, volume di scritture, finestre di manutenzione, backup e replica. Cercare transazioni e snapshot lunghi, slot inattivi e query standby che possono impedire la rimozione di tuple. Il ruolo osservativo potrebbe non vedere tutte le statistiche.

```sql
SELECT datname, age(datfrozenxid) AS xid_age, datallowconn
FROM pg_database ORDER BY xid_age DESC;
SELECT pid, datname, usename, state, xact_start, backend_xmin,
       wait_event_type, wait_event, left(query,300) AS query_excerpt
FROM pg_stat_activity
WHERE xact_start IS NOT NULL OR backend_xmin IS NOT NULL
ORDER BY xact_start NULLS LAST;
SELECT schemaname, relname, n_live_tup, n_dead_tup,
       last_vacuum, last_autovacuum, vacuum_count, autovacuum_count,
       last_analyze, last_autoanalyze
FROM pg_stat_user_tables
ORDER BY n_dead_tup DESC NULLS LAST LIMIT 30;
SELECT datname, age(datfrozenxid) AS xid_age
FROM pg_database ORDER BY xid_age DESC;
```

Le stime `n_dead_tup` sono approssimative. Ispezionare progressi correnti:

```sql
SELECT pid, datname, relid::regclass AS relation, phase,
       heap_blks_total, heap_blks_scanned, heap_blks_vacuumed,
       index_vacuum_count
FROM pg_stat_progress_vacuum;
```

Le query alle statistiche possono includere solo il database connesso o richiedere privilegi aggiuntivi. Per `pg_stat_io`, disponibile da PostgreSQL 16, usare il manuale della major e non eseguirla su 14/15.

## Interpretazione e azione

Distinguere: autovacuum non parte; lavora ma non tiene il passo; non può rimuovere tuple per transazioni/snapshot/slot; crescita causata da attività attesa; spazio inutilizzato interno non restituibile al filesystem. Controllare log autovacuum, saturazione I/O, `autovacuum_*`, `vacuum_cost_*`, `maintenance_work_mem`, `track_counts`, `autovacuum_freeze_max_age` e configurazioni per tabella, confrontandoli con workload e default della major. Non impostare valori universali o disabilitare autovacuum.

Per una tabella identificata e con finestra/capacità confermate, eseguire manutenzione ordinaria mirata:

```sql
VACUUM (VERBOSE, ANALYZE) schema.tabella;
```

Il `VACUUM` standard consente accessi concorrenti in lettura/scrittura e rende spazio riutilizzabile internamente; di norma non riduce il file sul filesystem. Non eseguire `VACUUM FULL` come riflesso: riscrive la tabella, richiede lock `ACCESS EXCLUSIVE` e spazio aggiuntivo. Valutare una riscrittura o una strategia online solo in un piano specifico per versione/estensioni, con replica e spazio misurati.

## Verifica, rollback ed escalation

Controllare progress, log, `n_dead_tup` dopo aggiornamento delle statistiche, spazio riusabile e tempo/impatti applicativi. `VACUUM` ordinario non ha rollback significativo e va lasciato completare salvo rischio operativo; interromperlo non annulla già svolto. Se `age(datfrozenxid)` si avvicina alle soglie del team, l'autovacuum non avanza, il cluster registra rischio wraparound o il disco è in esaurimento, escalation immediata al DBA senior. Non terminare autovacuum senza piano validato.

Fonti: [VACUUM](https://www.postgresql.org/docs/current/sql-vacuum.html), [routine vacuuming](https://www.postgresql.org/docs/current/routine-vacuuming.html), [progresso](https://www.postgresql.org/docs/current/progress-reporting.html).
