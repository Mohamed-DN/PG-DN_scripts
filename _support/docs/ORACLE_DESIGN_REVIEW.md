# Architettura della libreria: riferimenti e scelte

[← Home](../../README.md) · [Inizia da qui](START_HERE.md)

La struttura PostgreSQL riprende alcuni percorsi operativi della libreria `dba_oracle_lab`: ingresso rapido, mappa commentata, collegamenti fra script e runbook. Indici e conteggi sono generati automaticamente dai file presenti.

| Idea osservata in Oracle | Scelta PostgreSQL | Utilità |
| :-- | :-- | :-- |
| Mappa della libreria con descrizioni a destra | Albero ASCII commentato nella home e nei README di `scripts/` | Capire funzione e contenuto prima di aprire una cartella |
| Conteggio degli script per area | Conteggi calcolati dai file, senza numeri scritti a mano | Evitare divergenze tra mappa e catalogo |
| `START_HERE` e shortcut operativi | [Ingresso rapido](START_HERE.md) con problema → script → runbook | Ridurre la ricerca durante il triage |
| Cheat sheet, runbook e script pronti separati | `_support/docs/reference/`, `procedures/` e `scripts/` | Collegare comandi, evidenze e decisioni senza mescolarli |
| Comunità e raccolte estese | Sorgenti fissate in `_support/upstream/`, casi utili integrati in `scripts/` | Consultare gli originali mantenendo una libreria operativa uniforme |
| Etichette di qualità | Header di versione/privilegi/rischio e rapporto dei test | Distinguere prova effettiva e materiale di riferimento |

Non sono state riprodotte le aree proprie di ASM, RAC, Data Guard, patching Oracle, CDB/PDB o ZDM. Le categorie PostgreSQL seguono istanza/cataloghi, monitoraggio, performance, manutenzione, replica, WAL, backup e sicurezza. Per queste dimensioni bastano categoria e funzione; ulteriori livelli vanno aggiunti solo quando migliorano la ricerca.

La home risiede nel `README.md` di radice. `.github/AUTOMATION.md` contiene le istruzioni CI: un README direttamente in `.github/` avrebbe precedenza sulla home secondo le [regole di GitHub](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-readmes).

Fonti del confronto: [home Oracle](https://github.com/Mohamed-DN/dba_oracle_lab), [operatività](https://github.com/Mohamed-DN/dba_oracle_lab/blob/master/docs/01_operations/README.md), [libreria e mappa](https://github.com/Mohamed-DN/dba_oracle_lab/blob/master/docs/01_operations/04_libreria_script_completa/README.md).
