# Note operative PostgreSQL

Questa pagina raccoglie indicazioni diagnostiche PostgreSQL e ne chiarisce i limiti di interpretazione. Non contiene output di incidenti, host, percorsi interni, credenziali o comandi di intervento pronti all'uso.

## Primo triage

1. Controllare versione, ruolo, database, stato recovery e visibilità delle viste prima di interpretare una query. Le query su sessioni e statistiche possono mostrare soltanto le proprie sessioni senza i privilegi adatti.
2. Registrare due snapshot delle statistiche con i rispettivi orari. Contatori come `pg_stat_database`, `pg_stat_wal`, `pg_stat_io` e `pg_stat_statements` sono cumulativi dall'ultimo reset; una singola lettura non dà un tasso.
3. Per le sessioni, distinguere `active`, `idle`, `idle in transaction` e attese. Una query attiva da molto tempo non prova da sola un blocco; verificare wait event e relazioni con i lock.
4. Per la capacità, confrontare dimensioni database/relazioni con telemetria filesystem e storage. `pg_database_size` e `pg_total_relation_size` descrivono spazio allocato dal cluster, non spazio libero sul volume.

## Statistiche, query e indici

- Il rapporto cache hit è un indicatore aggregato e dipende da finestra di osservazione, workload e cache del sistema operativo. Un valore fisso come 99% non è una soglia operativa valida per ogni istanza.
- `pg_stat_statements` richiede che il modulo sia già configurato e caricato dal server; il catalogo non crea estensioni né cambia `shared_preload_libraries`. Le query normalizzate e le statistiche possono esporre dettagli applicativi e vanno condivise con cautela.
- Un indice con `idx_scan = 0` può essere appena creato, usato raramente, necessario per vincoli o utile in finestre particolari. Verificare periodo rappresentativo, workload, vincoli, replica e piano prima di proporre una rimozione. Non cancellare indici in base al solo contatore.
- Le statistiche in `pg_stat_user_tables` e `pg_stats` possono essere stime o non aggiornate; verificare `last_analyze`, reset e sampling prima di concludere che l'ottimizzatore abbia statistiche errate.

## Vacuum e spazio

- Il vacuum ordinario rende spazio riutilizzabile dentro la relazione e aggiorna informazioni utili; non promette di restituire subito spazio al filesystem.
- `VACUUM FULL` riscrive la tabella, richiede un lock forte e spazio aggiuntivo temporaneo. Può bloccare accessi per molto tempo su tabelle grandi. Non è il rimedio predefinito per tuple morte o filesystem pieno.
- Tuple morte e dimensione totale non misurano direttamente il bloat recuperabile. Confrontare andamento nel tempo e strumenti/metriche adatti, considerando TOAST, indici, partizionamento e churn.
- Prima di manutenzione, controllare transazioni lunghe, `backend_xmin`, slot e feedback degli standby: possono trattenere tuple o WAL. Lo stato di progressione identifica un'operazione attiva, non giustifica da solo una cancellazione o un'interruzione.

## Replica e WAL

- Sul primary `pg_stat_replication` descrive i sender connessi. Sullo standby `pg_stat_wal_receiver`, LSN ricevuto e LSN riprodotto descrivono un lato diverso del flusso; confrontare la vista coerente con il ruolo del nodo.
- Il lag in byte ottenuto con `pg_wal_lsn_diff` è un delta tra LSN e va interpretato sullo stesso timeline/contesto. Il tempo dall'ultimo commit riprodotto può crescere durante un periodo senza scritture: non equivale necessariamente a ritardo di replica.
- Slot inattivi possono impedire la rimozione di WAL, ma eliminarli può rendere necessario ricreare o riallineare un consumer. Prima di qualsiasi rimedio, identificare owner, tipo slot, consumer, `restart_lsn`, soglie di retention e spazio richiesto.
- `max_wal_size`, `wal_keep_size`, archiving e slot hanno scopi diversi. `max_wal_size` non è un limite assoluto al volume in `pg_wal`; retention e archiver possono mantenerlo sopra il valore atteso.
- `pg_stat_archiver` è cumulativo e non garantisce che ogni WAL precedente a `last_archived_wal` sia archiviato in ordine in ogni scenario. Verificare backup manager e archivio, non dedurre l'integrità dal solo contatore.

## Backup, restore e comandi esterni

- `pg_dump`/`pg_restore` sono backup logici; `pg_basebackup` e Barman operano su backup fisici e WAL. Verificare separatamente copertura, retention, catena WAL, checksum e procedura di restore.
- Un backup non è verificato solo perché il comando è terminato con successo. La prova significativa è il ripristino secondo una procedura controllata e coerente con RPO/RTO.
- Opzioni come `pg_restore --clean`, cancellazioni Barman, rimozione file, terminazione processi e modifica di configurazione sono azioni con impatto. Le trascrizioni shell vanno adattate e revisionate in un runbook prima dell'uso.
- SQL e metacomandi `psql` sono livelli distinti. Un blocco `BEGIN READ ONLY` non rende read-only un comando shell esterno né protegge operazioni eseguite fuori dalla transazione.

## Versioni e permessi

- Il catalogo considera PostgreSQL 14–18 come intervallo di riferimento. `pg_stat_io` è disponibile da PostgreSQL 16; la vista dedicata `pg_stat_checkpointer` è disponibile da PostgreSQL 17. Gli script corrispondenti fermano l'esecuzione sulle versioni precedenti.
- Dal PostgreSQL 17 alcuni contatori prima esposti da `pg_stat_bgwriter` sono in `pg_stat_checkpointer`; non copiare query tra versioni senza controllare le colonne effettive.
- `pg_read_all_stats`, `pg_read_all_settings` e privilegi per funzioni di lettura filesystem determinano cosa si vede. ACL espliciti, membership e ownership concorrono ai privilegi effettivi; l'elenco di grant non è una prova completa dell'accesso effettivo.
- I file del catalogo sono focalizzati per operazione e applicano timeout brevi; le funzioni di dimensionamento possono comunque avere costo su cataloghi e oggetti estesi. Eseguire prima su una sessione di monitoraggio appropriata e confrontare l'impatto.
