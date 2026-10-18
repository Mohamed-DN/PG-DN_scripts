# Audit documentale delle sorgenti upstream

## Ambito e limite

Le copie sotto `upstream/` sono reference esterne non verificate. Non sono incluse nello smoke del progetto, non sono state eseguite e non sono state sottoposte a revisione di sicurezza. In particolare, gli script shell non sono mai stati eseguiti. Questa pagina registra origine, revisione, conservazione della licenza e una classificazione testuale preliminare; non certifica sicurezza, correttezza o compatibilita.

## Conteggi per snapshot importato

Le categorie sono assegnate per singolo file dal manifest. `read-only` indica soltanto che la scansione non ha riconosciuto parole chiave mutanti nei file SQL; `non-read-only` segnala parole chiave SQL mutanti; `review-required` si applica a script, configurazioni, formati non classificati e chiamate a funzioni potenzialmente operative. Il risultato puo avere falsi positivi e falsi negativi, per esempio per SQL dinamico, funzioni, commenti, operatori shell o semantica implicita.

| Sorgente | Commit | File importati | Read-only (euristico) | Non-read-only | Review-required | Licenza |
|---|---|---:|---:|---:|---:|---|
| limdauto/pg-monitoring | `1cb18cbecc8d1f67ea1d3e8f141cbd4e012a1efe` | 10 | 7 | 0 | 3 | MIT |
| pgexperts/pgx_scripts | `e4f312d37b5fcf8a9f18fe857cee00ece13a387d` | 26 | 13 | 3 | 10 | BSD-3-Clause (testo riportato nel LICENSE upstream) |
| dataegret/pg-utils | `0835aa25b815b0589cf66f88537bb7952fb50543` | 110 | 58 | 20 | 32 | Permesso custom nel LICENSE.md upstream |
| NikolayS/postgres_dba | `455c2f69aae37fc679c763f8de0952bdd5517a1b` | 53 | 21 | 20 | 12 | BSD-3-Clause |
| **Totale** | - | **199** | **99** | **43** | **57** | - |

## Regole prima di un uso manuale

1. Aprire il README vendor e il manifest; verificare il permalink upstream alla revisione indicata.
2. Leggere il file completo e ogni dipendenza, concentrandosi su `CREATE`, `ALTER`, `DROP`, `GRANT`, `REVOKE`, DML, `VACUUM`, `REINDEX`, chiamate a funzioni operative, SQL dinamico e comandi shell.
3. Confermare major version, estensioni, schema, privilegi e impatto su produzione. Provare in un ambiente isolato con dati sacrificabili prima di considerare un uso reale.
4. Verificare separatamente la licenza del file e dei frammenti di terzi indicati dagli autori; la licenza repository non risolve diritti di terzi non chiariti.

Queste indicazioni non sostituiscono una revisione specifica del comando da eseguire. Nessun file non licenziato e stato importato: per `andyatkinson/pg_scripts` e `Azmodey/pg_dba_scripts` sono presenti solo gli indici di metadata, mentre i cloni restano sotto `.work/upstream/`.

## Manifest per sorgente

- [`limdauto/pg-monitoring`](../upstream/limdauto_pg_monitoring/manifest.json)
- [`pgexperts/pgx_scripts`](../upstream/pgexperts_pgx_scripts/manifest.json)
- [`dataegret/pg-utils`](../upstream/dataegret_pg_utils/manifest.json)
- [`NikolayS/postgres_dba`](../upstream/nikolays_postgres_dba/manifest.json)

Classificazione generata dalla scansione testuale del 2026-10-18; consultare i file `manifest.json` per la motivazione associata a ciascun file.

I quattro README originali sono preservati come `README.upstream.md` e inclusi nei manifest con il percorso di origine; gli indici italiani non sostituiscono le attribuzioni upstream.
