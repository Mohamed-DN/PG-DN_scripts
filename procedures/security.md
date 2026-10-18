# Diagnosi ruoli, privilegi e autenticazione

Usare per accesso negato o sospetto e per verificare privilegi prima di un cambiamento. Limitare l'esame ai metadati strettamente necessari e non riportare password, hash, URI o query riservate nei ticket.

## Percorso operativo

1. Eseguire [role-attributes.sql](../scripts/security/roles/role-attributes.sql) per verificare `rolcanlogin`, `rolsuper`, `rolreplication`, `rolbypassrls` e scadenza. Se visibilità o ruolo non sono quelli attesi, non modificare attributi: chiedere una raccolta con privilegi adeguati.
2. Per accesso negato al database, eseguire [effective-database-privileges.sql](../scripts/security/privileges/effective-database-privileges.sql). `can_connect`, `can_create_schema` e `can_create_temp` valutano i diritti effettivi; se non spiegano l'errore, controllare endpoint, SSL e HBA.
3. Se il sintomo riguarda connessione, eseguire [hba-rule-health.sql](../scripts/security/privileges/hba-rule-health.sql). `line_number`, `auth_method` ed `error` individuano errori di parsing, non la regola scelta per una connessione. In caso di errore, verificare ordine e log con l'amministratore prima di ogni change.
4. Per oggetto specifico eseguire [relation-acl.sql](../scripts/security/privileges/relation-acl.sql); se servono membership su PostgreSQL 16+, usare [membership.sql](../scripts/security/roles/membership.sql). ACL esplicite e membership non includono tutto ownership/default ACL/RLS: correggere solo il diritto dimostrato e approvato.
5. Verificare con la stessa identità una prova non distruttiva e riconfermare i diritti effettivi dopo il change. Se emerge ruolo privilegiato inatteso o compromissione, preservare log e attivare la risposta sicurezza.

## Precheck

Confermare ambiente, identità richiedente tramite processo aziendale, ruolo, database, oggetto, operazione richiesta, approvatore e ticket. Stabilire se si tratta di errore applicativo, autenticazione, autorizzazione o rete/TLS. Non concedere `SUPERUSER` come scorciatoia.

## Diagnostica read-only

```sql
SELECT current_database(), current_user, session_user,
       inet_server_addr(), inet_server_port(), version();
SELECT rolname, rolsuper, rolcreaterole, rolcreatedb, rolcanlogin,
       rolreplication, rolvaliduntil
FROM pg_roles
WHERE rolname = current_user;
SELECT datname, datacl FROM pg_database WHERE datname = current_database();
SELECT n.nspname AS schemaname, c.relname AS tablename,
       pg_get_userbyid(c.relowner) AS tableowner, c.relacl
FROM pg_catalog.pg_class AS c
JOIN pg_catalog.pg_namespace AS n ON n.oid = c.relnamespace
WHERE c.relkind IN ('r','p') AND n.nspname NOT IN ('pg_catalog','information_schema')
ORDER BY n.nspname, c.relname LIMIT 100;
```

Per regole HBA, il ruolo appropriato può esaminare `pg_hba_file_rules` e il log di autenticazione (redatto). Controllare `error` nella vista e ordine delle regole: PostgreSQL usa la prima regola corrispondente; una regola successiva non è fallback se quella scelta fallisce. Su Windows le modifiche a HBA possono applicarsi alle nuove connessioni senza reload; verificare il manuale della piattaforma.

## Correzione minima

Risolvere prima endpoint/SSL/service e identità esatta. Per autorizzazione, chiedere all'owner dell'oggetto il privilegio minimo e una scadenza/ricertificazione. Preferire ruolo di gruppo senza LOGIN e credenziale nominativa; assegnare solo il privilegio necessario al database/schema/oggetto. Applicare tramite migration/change approvato, poi verificare con la stessa identità e una prova non distruttiva. Non alterare `pg_hba.conf`, membership, ownership o password durante la diagnosi senza change approvato e accesso fuori banda.

## Successo, rollback ed escalation

Successo: autenticazione usa il metodo atteso, la richiesta minima riesce, permessi e approvatore sono registrati, privilegi non necessari sono rimossi secondo change. Rollback: revocare il grant/membership o ripristinare la regola precedente; verificare che la sessione abbia riacquisito privilegi aggiornati e che non restino accessi involontari. In caso di sospetta compromissione, account privilegiato inatteso o divulgazione credenziali, attivare immediatamente la risposta sicurezza e preservare log; non cancellare evidenze.

Fonti: [pg_hba.conf](https://www.postgresql.org/docs/current/auth-pg-hba-conf.html), [ruoli](https://www.postgresql.org/docs/current/user-manag.html), [privilegi](https://www.postgresql.org/docs/current/ddl-priv.html).
