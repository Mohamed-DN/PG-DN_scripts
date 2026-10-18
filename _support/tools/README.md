# Strumenti del catalogo

[← Home](../../README.md)

| Comando | Risultato |
| :-- | :-- |
| `python _support/tools/pgdn.py list --search wal` | Ricerca offline per nome, metadati e descrizione |
| `python _support/tools/pgdn.py run scripts/.../file.sql` | Esegue una query curata con `psql -X`, senza prompt password |
| `python _support/tools/catalog.py` | Aggiorna albero, catalogo JSON e README di tutte le cartelle script |
| `python _support/tools/catalog.py --check` | Fallisce se la navigazione è obsoleta, senza scrivere file |
| `python _support/tools/validate.py` | Controlla header, convenzioni e link Markdown |

Python 3.10+ e libreria standard. Il runner eredita la connessione libpq e aggiunge timeout e modalità read-only alla sessione. Non esegue script `_support/upstream/`. Evita di mettere password in argomenti, URL o file versionati.

Le descrizioni vengono dagli header SQL: nessun inventario da aggiornare a mano. La mappa degli script include i file `.sql` e le relative categorie sotto `scripts/`; la mappa delle procedure include i file Markdown sotto `procedures/`. Entrambe si aggiornano dai file presenti, senza elenchi manuali.
