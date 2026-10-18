"""Ensure a failed lab creation can never delete an existing unrelated container."""
from pathlib import Path
import subprocess
import sys
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).parent))
from integration import Lab


class LabOwnershipTest(unittest.TestCase):
    def test_cleanup_refuses_foreign_container(self):
        lab = Lab('podman', '18')
        lab.created = True  # A run attempt can fail because the name already exists.
        foreign = subprocess.CompletedProcess([], 0, stdout='another-process\n', stderr='')
        with patch.object(lab, 'command', return_value=foreign) as command:
            lab.close()
        self.assertEqual(1, command.call_count)
        self.assertEqual('inspect', command.call_args.args[0])

    def test_cleanup_removes_only_matching_owner(self):
        lab = Lab('podman', '18')
        lab.created = True
        owned = subprocess.CompletedProcess([], 0, stdout=lab.owner + '\n', stderr='')
        with patch.object(lab, 'command', return_value=owned) as command:
            lab.close()
        self.assertEqual(('rm', '-f', '-v', lab.name), command.call_args.args)


if __name__ == '__main__':
    unittest.main()
