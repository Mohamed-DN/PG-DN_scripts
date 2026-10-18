# ADR 0001: separare script curati, snapshot upstream e procedure

- Stato: accettato
- Data: 2026-10-18

## Contesto

Il repository deve offrire strumenti PostgreSQL riutilizzabili senza confondere SQL selezionato con codice copiato da terzi o con procedure che richiedono giudizio umano. Il target comprende le major 14–18 e include operatori con privilegi differenti.

## Decisione

Esporre in radice `scripts/` e `procedures/`, con una home centrata sui due percorsi operativi. Raccogliere documentazione tecnica, strumenti, test, catalogo JSON e fonti esterne in `_support/`. La directory `.github/` contiene soltanto le automazioni. Gli script curati sono read-only per impostazione predefinita. Gli snapshot upstream conservano provenienza e licenza e richiedono revisione prima di ogni promozione. I runbook documentano diagnosi e azioni manuali. Un generatore in Python standard library produce indici deterministici per `scripts/`; una matrice CI esercita i controlli live sulle versioni 14–18 e con un ruolo ristretto.

## Conseguenze

- Gli operatori possono distinguere osservazione, modifica e materiale non revisionato.
- La CI deve coprire feature-specifiche e privilegi, e segnalare chiaramente i controlli non eseguiti.
- Il generatore deve limitare le proprie scritture alle aree dichiarate e consentire di rilevare drift.
- La documentazione operativa può rimanere esplicativa senza incorporare script estesi duplicati.
- Il supporto a una nuova major richiede aggiornamento della matrice e verifica delle differenze prima di dichiararlo.

## Alternative considerate

Una directory unica avrebbe ridotto la navigazione ma mischiato affidabilità, provenienza e modalità d'uso. Copiare ogni upstream dentro `scripts/` avrebbe fatto apparire revisionato materiale che non lo è. Si preferisce quindi il confine esplicito tra codice selezionato e snapshot.

## Revisione

Rivalutare questa decisione quando si aggiungono nuove major, il catalogo esce dalle directory generate, oppure il progetto introduce un sistema di packaging o pubblicazione degli script.
