# Research expansion: PostgreSQL upstream sources

Ricerca e acquisizione: 2026-10-18. I cloni di lavoro sono in `.work/upstream/new-*`; le copie selettive versionate sono sotto `_support/upstream/`. Ogni revisione e fissata a un commit e ogni file importato ha permalink e SHA-256 nel manifest della propria directory.

Tutti i file importati sono `review-required`: nessun file e certificato read-only e nessun codice e stato eseguito. I manifest includono licenze, eventuali notice e README upstream originali. Le quattro raccolte sono materiale di consultazione, escluse dallo smoke.

## Fonti selezionate

| Fonte / commit | Licenza | Copia selettiva | Casi pratici e destinazioni locali |
|---|---|---|---|
| [jobinau/pg_gather](https://github.com/jobinau/pg_gather), `fb0ed42a39a79ec0dcc13a497b31074fcc801a55` | PostgreSQL License, testo custom in `LICENSE.md` | [_support/upstream/jobinau_pg_gather](../upstream/jobinau_pg_gather/README.md), 6 file manifestati | Raccolta e analisi di configurazione/attivita tramite SQL e report: ispezione monitoring, `scripts/monitoring/activity`, `scripts/monitoring/statistics`. Non usarlo senza controllare privilegi richiesti e versione; l'upstream cita ruoli `pg_monitor`/superuser per alcuni dati. |
| [pgsty/pg_exporter](https://github.com/pgsty/pg_exporter), `72f00a4fa4e6eb7524174f2122b3fe1e1d608db4` | Apache-2.0 | [_support/upstream/pgsty_pg_exporter](../upstream/pgsty_pg_exporter/README.md), 8 collector YAML | Query/config per attivita, replica e slot, eta XID, vacuum, archiver e bloat: `scripts/monitoring/activity`, `scripts/monitoring/statistics`, `scripts/replication/physical`, `scripts/replication/slots`, `scripts/maintenance/vacuum`, `scripts/maintenance/bloat`. Il formato YAML e legato al collector pg_exporter; adattare e verificare versione e permessi prima di riusare le query. |
| [cybertec-postgresql/pgwatch2](https://github.com/cybertec-postgresql/pgwatch2), `0c009025367e8737544c1067b79fe36609670d10` | BSD-3-Clause | [_support/upstream/cybertec_pgwatch2](../upstream/cybertec_pgwatch2/README.md), 7 file manifestati (5 query) | Template per stat activity, replica, slot e statistiche di tabelle/indici: `scripts/monitoring/activity`, `scripts/replication/physical`, `scripts/replication/slots`, `scripts/performance/indexes`, `scripts/monitoring/statistics`. Repository archiviato upstream il 2024-12-17: conservarlo come riferimento storico e rivalidare tutte le query rispetto alle versioni PostgreSQL correnti. |
| [prometheus-community/postgres_exporter](https://github.com/prometheus-community/postgres_exporter), `5baef8f1b82b4520143ede48dedfcd58b31903f8` | Apache-2.0 | [_support/upstream/prometheus_postgres_exporter](../upstream/prometheus_postgres_exporter/README.md), `queries.yaml`, LICENSE, NOTICE e README | Query configurabili e indicazioni sui permessi per metriche di activity, database, replica e vacuum: `scripts/monitoring/activity`, `scripts/monitoring/statistics`, `scripts/replication/physical`, `scripts/maintenance/vacuum`. `queries.yaml` e configurazione dell'exporter, non un pacchetto SQL autonomo; le query vanno estratte/adattate con cautela. |

Le revisioni, la selezione esatta, gli hash, i percorsi originali e i permalink sono registrati nei quattro manifest. In particolare, i file `LICENSE`, `LICENSE.md`, `NOTICE` e i README originali sono inclusi nell'elenco manifestato, con byte upstream preservati.

Queste quattro acquisizioni sono distinte dalle analisi di Andy Atkinson, Azmodey e limdauto. Per quelle fonti, gli header delle query locali registrano i file upstream puntuali esaminati e la [revisione fonte→integrazione](SOURCE_REVIEW.md) elenca le implementazioni e i relativi limiti; i repository privi di licenza restano non redistribuiti.

## Candidati verificati ma non importati

- [CrunchyData/pgmonitor](https://github.com/CrunchyData/pgmonitor): il repository corrente mostra un avviso legale `All Rights Reserved` senza licenza chiara di ridistribuzione per i contenuti selezionati. Non copiato.
- `vonng/pgsql`: l'URL GitHub `https://github.com/vonng/pgsql` restituisce 404. Non trattato come fonte disponibile.

`pg_gather` dichiara una PostgreSQL License nel file upstream `LICENSE.md`; la selezione mantiene il testo integrale. `pgwatch2` ha una BSD-3-Clause e rimane utile come archivio di query, con la limitazione dello stato archived. Le due fonti Apache-2.0 includono i file di licenza originali; il repository Prometheus include anche `NOTICE`.
