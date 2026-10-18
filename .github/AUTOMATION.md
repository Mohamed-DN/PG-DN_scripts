# Automazione del repository

[← Home](../README.md)

| Workflow | Evento | Effetto |
| :-- | :-- | :-- |
| [Validate](workflows/validate.yml) | Push, pull request o manuale | Metadati, link, test di navigazione e matrice PostgreSQL 14–18 |
| [Refresh navigation](workflows/navigation.yml) | Push su `main` con modifiche a script, procedure, generatore, workflow o home; avvio manuale disponibile | Rigenera alberi, indici e catalogo; committa solo se cambiano. Nessun timer. |

Il validatore usa token in sola lettura. Solo il workflow di navigazione riceve `contents: write`, e gira sul codice del ramo principale. Nessun `pull_request_target`, password di produzione o segreto esterno. Le prove PostgreSQL usano database effimeri nel runner.
