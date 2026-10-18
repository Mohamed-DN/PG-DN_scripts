# Sorgenti PostgreSQL esterne

Repository acquisiti il 2026-10-18 per consultazione. Le revisioni sono fissate nei manifest; verificare sul repository upstream prima di basarsi su eventuali aggiornamenti.

## Importati nel progetto

| Sorgente | Revisione | Licenza | Contenuto locale | File upstream | Rischio euristico |
|---|---|---|---|---:|---|
| [limdauto/pg-monitoring](https://github.com/limdauto/pg-monitoring) | `1cb18cbecc8d1f67ea1d3e8f141cbd4e012a1efe` | MIT | [`_support/upstream/limdauto_pg_monitoring`](../upstream/limdauto_pg_monitoring/README.md) | 10 | R 7; NR 0; review 3 |
| [pgexperts/pgx_scripts](https://github.com/pgexperts/pgx_scripts) | `e4f312d37b5fcf8a9f18fe857cee00ece13a387d` | BSD-3-Clause (testo riportato nel LICENSE upstream) | [`_support/upstream/pgexperts_pgx_scripts`](../upstream/pgexperts_pgx_scripts/README.md) | 26 | R 13; NR 3; review 10 |
| [dataegret/pg-utils](https://github.com/dataegret/pg-utils) | `0835aa25b815b0589cf66f88537bb7952fb50543` | Permesso custom nel LICENSE.md upstream | [`_support/upstream/dataegret_pg_utils`](../upstream/dataegret_pg_utils/README.md) | 110 | R 58; NR 20; review 32 |
| [NikolayS/postgres_dba](https://github.com/NikolayS/postgres_dba) | `455c2f69aae37fc679c763f8de0952bdd5517a1b` | BSD-3-Clause | [`_support/upstream/nikolays_postgres_dba`](../upstream/nikolays_postgres_dba/README.md) | 53 | R 21; NR 20; review 12 |

Le licenze originali sono preservate nei rispettivi alberi. Il manifest di ciascun vendor contiene URL permalink e SHA-256 per ogni file importato. Per Data Egret il permesso e custom e richiede di mantenere l'avviso di copyright; non e stato sostituito con un'etichetta SPDX.

## Clone per l'analisi, senza redistribuire codice upstream

| Sorgente | Revisione | Stato licenza | Clone locale | File tracciati | Indice di percorso e permalink |
|---|---|---|---|---:|---|
| [andyatkinson/pg_scripts](https://github.com/andyatkinson/pg_scripts) | `b7736708e0cfa5b8a3e88df8b1704a80b3566896` | Assente al commit acquisito; nessun permesso di ridistribuzione rilevato | `.work/upstream/pg_scripts` (escluso dal versionamento) | 99 | [`_support/upstream/andyatkinson_pg_scripts/source_index.json`](../upstream/andyatkinson_pg_scripts/source_index.json) |
| [Azmodey/pg_dba_scripts](https://github.com/Azmodey/pg_dba_scripts) | `3ff7a9041e5a6a78a91bb222c962f76e30c1d3ab` | Assente al commit acquisito; nessun permesso di ridistribuzione rilevato | `.work/upstream/pg_dba_scripts` (escluso dal versionamento) | 16 | [`_support/upstream/Azmodey_pg_dba_scripts/source_index.json`](../upstream/Azmodey_pg_dba_scripts/source_index.json) |

L'assenza di licenza non viene interpretata come permesso. I cloni locali sono stati scaricati solo per consultazione e i rispettivi sorgenti, README e media non sono stati copiati in `_support/upstream/`.

I contenuti sono stati comunque esaminati e hanno informato reimplementazioni indipendenti basate sui cataloghi PostgreSQL documentati: i commit senza licenza hanno generato 24 query locali riferite ad Andy Atkinson e 12 ad Azmodey; gli header puntano ai file upstream puntuali senza incorporarne i byte. Per la sorgente MIT di limdauto sono state adattate altre 2 query con avviso di copyright conservato. La mappa completa source→query e le decisioni di revisione sono in [SOURCE_REVIEW.md](SOURCE_REVIEW.md); i percorsi esatti sono anche documentati in [expansion-admin.md](expansion-admin.md).

## Altre candidate esaminate

Tra le altre candidate esaminate, `postgres-ai/postgres_dba` non è risultato individuabile come repository nel controllo GitHub. `NikolayS/postgres_dba` è invece una raccolta pubblica con 34 report diagnostici e licenza BSD 3-Clause; è stata selezionata insieme a `dataegret/pg-utils` e `pgexperts/pgx_scripts` per quella raccolta.

Le fonti acquisite nell'espansione successiva, con commit, licenze e file selezionati, sono descritte in [RESEARCH_EXPANSION.md](RESEARCH_EXPANSION.md).

[Audit e classificazione](UPSTREAM_AUDIT.md) | [Indice upstream nel repository](../upstream/README.md) | [Inventario macchina](../upstream/SOURCES.json)

I README originali sono preservati come `README.upstream.md` e inclusi nei manifest con il percorso di origine; gli indici italiani non sostituiscono le attribuzioni upstream.

## Sorgenti per osservabilità e monitoraggio

| Fonte | Revisione | Licenza | File |
| :-- | :-- | :-- | --: |
| [cybertec-postgresql/pgwatch2](https://github.com/cybertec-postgresql/pgwatch2) | 0c009025367e8737544c1067b79fe36609670d10 | BSD-3-Clause | 7 |
| [jobinau/pg_gather](https://github.com/jobinau/pg_gather) | fb0ed42a39a79ec0dcc13a497b31074fcc801a55 | PostgreSQL License (custom text in LICENSE.md; permissive, MIT-like) | 6 |
| [pgsty/pg_exporter](https://github.com/pgsty/pg_exporter) | 72f00a4fa4e6eb7524174f2122b3fe1e1d608db4 | Apache-2.0 | 10 |
| [prometheus-community/postgres_exporter](https://github.com/prometheus-community/postgres_exporter) | 5baef8f1b82b4520143ede48dedfcd58b31903f8 | Apache-2.0 | 4 |

Tutti i 27 file di queste selezioni sono riferimenti da revisionare. Licenze, README originali ed eventuali NOTICE sono preservati nei manifest. Il totale delle otto selezioni licenziate è di 226 file.
