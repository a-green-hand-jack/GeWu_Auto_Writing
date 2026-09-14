"""Portable resource checks; behavior is exercised by the accompanying prompts."""
import json
from pathlib import Path
import re
import unittest

SKILL = Path(__file__).resolve().parents[1] / '.agents/skills/paperwriter-pi'


class PrxProfileResourcesTest(unittest.TestCase):
    def test_stage_hook_links_resolve(self):
        for relative in ['SKILL.md', 'references/production.md',
                         'references/writing.md', 'references/templates.md',
                         'references/checks.md']:
            path = SKILL / relative
            blocks = re.findall(r'<!-- prx-profile:start -->(.*?)<!-- prx-profile:end -->',
                                path.read_text(), re.S)
            self.assertEqual(len(blocks), 1, relative)
            links = re.findall(r'\]\(([^)]+)\)', blocks[0])
            self.assertTrue(links, relative)
            for link in links:
                with self.subTest(path=relative, link=link):
                    self.assertTrue((path.parent / link.split('#')[0]).is_file())

    def test_profile_and_template_are_packaged_together(self):
        self.assertTrue((SKILL / 'references/venues/prx.md').is_file())
        template = SKILL / 'templates/prx-official'
        metadata = json.loads((template / 'metadata.json').read_text())
        self.assertEqual(metadata['venue_id'], 'prx')
        self.assertTrue((template / metadata['entrypoint']).is_file())
        self.assertTrue((template / 'SOURCE-LICENSE.txt').is_file())


if __name__ == '__main__':
    unittest.main()
