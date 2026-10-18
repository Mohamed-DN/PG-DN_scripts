#!/usr/bin/env python3
"""Validate curated SQL metadata, safety conventions and repository links."""
from pathlib import Path
import re
import sys
from urllib.parse import unquote

from catalog import ROOT, FIELDS, scripts


def validate():
    errors = []
    items = scripts()
    if not items:
        errors.append('No curated scripts found')
    for item in items:
        name = item['path']
        text = (ROOT / name).read_text(encoding='utf-8')
        for key in FIELDS:
            if not item.get(key.lower()):
                errors.append(f'{name}: missing {key} header')
        active = re.sub(r'/\*.*?\*/', '', text, flags=re.S)
        active = '\n'.join(line for line in active.splitlines() if not line.lstrip().startswith('--'))
        for pattern, label in [(r'^\s*\\set\s+ON_ERROR_STOP\s+(on|1)\s*$', 'ON_ERROR_STOP'),
                               (r'^\s*BEGIN\s+(?:TRANSACTION\s+)?READ\s+ONLY\s*;', 'read-only transaction'),
                               (r'^\s*SET\s+LOCAL\s+statement_timeout\s*=', 'statement timeout'),
                               (r'^\s*SET\s+LOCAL\s+lock_timeout\s*=', 'lock timeout')]:
            if not re.search(pattern, active, re.I | re.M):
                errors.append(f'{name}: missing {label}')
        if re.search(r'\bpg_(?:terminate_backend|cancel_backend|reload_conf|rotate_logfile|switch_wal|promote|replication_slot_advance|drop_replication_slot|create_\w*replication_slot|stat_reset\w*)\s*\(', active, re.I):
            errors.append(f'{name}: mutating administrative function in diagnostic script')
        if re.search(r'\\(?:!|copy\b|gexec\b|i\b|ir\b|include\b|include_relative\b)', active, re.I):
            errors.append(f'{name}: shell, copy, dynamic execution or external include is not permitted')
        if item.get('risk') != 'read-only':
            errors.append(f'{name}: only read-only diagnostics belong in scripts/')
        rb = item.get('runbook', '')
        if not (ROOT / rb).is_file():
            errors.append(f'{name}: missing runbook {rb}')
    # Validate authored docs, not the internal relative links of unchanged vendor sources.
    for path in ROOT.rglob('*.md'):
        rel = path.relative_to(ROOT)
        if any(x in {'.git', '.work', '__pycache__', 'test-results'} for x in rel.parts) or rel.parts[0] == 'upstream':
            continue
        text = path.read_text(encoding='utf-8-sig')
        if len(re.findall(r'^```', text, re.M)) % 2:
            errors.append(f'{rel}: unclosed code fence')
        for target in re.findall(r'\]\(([^)]+)\)', text):
            target = target.split('#', 1)[0].strip('<>')
            if not target or re.match(r'[a-zA-Z]+:', target):
                continue
            if not (path.parent / unquote(target)).exists():
                errors.append(f'{rel}: broken link {target}')
    return errors


if __name__ == '__main__':
    problems = validate()
    for problem in problems:
        print(problem)
    print(f'{len(scripts())} curated scripts; {len(problems)} validation errors')
    sys.exit(bool(problems))
