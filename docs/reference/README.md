# Riferimenti PostgreSQL

Questa sezione integra il catalogo read-only con guide brevi per il client `psql` e per alcune azioni amministrative. Gli esempi usano nomi segnaposto e vanno revisionati prima dell'esecuzione.

- [Uso di psql](psql-cheatsheet.md): connessione, file SQL, metacomandi e quoting sicuro delle variabili.
- [Azioni amministrative](administration-actions.md): esempi parametrizzati per ruoli, schemi, grant, `ANALYZE` e `REINDEX CONCURRENTLY`, con impatto e verifiche preliminari.

Le query diagnostiche rimangono in `scripts/`. Gli esempi di questo riferimento possono modificare ruoli, ACL, statistiche o indici; hanno una revisione manuale separata e non vengono eseguiti dai controlli read-only.
