# Automazione del repository

[← Home](../README.md)

| Workflow | Evento | Effetto |
| :-- | :-- | :-- |
| [Validate](workflows/validate.yml) | Push, pull request o manuale | Metadati, link, test di navigazione e matrice PostgreSQL 14–18 |
| [Refresh navigation](workflows/navigation.yml) | Push su `main` o manuale da `main` | Rigenera README e catalogo, quindi committa solo i file generati |

Il validatore usa token in sola lettura. Solo il workflow di navigazione riceve `contents: write`, e gira sul codice del ramo principale. Nessun `pull_request_target`, password di produzione o segreto esterno. Le prove PostgreSQL usano database effimeri nel runner.
