# Esempi di azioni amministrative

Questi esempi preservano i temi operativi degli appunti originali separandoli dalle query diagnostiche. Sono modelli didattici con nomi segnaposto: non sono script di rilascio e non vanno eseguiti senza revisione, ruolo approvato, ambiente e piano di ritorno verificati.

## Gate manuale prima di un cambiamento

Prima di creare ruoli o schemi, aggiornare grant o avviare manutenzione:

1. Confermare cluster, database, versione, ambiente e principal effettivo con `\conninfo` e una verifica del ruolo corrente.
2. Rivedere il diff dei comandi, i grant esistenti e l'ownership degli oggetti. Le identità SQL non sono intercambiabili con nomi applicativi simili.
3. Per modifiche in produzione, verificare change approval, backup/restore recente, replica e WAL, spazio libero, carico attuale, finestra e responsabile dell'intervento.
4. Stimare lock, I/O, durata e oggetti coinvolti. Pianificare cosa fare se il comando fallisce a metà; alcuni comandi non hanno rollback pratico.
5. Eseguire un comando alla volta con `ON_ERROR_STOP`, acquisire l'esito e controllare ownership, ACL, progressi e log prima di proseguire.

## Ruolo di sola lettura e schema

Impostare nomi di esempio come variabili `psql`, che vengono quotate come identificatori. Il ruolo seguente è `NOLOGIN`: può essere concesso a ruoli di login gestiti separatamente. Le istruzioni falliscono se gli oggetti esistono già, così un operatore deve ispezionare lo stato prima di adattarle.

```sql
\set group_role reporting_readers
\set owner_role reporting_owner
\set schema_name reporting

BEGIN;
CREATE ROLE :"group_role" NOLOGIN;
CREATE SCHEMA :"schema_name" AUTHORIZATION :"owner_role";
GRANT USAGE ON SCHEMA :"schema_name" TO :"group_role";
GRANT SELECT ON ALL TABLES IN SCHEMA :"schema_name" TO :"group_role";
GRANT SELECT ON ALL SEQUENCES IN SCHEMA :"schema_name" TO :"group_role";
ALTER DEFAULT PRIVILEGES FOR ROLE :"owner_role" IN SCHEMA :"schema_name"
  GRANT SELECT ON TABLES TO :"group_role";
COMMIT;
```

`CREATE ROLE` crea un ruolo globale al cluster; `CREATE SCHEMA` e gli ACL successivi si applicano nel database corrente. I grant sulle tabelle esistenti non coprono automaticamente oggetti futuri: i default privileges valgono solo per gli oggetti creati dal ruolo indicato con `FOR ROLE`, nel database corrente. Grant e membership possono ampliare l'accesso in modo transitivo. Verificare i privilegi effettivi dopo l'esecuzione.

La password non compare nello script. Se serve un ruolo login, creare o gestire l'autenticazione tramite il processo aziendale approvato; non aggiungere password in chiaro al file. `psql` offre `\password` per l'inserimento interattivo.

## Aggiornare statistiche con ANALYZE

```sql
\set schema_name reporting
\set table_name monthly_sales
ANALYZE VERBOSE :"schema_name".:"table_name";
```

`ANALYZE` raccoglie statistiche usate dal planner. Legge campioni di dati e aggiorna statistiche di sistema; può consumare I/O e cambiare le stime e i piani delle query anche senza modificare le righe applicative. Il normale autovacuum effettua già analyze quando necessario. Prima di lanciarlo manualmente, controllare data e motivo delle statistiche stale, carico e progressi di manutenzione.

## Ricostruire un indice con REINDEX CONCURRENTLY

```sql
\set schema_name reporting
\set index_name monthly_sales_created_at_idx
REINDEX INDEX CONCURRENTLY :"schema_name".:"index_name";
```

`REINDEX CONCURRENTLY` permette a letture e scritture ordinarie di continuare, ma esegue più passaggi, richiede spazio aggiuntivo e può usare CPU e I/O per un periodo prolungato. Attende transazioni che potrebbero usare l'indice e non può essere eseguito dentro un blocco di transazione. Se fallisce, può lasciare un indice non valido da investigare. Verificare spazio, progressi, transazioni lunghe e impatto sul workload; usare [invalid-indexes.sql](../../../scripts/performance/indexes/invalid-indexes.sql) per il controllo successivo. Un candidato inutilizzato o duplicato è un punto di indagine, non da solo una motivazione sufficiente per rebuild o rimozione.

Riferimenti ufficiali: [CREATE ROLE](https://www.postgresql.org/docs/current/sql-createrole.html), [CREATE SCHEMA](https://www.postgresql.org/docs/current/sql-createschema.html), [GRANT](https://www.postgresql.org/docs/current/sql-grant.html), [ANALYZE](https://www.postgresql.org/docs/current/sql-analyze.html), [REINDEX](https://www.postgresql.org/docs/current/sql-reindex.html).
