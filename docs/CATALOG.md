# Catalogo degli script curati

[← Home](../README.md) · [Origini e correzioni](SOURCE_REVIEW.md)

| Script | Scopo | PostgreSQL | Privilegi |
| :-- | :-- | :-- | :-- |
| [connection-capacity.sql](../scripts/administration/configuration/connection-capacity.sql) | Compare configured connection limit with visible client backends; poolers and reserved slots affect capacity. | 14+ | pg_read_all_stats for full count |
| [non-default-settings.sql](../scripts/administration/configuration/non-default-settings.sql) | Show only allowlisted diagnostic settings; connection strings, commands, paths and secrets are excluded. | 14+ | pg_read_all_settings for full view |
| [vacuum-settings.sql](../scripts/administration/configuration/vacuum-settings.sql) | Show allowlisted vacuum-related settings; command strings, paths and secrets are excluded. | 14+ | pg_read_all_settings for full values |
| [wal-settings.sql](../scripts/administration/configuration/wal-settings.sql) | Inspect safe WAL retention and archiving settings; command strings, paths and secrets are excluded. | 14+ | pg_read_all_settings for full view |
| [active.sql](../scripts/administration/connections/active.sql) | Show active sessions, age, waits and bounded query prefix; query text may contain sensitive values. | 14+ | pg_read_all_stats; otherwise own sessions |
| [by-state.sql](../scripts/administration/connections/by-state.sql) | Summarize visible sessions by database, role, state and wait class. | 14+ | pg_read_all_stats for complete details |
| [idle-in-transaction.sql](../scripts/administration/connections/idle-in-transaction.sql) | Find idle-in-transaction sessions and transaction age. | 14+ | pg_read_all_stats; otherwise own sessions |
| [databases.sql](../scripts/administration/inventory/databases.sql) | List non-template databases, owners, connection limits and allocated size. | 14+ | database CONNECT |
| [extensions.sql](../scripts/administration/inventory/extensions.sql) | Show extensions installed in this database; no installation or update is performed. | 14+ | database CONNECT |
| [largest-relations.sql](../scripts/administration/inventory/largest-relations.sql) | Rank user tables by total allocated bytes including indexes and TOAST. | 14+ | database CONNECT |
| [materialized-views.sql](../scripts/administration/inventory/materialized-views.sql) | List materialized view ownership, tablespace and population state without exposing view definitions. | 14+ | database CONNECT |
| [partition-tree.sql](../scripts/administration/inventory/partition-tree.sql) | List partition parents and children using catalog inheritance links, without scanning table data. | 14+ | CONNECT |
| [routines.sql](../scripts/administration/inventory/routines.sql) | List function and procedure metadata without exposing routine source text or bodies. | 14+ | database CONNECT; routine metadata visibility depends on privileges |
| [schemas.sql](../scripts/administration/inventory/schemas.sql) | List non-system schemas and owners. | 14+ | database CONNECT |
| [sequences.sql](../scripts/administration/inventory/sequences.sql) | List sequence ownership and bounds without exposing current sequence values. | 14+ | database CONNECT; sequence metadata visibility depends on privileges |
| [server-info.sql](../scripts/administration/inventory/server-info.sql) | Identify database, role, server version, startup and primary or standby state before diagnosis. | 14+ | CONNECT |
| [active-backup-senders.sql](../scripts/backup/inspection/active-backup-senders.sql) | Show current walsender activity as clues for a physical backup; validate against backup tooling. | 14+ | pg_read_all_stats |
| [recovery-state.sql](../scripts/backup/inspection/recovery-state.sql) | Report recovery state and system identifier/timeline; control data access may require elevated privileges. | 14+ | pg_monitor; control functions may need elevated rights |
| [relation-size-breakdown.sql](../scripts/maintenance/bloat/relation-size-breakdown.sql) | Compare heap, indexes and total allocated size; these are not direct bloat estimates. | 14+ | database CONNECT |
| [toast-breakdown.sql](../scripts/maintenance/bloat/toast-breakdown.sql) | Show heap, index and TOAST allocation for larger user tables. | 14+ | database CONNECT |
| [analyze.sql](../scripts/maintenance/progress/analyze.sql) | Show active ANALYZE progress counters. | 14+ | pg_read_all_stats for full visibility |
| [create-index.sql](../scripts/maintenance/progress/create-index.sql) | Show active index build progress; no cancellation or mutation is performed. | 14+ | pg_read_all_stats for full visibility |
| [vacuum.sql](../scripts/maintenance/progress/vacuum.sql) | Show active vacuum phase and block counters common to PostgreSQL 14-18. | 14+ | pg_read_all_stats for full visibility |
| [dead-tuples.sql](../scripts/maintenance/vacuum/dead-tuples.sql) | Rank user tables by estimated dead tuples and show last maintenance times. | 14+ | database CONNECT; statistics may be stale |
| [oldest-transactions.sql](../scripts/maintenance/vacuum/oldest-transactions.sql) | Inspect backends with open transactions; long transactions can delay cleanup. | 14+ | pg_read_all_stats for complete details |
| [wraparound-risk.sql](../scripts/maintenance/vacuum/wraparound-risk.sql) | Compare database XID and multixact ages with configured autovacuum thresholds; investigate trends before acting. | 14+ | CONNECT |
| [advisory-locks.sql](../scripts/monitoring/activity/advisory-locks.sql) | List advisory lock ownership and wait state without exposing session query text. | 14+ | pg_read_all_stats for complete session details |
| [blocking-sessions.sql](../scripts/monitoring/activity/blocking-sessions.sql) | Show one row per blocked session and blocking PID; a zero PID denotes a prepared transaction. | 14+ | pg_read_all_stats for complete activity |
| [long-running.sql](../scripts/monitoring/activity/long-running.sql) | Find active queries older than one minute; query text may contain sensitive literals. | 14+ | pg_read_all_stats for complete details |
| [prepared-transactions.sql](../scripts/monitoring/activity/prepared-transactions.sql) | List two-phase transactions; resolution belongs to the transaction coordinator. | 14+ | database CONNECT |
| [ssl-connections.sql](../scripts/monitoring/activity/ssl-connections.sql) | Show TLS use and negotiated parameters without client or issuer distinguished names. | 14+ | pg_read_all_stats for complete visibility |
| [wait-summary.sql](../scripts/monitoring/activity/wait-summary.sql) | Summarize sessions by backend type, state and wait event. | 14+ | pg_read_all_stats for complete details |
| [database-sizes.sql](../scripts/monitoring/capacity/database-sizes.sql) | Rank connectable databases by allocated size. | 14+ | database CONNECT |
| [tablespace-inventory.sql](../scripts/monitoring/capacity/tablespace-inventory.sql) | List tablespace names and configured paths; filesystem free space is not included. | 14+ | database CONNECT |
| [checkpointer.sql](../scripts/monitoring/statistics/checkpointer.sql) | Show checkpoint and restartpoint counters on PostgreSQL 17+; cumulative counters need delta snapshots. | 17+ | pg_read_all_stats |
| [database-counters.sql](../scripts/monitoring/statistics/database-counters.sql) | Show cumulative transaction, deadlock, temp and block counters; use snapshot deltas for rates. | 14+ | pg_read_all_stats |
| [reset-times.sql](../scripts/monitoring/statistics/reset-times.sql) | Show database statistics reset timestamps to interpret cumulative counters. | 14+ | database CONNECT |
| [table-activity.sql](../scripts/monitoring/statistics/table-activity.sql) | Show scans, estimated tuples and last maintenance timestamps. | 14+ | database CONNECT; estimates and visibility vary |
| [definitions.sql](../scripts/performance/indexes/definitions.sql) | List index definitions for review. | 14+ | database CONNECT |
| [duplicate-candidates.sql](../scripts/performance/indexes/duplicate-candidates.sql) | Find exact-signature index pairs for manual review, comparing keys, expressions, predicates, opclasses, collations and storage options; no index is removed. | 14+ | database CONNECT |
| [invalid-indexes.sql](../scripts/performance/indexes/invalid-indexes.sql) | Identify indexes marked invalid or not ready for DBA investigation. | 14+ | database CONNECT |
| [unused-candidates.sql](../scripts/performance/indexes/unused-candidates.sql) | Find valid large indexes with zero scans; review workload cycles before any decision and never auto-drop. | 14+ | database CONNECT |
| [usage-by-table.sql](../scripts/performance/indexes/usage-by-table.sql) | Compare sequential and index scans and tuple fetches; counters can reset. | 14+ | database CONNECT |
| [buffercache-summary.sql](../scripts/performance/io/buffercache-summary.sql) | Summarize shared-buffer usage only when pg_buffercache is already installed; extension schema is discovered and quoted safely. | 16+ | pg_monitor; function EXECUTE may be granted separately |
| [database-io-timing.sql](../scripts/performance/io/database-io-timing.sql) | Show cumulative block timings; zero can mean track_io_timing was disabled. | 14+ | pg_read_all_stats |
| [pg-stat-io.sql](../scripts/performance/io/pg-stat-io.sql) | Inspect cumulative I/O counters; correlate them with operating system metrics. | 16+ | pg_read_all_stats; PostgreSQL 16+ |
| [top-mean-time.sql](../scripts/performance/queries/top-mean-time.sql) | Rank normalized statements by mean time; low call counts may skew results. | 14+ | pg_read_all_stats; extension already installed |
| [top-temp-blocks.sql](../scripts/performance/queries/top-temp-blocks.sql) | Find statements with cumulative temporary block writes; compare snapshots for rates. | 14+ | pg_read_all_stats; extension already installed |
| [top-total-time.sql](../scripts/performance/queries/top-total-time.sql) | Rank pg_stat_statements by cumulative execution time; extension must already be available. | 14+ | pg_read_all_stats; extension already installed |
| [subscriptions.sql](../scripts/replication/logical/subscriptions.sql) | List subscriptions without connection strings or credentials. | 14+ | database owner or pg_read_all_stats |
| [workers.sql](../scripts/replication/logical/workers.sql) | Show logical replication worker state and bounded query prefixes. | 14+ | pg_read_all_stats |
| [primary-senders.sql](../scripts/replication/physical/primary-senders.sql) | On primary show sender state and byte lag; time lag is approximate and may be NULL. | 14+ | pg_read_all_stats for full visibility |
| [standby-receiver.sql](../scripts/replication/physical/standby-receiver.sql) | On standby inspect receiver state; connection string is omitted to avoid credentials. | 14+ | database CONNECT |
| [standby-replay.sql](../scripts/replication/physical/standby-replay.sql) | Estimate received-but-not-replayed bytes and time since last replay; time can mislead when idle. | 14+ | database CONNECT |
| [logical-stats.sql](../scripts/replication/slots/logical-stats.sql) | Inspect cumulative logical decoding slot statistics. | 14+ | database CONNECT |
| [retention.sql](../scripts/replication/slots/retention.sql) | Show WAL retained by slots; inactive slots may retain large volumes. | 14+ | database CONNECT |
| [database-acl.sql](../scripts/security/privileges/database-acl.sql) | Expand database ACL entries; null ACLs use built-in defaults. | 14+ | database CONNECT |
| [hba-rule-health.sql](../scripts/security/privileges/hba-rule-health.sql) | Show parse health for pg_hba.conf rules without exposing databases, users, addresses or authentication options. | 14+ | superuser by default; an administrator can grant SELECT on the view |
| [relation-acl.sql](../scripts/security/privileges/relation-acl.sql) | Inspect explicit ACL entries for user relations. | 14+ | database CONNECT |
| [rls-policies.sql](../scripts/security/privileges/rls-policies.sql) | List user tables' RLS flags and policy names, modes, commands and roles; policy expressions are excluded. | 14+ | database CONNECT; metadata visibility depends on ownership/privileges |
| [schema-acl.sql](../scripts/security/privileges/schema-acl.sql) | List schema ACLs; role membership and ownership affect effective privileges. | 14+ | database CONNECT |
| [expiring-logins.sql](../scripts/security/roles/expiring-logins.sql) | Identify login roles expired or expiring in 30 days. | 14+ | database CONNECT |
| [membership.sql](../scripts/security/roles/membership.sql) | Show granted membership and delegation options. | 16+ | database CONNECT |
| [role-inventory.sql](../scripts/security/roles/role-inventory.sql) | List role attributes and validity without password hashes. | 14+ | database CONNECT |
| [archive-status.sql](../scripts/wal/archive/archive-status.sql) | Inspect cumulative archive success and failure counters; archive ordering can have exceptions. | 14+ | database CONNECT |
| [ready-files.sql](../scripts/wal/archive/ready-files.sql) | Count .ready/.done marker files in pg_wal/archive_status; marker sizes are not WAL sizes. | 14+ | pg_monitor or EXECUTE on pg_ls_archive_statusdir |
| [retention-context.sql](../scripts/wal/retention/retention-context.sql) | Summarize slots, senders and retention settings that may influence pg_wal growth. | 14+ | database CONNECT; settings visibility may require pg_read_all_settings |
| [wal-counters.sql](../scripts/wal/retention/wal-counters.sql) | Show cumulative WAL byte and record counters; compare snapshots for rates. | 14+ | pg_read_all_stats |
