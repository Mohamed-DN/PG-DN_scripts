"""Detect corruption and unintended changes in imported, attributed files."""
import hashlib
import json
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[2]


class UpstreamIntegrityTest(unittest.TestCase):
    def test_pinned_manifest_files_match(self):
        manifests = sorted((ROOT / '_support/upstream').glob('*/manifest.json'))
        self.assertGreaterEqual(len(manifests), 4)
        seen = 0
        for manifest_path in manifests:
            manifest = json.loads(manifest_path.read_text(encoding='utf-8'))
            self.assertRegex(manifest['commit'], r'^[0-9a-f]{40}$')
            self.assertTrue(manifest['license'])
            actual = {p.relative_to(manifest_path.parent).as_posix()
                      for p in manifest_path.parent.rglob('*') if p.is_file()}
            expected = {entry['path'] for entry in manifest['files']} | {'README.md', 'manifest.json'}
            self.assertEqual(expected, actual, 'Unmanifested file or missing upstream attribution')
            for entry in manifest['files']:
                with self.subTest(vendor=manifest['repository'], path=entry['path']):
                    path = manifest_path.parent / entry['path']
                    self.assertTrue(path.resolve().is_relative_to(manifest_path.parent.resolve()))
                    self.assertEqual(entry['sha256'], hashlib.sha256(path.read_bytes()).hexdigest())
                    self.assertIn('/blob/' + manifest['commit'] + '/', entry['url'])
                    seen += 1
        self.assertGreater(seen, 100)


if __name__ == '__main__':
    unittest.main()
