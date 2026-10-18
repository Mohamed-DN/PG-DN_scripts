# limdauto/pg-monitoring - materiale upstream

Raccolta compatta di query per statistiche, attività, lock, I/O e dimensioni; orientata anche a time-series e dashboard.

- Fonte: [limdauto/pg-monitoring](https://github.com/limdauto/pg-monitoring)
- Revisione acquisita: `1cb18cbecc8d1f67ea1d3e8f141cbd4e012a1efe` (branch al clone: `master`)
- Licenza verificata: MIT - [testo originale](https://github.com/limdauto/pg-monitoring/blob/1cb18cbecc8d1f67ea1d3e8f141cbd4e012a1efe/LICENSE) e copia preservata nel repository
- Contenuto importato: albero tracciato; README root preservato come README.upstream.md; submodule non inizializzati esclusi
- File di origine importati: 10; dettagli, permalink e SHA-256 in [manifest.json](manifest.json)
- Rischio euristico: read-only 7, non-read-only 0, review-required 3

Questa raccolta e solo reference esterna: non e stata sottoposta a verifica funzionale o di sicurezza, non entra nello smoke e non va eseguita senza revisione. Gli script shell non sono stati eseguiti. Per i file classificati read-only, l'etichetta descrive solo le istruzioni testuali riconosciute e non garantisce l'assenza di effetti.

## File upstream importati

| File | Categoria preliminare |
|---|---|
| `activities/connections.sql` | [read-only](https://github.com/limdauto/pg-monitoring/blob/1cb18cbecc8d1f67ea1d3e8f141cbd4e012a1efe/activities/connections.sql) |
| `examples/collectd.conf` | [review-required](https://github.com/limdauto/pg-monitoring/blob/1cb18cbecc8d1f67ea1d3e8f141cbd4e012a1efe/examples/collectd.conf) |
| `imgs/demo.png` | [review-required](https://github.com/limdauto/pg-monitoring/blob/1cb18cbecc8d1f67ea1d3e8f141cbd4e012a1efe/imgs/demo.png) |
| `locks/connections.sql` | [read-only](https://github.com/limdauto/pg-monitoring/blob/1cb18cbecc8d1f67ea1d3e8f141cbd4e012a1efe/locks/connections.sql) |
| `locks/relations.sql` | [read-only](https://github.com/limdauto/pg-monitoring/blob/1cb18cbecc8d1f67ea1d3e8f141cbd4e012a1efe/locks/relations.sql) |
| `locks/statements.sql` | [read-only](https://github.com/limdauto/pg-monitoring/blob/1cb18cbecc8d1f67ea1d3e8f141cbd4e012a1efe/locks/statements.sql) |
| `tables/disk.sql` | [read-only](https://github.com/limdauto/pg-monitoring/blob/1cb18cbecc8d1f67ea1d3e8f141cbd4e012a1efe/tables/disk.sql) |
| `tables/io.sql` | [read-only](https://github.com/limdauto/pg-monitoring/blob/1cb18cbecc8d1f67ea1d3e8f141cbd4e012a1efe/tables/io.sql) |

## Documentazione e attribuzioni originali

Il [README upstream originale](README.upstream.md) è conservato senza modifiche, comprese le attribuzioni dei contributori. Questo README italiano è un indice locale.
