#!/usr/bin/env python3
"""Find and run curated PostgreSQL diagnostics using an existing libpq connection."""
import argparse
import os
from pathlib import Path
import shutil
import subprocess
import sys

from catalog import ROOT, scripts


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest='command', required=True)
    find = commands.add_parser('list', help='Search names and descriptions')
    find.add_argument('--search', default='')
    run = commands.add_parser('run', help='Run one curated script with psql -X')
    run.add_argument('script', help='Repository-relative script path')
    args = parser.parse_args()
    if args.command == 'list':
        for item in scripts():
            if args.search.casefold() in str(item).casefold():
                print(f"{item['path']}  |  {item.get('description', '')}")
        return 0
    candidate = (ROOT / args.script).resolve()
    allowed = {str((ROOT / s['path']).resolve()) for s in scripts()}
    if str(candidate) not in allowed or not candidate.is_relative_to((ROOT / 'scripts').resolve()):
        parser.error('Choose an existing SQL file under scripts/ (upstream is excluded)')
    psql = shutil.which('psql')
    if not psql:
        parser.error('psql not found. Install the PostgreSQL client and configure PGSERVICE or PGHOST/PGDATABASE.')
    env = os.environ.copy()
    # A second fence; script headers also declare read-only transactions and timeouts.
    env['PGOPTIONS'] = env.get('PGOPTIONS', '') + ' -c default_transaction_read_only=on -c statement_timeout=15000 -c lock_timeout=2000'
    try:
        return subprocess.run([psql, '-X', '-w', '-v', 'ON_ERROR_STOP=1', '-f', str(candidate)], env=env).returncode
    except KeyboardInterrupt:
        return 130


if __name__ == '__main__':
    sys.exit(main())
