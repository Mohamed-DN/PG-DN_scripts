# Diagnosi dei lock

Usare quando sessioni applicative sono in attesa, DDL resta bloccato o l'allarme mostra lock non concessi. Un lock non è di per sé un errore: individuare la catena e il proprietario prima di intervenire.

## Percorso operativo

1. Eseguire [blocking-sessions.sql](../scripts/monitoring/activity/blocking-sessions.sql) per associare sessioni in attesa ai PID bloccanti. Leggere `blocked_pid`, `blocker_pid`, attesa e stato del bloccante; `blocker_pid=0` richiede di verificare prepared transaction, non di terminare un PID. Per quantificare l’impatto usare [blocking-impact.sql](../scripts/monitoring/activity/blocking-impact.sql); per individuare le relazioni contese usare [waiting-locks-by-relation.sql](../scripts/monitoring/activity/waiting-locks-by-relation.sql).
2. Se il blocco persiste, eseguire [oldest-backend-transactions.sql](../scripts/administration/connections/oldest-backend-transactions.sql). `transaction_age` e `time_in_state` distinguono transazione lunga e sessione ferma; se il candidato è `idle in transaction`, identificare owner e impatto prima di proseguire.
3. Se l'ipotesi è retention di snapshot/XID, eseguire [xid-holding-backends.sql](../scripts/administration/connections/xid-holding-backends.sql). `backend_xmin` individua orizzonti visibili, ma visibilità incompleta richiede una raccolta con ruolo adeguato; se non si conferma una radice, non intervenire.
4. Ripetere [blocking-sessions.sql](../scripts/monitoring/activity/blocking-sessions.sql) dopo un intervallo breve e confrontare PID, attesa e coda. Se la radice è confermata e l'owner autorizza, preferire cancellare la query specifica; terminare la sessione richiede valutare rollback e retry.
5. Verificare che la coda diminuisca e l'operazione applicativa riesca; se il blocco ricompare o coinvolge un processo interno, conservare i campioni e passare a DBA/owner applicativo.

Esempio da `procedures/`: `psql "service=$PGSERVICE" -X -v ON_ERROR_STOP=1 -f ../scripts/monitoring/activity/blocking-sessions.sql`.

## Precheck

Confermare database, ora, richiesta applicativa, transazione o deploy recenti e privilegi di visibilità. `pg_stat_activity` può nascondere dettagli di altri utenti a ruoli non privilegiati; chiedere al DBA una vista con `pg_read_all_stats` se necessaria.

## Diagnostica

```sql
SELECT clock_timestamp() AS observed_at, a.pid, a.usename, a.application_name,
       a.client_addr, a.state, a.wait_event_type, a.wait_event,
       clock_timestamp() - a.query_start AS query_age,
       clock_timestamp() - a.xact_start AS xact_age,
       pg_blocking_pids(a.pid) AS blocking_pids,
       left(a.query, 500) AS query_excerpt
FROM pg_stat_activity AS a
WHERE a.datname = current_database()
  AND (cardinality(pg_blocking_pids(a.pid)) > 0
       OR (a.wait_event_type = 'Lock' AND a.state = 'active'))
ORDER BY a.xact_start NULLS LAST;

SELECT l.pid, l.locktype, l.mode, l.granted, l.relation::regclass AS relation,
       l.transactionid, l.waitstart
FROM pg_locks AS l
WHERE NOT l.granted
ORDER BY l.waitstart NULLS LAST;
```

Ripetere dopo un breve intervallo controllato. `query_excerpt` è sensibile: oscurarlo prima di condividerlo. Una catena di bloccanti può avere più di un livello; verificare che il PID sia ancora attivo prima dell'azione.

## Interpretazione e intervento

Individuare il blocco radice, owner/applicazione, età transazione, oggetto e conseguenze di attesa/cancellazione. Una transazione `idle in transaction` può trattenere lock e snapshot; coinvolgere l'applicazione proprietaria e stimare rollback e retry. Se autorizzato, preferire chiedere all'applicazione di chiudere la transazione o cancellare la query specifica. `pg_cancel_backend(pid)` interrompe la query; terminare il backend con `pg_terminate_backend(pid)` chiude la sessione e fa rollback della transazione, potenzialmente lungo. Farlo solo con PID rivalidato, owner informato, impatto accettato e piano di retry. Non terminare processi interni o replica.

```sql
-- Solo dopo autorizzazione e verifica che PID e query siano ancora quelli attesi:
SELECT pg_cancel_backend(<pid>);
```

Per lock causati da DDL, valutare la migrazione e la finestra; non ripetere un DDL bloccante alla cieca. Evitare `lock_timeout`/`statement_timeout` globali come rimedio improvvisato.

## Verifica e recupero

Controllare che la coda si riduca, la richiesta applicativa riesca e i retry non generino un nuovo carico. Se l'azione annulla una transazione, il database non la ricostruisce: l'applicazione deve ripeterla secondo la propria logica. Se il blocco ricompare o la root sessione è di sistema, escalare al DBA e all'owner applicativo.

Fonti: [monitoraggio dei lock](https://www.postgresql.org/docs/current/monitoring-locks.html), [funzioni di controllo server](https://www.postgresql.org/docs/current/functions-admin.html#FUNCTIONS-ADMIN-SIGNAL).
