![PG-DN · PostgreSQL Operations Library](_support/docs/assets/banner.svg)

# PG-DN scripts

[![Verifica degli script](https://github.com/Mohamed-DN/PG-DN_scripts/actions/workflows/validate.yml/badge.svg)](https://github.com/Mohamed-DN/PG-DN_scripts/actions/workflows/validate.yml)
[![Indici automatici](https://github.com/Mohamed-DN/PG-DN_scripts/actions/workflows/navigation.yml/badge.svg)](https://github.com/Mohamed-DN/PG-DN_scripts/actions/workflows/navigation.yml)

Script e procedure PostgreSQL per amministrazione, monitoraggio e risoluzione dei problemi.

<!-- BEGIN GENERATED COUNTS -->
**144 script curati** · PostgreSQL 14–18
<!-- END GENERATED COUNTS -->

| Vai a | Cosa trovi |
| :-- | :-- |
| **[📂 Script](scripts/README.md)** | Query ordinate per categoria e funzione, con scopo, versione, privilegi e procedura collegata. |
| **[🧭 Procedure](procedures/README.md)** | Percorsi passo per passo: controllo iniziale, script da eseguire, lettura dei risultati, intervento e verifica. |

Per iniziare: scegli una procedura se hai un problema da risolvere, oppure una categoria se sai già quale controllo ti serve. Apri lo script collegato, leggi versione e privilegi, poi segui le indicazioni per interpretare il risultato.

## Script

Apri la categoria che ti serve. Ogni cartella contiene un indice con i link ai singoli file SQL.

<!-- BEGIN GENERATED MAP -->
```text
scripts/
|
+-- 🟦 administration/                                ← 31 script · Istanza, configurazione, connessioni e cataloghi
|   +-- configuration/                               ← 4 script · Parametri effettivi, capacità e impostazioni operative
|   +-- connections/                                 ← 6 script · Sessioni, transazioni e occupazione connessioni
|   +-- inventory/                                   ← 21 script · Oggetti, vincoli, tipi, partizioni e dipendenze
+-- 🟩 backup/                                        ← 4 script · Diagnosi backup fisico e stato recovery
|   +-- inspection/                                  ← 4 script · Identità cluster, recovery e attività di base backup
+-- 🟧 maintenance/                                   ← 17 script · Vacuum, freeze, spazio e avanzamento operazioni
|   +-- bloat/                                       ← 2 script · Dimensioni heap, indici e TOAST; indicatori da verificare
|   +-- progress/                                    ← 6 script · Progresso VACUUM, ANALYZE, COPY, CLUSTER e indici
|   +-- vacuum/                                      ← 9 script · Tuple morte, transazioni lunghe, XID e autovacuum
+-- 🟪 monitoring/                                    ← 26 script · Controlli quotidiani, attività e trend operativi
|   +-- activity/                                    ← 8 script · Attese, blocchi, transazioni e connessioni SSL
|   +-- capacity/                                    ← 2 script · Dimensioni, crescita e spazio allocato
|   +-- statistics/                                  ← 16 script · Contatori database, cache, SLRU e checkpoint
+-- 🟨 performance/                                   ← 29 script · Query, indici, statistiche del planner e I/O
|   +-- indexes/                                     ← 12 script · Indici, vincoli, FK, utilizzo e candidati da analizzare
|   +-- io/                                          ← 6 script · Letture, scritture, timing e buffer cache
|   +-- queries/                                     ← 3 script · Top SQL, tempi e file temporanei
|   +-- statistics/                                  ← 8 script · Distribuzione dati, partizioni, HOT e sequenze
+-- 🔷 replication/                                   ← 14 script · Replica fisica/logica, consumer e retention
|   +-- logical/                                     ← 5 script · Publication, subscription e sincronizzazione tabelle
|   +-- physical/                                    ← 5 script · Sender, receiver, replay e conflitti dello standby
|   +-- slots/                                       ← 4 script · Slot, xmin, WAL trattenuti e margine di retention
+-- 🟥 security/                                      ← 17 script · Ruoli, accessi, ACL e row-level security
|   +-- privileges/                                  ← 11 script · Grant, privilegi effettivi, RLS e regole di accesso
|   +-- roles/                                       ← 6 script · Membership, ereditarietà e attributi dei ruoli
+-- 🔶 wal/                                           ← 6 script · Generazione WAL, archiviazione e checkpoint
    +-- archive/                                     ← 2 script · Archiver, fallimenti e marker pronti da archiviare
    +-- retention/                                   ← 4 script · Contatori, segmenti e cause della crescita WAL
```
<!-- END GENERATED MAP -->

<details>
<summary>Espandi l'albero completo con tutti gli script</summary>

<!-- BEGIN GENERATED TREE -->
```text
scripts/
|
+-- 🟦 administration/                                ← 31 script · Istanza, configurazione, connessioni e cataloghi
|   +-- configuration/                               ← 4 script · Parametri effettivi, capacità e impostazioni operative
|   |   +-- connection-capacity.sql                  ← Connection capacity
|   |   +-- non-default-settings.sql                 ← Non-default settings
|   |   +-- vacuum-settings.sql                      ← Vacuum and autovacuum settings
|   |   +-- wal-settings.sql                         ← WAL and checkpoint settings
|   +-- connections/                                 ← 6 script · Sessioni, transazioni e occupazione connessioni
|   |   +-- active.sql                               ← Active sessions
|   |   +-- backend-detail.sql                       ← Backend session detail
|   |   +-- by-state.sql                             ← Connections by state
|   |   +-- idle-in-transaction.sql                  ← Idle transactions
|   |   +-- oldest-backend-transactions.sql          ← Oldest active backend transactions
|   |   +-- xid-holding-backends.sql                 ← Sessions holding old transaction horizons
|   +-- inventory/                                   ← 21 script · Oggetti, vincoli, tipi, partizioni e dipendenze
|       +-- collation-versions.sql                   ← Collation provider and recorded versions
|       +-- columns.sql                              ← Column definitions inventory
|       +-- constraints.sql                          ← Constraint inventory
|       +-- databases.sql                            ← Database inventory
|       +-- extensions-dependencies.sql              ← Extension-owned object dependencies
|       +-- extensions.sql                           ← Installed extensions
|       +-- fdw-metadata.sql                         ← Foreign data wrapper metadata
|       +-- largest-relations.sql                    ← Largest relations
|       +-- materialized-views.sql                   ← Materialized view inventory
|       +-- object-dependencies.sql                  ← Direct object dependencies
|       +-- ownership.sql                            ← Application object ownership
|       +-- partition-tree.sql                       ← Partition hierarchy
|       +-- relations-detailed.sql                   ← Relation inventory with storage and state
|       +-- routines.sql                             ← Routine inventory
|       +-- schemas.sql                              ← Schema inventory
|       +-- sequences.sql                            ← Sequence inventory
|       +-- server-info.sql                          ← Server identity
|       +-- triggers.sql                             ← Trigger inventory
|       +-- types-enums-domains.sql                  ← Enum and domain type inventory
|       +-- unvalidated-constraints.sql              ← Unvalidated constraints
|       +-- views-and-definitions.sql                ← View inventory with options
+-- 🟩 backup/                                        ← 4 script · Diagnosi backup fisico e stato recovery
|   +-- inspection/                                  ← 4 script · Identità cluster, recovery e attività di base backup
|       +-- active-backup-senders.sql                ← Active backup senders
|       +-- backup-api-activity.sql                  ← Backup API activity
|       +-- basebackup-progress.sql                  ← Base backup progress
|       +-- recovery-state.sql                       ← Recovery state
+-- 🟧 maintenance/                                   ← 17 script · Vacuum, freeze, spazio e avanzamento operazioni
|   +-- bloat/                                       ← 2 script · Dimensioni heap, indici e TOAST; indicatori da verificare
|   |   +-- relation-size-breakdown.sql              ← Relation size breakdown
|   |   +-- toast-breakdown.sql                      ← TOAST storage breakdown
|   +-- progress/                                    ← 6 script · Progresso VACUUM, ANALYZE, COPY, CLUSTER e indici
|   |   +-- analyze.sql                              ← Analyze progress
|   |   +-- cluster-rewrite.sql                      ← CLUSTER and rewrite progress
|   |   +-- copy.sql                                 ← COPY progress
|   |   +-- create-index.sql                         ← Index build progress
|   |   +-- index-build.sql                          ← Index build progress detail
|   |   +-- vacuum.sql                               ← Vacuum progress
|   +-- vacuum/                                      ← 9 script · Tuple morte, transazioni lunghe, XID e autovacuum
|       +-- dead-tuples.sql                          ← Dead tuple estimates
|       +-- hot-update-ratio.sql                     ← HOT update ratio
|       +-- oldest-transactions.sql                  ← Old transactions
|       +-- per-table-autovacuum-overrides.sql       ← Per-table autovacuum overrides
|       +-- table-freeze-age.sql                     ← Table freeze age
|       +-- table-multixact-age.sql                  ← Table multixact age
|       +-- toast-storage-share.sql                  ← TOAST storage candidates
|       +-- vacuum-history.sql                       ← Per-table vacuum history
|       +-- wraparound-risk.sql                      ← Transaction and multixact age
+-- 🟪 monitoring/                                    ← 26 script · Controlli quotidiani, attività e trend operativi
|   +-- activity/                                    ← 8 script · Attese, blocchi, transazioni e connessioni SSL
|   |   +-- advisory-locks.sql                       ← Advisory lock summary
|   |   +-- blocking-impact.sql                      ← Blocking impact by backend
|   |   +-- blocking-sessions.sql                    ← Blocking sessions
|   |   +-- long-running.sql                         ← Long-running queries
|   |   +-- prepared-transactions.sql                ← Prepared transactions
|   |   +-- ssl-connections.sql                      ← SSL connection summary
|   |   +-- wait-summary.sql                         ← Wait event summary
|   |   +-- waiting-locks-by-relation.sql            ← Waiting locks by relation
|   +-- capacity/                                    ← 2 script · Dimensioni, crescita e spazio allocato
|   |   +-- database-sizes.sql                       ← Database sizes
|   |   +-- tablespace-inventory.sql                 ← Tablespace inventory
|   +-- statistics/                                  ← 16 script · Contatori database, cache, SLRU e checkpoint
|       +-- checkpointer-activity.sql                ← Checkpointer activity counters
|       +-- checkpointer.sql                         ← Checkpointer counters
|       +-- database-age.sql                         ← Database transaction ID age
|       +-- database-cache-hit.sql                   ← Database shared-buffer hit ratio
|       +-- database-counters.sql                    ← Database counters
|       +-- database-transaction-ratio.sql           ← Database commit and rollback ratio
|       +-- database-work-counters.sql               ← Database workload counters
|       +-- deadlocks-and-conflicts.sql              ← Deadlocks and standby conflicts
|       +-- io-by-backend.sql                        ← I/O statistics by backend
|       +-- relation-block-io.sql                    ← Relation block I/O counters
|       +-- reset-times.sql                          ← Statistics reset times
|       +-- slru-counters.sql                        ← SLRU activity counters
|       +-- table-activity.sql                       ← Table activity
|       +-- table-hot-updates.sql                    ← Table HOT update ratios
|       +-- table-statistics-coverage.sql            ← Table statistics coverage
|       +-- temporary-files.sql                      ← Temporary file counters by database
+-- 🟨 performance/                                   ← 29 script · Query, indici, statistiche del planner e I/O
|   +-- indexes/                                     ← 12 script · Indici, vincoli, FK, utilizzo e candidati da analizzare
|   |   +-- access-methods.sql                       ← Index access methods
|   |   +-- constraint-index-signatures.sql          ← Constraint index signatures
|   |   +-- definitions.sql                          ← Index definitions
|   |   +-- duplicate-candidates.sql                 ← Duplicate index candidates
|   |   +-- foreign-keys-without-index.sql           ← Foreign keys without leading index
|   |   +-- index-usage-context.sql                  ← Index usage counter context
|   |   +-- index-validity-state.sql                 ← Index validity state
|   |   +-- invalid-indexes.sql                      ← Invalid indexes
|   |   +-- key-included-columns.sql                 ← Index keys and included columns
|   |   +-- unused-candidates.sql                    ← Unused index candidates
|   |   +-- usage-by-table.sql                       ← Index usage by table
|   |   +-- write-pressure.sql                       ← Index write pressure context
|   +-- io/                                          ← 6 script · Letture, scritture, timing e buffer cache
|   |   +-- buffercache-summary.sql                  ← Buffer cache summary
|   |   +-- checkpoint-settings-context.sql          ← Checkpoint setting context
|   |   +-- database-io-timing.sql                   ← Database I/O timing
|   |   +-- database-temp-files.sql                  ← Database temporary file counters
|   |   +-- io-wait-snapshot.sql                     ← Current I/O wait snapshot
|   |   +-- pg-stat-io.sql                           ← I/O by backend and context
|   +-- queries/                                     ← 3 script · Top SQL, tempi e file temporanei
|   |   +-- top-mean-time.sql                        ← Statements by mean time
|   |   +-- top-temp-blocks.sql                      ← Statements by temporary blocks
|   |   +-- top-total-time.sql                       ← Statements by total time
|   +-- statistics/                                  ← 8 script · Distribuzione dati, partizioni, HOT e sequenze
|       +-- analyze-freshness.sql                    ← Analyze freshness
|       +-- column-skew-metadata.sql                 ← Column skew metadata
|       +-- null-fractions.sql                       ← Column null fraction metadata
|       +-- partition-hierarchy.sql                  ← Partition hierarchy
|       +-- partition-index-attachments.sql          ← Partition index attachments
|       +-- physical-correlation.sql                 ← Column physical correlation
|       +-- sequence-context.sql                     ← Sequence inventory context
|       +-- sequence-headroom.sql                    ← Sequence exhaustion headroom
+-- 🔷 replication/                                   ← 14 script · Replica fisica/logica, consumer e retention
|   +-- logical/                                     ← 5 script · Publication, subscription e sincronizzazione tabelle
|   |   +-- publication-tables.sql                   ← Logical publication table mapping
|   |   +-- publications.sql                         ← Logical publication configuration
|   |   +-- subscriptions.sql                        ← Logical subscriptions
|   |   +-- table-sync-state.sql                     ← Logical table synchronization state
|   |   +-- workers.sql                              ← Logical replication workers
|   +-- physical/                                    ← 5 script · Sender, receiver, replay e conflitti dello standby
|   |   +-- primary-senders.sql                      ← Physical replication senders
|   |   +-- standby-conflicts.sql                    ← Standby recovery conflicts
|   |   +-- standby-receiver-health.sql              ← Standby receiver health
|   |   +-- standby-receiver.sql                     ← Standby WAL receiver
|   |   +-- standby-replay.sql                       ← Standby replay status
|   +-- slots/                                       ← 4 script · Slot, xmin, WAL trattenuti e margine di retention
|       +-- logical-stats.sql                        ← Logical slot counters
|       +-- retention.sql                            ← Replication slot retention
|       +-- wal-limit-headroom.sql                   ← Replication slot WAL limit headroom
|       +-- xmin-horizons.sql                        ← Replication slot xmin horizons
+-- 🟥 security/                                      ← 17 script · Ruoli, accessi, ACL e row-level security
|   +-- privileges/                                  ← 11 script · Grant, privilegi effettivi, RLS e regole di accesso
|   |   +-- database-acl.sql                         ← Database ACL
|   |   +-- effective-database-privileges.sql        ← Effective database privileges for roles
|   |   +-- hba-rule-health.sql                      ← HBA rule health
|   |   +-- public-schema-grants.sql                 ← PUBLIC schema and relation grants
|   |   +-- relation-acl.sql                         ← Relation ACL
|   |   +-- rls-enabled-without-policy.sql           ← RLS-enabled relations without visible policies
|   |   +-- rls-policies.sql                         ← Row-level security policy inventory
|   |   +-- routine-execute-grants.sql               ← Routine EXECUTE grants
|   |   +-- routine-security-definer.sql             ← SECURITY DEFINER routine inventory
|   |   +-- schema-acl.sql                           ← Schema ACL
|   |   +-- schema-effective-privileges.sql          ← Effective schema privileges
|   +-- roles/                                       ← 6 script · Membership, ereditarietà e attributi dei ruoli
|       +-- default-acl.sql                          ← Default privileges inventory
|       +-- expiring-logins.sql                      ← Expiring login roles
|       +-- membership.sql                           ← Role memberships
|       +-- role-attributes.sql                      ← Role security attributes
|       +-- role-inventory.sql                       ← Role inventory
|       +-- role-membership-edges.sql                ← Role membership edges with portable attributes
+-- 🔶 wal/                                           ← 6 script · Generazione WAL, archiviazione e checkpoint
    +-- archive/                                     ← 2 script · Archiver, fallimenti e marker pronti da archiviare
    |   +-- archive-status.sql                       ← Archive status
    |   +-- ready-files.sql                          ← Ready WAL archive files
    +-- retention/                                   ← 4 script · Contatori, segmenti e cause della crescita WAL
        +-- checkpoint-counters-common.sql           ← Checkpoint counters
        +-- retention-context.sql                    ← WAL retention context
        +-- wal-counters.sql                         ← WAL counters
        +-- wal-directory-dimensions.sql             ← WAL directory dimensions
```
<!-- END GENERATED TREE -->

</details>

## Procedure

Parti da [triage](procedures/triage.md) se la causa non è chiara, oppure scegli una procedura nell'[indice](procedures/README.md). Ogni percorso indica quali script usare e come proseguire in base al risultato.

<!-- BEGIN GENERATED PROCEDURES -->
```text
procedures/
|
+-- backup-restore.md                  ← Backup, restore e PITR
+-- barman.md                          ← Backup e PITR con Barman
+-- daily-health-check.md              ← Controllo giornaliero PostgreSQL
+-- incident-template.md               ← Scheda incidente PostgreSQL
+-- locks.md                           ← Diagnosi dei lock
+-- monitoring.md                      ← Baseline e monitoraggio PostgreSQL
+-- pgbackrest.md                      ← Backup e PITR con pgBackRest
+-- pitr.md                            ← PITR fisico su istanza isolata
+-- replication-lag.md                 ← Ritardo di replica fisica e logica
+-- security.md                        ← Diagnosi ruoli, privilegi e autenticazione
+-- slow-queries.md                    ← Diagnosi query lente
+-- triage.md                          ← Triage iniziale PostgreSQL
+-- vacuum-bloat.md                    ← Autovacuum, VACUUM e bloat
+-- wal-growth.md                      ← Crescita di WAL e ritardo archivio
```
<!-- END GENERATED PROCEDURES -->

## Esegui uno script

Configura la connessione `psql`, leggi scopo, versione e privilegi nell'header del file, quindi esegui dalla radice del repository:

```console
psql -X -v ON_ERROR_STOP=1 -f scripts/administration/inventory/server-info.sql
```

Le query in `scripts/` usano transazioni di sola lettura e timeout. Gli interventi sono descritti nelle procedure e richiedono la verifica dei prerequisiti. [Configurazione della connessione ed esempi](_support/docs/QUICKSTART.md).

Gli alberi e gli indici si aggiornano dopo un push su `main` che aggiunge, modifica, sposta o rimuove script o procedure. **Nessuna esecuzione periodica**: se la raccolta non cambia, l'automazione non parte. Per aggiornare gli indici prima del push: `python _support/tools/catalog.py`. [Aggiungere uno script o una procedura](_support/docs/MAINTENANCE.md).

Documentazione tecnica, fonti, test e strumenti di manutenzione sono raccolti in **[_support/](_support/README.md)**.
