# Verifica riproducibile

[← Home](../README.md) · [Risultati](../docs/VALIDATION.md)

```console
python -m unittest discover -s tests -v
python tools/validate.py
python tools/catalog.py --check
python tests/integration.py --engine podman --versions 14 15 16 17 18
python tests/replication.py --engine podman --version 18
```

L’integrazione usa container nuovi con prefisso `pgdn-test-`, senza porte pubblicate e senza volumi dell’host. Elimina esclusivamente i container creati dal proprio processo. Non usa database o container preesistenti.

I test eseguono le query curate con errori SQL bloccanti e verificano anche connessione con `pg_monitor`, fixture non vuote, rifiuto delle scritture e ripristino di un dump logico. Gli script esterni restano esclusi dall’esecuzione automatica. Leggere il rapporto per distinguere query eseguite, guardie di versione e limiti di copertura.
