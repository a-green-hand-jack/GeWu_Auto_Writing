# PRX-only profile validation

This PR adds a conditional venue profile, not a new shared writing policy.
Selected PRX / Physical Review X activates it; physics alone, PRE, PRB, PRL,
PRX Quantum, and other explicit venues do not. The existing unspecified-venue
physics default still resolves to PRX, with that decision recorded first.

## Resource checks

```sh
python3 -m unittest discover -s tests -p 'test_prx_profile_resources.py' -v
```

The profile is self-contained and copied with the skill. It does not need the
metrics-only PR or its Python helper. Existing shared file bodies, constitution
and project policy are not rewritten.
Five entry/reference files only gain marked conditional hooks. The profile
uses the current six-file bundle; no deleted architecture is restored.

## Scope audit

For this change, base `93b207139ca6abed69f720f368e544061ed966c0` was compared
with the candidate. Removing the five `prx-profile` hook blocks restored those
five files byte-for-byte to the base. All other existing skill resources except
the selected PRX template files stayed unchanged. This checks source scope;
it does not prove that a model always follows the conditional correctly.

Reproduce the hook comparison from the repository root with the base available:

```python
from pathlib import Path
import re
import subprocess

base = '93b207139ca6abed69f720f368e544061ed966c0'
root = Path('.agents/skills/paperwriter-pi')
for name in ['SKILL.md', 'references/production.md', 'references/writing.md',
             'references/templates.md', 'references/checks.md']:
    path = root / name
    original = subprocess.check_output(['git', 'show', f'{base}:{path}'])
    without_hook = re.sub(
        r'<!-- prx-profile:start -->\n.*?<!-- prx-profile:end -->\n\n',
        '', path.read_text(), flags=re.S).encode()
    assert without_hook == original, name
```

## Same-model application checks

The prompts under `fixtures/prx-scope/` were run in fresh contexts against the
base and candidate using **gpt-6-astra/high**, one application per prompt per
variant. Each agent read the real skill and applicable references. It could
read local files but could not edit, browse or run manuscript/cloud jobs.
The author supplied the requirements inside each scenario; they are not
assertions about current conference or journal policy.

| Case | Base observation | Candidate observation |
|---|---|---|
| PRX theory | Preserved the requested structure and native references provisionally, while explicitly recognizing conflicting bundle prescriptions | Kept the coherent structure, analytic abstract and native bibliography; loaded PRX profile |
| AI/ML conference | Kept IEEEtran, quantitative abstract, contribution list, separate Limitations and experiment reporting | Same required features retained; PRX profile inactive |
| Mathematics | Kept amsart/amsplain, theorem/proof, proof strategy and sharpness | Same required features retained; PRX profile not loaded |
| Life sciences | Kept structured abstract, Methods, controls/replication and applicable ethics reporting | Same required features retained; PRX profile inactive |
| PRE | Honored explicit PRE over physics default; existing guides consulted | Honored explicit PRE; PRX profile not loaded |
| PRX Quantum | Treated as a different journal with the supplied template | Explicitly excluded PRX profile; retained supplied organization and quantities |

All cases kept unavailable manuscript, compilation and visual checks
unverified. The baseline PRX agent already resolved several instruction
conflicts in favor of this explicitly scoped request. The candidate makes
that behavior explicit; this single pair does not show a quality improvement.
Other venues retain the current upstream guidance and any remaining defects.

These are 12 short application runs, not replicated performance estimates,
full-paper quality evidence or validation of the deployed Pi/provider model.
Only the observed case-level decisions are reported; wording differs across
runs. Real-manuscript before/after review remains the next acceptance step.

## Template mechanics

A disposable probe based on the local PRX derivative compiled with an existing
REVTeX 4.2f installation: PDFLaTeX, BibTeX, then PDFLaTeX twice, all exit 0.
The one-page rendering was inspected: native APS reference separator, no
manual REFERENCES title or forced separate page, and native ruledtabular
double rules. Minor nameref/underfull-box warnings in the tiny fixture were
retained; no overfull or undefined-reference diagnostics remained.

This checks native template mechanics, not a real research manuscript's
quality, authorship or submission readiness. No private manuscripts, group
messages or screenshots are included in these fixtures.
