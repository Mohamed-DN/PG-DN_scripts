# Far crescere la raccolta

[← Home](../../README.md) · [Contribuire](CONTRIBUTING.md) · [Fonti](SOURCES.md)

## Aggiungere uno script

1. Scegli categoria e funzione in `scripts/`; crea una nuova sottocartella se il caso d’uso è diverso.
2. Usa l’header e la transazione read-only del modello in [CONTRIBUTING](CONTRIBUTING.md). Spiega versione, privilegi e interpretazione del risultato.
3. Collega un runbook; conserva azioni che modificano stato nella procedura, separate dalle query diagnostiche.
4. Esegui `python _support/tools/catalog.py`, `python _support/tools/validate.py` e i test pertinenti. Committa insieme codice e indici.
5. Su GitHub, dopo un push a `main`, **Refresh navigation** ricostruisce albero, catalogo e README delle cartelle script. Controlla il suo commit e il risultato di **Validate**.

Il generatore aggiorna gli alberi di script e procedure nella home. Gli altri materiali rimangono in `_support/` e non compaiono negli alberi operativi. Non modificare a mano le sezioni tra `BEGIN GENERATED` e `END GENERATED`, né i README generati in `scripts/`.

## Aggiungere una procedura

1. Crea un file `.md` in `procedures/`, oppure in una sottocartella per argomento. Usa un titolo `#` chiaro e un primo paragrafo che spieghi quando seguire la guida.
2. Descrivi controlli iniziali, link ai file SQL, risultati attesi, decisioni e verifica finale. Per gli interventi indica prerequisiti e recupero o escalation.
3. Dopo il push su `main`, l'albero nella home e l'indice di `procedures/` includono automaticamente il nuovo file. Per aggiornare gli indici localmente usa `python _support/tools/catalog.py`.

## Quando parte l'automazione

**Refresh navigation non ha un timer.** Parte dopo un push su `main` che modifica `scripts/`, `procedures/`, il generatore, la definizione del workflow o il README principale. Aggiunte, modifiche, cancellazioni e spostamenti sono rilevati attraverso i percorsi cambiati. Le modifiche alle sole fonti esterne o agli altri materiali di supporto non avviano questo aggiornamento.

Il workflow aggiorna solo gli indici generati e crea un commit soltanto se il contenuto cambia. Il commit del bot non innesca un ciclo di aggiornamenti. Il pulsante **Run workflow** permette anche un avvio manuale. [Definizione del workflow](../../.github/workflows/navigation.yml).

## Aggiornare una sorgente esterna

Acquisisci la nuova revisione in una directory di lavoro separata. Confronta commit, licenza repository, avvisi dei singoli file e changelog. Non eseguire gli script durante l’importazione e non sovrascrivere le query curate con un aggiornamento del vendor.

Mantieni i byte originali, incluse licenze e attribuzioni del README. Aggiorna commit, URL permalink e SHA-256 in ogni `manifest.json` e in `_support/upstream/SOURCES.json`, quindi i conteggi in [SOURCES](SOURCES.md) e [UPSTREAM_AUDIT](UPSTREAM_AUDIT.md). `README.upstream.md` conserva il README originale; `README.md` è l’indice locale italiano.

Esegui `python -m unittest discover -s _support/tests -v`: un file mancante, alterato o non registrato nel manifest deve far fallire il controllo di integrità. Per le raccolte senza licenza, mantieni soltanto metadata e link finché non è disponibile un permesso di ridistribuzione verificabile.

## Promuovere una query esterna nel catalogo curato

Rivedi licenza e attribuzioni, rimuovi dipendenze da oggetti applicativi, controlla privilegi ed effetti e prova tutte le major dichiarate. Non basta cambiare cartella o aggiungere `BEGIN READ ONLY`: funzioni amministrative e metacomandi possono avere effetti esterni alla transazione.

Conserva fonte e motivo dell’adattamento nell’header e nella documentazione. Aggiungi un test comportamentale se correggi un difetto che una query senza righe non avrebbe rilevato. Le nuove evidenze GitHub Actions sono artifact del relativo run; i rapporti in `_support/docs/evidence/` restano istantanee datate.
