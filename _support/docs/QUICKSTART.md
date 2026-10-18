# Avvio rapido

Questo repository fornisce query e procedure per PostgreSQL 14–18; non installa né configura un server.

La riga `Postgres` nell'header di ciascuno script indica il range verificato. [Come leggere la compatibilità](COMPATIBILITY.md).

1. Verifica quale cluster, ambiente e database stai interrogando. Non dedurre il target dal nome del servizio.
2. Configura le credenziali fuori dal comando, preferibilmente tramite service file libpq e password file protetto.
3. Scegli un runbook da [procedures/README.md](../../procedures/README.md), quindi apri la categoria SQL collegata.
4. Inizia dalle query di osservazione. Raccogli stato iniziale e timestamp prima di qualsiasi intervento.
5. Se il runbook propone una modifica, verifica che i criteri di ingresso siano soddisfatti e che l'impatto sia accettato. Esegui un solo passo e controlla il risultato.

Esempio di connessione mediante service configurato in `~/.pg_service.conf` e `~/.pgpass`:

```sh
export PGSERVICE=prod-readonly
psql "service=$PGSERVICE" -X -v ON_ERROR_STOP=1 -c 'SELECT current_database(), current_user, version();'
```

Il service name è un esempio, non una configurazione fornita dal repository. In ambienti diversi da Unix, usare il percorso e le ACL equivalenti per i file libpq. Non inserire segreti nella URI o nella riga di comando.

Su Windows, il file di servizio libpq è `%APPDATA%\postgresql\.pg_service.conf` e il file password è `%APPDATA%\postgresql\pgpass.conf`. È possibile impostare esplicitamente `PGSERVICEFILE` e `PGPASSFILE` per scegliere altri percorsi; proteggerli con ACL che consentano l'accesso solo agli account necessari. [Percorsi libpq](https://www.postgresql.org/docs/18/libpq-pgservice.html).

```powershell
$env:PGSERVICE = 'prod-readonly'
psql -X -v ON_ERROR_STOP=1 -c 'SELECT current_database(), current_user, version();'
python _support/tools/pgdn.py list --search wal
python _support/tools/pgdn.py run scripts/administration/inventory/server-info.sql
```

Per i generatori serve Python 3.10+; `pgdn.py run` richiede `psql` nel PATH. Il runner non legge credenziali per mostrarle e non costruisce comandi attraverso una shell. Con il client diretto puoi eseguire `psql -X -v ON_ERROR_STOP=1 -f scripts/administration/inventory/server-info.sql`. Usa un client della stessa major del server, o verifica le funzionalità richieste nel manuale del client scelto.

Per contributi, vedere [CONTRIBUTING](CONTRIBUTING.md); per interventi con impatto, leggere [SAFETY](SAFETY.md). La documentazione non dichiara procedure testate su server live se tale verifica non è stata effettuata e registrata.
