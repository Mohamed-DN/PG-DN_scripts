# Verifica e limiti

Snapshot verificato il 18 ottobre 2026 su GitHub Actions ([run 39151437450](https://github.com/Mohamed-DN/PG-DN_scripts/actions/runs/39151437450)), commit [b746e4a](https://github.com/Mohamed-DN/PG-DN_scripts/commit/b746e4ac549a7a50c226da4a396ff65cb844a580). Le prove sono riproducibili con i comandi in [tests/README.md](../tests/README.md), su database effimeri isolati dagli ambienti esistenti.

## Script PostgreSQL

Tutti i **144 file SQL** sono stati eseguiti come amministratore e come `pg_monitor` dove consentito, sulle cinque major supportate. Il controllo HBA richiede superuser ed è esplicitamente escluso dal ruolo monitor. Le funzionalità assenti nelle versioni precedenti usano guardie: il passaggio della guardia non equivale all'esecuzione di una vista non disponibile.

| Server effettivo | File controllati | Esecuzione SQL | Prove comportamentali |
| :-- | --: | :-- | :-- |
| PostgreSQL 14.24 | 144 | PASS | 14 controlli PASS |
| PostgreSQL 15.19 | 144 | PASS | 14 controlli PASS |
| PostgreSQL 16.15 | 144 | PASS | 14 controlli PASS |
| PostgreSQL 17.11 | 144 | PASS | 14 controlli PASS |
| PostgreSQL 18.6 | 144 | PASS | 14 controlli PASS |

[Rapporto JSON della matrice](evidence/postgres-matrix.json) · [SHA-256 dei 144 file](evidence/curated-sha256.json). Gli hash registrati da ciascuna major coincidono con questo snapshot SQL.

Sono passati anche **12 test Python** su navigazione, modifica delle protezioni, scelta della home, proprietà delle risorse temporanee e integrità upstream. Il generatore è idempotente, i collegamenti locali sono validi e actionlint 1.7.12 non segnala errori nei workflow. Gitleaks 8.30.1, con regole predefinite e output redatto, ha segnalato due valori nel manifest SHA-256: entrambi sono stati verificati contro i byte SQL e sono hash di file, quindi falsi positivi. Non sono emerse credenziali dalla scansione. La revisione indipendente non ha rilevato problemi aperti nelle query e nella navigazione.

## Cosa provano i controlli comportamentali

- Estensioni opzionali installate in uno schema diverso da `public` e guardie quando assenti.
- Rifiuto di scritture nella transazione read-only e di DDL dal ruolo ristretto.
- Foreign key senza copertura d'indice, includendo casi positivi e negativi con chiavi invertite, indici parziali, colonne INCLUDE e prefissi intercalati.
- RLS con e senza policy, vincoli non validati, enum e domini, indici delle partizioni associati al figlio corretto.
- Headroom delle sequenze senza consumo di valori e identificatori quotati con punti e spazi.
- Dump logico custom e restore, con confronto di conteggio e checksum su 200 righe.
- Contesa reale, sessione bloccante e aggregazioni per bloccante e relazione.

I contatori cumulativi e gli indicatori di costo restano da interpretare su intervalli rappresentativi. Un risultato SQL valido non rende automatica una decisione di manutenzione.

## Backup fisico e replica streaming

La prova PostgreSQL **18.6** ha creato primary e standby isolati e verificato il backup fisico con `pg_verifybackup`. A replay sospeso, il ritardo osservato era **72.504 byte** e lo standby è rimasto a 20 righe. Dopo la ripresa, primary e standby sono convergenti a **120 righe**. Tutte le **24 query** in replica, WAL e ispezione backup sono passate anche sullo standby. La pulizia delle sole risorse del lab è riuscita.

[Rapporto JSON](evidence/physical-replication.json) · [Laboratorio riproducibile](REPLICATION_LAB.md). Questa prova dimostra backup fisico verificato e streaming; non dimostra PITR con archivio storico, promozione o failover.

## Limiti

Gli **226 file upstream** in otto raccolte sono riferimenti separati: i manifest ne verificano integrità e provenienza, ma non sono eseguiti né certificati dalla matrice SQL. La classificazione del rischio delle sorgenti esterne è euristica.

Le prove non simulano carico e dimensioni di produzione, sistemi cloud gestiti, tutte le estensioni o ogni combinazione di privilegi. I controlli statici non sono un parser SQL completo né una sandbox per codice arbitrario. Le procedure PITR, Barman e pgBackRest richiedono prove nel proprio ambiente. Non sono stati eseguiti comandi su database di produzione.
