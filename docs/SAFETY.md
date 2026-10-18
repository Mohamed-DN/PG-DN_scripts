# Sicurezza e limiti operativi

Queste regole si applicano a script, runbook, test e report.

## Credenziali e dati

- Usare `PGSERVICE` e un `PGPASSFILE` protetto, oppure `.pgpass` accessibile solo al proprietario (permessi `0600` su Unix). Evitare password in URL, `PGPASSWORD`, comandi, ticket e log.
- Non stampare credenziali, hash, stringhe di connessione, dump o righe applicative contenenti dati personali.
- Redigere i risultati prima di allegarli a un ticket o a una pull request. Le statistiche possono comunque contenere nomi di database, ruoli e query sensibili.

## Separare osservazione e cambiamento

Le query di diagnostica devono essere read-only e non richiedere superuser quando bastano privilegi minori. Prima di una modifica, confermare ambiente, database, target, finestra, impatto e piano di recupero. Preferire un'azione per volta e controllare le evidenze immediatamente dopo.

Non cancellare o rinominare file in `pg_wal`; non usare `pg_resetwal` come rimedio ordinario; non eliminare slot o terminare sessioni senza aver stabilito proprietario, impatto e alternative. Questi interventi possono rendere il cluster irrecuperabile o causare perdita dati. Non forzare failover automatici dai runbook generici.

## DDL e manutenzione

Controllare lock acquisiti, durata prevista, spazio temporaneo/destinazione e impatto sulle repliche. `VACUUM FULL`, `CLUSTER`, `REINDEX` tradizionale, restore in place e `DROP` possono bloccare o sostituire dati. Usare procedure specifiche con backup verificato, finestra e accettazione dell'impatto. Un `ROLLBACK` SQL non annulla un'operazione già eseguita in autocommit né ripristina dati cancellati.

## Evidenza e versioni

Salvare timestamp con fuso orario, `version()`, host/cluster in forma non sensibile, identificatore dell'incidente e query/metodo usato. Separare l'osservato dall'ipotesi. Confrontare con i manuali della major in uso: documentazione `current` può includere funzioni successive rispetto a PostgreSQL 14.
