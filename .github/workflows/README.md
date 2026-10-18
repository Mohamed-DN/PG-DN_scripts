# Workflow GitHub Actions

Questa directory contiene automazioni CI del repository. Il catalogo descrive i workflow effettivamente presenti; la definizione YAML resta la fonte di verità.

## Principi

- Limitare ogni workflow alle directory e alle azioni dichiarate e usare permessi `GITHUB_TOKEN` minimi.
- Non eseguire SQL contro ambienti di produzione. I test database devono usare istanze PostgreSQL temporanee della matrice dichiarata e credenziali effimere.
- Non stampare segreti, password, dump o query con dati applicativi nei log.
- Separare controlli statici dai test live e indicare major PostgreSQL, versione client e privilegi effettivamente esercitati.
- Segnalare un test saltato o una major mancante come copertura non verificata.

## Workflow presenti

| File | Trigger e scopo | Permessi / effetto |
|---|---|---|
| [validate.yml](validate.yml) | Push, pull request e dispatch manuale; unit test, validatore repository, controllo catalogo e matrice PostgreSQL 14–18 via Docker. | `contents: read`; carica un artefatto per major. |
| [navigation.yml](navigation.yml) | Push su `main` e dispatch manuale; genera e verifica la navigazione. | `contents: write`; se cambia output generato, effettua commit e push su `main`. Eseguire manualmente solo dopo aver verificato il branch e gli output attesi. |

Aggiornare questo indice quando si aggiunge, rinomina o rimuove un workflow. Il catalogo automatico in `tools/` non sostituisce questo README.

## Revisione

Prima del merge, controllare segreti, azioni distruttive, input non fidati e permessi nei job. Per le procedure PostgreSQL vedere [runbooks](../../runbooks/README.md), [sicurezza](../../docs/SAFETY.md) e [contributi](../../docs/CONTRIBUTING.md).
