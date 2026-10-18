# Piano di verifica delle query

[← Supporto](../README.md) · [Esecuzione dei test](../tests/README.md) · [Risultati](VALIDATION.md)

La verifica riguarda tutti i file SQL della libreria operativa `scripts/`, nelle major dichiarate dai singoli header. Gli originali in `_support/upstream/` sono riferimenti esterni con requisiti propri: non ereditano l'esito dei test della libreria curata.

## Ambiente riproducibile

La matrice crea cluster PostgreSQL 14–18 indipendenti, senza rete esterna, porte host o mount di directory esistenti. Ogni container riceve un nome casuale e un'etichetta proprietario; la pulizia verifica tale etichetta. Il test fisico usa una rete interna separata e volumi nuovi per primary e standby.

Lo schema sintetico `pgdn_fixture` comprende dati, primary/foreign key, indici ordinari/parziali/INCLUDE, partizioni, viste e materialized view, enum, domini, sequenze crescenti e decrescenti, trigger e funzioni. Le estensioni opzionali risiedono nello schema `extensions`, così la ricerca non può presumere `public`.

La fixture estesa aggiunge TOAST effettivamente allocato, un indice invalido prodotto da una vera build unica fallita, indici con firme uguali e predicati diversi, ACL e default privilege, ruoli con e senza privilegi, una subscription disabilitata e metadati FDW senza connessioni esterne. I valori canary controllano che le query di metadati non espongano le opzioni di connessione.

## Livelli di evidenza

| Livello | Cosa prova |
| :-- | :-- |
| Esecuzione amministrativa | Lo script termina con `ON_ERROR_STOP` nella major disponibile. |
| Ruolo `pg_monitor` | L'esecuzione riesce con privilegi ridotti, oppure la negazione attesa è verificata esplicitamente per la vista HBA. |
| Guardia di versione | Su una major precedente, il messaggio di esclusione è presente; la SELECT non è dichiarata eseguita. |
| Risultato su fixture | Oggetti, relazioni, privilegi e calcoli corrispondono ai dati noti. I casi negativi devono essere esclusi. |
| Processo reale | La diagnosi individua PID e stato di un'operazione effettivamente in corso nel lab. |
| Mutazione controllata | Una copia della query degli indici, privata del confronto dei predicati, produce il falso positivo che l'oracolo deve rilevare. Il file operativo resta invariato. |

Un output non vuoto non dimostra da solo la correttezza. `admin_result_lines` e `pg_monitor_result_lines` contano righe di evidenza testuale, non righe SQL: per esempio il testo di uno statement può contenere ritorni a capo. Il campo `scenario_assertions` elenca le verifiche di risultato effettivamente associate a ciascun file.

## Scenari attivi

- Transazione idle con snapshot trattenuto, sessione attiva e advisory lock, osservati da connessioni distinte.
- Contesa reale su una tabella e aggregazione dei bloccanti.
- `COPY FROM STDIN` in attesa di dati e build concorrente di un indice in attesa di un writer.
- `ANALYZE` e `VACUUM` reali, rallentati soltanto nel lab con cost delay per osservarne l'avanzamento.
- `CLUSTER` reale con rebuild di un indice su una funzione deterministica rallentata artificialmente.
- Chiamata effettiva all'API di backup della major e query realmente attiva da oltre un minuto.

I processi usati per osservare l'avanzamento sono cancellati e chiusi dopo il controllo. Questo prova la diagnostica dello stato attivo, non il completamento della manutenzione o la consistenza di un backup. Quest'ultima viene verificata separatamente con `pg_basebackup` e `pg_verifybackup` nel laboratorio fisico.

## Limiti da conservare nei risultati

Il report deve distinguere esecuzioni, guardie, negazioni attese e verifiche semantiche. Una vista che legittimamente non ha righe nel lab non equivale a uno scenario positivo provato. Carico di produzione, recovery point-in-time, backup manager e configurazioni esterne richiedono laboratori dedicati; nessun risultato di questa matrice li certifica automaticamente.
