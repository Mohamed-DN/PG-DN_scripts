# Strumenti del catalogo

[← Home](../README.md)

| Comando | Risultato |
| :-- | :-- |
| `python tools/pgdn.py list --search wal` | Ricerca offline per nome, metadati e descrizione |
| `python tools/pgdn.py run scripts/.../file.sql` | Esegue una query curata con `psql -X`, senza prompt password |
| `python tools/catalog.py` | Aggiorna albero, catalogo JSON e README di tutte le cartelle script |
| `python tools/catalog.py --check` | Fallisce se la navigazione è obsoleta, senza scrivere file |
| `python tools/validate.py` | Controlla header, convenzioni e link Markdown |

Python 3.10+ e libreria standard. Il runner eredita la connessione libpq e aggiunge timeout e modalità read-only alla sessione. Non esegue script `upstream/`. Evita di mettere password in argomenti, URL o file versionati.

Le descrizioni vengono dagli header SQL: nessun inventario da aggiornare a mano. L’albero comprende anche nuovi tipi di file e nuove cartelle; il catalogo delle query indicizza i file `.sql` sotto `scripts/`.
