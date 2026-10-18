# Verifica e limiti

Raccolta verificata il 18 ottobre 2026. Le prove sono riproducibili con i comandi in [tests/README.md](../tests/README.md), su database effimeri senza accesso agli stack esistenti.

## Stato della verifica

La matrice finale esegue tutti i **68 file SQL** come amministratore e come `pg_monitor` dove consentito. Le viste assenti sulle major precedenti sono gestite da guardie esplicite; il controllo HBA richiede superuser e non è eseguito con `pg_monitor`.

| Server effettivo | File controllati | Risultato | Prove comportamentali |
| :-- | --: | :-- | :-- |
| PostgreSQL 14.24 | 68 | PASS, incluse guardie di versione | Permessi, estensioni, lock, dump/restore |
| PostgreSQL 15.19 | 68 | PASS, incluse guardie di versione | Permessi, estensioni, lock, dump/restore |
| PostgreSQL 16.15 | 68 | PASS, inclusa guardia checkpointer | Permessi, estensioni, lock, dump/restore |
| PostgreSQL 17.11 | 68 | PASS | Permessi, estensioni, lock, dump/restore |
| PostgreSQL 18.6 | 68 | PASS | Permessi, estensioni, lock, dump/restore |

[Rapporto JSON della matrice](evidence/postgres-matrix.json) e [hash dello snapshot SQL](evidence/curated-sha256.json). Gli otto test Python di navigazione, mutazione dei comandi di protezione, proprietà dei container e integrità upstream sono passati. La revisione indipendente è stata eseguita con **Sol 6.1 High**; i worker hanno usato **Luna High**.

## Backup fisico e replica streaming

La prova PostgreSQL **18.6** ha creato primary e standby isolati, senza porte host pubblicate, e verificato il backup fisico con `pg_verifybackup`. Dopo la sospensione del replay, il ritardo osservato è stato di **72.504 byte** e lo standby è rimasto a 20 righe; dopo la ripresa ha raggiunto le **120 righe** del primary. Sei query curate di replica/slot/retention sono passate anche sullo standby. La rimozione delle sole risorse del lab è riuscita.

[Rapporto JSON](evidence/physical-replication.json) · [Procedura riproducibile](REPLICATION_LAB.md). Questo dimostra backup fisico e streaming; il PITR con archivio storico resta una procedura documentata, da provare separatamente.

I workflow sono stati controllati con actionlint 1.7.12. La scansione del contenuto testuale staged con Gitleaks 8.30.1, output redatto e regole predefinite, non ha trovato segreti; non equivale a una prova matematica della loro assenza.

## Cosa controllano le prove

- Header e convenzioni degli script curati, timeout, transazioni read-only e collegamenti alla documentazione.
- Navigazione dopo aggiunta, spostamento e cancellazione di uno script; idempotenza e modalità `--check` senza scritture.
- Mutazione dei comandi di protezione in commenti: il controllo deve fallire; rifiuto di funzioni amministrative che modificano stato.
- Integrità SHA-256 dei file esterni, commit fissati e licenze conservate; i quattro README originali mantengono le attribuzioni.
- Esecuzione delle query con `ON_ERROR_STOP`, ruolo amministrativo e `pg_monitor` dove consentito; guardie sulle major precedenti alla disponibilità delle viste.
- `pg_stat_statements` e `pg_buffercache` installate nello schema `extensions`; prova separata con estensioni assenti.
- Fixture con dati, indici e slot; rifiuto delle scritture in una transazione read-only e del DDL del ruolo ristretto.
- Dump logico custom e restore in database vuoto, con confronto di conteggio e checksum applicativo su 200 righe.
- Contesa reale su una tabella, individuata dalla query curata sui bloccanti.

## Limiti espliciti

Gli snapshot in `upstream/` non sono eseguiti né certificati dal test delle query curate. La classificazione di rischio esterna è euristica. I controlli statici sono convenzioni e rilevamenti mirati, non un parser SQL completo né una sandbox per codice arbitrario.

Le prove non simulano dimensioni e carico di produzione, sistemi gestiti cloud, tutte le estensioni o ogni combinazione di autorizzazioni. I runbook PITR, Barman e pgBackRest richiedono una prova nel proprio ambiente: nessun esito del dump logico dimostra un PITR riuscito. Non sono stati eseguiti comandi su database di produzione.
