# Sorgenti PostgreSQL esterne

Repository acquisiti il 2026-10-18 per consultazione. Le revisioni sono fissate nei manifest; verificare sul repository upstream prima di basarsi su eventuali aggiornamenti.

## Importati nel progetto

| Sorgente | Revisione | Licenza | Contenuto locale | File upstream | Rischio euristico |
|---|---|---|---|---:|---|
| [limdauto/pg-monitoring](https://github.com/limdauto/pg-monitoring) | `1cb18cbecc8d1f67ea1d3e8f141cbd4e012a1efe` | MIT | [`upstream/limdauto_pg_monitoring`](../upstream/limdauto_pg_monitoring/README.md) | 10 | R 7; NR 0; review 3 |
| [pgexperts/pgx_scripts](https://github.com/pgexperts/pgx_scripts) | `e4f312d37b5fcf8a9f18fe857cee00ece13a387d` | BSD-3-Clause (testo riportato nel LICENSE upstream) | [`upstream/pgexperts_pgx_scripts`](../upstream/pgexperts_pgx_scripts/README.md) | 26 | R 13; NR 3; review 10 |
| [dataegret/pg-utils](https://github.com/dataegret/pg-utils) | `0835aa25b815b0589cf66f88537bb7952fb50543` | Permesso custom nel LICENSE.md upstream | [`upstream/dataegret_pg_utils`](../upstream/dataegret_pg_utils/README.md) | 110 | R 58; NR 20; review 32 |
| [NikolayS/postgres_dba](https://github.com/NikolayS/postgres_dba) | `455c2f69aae37fc679c763f8de0952bdd5517a1b` | BSD-3-Clause | [`upstream/nikolays_postgres_dba`](../upstream/nikolays_postgres_dba/README.md) | 53 | R 21; NR 20; review 12 |

Le licenze originali sono preservate nei rispettivi alberi. Il manifest di ciascun vendor contiene URL permalink e SHA-256 per ogni file importato. Per Data Egret il permesso e custom e richiede di mantenere l'avviso di copyright; non e stato sostituito con un'etichetta SPDX.

## Solo clone locale, nessun codice redistribuito

| Sorgente | Revisione | Stato licenza | Clone locale | File tracciati | Indice di percorso e permalink |
|---|---|---|---|---:|---|
| [andyatkinson/pg_scripts](https://github.com/andyatkinson/pg_scripts) | `b7736708e0cfa5b8a3e88df8b1704a80b3566896` | Assente al commit acquisito; nessun permesso di ridistribuzione rilevato | `.work/upstream/pg_scripts` (escluso dal versionamento) | 99 | [`upstream/andyatkinson_pg_scripts/source_index.json`](../upstream/andyatkinson_pg_scripts/source_index.json) |
| [Azmodey/pg_dba_scripts](https://github.com/Azmodey/pg_dba_scripts) | `3ff7a9041e5a6a78a91bb222c962f76e30c1d3ab` | Assente al commit acquisito; nessun permesso di ridistribuzione rilevato | `.work/upstream/pg_dba_scripts` (escluso dal versionamento) | 16 | [`upstream/Azmodey_pg_dba_scripts/source_index.json`](../upstream/Azmodey_pg_dba_scripts/source_index.json) |

L'assenza di licenza non viene interpretata come permesso. I cloni locali sono stati scaricati solo per consultazione e i rispettivi sorgenti, README e media non sono stati copiati in `upstream/`.

## Altre candidate esaminate

Sono state esaminate anche le sorgenti citate dall'utente. `postgres-ai/postgres_dba` non e risultato individuabile come repository nel controllo GitHub; `NikolayS/postgres_dba` e invece una raccolta pubblica con 34 report diagnostici e licenza BSD 3-Clause, quindi e stato scelto. `dataegret/pg-utils`, `pgexperts/pgx_scripts` e `NikolayS/postgres_dba` sono le tre sorgenti aggiuntive selezionate.

[Audit e classificazione](UPSTREAM_AUDIT.md) | [Indice upstream nel repository](../upstream/README.md) | [Inventario macchina](../upstream/SOURCES.json)

I quattro README originali sono preservati come `README.upstream.md` e inclusi nei manifest con il percorso di origine; gli indici italiani non sostituiscono le attribuzioni upstream.
