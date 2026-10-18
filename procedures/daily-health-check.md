# Controllo giornaliero PostgreSQL

Usare questa sequenza per un controllo manuale dello stato del servizio e per individuare le anomalie che richiedono una diagnosi dedicata.

## Prima di iniziare

Configura una connessione `psql` come descritto nella [guida di esecuzione](../_support/docs/QUICKSTART.md). Leggi versione e privilegi nell'header di ogni file. Registra ambiente, database, ruolo e orario: il confronto ha senso solo fra campioni dello stesso servizio e con reset delle statistiche coerenti.

Questa procedura raccoglie evidenze in sola lettura. Se il servizio è già indisponibile o l'impatto è in aumento, passa subito al [triage](triage.md).

## 1. Conferma dove sei collegato

Apri ed esegui [server-info.sql](../scripts/administration/inventory/server-info.sql). Controlla `database`, `version`, `server_address`, `started_at` e `standby` rispetto all'inventario atteso. Un indirizzo NULL è possibile con un socket locale. Se endpoint, ruolo del nodo o avvio recente non sono spiegabili, chiarisci la topologia prima degli altri controlli.

## 2. Controlla connessioni e attese

Esegui [connection-capacity.sql](../scripts/administration/configuration/connection-capacity.sql) e [wait-summary.sql](../scripts/monitoring/activity/wait-summary.sql). Confronta `visible_client_backends` con la capacità abituale e osserva `wait_event_type`, `wait_event` e `sessions`.

Se la pressione cresce, verifica pooler e applicazioni con la procedura di [monitoraggio](monitoring.md). Se le attese `Lock` persistono nei campioni successivi, segui la [diagnosi dei lock](locks.md). Il conteggio visibile non è il numero garantito di connessioni ancora disponibili.

## 3. Confronta i contatori con il campione precedente

Esegui [database-counters.sql](../scripts/monitoring/statistics/database-counters.sql). Confronta i delta di `deadlocks`, `temp_bytes`, transazioni e blocchi, controllando prima `stats_reset`. Se il reset è cambiato, avvia una nuova finestra di osservazione.

Se aumentano deadlock o attese, passa a [locks](locks.md); se peggiorano tempi e lavoro temporaneo, apri [query lente](slow-queries.md). Un totale alto o una percentuale cache isolata non identificano da soli una causa.

## 4. Verifica WAL e replica quando presenti

Se il cluster usa slot, esegui [retention.sql](../scripts/replication/slots/retention.sql) e confronta `retained_wal_bytes`, `active` e `wal_status` con i campioni precedenti. Se usa archiviazione, controlla [archive-status.sql](../scripts/wal/archive/archive-status.sql). Zero righe negli slot è normale quando non ne sono configurati.

Se i WAL trattenuti aumentano o l'archiver fallisce, segui [crescita WAL](wal-growth.md). Se lo standby o un consumer non avanza, segui [ritardo di replica](replication-lag.md). La retention di uno slot non misura l'intero spazio fisico di `pg_wal`.

## 5. Osserva manutenzione e protezione dati

Esegui [wraparound-risk.sql](../scripts/maintenance/vacuum/wraparound-risk.sql) e [dead-tuples.sql](../scripts/maintenance/vacuum/dead-tuples.sql). Un trend crescente o un arretrato persistente richiedono [vacuum e bloat](vacuum-bloat.md); nessuno di questi risultati giustifica da solo un comando di manutenzione.

Verifica anche l'esito del backup e la disponibilità di una prova di ripristino nel sistema che li gestisce. Le sole query di ispezione SQL non dimostrano che il backup sia recuperabile: usa [backup e restore](backup-restore.md), [Barman](barman.md) o [pgBackRest](pgbackrest.md) secondo la configurazione.

## Chiusura

Registra intervallo osservato, anomalie, procedura seguita ed eventuale ticket nella [scheda incidente](incident-template.md), omettendo dati riservati. Il controllo è concluso quando il target è confermato, gli scostamenti rispetto alla baseline sono spiegati oppure assegnati a una diagnosi, e non restano segnali in peggioramento privi di un responsabile.

Per definire raccolta continua, soglie e azioni di allarme, continua con [baseline e monitoraggio](monitoring.md). Questa guida non installa un monitor e non programma esecuzioni periodiche.
