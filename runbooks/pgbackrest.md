# Backup e PITR con pgBackRest

Procedura basata sulla documentazione pgBackRest **2.59.3**. Prima di eseguire verificare la versione installata e consultare il relativo command reference; non assumere compatibilità automatica di opzioni/configurazione. PostgreSQL target: 14–18. Valori `<...>` e timestamp sono segnaposto che richiedono un change approvato.

## 1. Precheck e diagnostica

Eseguire come utente di servizio pgBackRest/PostgreSQL secondo l'installazione. Non passare segreti in command line: la configurazione deve usare il meccanismo di credenziali e cifratura già gestito.

```sh
export STANZA='sostituire-con-stanza-configurata'
pgbackrest version
pgbackrest --stanza="$STANZA" info
pgbackrest --stanza="$STANZA" info --output=json
```

Dopo aver identificato il backup set nell'output `info`:

```sh
export BACKUP_SET='incollare-il-set-verificato-dall-info'
pgbackrest --stanza="$STANZA" --set="$BACKUP_SET" info
pgbackrest --stanza="$STANZA" --set="$BACKUP_SET" --output=text verify
```

- Confermare che `version` coincida con la release di riferimento; usare `pgbackrest help <command>` per i flag accettati localmente.
- `info` riassume stato della stanza, backup, dimensioni e intervalli WAL. La vista JSON è preferibile per automazione stabile.
- `info --set` mostra dipendenze del set, database, tablespace e riferimenti necessari per restore.
- `verify --set` controlla i file del backup set e dell'archivio associato. Può leggere una quantità rilevante di dati e generare I/O: selezionare il set e pianificare capacità. La verifica non sostituisce il restore di prova.

Il comando `check` verifica la configurazione di stanza, repository e archiving, ma **non è una query read-only**: pgBackRest crea un restore point e richiede uno switch WAL per testare l'archivio. Eseguirlo solo nella finestra concordata con il DBA e dopo averne valutato l'effetto:

```sh
pgbackrest --stanza="$STANZA" --log-level-console=info check
```

## 2. Backup mirato

Prima verificare che la stanza punti al cluster corretto, repository, retention e archiving siano conformi, e spazio/I/O sufficienti. Un backup full esplicito è semplice da identificare, ma può caricare rete, CPU e storage:

```sh
pgbackrest --stanza=<STANZA> --type=full backup
pgbackrest --stanza=<STANZA> info
```

Per backup differenziali o incrementali seguire la policy già configurata (`diff`/`incr`) e conservarne la catena di dipendenze. Non eseguire `expire` in risposta a un allarme spazio senza change: può rimuovere backup e WAL necessari al PITR.

## 3. Selezionare il backup fisico

Annotare stanza, repository scelto, major/versione del cluster, `BACKUP_SET`, intervallo WAL, timeline, backup predecessori richiesti (per incremental), target UTC e spazio nella directory di restore. Il timestamp deve cadere nel periodo coperto dalla base e dalla retention archivio. Con più repository, decidere il repository esplicito e verificare quel repository; non lasciare che una selezione ambigua scelga una copia inattesa.

Se il comando `info --set` non mostra tutte le dipendenze o l'archivio non copre il target, fermarsi. Per timestamp prima dell'ultimo backup o per timeline complesse, seguire la regola di selezione `--set` descritta dal command reference 2.59.3 e verificare manualmente che il set possa fornire il target. In caso di dubbio passare a [pitr.md](pitr.md) e al proprietario backup.

## 4. Restore PITR in directory nuova e isolata

Eseguire da host target con configurazione pgBackRest in grado di accedere al repository. Impostare `PGDATA` a un percorso nuovo e vuoto e validarlo senza cancellare nulla. Rivedere tablespace e symlink dal dettaglio `info`; mappare tabelle fuori directory solo con percorsi nuovi e isolati. Esempio parametrizzato per la sintassi 2.59.3:

```sh
export REPO='sostituire-con-numero-repository-verificato'
export TARGET_UTC='2026-10-18 12:30:00+00'
export TARGET_TLI='sostituire-con-timeline-numerica-verificata'
export PGDATA='/srv/restore/INCIDENTE/CLUSTER-pitr' # sostituire con un percorso nuovo

: "${STANZA:?impostare STANZA}"
: "${BACKUP_SET:?impostare BACKUP_SET}"
: "${REPO:?impostare REPO}"
: "${TARGET_TLI:?impostare TARGET_TLI}"
: "${PGDATA:?impostare PGDATA}"
test ! -e "$PGDATA" || { echo "PGDATA esiste: stop" >&2; exit 1; }
install -d -o postgres -g postgres -m 0700 "$PGDATA"
find "$PGDATA" -mindepth 1 -maxdepth 1 -print -quit
```

Se il controllo stampa un contenuto o il target risulta symlink/alias del cluster attivo, fermarsi e scegliere un altro percorso. Poi ripristinare senza `--delta` e senza `--force`:

```sh
sudo -u postgres pgbackrest \
  --stanza="$STANZA" \
  --repo="$REPO" \
  --set="$BACKUP_SET" \
  --pg1-path="$PGDATA" \
  --type=time \
  --target="$TARGET_UTC" \
  --target-timeline="$TARGET_TLI" \
  --target-action=pause \
  --archive-mode=off \
  --log-level-console=info restore
```

La documentazione 2.59.3 indica che `--target` è necessario insieme a `--type=time`; `--target-timeline` fissa la timeline; `--target-action=pause` lascia il server in recovery per ispezione. `--pg1-path` dirige il restore nel percorso temporaneo (verificare la sintassi nella versione installata). pgBackRest scrive la configurazione di recovery in `postgresql.auto.conf` e non avvia il server: leggerla integralmente prima dello start, controllando `restore_command`, target, timeline e azione. Confermare che il segnale di recovery sia `recovery.signal` e non `standby.signal`.

Il default `--archive-mode=preserve` può ereditare l’archiviazione del primary: il clone usa esplicitamente **`--archive-mode=off`**. Controllare anche che `archive_mode=off` sia il valore effettivo prima dello start, compresi eventuali include o override. In particolare `archive_mode=always` può scrivere nell’archivio anche durante recovery. Il recupero tramite `archive-get` deve poter leggere i WAL, senza abilitarne l’invio dal clone.

Impostare `listen_addresses='127.0.0.1'`, porta dedicata e HBA/firewall isolati nella configurazione effettivamente letta. Non esporre ai client. Completare poi avvio, verifica del target, validazione business read-only e promozione solo con approvazione seguendo [pitr.md](pitr.md). Riattivare l’archiviazione soltanto per il nuovo primary autorizzato, con destinazione backup verificata e riavvio pianificato.

## 5. Interpretare errori e fermarsi in sicurezza

- **Nessun set che copre il target / WAL mancante:** non avviare o non promuovere; verificare repository, timeline, target timezone e retention col backup owner.
- **`recovery ended before configured recovery target was reached`:** target non dimostrato. Conservare log, fermare il clone, correggere selezione set/WAL/timeline e riprovare in un'altra directory nuova.
- **Errori di ownership, tablespace o path:** fermarsi; correggere il mapping sul solo clone, non sul cluster attivo.
- **Checksum o verify non riusciti:** trattare il backup come non valido e coinvolgere il DBA/backup owner. Non bypassare i controlli per arrivare alla promozione.

Non eliminare o modificare archivi e WAL, non usare `expire` per liberare spazio durante un incident e non usare `pg_resetwal`. Dopo la prova, fermare il clone e lasciare il cleanup al processo approvato di incident/retention; nessuna cancellazione automatica.

Fonti: [pgBackRest 2.59.3 User Guide](https://pgbackrest.org/user-guide.html), [Command Reference](https://pgbackrest.org/command.html), [PITR PostgreSQL 14](https://www.postgresql.org/docs/14/continuous-archiving.html), [PITR PostgreSQL 18](https://www.postgresql.org/docs/18/continuous-archiving.html).
