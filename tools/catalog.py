#!/usr/bin/env python3
"""Deterministic repository navigation, with no third party dependencies."""
from __future__ import annotations

import argparse
import json
from pathlib import Path
import re
from urllib.parse import quote

ROOT = Path(__file__).resolve().parents[1]
IGNORED = {'.git', '.work', '__pycache__', 'test-results', '.pytest_cache'}
FIELDS = ('Title', 'Description', 'Postgres', 'Privilege', 'Risk', 'Source', 'Runbook')
LABELS = {
    'scripts': 'Script operativi', 'administration': 'Amministrazione',
    'security': 'Sicurezza e accessi', 'monitoring': 'Monitoraggio',
    'performance': 'Prestazioni', 'maintenance': 'Manutenzione',
    'replication': 'Replica', 'wal': 'WAL e archiviazione', 'backup': 'Backup',
}


def metadata(path: Path) -> dict[str, str]:
    text = path.read_text(encoding='utf-8-sig')
    result = {key.lower(): value.strip() for key, value in
              re.findall(r'^--\s*(' + '|'.join(FIELDS) + r'):\s*(.+)$', text, re.M)}
    result['path'] = path.relative_to(ROOT).as_posix()
    return result


def scripts() -> list[dict[str, str]]:
    return [metadata(p) for p in sorted((ROOT / 'scripts').rglob('*.sql'))]


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
    rows = ['| Script | Scopo | PostgreSQL | Privilegi |', '| :-- | :-- | :-- | :-- |']
    import os
    for item in items:
        relative = Path(os.path.relpath(ROOT / item['path'], base)).as_posix()
        rows.append(f"| [{Path(item['path']).name}]({quote(relative, safe='/.-')}) | "
                    f"{escape(item.get('description', 'Da revisionare: aggiungere header'))} | "
                    f"{escape(item.get('postgres', '?'))} | {escape(item.get('privilege', '?'))} |")
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
        safety = Path(os.path.relpath(ROOT / 'docs/SAFETY.md', directory)).as_posix()
        children = sorted(p for p in directory.iterdir() if p.is_dir() and p.name not in IGNORED)
        nav = ' · '.join(f'[{p.name}]({p.name}/README.md)' for p in children)
        diagram = ''
        if children:
            diagram = '```mermaid\nflowchart TD\n    root["' + title + '"]\n'
            for i, child in enumerate(children):
                count = sum((ROOT / x['path']).is_relative_to(child) for x in selected)
                diagram += f'    root --> c{i}["{child.name} · {count} query"]\n'
            diagram += '```\n\n'
        example = (f"```console\npython tools/pgdn.py run {selected[0]['path']}\n```\n\n"
                   'Comando da eseguire dalla radice del checkout.\n\n') if selected else ''
        result[directory / 'README.md'] = (f'# {title}\n\n[← Home]({home}) · [Sicurezza e privilegi]({safety})\n\n'
            f'**{len(selected)} query** · client `psql` · diagnosi in transazione read-only.\n\n'
            'Leggere header, versione e privilegi prima dell’esecuzione. Le statistiche sono cumulative: '
            'un valore isolato non giustifica un’azione correttiva.\n\n' + (nav + '\n\n' if nav else '') +
            diagram + example + table(selected, directory) + '\n\n> Indice generato da `python tools/catalog.py`; modificare gli header SQL per aggiornare le descrizioni.\n')
    result[ROOT / 'catalog.json'] = json.dumps({'schema_version': 1, 'scripts': items}, ensure_ascii=False, indent=2) + '\n'
    result[ROOT / 'docs/CATALOG.md'] = '# Catalogo degli script curati\n\n[← Home](../README.md) · [Origini e correzioni](SOURCE_REVIEW.md)\n\n' + table(items, ROOT / 'docs') + '\n'
    readme = (ROOT / 'README.md').read_text(encoding='utf-8')
    readme = replace_block(readme, 'COUNTS', f'**{len(items)} script curati** · PostgreSQL 14–18 · [Catalogo ricercabile](docs/CATALOG.md) · [Fonti esterne](upstream/README.md)')
    readme = replace_block(readme, 'TREE', '```text\nPG-DN_scripts/\n' + '\n'.join(tree(ROOT, extra=tuple(result))) + '\n```')
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
