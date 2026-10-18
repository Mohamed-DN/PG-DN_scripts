# Verifica e limiti

Verifica aggiornata il 18 ottobre 2026 su container Podman effimeri. I report registrano versione effettiva del server, immagine, SHA-256 dei file eseguiti, esito per ruolo e pulizia delle risorse del laboratorio.

## Matrice completa della libreria operativa

Tutti i **144 file SQL** di `scripts/` sono eseguiti su PostgreSQL 14–18, come amministratore e con `pg_monitor`. Le query che richiedono 16 o 17 terminano con la guardia sulle major precedenti: il report le distingue dalle SELECT realmente eseguite. Per la vista HBA è verificata la negazione al ruolo monitor e il successo amministrativo.

| Server effettivo | File | Controlli di base | Verifiche estese | Pulizia |
| :-- | --: | --: | --: | :-- |
| 14.24 | 144 | 14 | 76 | passed |
| 15.19 | 144 | 14 | 76 | passed |
| 16.15 | 144 | 14 | 77 | passed |
| 17.11 | 144 | 14 | 77 | passed |
| 18.6 | 144 | 14 | 77 | passed |

[Rapporto JSON](evidence/postgres-matrix.json) · [Copertura per file](evidence/SQL_COVERAGE.md) · [SHA-256 dello snapshot](evidence/curated-sha256.json) · [Piano e significato degli esiti](QUERY_TEST_PLAN.md).

Le verifiche estese controllano oggetti e privilegi su dati noti, indici duplicati e invalidi, TOAST, sequenze, aritmetica dei contatori e casi negativi. Una mutazione della query degli indici rimuove soltanto il confronto dei predicati: il falso positivo prodotto dalla copia alterata viene rilevato. Il file SQL operativo rimane invariato.

I processi attivi comprendono sessioni idle, advisory lock, COPY, build concorrente di indici, ANALYZE, VACUUM, CLUSTER, chiamata all'API di backup e query realmente più vecchia di un minuto. I processi osservati sono poi cancellati nel solo lab: questa parte prova la diagnostica, non il completamento della manutenzione.

## Backup fisico e replica

Il laboratorio PostgreSQL **18.6** osserva la query di progresso durante un vero `pg_basebackup`, verifica il manifest con `pg_verifybackup` e avvia la replica streaming. A replay sospeso, il lag è positivo e lo standby resta a 20 righe; alla ripresa converge alle **120 righe** del primary.

Tutte le **24 diagnostiche** di backup, WAL e replica sono eseguite sia sul primary sia sullo standby (**48 esecuzioni**). I controlli puntuali verificano sender in streaming con lag positivo, receiver e slot attivi, avanzamento del replay e identico system identifier con ruoli recovery differenti. Pulizia delle sole risorse proprietarie: **passed**.

[Rapporto fisico](evidence/physical-replication.json) · [Laboratorio riproducibile](REPLICATION_LAB.md).

## Controlli del repository

Sono passati **14 test Python** di navigazione e protezione delle risorse. Il validatore controlla header, convenzioni e link; la generazione è idempotente. I manifest verificano i byte dei **226 file upstream** conservati. I test di risorse verificano anche il rifiuto di cancellare container altrui e la segnalazione di una rimozione fallita.

## Limiti

Gli originali esterni in `_support/upstream/` sono riferimenti separati e non sono dichiarati eseguiti o certificati dalla matrice delle query curate. Versioni 8.x–13, tutti i possibili privilegi, sistemi cloud gestiti e carichi di produzione non sono coperti da questo laboratorio.

Un risultato non vuoto non dimostra ogni proprietà della query: il dettaglio distingue esecuzione, guardia e verifiche specifiche del risultato. Le prove non dimostrano PITR con archivio storico, failover, Barman o pgBackRest. Non sono stati eseguiti comandi su database di produzione.
