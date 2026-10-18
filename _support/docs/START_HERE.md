# 🧭 Da dove iniziare

[← Home](../../README.md) · [Catalogo completo](CATALOG.md) · [Connessione Linux e Windows](QUICKSTART.md)

## Primo controllo

Configura una connessione libpq, quindi identifica sempre il target:

```console
python _support/tools/pgdn.py run scripts/administration/inventory/server-info.sql
python _support/tools/pgdn.py list --search wal
```

## Ho un problema: quale script apro?

| Situazione | Primo script | Poi leggi |
| :-- | :-- | :-- |
| L’applicazione è bloccata | [Sessioni bloccanti](../../scripts/monitoring/activity/blocking-sessions.sql) | [Lock](../../procedures/locks.md) |
| Il database è lento | [Attività corrente](../../scripts/administration/connections/active.sql) | [Query lente](../../procedures/slow-queries.md) |
| Cresce lo spazio WAL | [Retention degli slot](../../scripts/replication/slots/retention.sql) | [Crescita WAL](../../procedures/wal-growth.md) |
| La replica è in ritardo | [Sender](../../scripts/replication/physical/primary-senders.sql) o [replay standby](../../scripts/replication/physical/standby-replay.sql) | [Replica](../../procedures/replication-lag.md) |
| La tabella cresce e vacuum non recupera | [Transazioni più vecchie](../../scripts/maintenance/vacuum/oldest-transactions.sql) | [Vacuum e bloat](../../procedures/vacuum-bloat.md) |
| Devo verificare backup/recovery | [Stato recovery](../../scripts/backup/inspection/recovery-state.sql) | [Backup e restore](../../procedures/backup-restore.md) |
| Un ruolo non accede a un oggetto | [ACL relazioni](../../scripts/security/privileges/relation-acl.sql) | [Sicurezza](../../procedures/security.md) |

## Consultazione e studio

- [Mappa commentata e libreria completa](../../scripts/README.md): categorie → funzione → script.
- [Cheat sheet e azioni amministrative](reference/README.md): `psql`, ruoli, schemi e manutenzione.
- [Scelte architetturali](ORACLE_DESIGN_REVIEW.md): organizzazione della libreria e riferimenti.
- [Ricerca delle nuove fonti](RESEARCH_EXPANSION.md): progetti studiati, revisioni e licenze.
- [Verifiche e limiti](VALIDATION.md): prove effettive e risultati datati.

Le query diagnostiche sono separate dalle azioni. Il runbook è il punto da cui scegliere un intervento in base alle evidenze raccolte.
