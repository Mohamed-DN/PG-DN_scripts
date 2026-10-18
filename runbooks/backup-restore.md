# Backup, restore e PITR

Usare per verificare protezione dati, recuperare una base logica o predisporre ripristino fisico. Backup riuscito e ripristino dimostrato sono cose diverse. Definire target, RPO/RTO, punto di recupero e impatto prima di iniziare.

## Precheck

Confermare ambiente sorgente e target con il proprietario del servizio; registrare major, estensioni, locale, encoding, tablespace, ruolo proprietario, dipendenze esterne, cifratura, spazio e retention. Stabilire restore isolato e responsabile della decisione. Leggere [SAFETY](../docs/SAFETY.md). Credenziali tramite service file/pgpass, mai password nella URI. Verificare ultimo backup, integrità/manifest, WAL richiesto e catena di retention tramite lo strumento effettivo.

## Backup e restore logico

Esempio di dump custom di un database. `PGSERVICE` deve puntare a un ruolo autorizzato e a un host esplicitamente confermato:

```sh
export PGSERVICE=backup-source
pg_dump --format=custom --file="/secure/path/db.dump" --dbname="service=$PGSERVICE"
pg_restore --list "/secure/path/db.dump"
```

Il dump può contenere tutti i dati del database: conservarlo cifrato, con accesso e retention approvati. Per il ripristino, usare una destinazione isolata e confermata; creare prima un database vuoto compatibile:

```sh
export PGSERVICE=restore-isolated
createdb --maintenance-db="service=$PGSERVICE" restore_check
pg_restore --exit-on-error --no-owner --no-privileges \
  --dbname="service=$PGSERVICE dbname=restore_check" "/secure/path/db.dump"
```

Questo profilo isolato assegna gli oggetti al ruolo di restore ed esclude gli ACL: serve a verificare il recupero dei dati. Per verificare anche ownership e autorizzazioni, predisporre i ruoli sorgente e ripetere una prova dedicata senza quelle due opzioni. Con un archivio custom `--no-owner` va passato a `pg_restore`, non a `pg_dump`. `pg_dump` non include ruoli cluster-wide; gestire globals e dipendenze con procedura dedicata. Non ripristinare sopra una produzione per provare il backup.

## Backup fisico, archiviazione continua e PITR

Procedure dedicate: [PITR passo per passo](pitr.md), [Barman](barman.md), [pgBackRest](pgbackrest.md).

`pg_basebackup` produce un backup fisico dell'intero cluster e richiede connessione di replica, privilegi adeguati e capacità di WAL sender. Per esempio:

```sh
export PGSERVICE=physical-backup
pg_basebackup --dbname="service=$PGSERVICE" --pgdata="/secure/backup/cluster" \
  --format=plain --wal-method=stream --progress --manifest-checksums=SHA256
```

L'opzione manifest/checksum va verificata con il client della major. Non usare `--no-sync` per backup produttivi. Conservare base backup e sequenza WAL coerenti; per PITR dichiarare timestamp/timeline e fermare il recovery solo secondo il piano. I dettagli di `restore_command`, `recovery.signal` e `recovery_target_*` dipendono dalla major e dal layout: seguire il manuale di quella major in ambiente isolato.

Per produzione, adottare e testare una strategia gestita con [pgBackRest](https://pgbackrest.org/user-guide.html) o [Barman](https://docs.pgbarman.org/), includendo retention, cifratura, archiviazione, monitoraggio e restore regolari. Gli esempi di questo runbook non sostituiscono la configurazione di tali strumenti.

## Verifica di recupero e decisione

Su ambiente isolato verificare exit code, log, versione, completezza oggetti, estensioni, query di integrità applicativa, permessi, tempi reali e punto RPO. Confrontare RTO con obiettivo; un file presente o `pg_restore --list` non dimostra un recupero valido. Se il restore tocca un target contenente dati, fermarsi: la sovrascrittura è distruttiva e richiede approvazione e piano separato.

Successo: il servizio proprietario accetta il ripristino, controlli tecnici e applicativi passano e tempi/RPO sono registrati. Per rollback di una prova isolata, conservare evidenze poi rimuovere il target secondo la gestione ambienti. Per un restore in place, il rollback richiede una copia/snapshot e un piano specifico; non si annulla con SQL. Escalare se mancano segmenti WAL, backup o chiavi, se il manifest non corrisponde o se il punto di recupero è incerto.

Fonti: [backup e restore PostgreSQL](https://www.postgresql.org/docs/current/backup.html), [pg_basebackup](https://www.postgresql.org/docs/current/app-pgbasebackup.html), [restore da archive/PITR](https://www.postgresql.org/docs/current/continuous-archiving.html).
