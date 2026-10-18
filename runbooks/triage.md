# Triage iniziale PostgreSQL

Usare questa procedura quando un allarme o una segnalazione non ha ancora una causa verificata. L'obiettivo è circoscrivere impatto e cambiamenti recenti prima di terminare sessioni o modificare parametri.

## Precheck

Registrare ora UTC, fuso, ambiente, endpoint/cluster, database, segnalante, sintomo, prima osservazione e impatto sugli utenti. Confermare l'identità del cluster tramite canale indipendente dall'alias del client. Usare un ruolo osservativo; evitare output con query o dati sensibili. Per la raccolta, il ruolo deve poter vedere le sessioni che si stanno valutando.

```sh
psql "service=$PGSERVICE" -X -v ON_ERROR_STOP=1
```

```sql
SELECT clock_timestamp() AS observed_at, current_database(), current_user,
       inet_server_addr(), inet_server_port(), version();
SELECT pg_postmaster_start_time(), pg_is_in_recovery();
SELECT datname, numbackends, deadlocks, conflicts, stats_reset
FROM pg_stat_database
WHERE datname = current_database();
SELECT state, wait_event_type, wait_event, count(*)
FROM pg_stat_activity
WHERE datname = current_database()
GROUP BY 1,2,3 ORDER BY 4 DESC;
```

Da host/monitoring, controllare disponibilità filesystem, CPU, memoria, I/O, errori recenti del servizio, rete e stato backup/archivio. Non incollare log grezzi contenenti segreti o query sensibili.

## Decisione

```mermaid
flowchart TD
  A[Conferma cluster e impatto] --> B{Impatto ampio o perdita dati?}
  B -- sì / incerto --> C[Escalation immediata a IC e DBA]
  B -- no --> D{Lock o saturazione sessioni?}
  D -- lock --> E[locks.md]
  D -- WAL o archivio --> F[wal-growth.md]
  D -- replica --> G[replication-lag.md]
  D -- vacuum / bloat --> H[vacuum-bloat.md]
  D -- query specifica --> I[slow-queries.md]
  D -- nessuno --> J[Confronta baseline e telemetria host]
```

## Interpretazione e azione

Un singolo campione non stabilisce la causa: confrontare almeno due osservazioni con timestamp e baseline, verificando se il sintomo cresce o rientra. `pg_stat_database` contiene contatori dall'ultimo reset e non è un tasso finché non si confrontano intervalli. `pg_is_in_recovery()` identifica un server in recovery/standby, non prova che sia il primario previsto.

Non riavviare, terminare backend o cambiare configurazione come primo tentativo. Se una risorsa è vicina all'esaurimento, seguire il runbook dedicato e concordare l'impatto prima dell'azione.

## Successo, rollback ed escalation

Triage concluso quando target, impatto, finestra temporale, evidenze, ipotesi e responsabile sono registrati e instradati a un runbook specifico. Se l'impatto aumenta, ci sono errori di storage/corruzione, il primario è incerto o il margine di spazio è critico, passare subito all'incident commander/DBA senior e al responsabile infrastruttura. Non c'è rollback per la sola raccolta read-only; ripristinare eventuali modifiche di raccolta concordate.

Fonti: [attività e statistiche](https://www.postgresql.org/docs/current/monitoring-stats.html), [progress reporting](https://www.postgresql.org/docs/current/progress-reporting.html).
