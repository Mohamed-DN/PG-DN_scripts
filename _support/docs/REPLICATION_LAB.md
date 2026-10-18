# Laboratorio di replica fisica PostgreSQL

Questo test avvia un primary e uno standby PostgreSQL 18 in una rete Podman o Docker isolata, esegue un backup fisico e dimostra la ricezione e il replay del WAL. Verifica anche che alcune query diagnostiche esistenti siano eseguibili sullo standby. Il laboratorio non è una procedura di ripristino e non dimostra PITR.

## Esecuzione

Dal root del repository:

```powershell
python _support/tests/replication.py --engine podman --version 18
```

Per Docker usare `--engine docker`. Il report JSON viene scritto in `test-results/replication.json` (directory ignorata da Git). Un codice di uscita diverso da zero indica un errore del test o della pulizia.

## Isolamento e pulizia

Ogni esecuzione genera un UUID e nomi dedicati per rete, container e volumi. La rete è interna, non vengono pubblicate porte host e i volumi sono nuovi e senza bind mount. L'autenticazione `trust` è confinata alla rete temporanea del laboratorio; anche la regola HBA per il protocollo di replica è aggiunta solo al primary usa-e-getta.

Rete, container e volumi ricevono l'etichetta `pgdn.owner=<UUID>`. Prima di rimuovere ciascuna risorsa, il test ne verifica il proprietario; rifiuta nomi già esistenti e non elimina risorse senza la propria etichetta. Il report dichiara l'esito della pulizia e qualsiasi errore. In caso di arresto forzato del processo prima della pulizia, i nomi e l'UUID delle risorse sono nel report solo se è stato scritto; controllare le etichette prima di intervenire manualmente.

Il test usa solo comandi `subprocess` con argomenti separati (`shell=False`) e non esegue script shell scaricati. L'immagine PG18 usa `PGDATA=/var/lib/postgresql/18/docker` e monta il volume alla directory `/var/lib/postgresql`, come richiesto dalla struttura dell'immagine ufficiale PostgreSQL 18.

## Cosa prova

La procedura attende il readiness del processo PostgreSQL definitivo, crea un ruolo e uno slot fisico, esegue `pg_basebackup` con manifest e checksum SHA-256 e controlla il backup con `pg_verifybackup`. Poi verifica che lo standby sia in recovery e che il primary veda un sender in streaming.

Una tabella di fixture viene replicata inizialmente con 20 righe. Il test sospende il replay sullo standby, inserisce altre 100 righe sul primary, interroga lo standby finché i byte WAL arrivati ma non riprodotti sono maggiori di zero e conferma che il conteggio resta 20. Dopo la ripresa, attende via polling che lo standby converga a 120 righe. I poll hanno scadenze finite; non si usano pause fisse per presumere che la replica sia pronta.

Durante il replay sospeso, il test esegue con `ON_ERROR_STOP=1` tutti i **24 file SQL** presenti in `scripts/replication/`, `scripts/wal/` e `scripts/backup/`. L’elenco puntuale e il codice di uscita sono nel rapporto JSON; gli hash dello snapshot SQL sono nel [rapporto di validazione](VALIDATION.md).

Il risultato documenta l'eseguibilità su questa versione e in questo ruolo. Non certifica la correttezza operativa degli script. In particolare, `primary-senders.sql` può restituire zero righe sullo standby: l'osservazione dei sender è stata verificata separatamente sul primary.

## Evidenza corrente

L'esecuzione pubblicata in [`evidence/physical-replication.json`](evidence/physical-replication.json) è passata con Docker e `docker.io/library/postgres:18-alpine`, server PostgreSQL 18.6. `pg_verifybackup` ha confermato il manifest; lo standby era in recovery e lo stato di streaming era attivo. La replica iniziale ha raggiunto 20 righe; a replay sospeso il lag osservato era 72.504 byte e lo standby è rimasto a 20 righe. Dopo la ripresa primary e standby sono entrambi arrivati a 120 righe. Tutti i 24 file diagnostici hanno restituito codice 0. La pulizia delle risorse con etichetta proprietario è passata senza errori.

Questa prova non testa promozione/failover, replica logica, archiviazione WAL, recupero point-in-time o ripristino da backup in un cluster distinto. Il campo `pitr_proven` resta `false` nel JSON.
