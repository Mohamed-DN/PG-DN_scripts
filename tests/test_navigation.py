"""Behavioral tests: adding, moving and removing files updates all navigation."""
import contextlib
import io
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
import catalog
import pgdn
import validate


class NavigationTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        (self.root / 'scripts' / 'wal').mkdir(parents=True)
        (self.root / 'docs').mkdir()
        (self.root / 'README.md').write_text('<!-- BEGIN GENERATED COUNTS -->\n<!-- END GENERATED COUNTS -->\n<!-- BEGIN GENERATED TREE -->\n<!-- END GENERATED TREE -->\n')
        self.fixture = '-- Title: WAL test\n-- Description: Archive | status\n-- Postgres: 14+\n-- Privilege: pg_monitor\n-- Risk: read-only\n-- Source: original\n-- Runbook: runbooks/wal-growth.md\nSELECT 1;\n'

    def generate(self):
        result = catalog.outputs()
        for path, text in result.items():
            path.write_text(text, encoding='utf-8')
        return result

    def test_add_move_remove_and_idempotence(self):
        with patch.object(catalog, 'ROOT', self.root):
            path = self.root / 'scripts/wal/archive status.sql'
            path.write_text(self.fixture)
            first = self.generate()
            self.assertIn('archive status.sql', first[self.root / 'README.md'])
            self.assertIn('archive%20status.sql', first[self.root / 'scripts/wal/README.md'])
            self.assertIn('Archive \\| status', first[self.root / 'scripts/wal/README.md'])
            self.assertEqual(first, catalog.outputs())
            path.rename(path.with_name('moved.sql'))
            moved = self.generate()
            self.assertIn('moved.sql', moved[self.root / 'README.md'])
            self.assertNotIn('archive status.sql', moved[self.root / 'README.md'])
            path.with_name('moved.sql').unlink()
            removed = catalog.outputs()
            self.assertNotIn('moved.sql', removed[self.root / 'README.md'])
            self.assertIn('**0 script curati**', removed[self.root / 'README.md'])

    def test_check_calculation_does_not_write_files(self):
        with patch.object(catalog, 'ROOT', self.root):
            before = set(self.root.rglob('*'))
            catalog.outputs()
            self.assertEqual(before, set(self.root.rglob('*')))

    def test_hidden_work_is_excluded(self):
        (self.root / '.work').mkdir()
        (self.root / '.work/private.sql').touch()
        with patch.object(catalog, 'ROOT', self.root):
            self.assertNotIn('private.sql', '\n'.join(catalog.tree(self.root)))

    def test_runner_refuses_upstream_and_traversal(self):
        for name in ['upstream/vendor.sql', '../outside.sql']:
            with self.subTest(name=name), patch.object(sys, 'argv', ['pgdn', 'run', name]), contextlib.redirect_stderr(io.StringIO()):
                with self.assertRaises(SystemExit) as raised:
                    pgdn.main()
                self.assertEqual(2, raised.exception.code)

    def test_commented_safety_and_admin_action_are_rejected(self):
        (self.root / 'runbooks').mkdir()
        (self.root / 'runbooks/wal-growth.md').touch()
        path = self.root / 'scripts/wal/unsafe.sql'
        path.write_text(self.fixture + '\n-- \\set ON_ERROR_STOP on\n-- BEGIN READ ONLY;\n'
                        '-- SET LOCAL statement_timeout=\'15s\';\n-- SET LOCAL lock_timeout=\'2s\';\n'
                        'SELECT pg_terminate_backend(42);\n')
        with patch.object(catalog, 'ROOT', self.root), patch.object(validate, 'ROOT', self.root):
            errors = validate.validate()
            for expected in ['missing ON_ERROR_STOP', 'missing read-only transaction',
                             'missing statement timeout', 'missing lock timeout',
                             'mutating administrative function']:
                self.assertTrue(any(expected in e for e in errors), errors)


if __name__ == '__main__':
    unittest.main()
