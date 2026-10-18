# Scheda incidente PostgreSQL

Copiare questa scheda in uno spazio autorizzato dal processo di incident response. Non includere credenziali, query complete o dati personali se non necessari; redigere il materiale prima di condividerlo.

## Identificazione

- **Titolo:**
- **ID incidente / ticket:**
- **Severità:** SEV1 / SEV2 / SEV3 / SEV4 secondo criteri del servizio
- **Stato:** Investigating / Identified / Mitigating / Monitoring / Resolved
- **Incident commander:**
- **DBA on-call / responder:**
- **Owner applicazione / comunicazioni:**
- **Ultimo aggiornamento (ISO 8601 con fuso):**
- **Prossimo aggiornamento previsto:**

## Impatto e ambito

- **Servizio e utenti interessati:**
- **Sintomo osservato:**
- **Inizio stimato / rilevamento:**
- **Disponibilità, latenza o dati coinvolti:**
- **Ambiente, cluster, database e ruolo PostgreSQL:**
- **Versione e stato primary/standby:**
- **Impatto su RPO/RTO o backup:**

## Evidenze e ipotesi

| Timestamp | Evidenza osservata | Fonte/metodo | Interpretazione o ipotesi | Confidenza |
|---|---|---|---|---|
| | | | | |

Annotare il periodo e il reset delle statistiche. Distinguere esplicitamente dato misurato da ipotesi. Link a log/metriche solo in sistemi con accesso appropriato; oscurare query e identificativi sensibili.

## Decisioni e azioni

| Ora | Azione/decisione | Motivazione e impatto previsto | Owner | Esito/verifica | Rollback/escalation |
|---|---|---|---|---|---|
| | | | | | |

Runbook seguito: [titolo/link]. Change/approvazione: . Stato iniziale salvato: sì/no. Azioni selettive eseguite: .

## Comunicazione

**Stato attuale:** cosa è noto e cosa resta da verificare.
**Azione in corso:** mitigazione e owner.
**Prossimo passo / tempo di aggiornamento:** .

Gli aggiornamenti devono essere fattuali; dichiarare quando l'impatto è ancora in valutazione.

## Chiusura e apprendimento

- **Risoluzione confermata da:**
- **Impatto e durata effettivi:**
- **Causa verificata:**
- **Cosa ha funzionato:**
- **Cosa ha ritardato o peggiorato la risposta:**
- **Azioni preventive:**

| Azione | Owner | Priorità | Scadenza | Evidenza di completamento |
|---|---|---|---|---|
| | | | | |

Fonti di processo: [Incident response](triage.md), [sicurezza e redazione](../docs/SAFETY.md).
