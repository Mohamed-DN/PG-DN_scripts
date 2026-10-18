"""The GitHub landing page must display the root home, not automation notes."""
from pathlib import Path
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
from validate import homepage_errors


class HomepageTest(unittest.TestCase):
    def test_automation_document_does_not_override_home(self):
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            (root / '.github/workflows').mkdir(parents=True)
            (root / 'README.md').write_text('# PG-DN_scripts\n')
            (root / '.github/AUTOMATION.md').write_text('# Automation\n')
            (root / '.github/workflows/README.md').write_text('# Workflows\n')
            self.assertEqual([], homepage_errors(root))

    def test_nested_priority_readme_is_rejected(self):
        for filename in ('README.md', 'readme.rst', 'Readme'):
            with self.subTest(filename=filename), tempfile.TemporaryDirectory() as folder:
                root = Path(folder)
                (root / '.github').mkdir()
                (root / '.github' / filename).touch()
                self.assertEqual(1, len(homepage_errors(root)))


if __name__ == '__main__':
    unittest.main()
