# Copertura dei file SQL

[← Risultati](../VALIDATION.md) · [Piano di verifica](../QUERY_TEST_PLAN.md)

Tutti i file elencati sono eseguiti nella matrice. Le guardie sono distinte dalle SELECT eseguite. La colonna scenari conta le verifiche estese associate al file; i 14 controlli di base del report comprendono ulteriori prove di lock, permessi, restore e cataloghi.

| Script | Major con SELECT eseguita | Ruolo monitor | Scenari estesi |
| :-- | :-- | :-- | --: |
| [administration/configuration/connection-capacity.sql](../../../scripts/administration/configuration/connection-capacity.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [administration/configuration/non-default-settings.sql](../../../scripts/administration/configuration/non-default-settings.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [administration/configuration/vacuum-settings.sql](../../../scripts/administration/configuration/vacuum-settings.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [administration/configuration/wal-settings.sql](../../../scripts/administration/configuration/wal-settings.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [administration/connections/active.sql](../../../scripts/administration/connections/active.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [administration/connections/backend-detail.sql](../../../scripts/administration/connections/backend-detail.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [administration/connections/by-state.sql](../../../scripts/administration/connections/by-state.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [administration/connections/idle-in-transaction.sql](../../../scripts/administration/connections/idle-in-transaction.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [administration/connections/oldest-backend-transactions.sql](../../../scripts/administration/connections/oldest-backend-transactions.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [administration/connections/xid-holding-backends.sql](../../../scripts/administration/connections/xid-holding-backends.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [administration/inventory/collation-versions.sql](../../../scripts/administration/inventory/collation-versions.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [administration/inventory/columns.sql](../../../scripts/administration/inventory/columns.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [administration/inventory/constraints.sql](../../../scripts/administration/inventory/constraints.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [administration/inventory/databases.sql](../../../scripts/administration/inventory/databases.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [administration/inventory/extensions-dependencies.sql](../../../scripts/administration/inventory/extensions-dependencies.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [administration/inventory/extensions.sql](../../../scripts/administration/inventory/extensions.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [administration/inventory/fdw-metadata.sql](../../../scripts/administration/inventory/fdw-metadata.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 2 |
| [administration/inventory/largest-relations.sql](../../../scripts/administration/inventory/largest-relations.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [administration/inventory/materialized-views.sql](../../../scripts/administration/inventory/materialized-views.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [administration/inventory/object-dependencies.sql](../../../scripts/administration/inventory/object-dependencies.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [administration/inventory/ownership.sql](../../../scripts/administration/inventory/ownership.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [administration/inventory/partition-tree.sql](../../../scripts/administration/inventory/partition-tree.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [administration/inventory/relations-detailed.sql](../../../scripts/administration/inventory/relations-detailed.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [administration/inventory/routines.sql](../../../scripts/administration/inventory/routines.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [administration/inventory/schemas.sql](../../../scripts/administration/inventory/schemas.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [administration/inventory/sequences.sql](../../../scripts/administration/inventory/sequences.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [administration/inventory/server-info.sql](../../../scripts/administration/inventory/server-info.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [administration/inventory/triggers.sql](../../../scripts/administration/inventory/triggers.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [administration/inventory/types-enums-domains.sql](../../../scripts/administration/inventory/types-enums-domains.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [administration/inventory/unvalidated-constraints.sql](../../../scripts/administration/inventory/unvalidated-constraints.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [administration/inventory/views-and-definitions.sql](../../../scripts/administration/inventory/views-and-definitions.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [backup/inspection/active-backup-senders.sql](../../../scripts/backup/inspection/active-backup-senders.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [backup/inspection/backup-api-activity.sql](../../../scripts/backup/inspection/backup-api-activity.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [backup/inspection/basebackup-progress.sql](../../../scripts/backup/inspection/basebackup-progress.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [backup/inspection/recovery-state.sql](../../../scripts/backup/inspection/recovery-state.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [maintenance/bloat/relation-size-breakdown.sql](../../../scripts/maintenance/bloat/relation-size-breakdown.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [maintenance/bloat/toast-breakdown.sql](../../../scripts/maintenance/bloat/toast-breakdown.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [maintenance/progress/analyze.sql](../../../scripts/maintenance/progress/analyze.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [maintenance/progress/cluster-rewrite.sql](../../../scripts/maintenance/progress/cluster-rewrite.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [maintenance/progress/copy.sql](../../../scripts/maintenance/progress/copy.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [maintenance/progress/create-index.sql](../../../scripts/maintenance/progress/create-index.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [maintenance/progress/index-build.sql](../../../scripts/maintenance/progress/index-build.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [maintenance/progress/vacuum.sql](../../../scripts/maintenance/progress/vacuum.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [maintenance/vacuum/dead-tuples.sql](../../../scripts/maintenance/vacuum/dead-tuples.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [maintenance/vacuum/hot-update-ratio.sql](../../../scripts/maintenance/vacuum/hot-update-ratio.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [maintenance/vacuum/oldest-transactions.sql](../../../scripts/maintenance/vacuum/oldest-transactions.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [maintenance/vacuum/per-table-autovacuum-overrides.sql](../../../scripts/maintenance/vacuum/per-table-autovacuum-overrides.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [maintenance/vacuum/table-freeze-age.sql](../../../scripts/maintenance/vacuum/table-freeze-age.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [maintenance/vacuum/table-multixact-age.sql](../../../scripts/maintenance/vacuum/table-multixact-age.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [maintenance/vacuum/toast-storage-share.sql](../../../scripts/maintenance/vacuum/toast-storage-share.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [maintenance/vacuum/vacuum-history.sql](../../../scripts/maintenance/vacuum/vacuum-history.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [maintenance/vacuum/wraparound-risk.sql](../../../scripts/maintenance/vacuum/wraparound-risk.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [monitoring/activity/advisory-locks.sql](../../../scripts/monitoring/activity/advisory-locks.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [monitoring/activity/blocking-impact.sql](../../../scripts/monitoring/activity/blocking-impact.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [monitoring/activity/blocking-sessions.sql](../../../scripts/monitoring/activity/blocking-sessions.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [monitoring/activity/long-running.sql](../../../scripts/monitoring/activity/long-running.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [monitoring/activity/prepared-transactions.sql](../../../scripts/monitoring/activity/prepared-transactions.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [monitoring/activity/ssl-connections.sql](../../../scripts/monitoring/activity/ssl-connections.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [monitoring/activity/wait-summary.sql](../../../scripts/monitoring/activity/wait-summary.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [monitoring/activity/waiting-locks-by-relation.sql](../../../scripts/monitoring/activity/waiting-locks-by-relation.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [monitoring/capacity/database-sizes.sql](../../../scripts/monitoring/capacity/database-sizes.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [monitoring/capacity/tablespace-inventory.sql](../../../scripts/monitoring/capacity/tablespace-inventory.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [monitoring/statistics/checkpointer-activity.sql](../../../scripts/monitoring/statistics/checkpointer-activity.sql) | 17, 18 | PASS nelle major applicabili | 0 |
| [monitoring/statistics/checkpointer.sql](../../../scripts/monitoring/statistics/checkpointer.sql) | 17, 18 | PASS nelle major applicabili | 0 |
| [monitoring/statistics/database-age.sql](../../../scripts/monitoring/statistics/database-age.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [monitoring/statistics/database-cache-hit.sql](../../../scripts/monitoring/statistics/database-cache-hit.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [monitoring/statistics/database-counters.sql](../../../scripts/monitoring/statistics/database-counters.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [monitoring/statistics/database-transaction-ratio.sql](../../../scripts/monitoring/statistics/database-transaction-ratio.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [monitoring/statistics/database-work-counters.sql](../../../scripts/monitoring/statistics/database-work-counters.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [monitoring/statistics/deadlocks-and-conflicts.sql](../../../scripts/monitoring/statistics/deadlocks-and-conflicts.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [monitoring/statistics/io-by-backend.sql](../../../scripts/monitoring/statistics/io-by-backend.sql) | 16, 17, 18 | PASS nelle major applicabili | 0 |
| [monitoring/statistics/relation-block-io.sql](../../../scripts/monitoring/statistics/relation-block-io.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [monitoring/statistics/reset-times.sql](../../../scripts/monitoring/statistics/reset-times.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [monitoring/statistics/slru-counters.sql](../../../scripts/monitoring/statistics/slru-counters.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [monitoring/statistics/table-activity.sql](../../../scripts/monitoring/statistics/table-activity.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [monitoring/statistics/table-hot-updates.sql](../../../scripts/monitoring/statistics/table-hot-updates.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [monitoring/statistics/table-statistics-coverage.sql](../../../scripts/monitoring/statistics/table-statistics-coverage.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [monitoring/statistics/temporary-files.sql](../../../scripts/monitoring/statistics/temporary-files.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [performance/indexes/access-methods.sql](../../../scripts/performance/indexes/access-methods.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [performance/indexes/constraint-index-signatures.sql](../../../scripts/performance/indexes/constraint-index-signatures.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [performance/indexes/definitions.sql](../../../scripts/performance/indexes/definitions.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [performance/indexes/duplicate-candidates.sql](../../../scripts/performance/indexes/duplicate-candidates.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 2 |
| [performance/indexes/foreign-keys-without-index.sql](../../../scripts/performance/indexes/foreign-keys-without-index.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [performance/indexes/index-usage-context.sql](../../../scripts/performance/indexes/index-usage-context.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [performance/indexes/index-validity-state.sql](../../../scripts/performance/indexes/index-validity-state.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [performance/indexes/invalid-indexes.sql](../../../scripts/performance/indexes/invalid-indexes.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [performance/indexes/key-included-columns.sql](../../../scripts/performance/indexes/key-included-columns.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [performance/indexes/unused-candidates.sql](../../../scripts/performance/indexes/unused-candidates.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [performance/indexes/usage-by-table.sql](../../../scripts/performance/indexes/usage-by-table.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [performance/indexes/write-pressure.sql](../../../scripts/performance/indexes/write-pressure.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [performance/io/buffercache-summary.sql](../../../scripts/performance/io/buffercache-summary.sql) | 16, 17, 18 | PASS nelle major applicabili | 0 |
| [performance/io/checkpoint-settings-context.sql](../../../scripts/performance/io/checkpoint-settings-context.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [performance/io/database-io-timing.sql](../../../scripts/performance/io/database-io-timing.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [performance/io/database-temp-files.sql](../../../scripts/performance/io/database-temp-files.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [performance/io/io-wait-snapshot.sql](../../../scripts/performance/io/io-wait-snapshot.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [performance/io/pg-stat-io.sql](../../../scripts/performance/io/pg-stat-io.sql) | 16, 17, 18 | PASS nelle major applicabili | 0 |
| [performance/queries/top-mean-time.sql](../../../scripts/performance/queries/top-mean-time.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [performance/queries/top-temp-blocks.sql](../../../scripts/performance/queries/top-temp-blocks.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [performance/queries/top-total-time.sql](../../../scripts/performance/queries/top-total-time.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [performance/statistics/analyze-freshness.sql](../../../scripts/performance/statistics/analyze-freshness.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [performance/statistics/column-skew-metadata.sql](../../../scripts/performance/statistics/column-skew-metadata.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [performance/statistics/null-fractions.sql](../../../scripts/performance/statistics/null-fractions.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 2 |
| [performance/statistics/partition-hierarchy.sql](../../../scripts/performance/statistics/partition-hierarchy.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [performance/statistics/partition-index-attachments.sql](../../../scripts/performance/statistics/partition-index-attachments.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [performance/statistics/physical-correlation.sql](../../../scripts/performance/statistics/physical-correlation.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [performance/statistics/sequence-context.sql](../../../scripts/performance/statistics/sequence-context.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [performance/statistics/sequence-headroom.sql](../../../scripts/performance/statistics/sequence-headroom.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [replication/logical/publication-tables.sql](../../../scripts/replication/logical/publication-tables.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [replication/logical/publications.sql](../../../scripts/replication/logical/publications.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [replication/logical/subscriptions.sql](../../../scripts/replication/logical/subscriptions.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 2 |
| [replication/logical/table-sync-state.sql](../../../scripts/replication/logical/table-sync-state.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [replication/logical/workers.sql](../../../scripts/replication/logical/workers.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [replication/physical/primary-senders.sql](../../../scripts/replication/physical/primary-senders.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [replication/physical/standby-conflicts.sql](../../../scripts/replication/physical/standby-conflicts.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [replication/physical/standby-receiver-health.sql](../../../scripts/replication/physical/standby-receiver-health.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [replication/physical/standby-receiver.sql](../../../scripts/replication/physical/standby-receiver.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [replication/physical/standby-replay.sql](../../../scripts/replication/physical/standby-replay.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [replication/slots/logical-stats.sql](../../../scripts/replication/slots/logical-stats.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [replication/slots/retention.sql](../../../scripts/replication/slots/retention.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [replication/slots/wal-limit-headroom.sql](../../../scripts/replication/slots/wal-limit-headroom.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [replication/slots/xmin-horizons.sql](../../../scripts/replication/slots/xmin-horizons.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [security/privileges/database-acl.sql](../../../scripts/security/privileges/database-acl.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [security/privileges/effective-database-privileges.sql](../../../scripts/security/privileges/effective-database-privileges.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [security/privileges/hba-rule-health.sql](../../../scripts/security/privileges/hba-rule-health.sql) | 14, 15, 16, 17, 18 | Negazione HBA attesa e provata | 0 |
| [security/privileges/public-schema-grants.sql](../../../scripts/security/privileges/public-schema-grants.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [security/privileges/relation-acl.sql](../../../scripts/security/privileges/relation-acl.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 2 |
| [security/privileges/rls-enabled-without-policy.sql](../../../scripts/security/privileges/rls-enabled-without-policy.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [security/privileges/rls-policies.sql](../../../scripts/security/privileges/rls-policies.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [security/privileges/routine-execute-grants.sql](../../../scripts/security/privileges/routine-execute-grants.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [security/privileges/routine-security-definer.sql](../../../scripts/security/privileges/routine-security-definer.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [security/privileges/schema-acl.sql](../../../scripts/security/privileges/schema-acl.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [security/privileges/schema-effective-privileges.sql](../../../scripts/security/privileges/schema-effective-privileges.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [security/roles/default-acl.sql](../../../scripts/security/roles/default-acl.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [security/roles/expiring-logins.sql](../../../scripts/security/roles/expiring-logins.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [security/roles/membership.sql](../../../scripts/security/roles/membership.sql) | 16, 17, 18 | PASS nelle major applicabili | 1 |
| [security/roles/role-attributes.sql](../../../scripts/security/roles/role-attributes.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [security/roles/role-inventory.sql](../../../scripts/security/roles/role-inventory.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [security/roles/role-membership-edges.sql](../../../scripts/security/roles/role-membership-edges.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |
| [wal/archive/archive-status.sql](../../../scripts/wal/archive/archive-status.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [wal/archive/ready-files.sql](../../../scripts/wal/archive/ready-files.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [wal/retention/checkpoint-counters-common.sql](../../../scripts/wal/retention/checkpoint-counters-common.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [wal/retention/retention-context.sql](../../../scripts/wal/retention/retention-context.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [wal/retention/wal-counters.sql](../../../scripts/wal/retention/wal-counters.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 0 |
| [wal/retention/wal-directory-dimensions.sql](../../../scripts/wal/retention/wal-directory-dimensions.sql) | 14, 15, 16, 17, 18 | PASS nelle major applicabili | 1 |

Zero scenari estesi non significa file non eseguito: significa che non è associato a una verifica di risultato specifica di questo schema. Per i processi di replica e backup, il rapporto fisico aggiunge verifiche su primary e standby. Gli identificativi delle verifiche sono nel JSON.
