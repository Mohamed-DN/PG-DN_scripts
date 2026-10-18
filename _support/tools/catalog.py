#!/usr/bin/env python3
"""Deterministic repository navigation, with no third party dependencies."""
from __future__ import annotations

import argparse
import json
from pathlib import Path
import re
from urllib.parse import quote

ROOT = Path(__file__).resolve().parents[2]
IGNORED = {'.git', '.work', '__pycache__', 'test-results', '.pytest_cache'}
FIELDS = ('Title', 'Description', 'Postgres', 'Privilege', 'Risk', 'Source', 'Runbook')
LABELS = {
    'scripts': 'Script operativi', 'administration': 'Amministrazione',
    'security': 'Sicurezza e accessi', 'monitoring': 'Monitoraggio',
    'performance': 'Prestazioni', 'maintenance': 'Manutenzione',
    'replication': 'Replica', 'wal': 'WAL e archiviazione', 'backup': 'Backup',
}
COLORS = {
    'administration': '🟦', 'backup': '🟩', 'maintenance': '🟧',
    'monitoring': '🟪', 'performance': '🟨', 'replication': '🔷',
    'security': '🟥', 'wal': '🔶',
}
PURPOSES = {
    'scripts': 'Libreria PostgreSQL integrata e commentata',
    'administration': 'Istanza, configurazione, connessioni e cataloghi',
    'administration/inventory': 'Oggetti, vincoli, tipi, partizioni e dipendenze',
    'administration/connections': 'Sessioni, transazioni e occupazione connessioni',
    'administration/configuration': 'Parametri effettivi, capacità e impostazioni operative',
    'monitoring': 'Controlli quotidiani, attività e trend operativi',
    'monitoring/activity': 'Attese, blocchi, transazioni e connessioni SSL',
    'monitoring/statistics': 'Contatori database, cache, SLRU e checkpoint',
    'monitoring/capacity': 'Dimensioni, crescita e spazio allocato',
    'performance': 'Query, indici, statistiche del planner e I/O',
    'performance/queries': 'Top SQL, tempi e file temporanei',
    'performance/indexes': 'Indici, vincoli, FK, utilizzo e candidati da analizzare',
    'performance/io': 'Letture, scritture, timing e buffer cache',
    'performance/statistics': 'Distribuzione dati, partizioni, HOT e sequenze',
    'maintenance': 'Vacuum, freeze, spazio e avanzamento operazioni',
    'maintenance/vacuum': 'Tuple morte, transazioni lunghe, XID e autovacuum',
    'maintenance/bloat': 'Dimensioni heap, indici e TOAST; indicatori da verificare',
    'maintenance/progress': 'Progresso VACUUM, ANALYZE, COPY, CLUSTER e indici',
    'replication': 'Replica fisica/logica, consumer e retention',
    'replication/physical': 'Sender, receiver, replay e conflitti dello standby',
    'replication/logical': 'Publication, subscription e sincronizzazione tabelle',
    'replication/slots': 'Slot, xmin, WAL trattenuti e margine di retention',
    'wal': 'Generazione WAL, archiviazione e checkpoint',
    'wal/archive': 'Archiver, fallimenti e marker pronti da archiviare',
    'wal/retention': 'Contatori, segmenti e cause della crescita WAL',
    'backup': 'Diagnosi backup fisico e stato recovery',
    'backup/inspection': 'Identità cluster, recovery e attività di base backup',
    'security': 'Ruoli, accessi, ACL e row-level security',
    'security/roles': 'Membership, ereditarietà e attributi dei ruoli',
    'security/privileges': 'Grant, privilegi effettivi, RLS e regole di accesso',
}


def library_map(directory: Path, *, files: bool = False) -> str:
    """An annotated, live-count ASCII tree like the Oracle library map."""
    lines = [directory.name + '/', '|']
    def visit(folder, prefix=''):
        directories = sorted(p for p in folder.iterdir() if p.is_dir() and p.name not in IGNORED
                             and any(p.rglob('*.sql')))
        entries = directories + (sorted(folder.glob('*.sql')) if files else [])
        for i, path in enumerate(entries):
            last = i == len(entries) - 1
            accent = COLORS.get(path.name, '') + ' ' if path.is_dir() and path.parent == ROOT / 'scripts' else ''
            label = prefix + '+-- ' + accent + path.name + ('/' if path.is_dir() else '')
            if path.is_dir():
                key = path.relative_to(ROOT / 'scripts').as_posix()
                count = len(list(path.rglob('*.sql')))
                detail = f'{count} script · ' + PURPOSES.get(key, path.name.replace('-', ' ').replace('_', ' '))
            else:
                detail = metadata(path).get('title', 'Da documentare')
            lines.append(f'{label:<52} ← {detail}')
            if path.is_dir():
                visit(path, prefix + ('    ' if last else '|   '))
    visit(directory)
    return '```text\n' + '\n'.join(lines) + '\n```'


def metadata(path: Path) -> dict[str, str]:
    text = path.read_text(encoding='utf-8-sig')
    result = {key.lower(): value.strip() for key, value in
              re.findall(r'^--\s*(' + '|'.join(FIELDS) + r'):\s*(.+)$', text, re.M)}
    result['path'] = path.relative_to(ROOT).as_posix()
    return result


def scripts() -> list[dict[str, str]]:
    return [metadata(p) for p in sorted((ROOT / 'scripts').rglob('*.sql'))]


def procedures() -> list[dict[str, str]]:
    result = []
    for path in sorted((ROOT / 'procedures').rglob('*.md')):
        if path.name.lower() == 'readme.md' or any(part in IGNORED for part in path.parts):
            continue
        text = path.read_text(encoding='utf-8-sig')
        heading = re.search(r'^#\s+(.+)$', text, re.M)
        title = heading.group(1) if heading else path.stem.replace('-', ' ')
        paragraphs = re.split(r'\n\s*\n', text)
        summary = next((p.strip() for p in paragraphs if p.strip() and not p.lstrip().startswith(('#', '[', '```', '<!--'))), '')
        summary = re.sub(r'\[([^\]]+)\]\([^)]+\)', r'\1', summary).replace('\n', ' ')
        summary = re.split(r'(?<=[.!?])\s+', summary, maxsplit=1)[0]
        if len(summary) > 220:
            summary = summary[:217].rsplit(' ', 1)[0] + '…'
        result.append({'path': path.relative_to(ROOT / 'procedures').as_posix(), 'title': title, 'summary': summary})
    return result


def procedure_map() -> str:
    """List procedures recursively, including future scenario subdirectories."""
    folder = ROOT / 'procedures'
    items = {folder / item['path']: item for item in procedures()}
    lines = ['procedures/', '|']
    def visit(directory, prefix=''):
        if not directory.exists():
            return
        folders = sorted(p for p in directory.iterdir() if p.is_dir() and any(x.is_relative_to(p) for x in items))
        entries = folders + sorted(p for p in items if p.parent == directory)
        for i, path in enumerate(entries):
            label = prefix + '+-- ' + path.name + ('/' if path.is_dir() else '')
            detail = f'{sum(x.is_relative_to(path) for x in items)} procedure' if path.is_dir() else items[path]['title']
            lines.append(f'{label:<38} ← {detail}')
            if path.is_dir():
                visit(path, prefix + ('    ' if i == len(entries) - 1 else '|   '))
    visit(folder)
    return '```text\n' + '\n'.join(lines) + '\n```'


def procedure_table() -> str:
    rows = ['| Procedura | Quando usarla |', '| :-- | :-- |']
    for item in procedures():
        rows.append(f"| [{escape(item['title'])}]({quote(item['path'], safe='/.-')}) | {escape(item['summary'])} |")
    return '\n'.join(rows)


def tree(directory: Path, prefix: str = '', extra: tuple[Path, ...] = ()) -> list[str]:
    candidates = set(directory.iterdir()) | {p for p in extra if p.parent == directory}
    entries = sorted((p for p in candidates
                      if p.name not in IGNORED and not p.is_symlink()),
                     key=lambda p: (not p.is_dir(), p.name.lower()))
    lines = []
    for i, p in enumerate(entries):
        last = i == len(entries) - 1
        lines.append(prefix + ('└── ' if last else '├── ') + p.name + ('/' if p.is_dir() else ''))
        if p.is_dir():
            lines.extend(tree(p, prefix + ('    ' if last else '│   '), extra))
    return lines


def replace_block(text: str, name: str, value: str) -> str:
    start, end = f'<!-- BEGIN GENERATED {name} -->', f'<!-- END GENERATED {name} -->'
    if text.count(start) != 1 or text.count(end) != 1:
        raise ValueError(f'Exactly one marker pair required: {name}')
    before, rest = text.split(start)
    _, after = rest.split(end)
    return before + start + '\n' + value.rstrip() + '\n' + end + after


def escape(text: str) -> str:
    return text.replace('|', '\\|').replace('\n', ' ')


def table(items: list[dict[str, str]], base: Path) -> str:
    rows = ['| Script | Scopo | PostgreSQL | Privilegi | Procedura |', '| :-- | :-- | :-- | :-- | :-- |']
    import os
    for item in items:
        relative = Path(os.path.relpath(ROOT / item['path'], base)).as_posix()
        rb = Path(os.path.relpath(ROOT / item['runbook'], base)).as_posix() if item.get('runbook') else ''
        procedure = f'[Apri]({quote(rb, safe="/.-")})' if rb else 'Da collegare'
        rows.append(f"| [{Path(item['path']).name}]({quote(relative, safe='/.-')}) | "
                    f"{escape(item.get('description', 'Da revisionare: aggiungere header'))} | "
                    f"{escape(item.get('postgres', '?'))} | {escape(item.get('privilege', '?'))} | {procedure} |")
    return '\n'.join(rows)


def outputs() -> dict[Path, str]:
    items = scripts()
    result = {}
    dirs = [ROOT / 'scripts'] + sorted(p for p in (ROOT / 'scripts').rglob('*') if p.is_dir() and p.name not in IGNORED)
    for directory in dirs:
        selected = [x for x in items if (ROOT / x['path']).is_relative_to(directory)]
        title = LABELS.get(directory.name, directory.name.replace('-', ' ').replace('_', ' ').capitalize())
        import os
        home = Path(os.path.relpath(ROOT / 'README.md', directory)).as_posix()
        safety = Path(os.path.relpath(ROOT / '_support/docs/SAFETY.md', directory)).as_posix()
        quickstart = Path(os.path.relpath(ROOT / '_support/docs/QUICKSTART.md', directory)).as_posix()
        children = sorted(p for p in directory.iterdir() if p.is_dir() and p.name not in IGNORED)
        nav = ' · '.join(f'[{p.name}]({p.name}/README.md)' for p in children)
        diagram = ''
        if children:
            diagram = '```mermaid\nflowchart TD\n    root["' + title + '"]\n'
            for i, child in enumerate(children):
                count = sum((ROOT / x['path']).is_relative_to(child) for x in selected)
                diagram += f'    root --> c{i}["{child.name} · {count} query"]\n'
            diagram += '```\n\n'
        result[directory / 'README.md'] = (f'# {title}\n\n[← Home]({home}) · [Come eseguire gli script]({quickstart}) · [Sicurezza e privilegi]({safety})\n\n'
            f'**{len(selected)} query** · client `psql` · diagnosi in transazione read-only.\n\n'
            'Leggere header, versione e privilegi prima dell’esecuzione. I contatori di attività sono cumulativi: '
            'un valore isolato non giustifica un’azione correttiva.\n\n' + (nav + '\n\n' if nav else '') +
            '<details>\n<summary>🗂️ Mappa della libreria · apri / chiudi</summary>\n\n' +
            library_map(directory, files=True) + '\n\n' + diagram + '</details>\n\n' +
            '## Scegli uno script\n\nTrova il controllo nella tabella, apri il file e leggi scopo, versione e privilegi. '
            'La colonna **Procedura** spiega come interpretare il risultato e scegliere il passo successivo.\n\n' +
            table(selected, directory) + '\n\n> Indice generato da `python _support/tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.\n')
    result[ROOT / '_support/catalog.json'] = json.dumps({'schema_version': 1, 'scripts': items}, ensure_ascii=False, indent=2) + '\n'
    result[ROOT / '_support/docs/CATALOG.md'] = '# Catalogo degli script curati\n\n[← Home](../../README.md) · [Origini e correzioni](SOURCE_REVIEW.md)\n\n' + table(items, ROOT / '_support/docs') + '\n'
    procedure_index = ROOT / 'procedures/README.md'
    if procedure_index.exists():
        text = procedure_index.read_text(encoding='utf-8')
        if '<!-- BEGIN GENERATED INDEX -->' in text:
            result[procedure_index] = replace_block(text, 'INDEX', procedure_table())
    readme = (ROOT / 'README.md').read_text(encoding='utf-8')
    readme = replace_block(readme, 'COUNTS', f'**{len(items)} script curati** · PostgreSQL 14–18')
    if '<!-- BEGIN GENERATED MAP -->' in readme:
        readme = replace_block(readme, 'MAP', library_map(ROOT / 'scripts'))
    if '<!-- BEGIN GENERATED PROCEDURES -->' in readme:
        readme = replace_block(readme, 'PROCEDURES', procedure_map())
    readme = replace_block(readme, 'TREE', library_map(ROOT / 'scripts', files=True))
    result[ROOT / 'README.md'] = readme
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check', action='store_true', help='Exit 1 if navigation is stale')
    args = parser.parse_args()
    stale = []
    for path, content in outputs().items():
        previous = path.read_text(encoding='utf-8') if path.exists() else None
        if previous != content:
            stale.append(path.relative_to(ROOT).as_posix())
            if not args.check:
                path.write_text(content, encoding='utf-8', newline='\n')
    if args.check and stale:
        print('Navigation out of date: ' + ', '.join(stale))
        return 1
    print(('Would update ' if args.check else 'Updated ') + str(len(stale)) + ' files')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
