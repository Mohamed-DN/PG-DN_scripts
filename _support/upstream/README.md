# Materiale upstream PostgreSQL

Raccolta di riferimento esterna, acquisita a revisioni fissate. Non e stata verificata funzionalmente o sottoposta ad audit di sicurezza e non entra nello smoke del progetto. Gli script shell non sono stati eseguiti. Rivedere ogni file, versione PostgreSQL, privilegi ed effetti prima di usarlo. Le classi di rischio nel manifest sono euristiche testuali e non attestano sicurezza.

## Sorgenti importate con licenza verificata

- [limdauto/pg-monitoring](limdauto_pg_monitoring/README.md) - query statistiche, lock, attivita e I/O (MIT).
- [pgexperts/pgx_scripts](pgexperts_pgx_scripts/README.md) - bloat, indici, lock e utility DBA (BSD 3-Clause).
- [dataegret/pg-utils](dataegret_pg_utils/README.md) - raccolta ampia di query e utility (licenza custom permissiva, copyright conservato).
- [NikolayS/postgres_dba](nikolays_postgres_dba/README.md) - report diagnostici psql, licenza BSD 3-Clause.

## Solo indice, codice non ridistribuito

- [andyatkinson/pg_scripts](andyatkinson_pg_scripts/README.md)
- [Azmodey/pg_dba_scripts](Azmodey_pg_dba_scripts/README.md)

[SOURCES.json](SOURCES.json) contiene commit, licenze, inventari e permalink; ogni sorgente importata ha un `manifest.json` con SHA-256 per file.

## Osservabilità e monitoraggio

- [cybertec-postgresql/pgwatch2](cybertec_pgwatch2/README.md) — BSD-3-Clause
- [jobinau/pg_gather](jobinau_pg_gather/README.md) — PostgreSQL License (custom text in LICENSE.md; permissive, MIT-like)
- [pgsty/pg_exporter](pgsty_pg_exporter/README.md) — Apache-2.0
- [prometheus-community/postgres_exporter](prometheus_postgres_exporter/README.md) — Apache-2.0
