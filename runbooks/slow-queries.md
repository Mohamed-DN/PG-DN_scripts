# Diagnosi query lente

Usare quando una query ha latenza elevata o peggiora rispetto alla baseline. Prima distinguere query lenta, attesa su lock, saturazione condivisa e latenza esterna; poi misurare un caso riproducibile.

## Precheck

Raccogliere query ID se disponibile, applicazione, database, timestamp, parametri (oscurati), frequenza, latenza attesa/osservata, piano precedente e distribuzione dei dati. Verificare spazio, lock, replica, CPU e I/O. Non abilitare logging dettagliato a livello globale senza stimare volume e sensibilità.

```sql
SELECT pid, usename, application_name, state, wait_event_type, wait_event,
       clock_timestamp() - query_start AS elapsed,
       query_id, left(query,1000) AS query_excerpt
FROM pg_stat_activity
WHERE datname = current_database() AND state = 'active'
ORDER BY query_start NULLS LAST;
```

`query_id` dipende dalla configurazione di calcolo query ID e versione; `query` può richiedere privilegi osservativi e contenere dati sensibili. `pg_stat_statements` richiede installazione/configurazione e riporta statistiche aggregate, non sostituisce il piano del caso concreto.

## Diagnostica e interpretazione

Su una query rappresentativa, con parametri non sensibili e ambiente appropriato, raccogliere il piano effettivo. `EXPLAIN ANALYZE` esegue davvero la query; per SELECT con funzioni volatili o su carico critico può causare effetti/tempo significativi. Non eseguirlo alla cieca su query di scrittura; `BEGIN; EXPLAIN ANALYZE ...; ROLLBACK;` non neutralizza effetti esterni, chiamate volatile o side effects.

```sql
EXPLAIN (ANALYZE, BUFFERS, SETTINGS, VERBOSE, SUMMARY)
SELECT ...;  -- query controllata e parametri rappresentativi
```

Usare `EXPLAIN (VERBOSE, SETTINGS)` senza ANALYZE se l'esecuzione non è sicura. Confrontare righe stimate/reali, loop, buffer hit/read, sort spill, scansioni ripetute, tempi di pianificazione/esecuzione e impostazioni. Un piano non dimostra causalità: correlare con attese, I/O host, statistiche, cardinalità e cambiamenti di schema/dati.

Se disponibile, consultare `pg_stat_statements` dopo aver verificato query ID e reset time; non condividere query normalizzate senza revisione.

## Intervento controllato

Ordine consigliato: verificare attese/lock; controllare che statistiche siano aggiornate; semplificare o correggere query/parametri; valutare indice solo con workload completo e costo di scrittura/spazio; considerare configurazione solo dopo misure ripetibili. Non creare indici o cambiare planner cost globali come tentativo casuale. `CREATE INDEX CONCURRENTLY` riduce il blocco delle scritture ma dura di più e può lasciare un indice non valido dopo errore; pianificare spazio, lock e verifica. Per qualunque DDL acquisire approvazione e seguire il piano di change.

## Successo e rollback

Ripetere con stesso caso e comparare percentili applicativi, piano, buffer, CPU/I/O, lock e replica. Se la modifica peggiora altre query o scritture, ripristinare la query/configurazione o rimuovere l'indice solo con owner, finestra e dipendenze verificate. Escalare al team applicativo per semantica/parametri; DBA per piano/indici; infrastruttura per saturazione host.

Fonti: [EXPLAIN](https://www.postgresql.org/docs/current/using-explain.html), [monitoraggio statistiche](https://www.postgresql.org/docs/current/monitoring-stats.html), [pg_stat_statements](https://www.postgresql.org/docs/current/pgstatstatements.html).
