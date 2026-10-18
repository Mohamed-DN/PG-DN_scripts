# Contribuire

## Prima di proporre una modifica

Individua il runbook o la categoria in `scripts/` che possiede il caso d'uso. Controlla la versione minima supportata, i privilegi necessari, l'effetto della query e i riferimenti alla documentazione ufficiale della stessa major. Non inserire dati di produzione, dump, credenziali o identificativi sensibili.

## Requisiti per gli script

Aggiungi una query per file sotto `scripts/<categoria>/<funzione>/nome.sql`. Il catalogo e i README sono generati dagli header, senza una lista da mantenere a mano. Modello minimo:

```sql
-- Title: Database identity
-- Description: Identify the selected database before collecting evidence.
-- Postgres: 14+
-- Privilege: CONNECT
-- Risk: read-only
-- Source: original; https://www.postgresql.org/docs/18/functions-info.html
-- Runbook: procedures/triage.md
\set ON_ERROR_STOP on
\pset pager off
BEGIN READ ONLY;
SET LOCAL statement_timeout='15s';
SET LOCAL lock_timeout='2s';
SELECT pg_catalog.current_database();
COMMIT;
```

Esegui `python _support/tools/catalog.py`, `python _support/tools/validate.py` e `python -m unittest discover -s _support/tests -v`, quindi committa anche gli indici aggiornati. Il workflow sul ramo principale aggiorna automaticamente la navigazione se aggiungi un file direttamente da GitHub. Se `main` è protetto contro i push del bot, il manutentore deve applicare la generazione nella pull request; il fallimento del workflow resta visibile in Actions.

- In `scripts/` accettiamo solo diagnostica read-only. Un comando che modifica stato va nei runbook o in `_support/docs/reference/`, con intenzione esplicita, lock, impatto, prerequisiti, verifica, rollback e condizioni di arresto.
- Usa parametri o variabili `psql` per i valori; non concatenare input non attendibile in SQL.
- Non inserire password in URI, SQL, argomenti shell o output. Indicare `PGSERVICE`/`PGPASSFILE` o `.pgpass` con permessi restrittivi.
- Dichiara versione e privilegi richiesti, schema, database e interpretazione dei risultati.
- Annota le query con feature dipendenti da versione (ad esempio `pg_stat_io`, PostgreSQL 16+).
- Gli snapshot in `_support/upstream/` mantengono provenienza e licenza; non copiarli come strumenti curati senza revisione.

## Documentazione

Un runbook deve spiegare quando usarlo, precheck, raccolta di evidenze, interpretazione, azione circoscritta, risultato atteso, rollback/escalation e fonti. Usa `incident-template.md` per annotare un incidente. Se non hai verificato la procedura contro un server reale, presentala come procedura documentata e non come testata.

## Controlli prima della revisione

Rileggi i link Markdown e i blocchi SQL, controlla che le modifiche generate ricadano nelle directory previste, esegui i controlli pertinenti e annota versioni e limiti di ciò che è stato eseguito. Un esito statico non prova il comportamento live né l'intera matrice PostgreSQL.
