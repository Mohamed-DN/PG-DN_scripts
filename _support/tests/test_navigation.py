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
        (self.root / '_support/docs').mkdir(parents=True)
        (self.root / 'README.md').write_text('<!-- BEGIN GENERATED COUNTS -->\n<!-- END GENERATED COUNTS -->\n<!-- BEGIN GENERATED TREE -->\n<!-- END GENERATED TREE -->\n<!-- BEGIN GENERATED PROCEDURES -->\n<!-- END GENERATED PROCEDURES -->\n')
        self.fixture = '-- Title: WAL test\n-- Description: Archive | status\n-- Postgres: 14+\n-- Privilege: pg_monitor\n-- Risk: read-only\n-- Source: original\n-- Runbook: procedures/wal-growth.md\nSELECT 1;\n'

    def generate(self):
        result = catalog.outputs()
        for path, text in result.items():
            path.write_text(text, encoding='utf-8')
        return result

    def test_add_move_remove_and_idempotence(self):
        with patch.object(catalog, 'ROOT', self.root):
            path = self.root / 'scripts/wal/archive status.sql'
            path.write_text(self.fixture)
            overview = catalog.library_map(self.root / 'scripts')
            self.assertIn('wal/', overview)
            self.assertIn('1 script', overview)
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
            self.assertNotIn('wal/', catalog.library_map(self.root / 'scripts'))

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

    def test_procedure_map_tracks_add_rename_and_remove(self):
        folder = self.root / 'procedures'
        folder.mkdir()
        (folder / 'README.md').write_text('# Index\n\n<!-- BEGIN GENERATED INDEX -->\n<!-- END GENERATED INDEX -->\n', encoding='utf-8')
        path = folder / 'locks.md'
        path.write_text('# Blocchi e attese\n\nUsare per sessioni bloccate. Continuare con la diagnosi.\n', encoding='utf-8')
        with patch.object(catalog, 'ROOT', self.root):
            self.assertIn('locks.md', catalog.procedure_map())
            self.assertIn('Blocchi e attese', catalog.procedure_map())
            self.assertNotIn('README.md', catalog.procedure_map())
            added = self.generate()
            self.assertIn('[Blocchi e attese](locks.md)', added[folder / 'README.md'])
            self.assertIn('Usare per sessioni bloccate.', added[folder / 'README.md'])
            self.assertNotIn('Continuare con la diagnosi.', added[folder / 'README.md'])
            (folder / 'new area').mkdir()
            path = path.rename(folder / 'new area/blocked sessions.md')
            self.assertNotIn('locks.md', catalog.procedure_map())
            self.assertIn('blocked sessions.md', catalog.procedure_map())
            moved = self.generate()
            self.assertIn('new%20area/blocked%20sessions.md', moved[folder / 'README.md'])
            self.assertIn('blocked sessions.md', moved[self.root / 'README.md'])
            path.unlink()
            removed = self.generate()
            self.assertNotIn('blocked sessions.md', catalog.procedure_map())
            self.assertNotIn('blocked%20sessions.md', removed[folder / 'README.md'])
            self.assertNotIn('new area/', removed[self.root / 'README.md'])

    def test_script_map_is_collapsed_and_table_is_visible(self):
        (self.root / 'scripts/wal/status.sql').write_text(self.fixture)
        with patch.object(catalog, 'ROOT', self.root):
            content = catalog.outputs()[self.root / 'scripts/wal/README.md']
            self.assertIn('<details>\n<summary>', content)
            self.assertLess(content.index('<details>'), content.index('```text'))
            self.assertLess(content.index('status.sql'), content.index('</details>'))
            self.assertLess(content.index('</details>'), content.index('| Script |'))
            self.assertNotIn('```console', content)
            self.assertIn('Come eseguire gli script', content)
            self.assertIn('## Scegli uno script', content)

    def test_home_tree_shows_only_the_script_library(self):
        (self.root / '_support/technical-only.md').touch()
        with patch.object(catalog, 'ROOT', self.root):
            home = catalog.outputs()[self.root / 'README.md']
            self.assertIn('scripts/', home)
            self.assertNotIn('technical-only.md', home)
            self.assertNotIn('_support/', home)

    def test_runner_refuses_upstream_and_traversal(self):
        for name in ['upstream/vendor.sql', '../outside.sql']:
            with self.subTest(name=name), patch.object(sys, 'argv', ['pgdn', 'run', name]), contextlib.redirect_stderr(io.StringIO()):
                with self.assertRaises(SystemExit) as raised:
                    pgdn.main()
                self.assertEqual(2, raised.exception.code)

    def test_commented_safety_and_admin_action_are_rejected(self):
        (self.root / 'procedures').mkdir()
        (self.root / 'procedures/wal-growth.md').touch()
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
