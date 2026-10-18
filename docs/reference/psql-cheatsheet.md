# Promemoria psql

`psql` è il client a riga di comando PostgreSQL. Le righe che iniziano con `\` sono metacomandi del client; non sono comandi SQL inviati al server.

## Connessione e file

Preferire un servizio già configurato (`pg_service.conf`) o i parametri di connessione gestiti dall'ambiente. Evitare password dentro la command line, script o variabili d'ambiente visibili ad altri processi; usare il prompt sicuro quando serve autenticazione interattiva.

```text
psql -X --set=ON_ERROR_STOP=on --dbname="service=reporting"
```

`-X` ignora `.psqlrc`, così le impostazioni locali non cambiano il comportamento del comando. `ON_ERROR_STOP` fa terminare l'esecuzione di un file al primo errore SQL o di metacomando che segnala errore.

Per aprire una sessione interattiva con prompt password:

```text
psql -X -W -U app_role -d app_db
```

Per eseguire un file:

```text
psql -X --set=ON_ERROR_STOP=on --dbname="service=reporting" --file="scripts/monitoring/statistics/database-counters.sql"
```

Dentro la sessione, `\i path/file.sql` include un file dal percorso corrente; `\ir path/file.sql` risolve il percorso relativo rispetto al file che contiene il metacomando. `\o file` redirige l'output su un file: usare solo destinazioni approvate, perché l'output può contenere dati operativi.

## Metacomandi utili

| Comando | Uso |
| --- | --- |
| `\conninfo` | Mostra i dettagli della connessione corrente. |
| `\l` o `\list` | Elenca i database visibili. |
| `\dn` / `\dn+` | Elenca gli schemi, con dettagli aggiuntivi nella seconda forma. |
| `\dt` / `\dt schema.*` | Elenca tabelle visibili. |
| `\di` | Elenca indici visibili. |
| `\ds` | Elenca sequenze visibili. |
| `\dm` | Elenca viste materializzate visibili. |
| `\df` / `\df+` | Elenca funzioni; la forma estesa mostra più metadati. |
| `\du` / `\du+` | Elenca ruoli e attributi visibili. |
| `\db` | Elenca tablespace visibili. |
| `\d schema.tabella` | Descrive colonne, vincoli e indici di una relazione. |
| `\timing on` | Mostra il tempo impiegato dalle query successive. |
| `\pset pager off` | Disattiva il pager nell'output della sessione. |
| `\h GRANT` | Mostra la sintassi SQL di un comando server-side. |
| `\?` | Mostra la guida dei metacomandi `psql`. |
| `\q` | Esce da `psql`. |

La disponibilità dei metadati dipende dai privilegi e dalla versione del server. I metacomandi che stampano definizioni possono mostrare nomi o struttura applicativa: condividere l'output solo se appropriato.

## Variabili psql e quoting

Non interpolare mai variabili come testo SQL non quotato. Per una variabile usata come valore letterale si usa `:'nome'`; per un identificatore SQL si usa `:"nome"`. `psql` gestisce così apici e caratteri speciali secondo il contesto.

```text
\set schema_name reporting
\set table_name monthly_sales
SELECT :'schema_name' AS schema_label;
SELECT * FROM :"schema_name".:"table_name" LIMIT 10;
```

Per catturare una singola riga di risultato in variabili client si usa `\gset`:

```text
SELECT current_setting('server_version_num')::integer >= 160000 AS supports_pg_stat_io \gset
\if :supports_pg_stat_io
\echo pg_stat_io è disponibile
\else
\echo versione server non compatibile
\endif
```

Le condizioni di `\if` valutano un valore booleano (per esempio `true`, `false`, `1` o `0`), non un'espressione numerica arbitraria. La query che precede `\gset` deve restituire esattamente una riga. Per gestire identificatori scoperti a runtime, salvarli in una variabile con `\gset` e sostituirli con `:"variabile"`.

`\password [role]` apre il flusso interattivo per impostare una password senza scriverla nella cronologia SQL. Non copiare password in esempi, ticket o output.

Riferimenti ufficiali: [psql](https://www.postgresql.org/docs/current/app-psql.html), [libpq service files](https://www.postgresql.org/docs/current/libpq-pgservice.html).
