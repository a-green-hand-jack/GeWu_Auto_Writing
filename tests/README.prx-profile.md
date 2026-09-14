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

For this change, base `b61f40d7ed1e4b4fffeed1b4d63511a4b3532927` was compared
with the candidate. Removing the five `prx-profile` hook blocks restored those
five files byte-for-byte to the base. All other existing skill resources except
the selected PRX template files stayed unchanged. This checks source scope;
it does not prove that a model always follows the conditional correctly.

Reproduce the hook comparison from the repository root with the base available:

```python
from pathlib import Path
import re
import subprocess

base = 'b61f40d7ed1e4b4fffeed1b4d63511a4b3532927'
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

## Frozen skill validation

The final executable skill under test is commit
`81b84956765d0a79d4e662d6d63811a27525181b`, skill tree
`9bcb54948747676d69d50e46ff2f0f1cd6adcfc9`. The baseline for actual manuscript
editing is `b61f40d7ed1e4b4fffeed1b4d63511a4b3532927`, skill tree
`0125dc52b0904d9302bfaf577fad3e33a4b8c8d4`. Subsequent validation-artifact commits
do not change these skill files.

### Routing applications

Eleven prompts under `fixtures/prx-scope/` were applied to the candidate by
**gpt-6-astra/high**, with a fresh context for each prompt. Each agent read the
real skill and required resources and returned an editorial plan. Local reads
and an evaluation report were allowed; manuscript edits, network access and
cloud jobs were excluded. These are author-specified synthetic requirements,
not statements of current journal/conference policy.

| Case | Observed decision |
|---|---|
| PRX theory | Loaded PRX profile; retained coherent sections, analytic abstract and native references |
| IEEE AI/ML | Did not load PRX profile; kept IEEEtran, quantitative abstract, contribution list, independent Limitations and experiment reporting |
| Mathematics | Did not load PRX profile; kept amsart/amsplain, theorem/proof, proof strategy and sharpness |
| Life sciences | Did not load PRX profile; kept structured abstract, Methods, controls/replication and applicable ethics reporting |
| PRE | Did not load PRX profile; retained explicit PRE and supplied template |
| PRX Quantum | Did not load PRX profile; retained supplied template, organization and quantities |
| Physics, no venue | Resolved existing default to PRX; required assessment record, loaded PRX profile |
| PRB | Did not load PRX profile; retained explicit PRB and supplied template |
| PRL | Did not load PRX profile; retained explicit PRL and supplied template |
| Physics, explicit neutral | Did not load PRX profile; used explicit neutral single-column article |
| PRX, exact author overrides | Loaded PRX profile but retained preprint/superscriptaddress and documented manual References heading |

All applications left unavailable scientific, policy, compilation and visual
checks unverified. A preliminary five-case interpretive matrix used a shared
context; it is not counted among these eleven fresh applications. There is
one application per case, so these observations are not replicated reliability
estimates. Applications ran through Codex subagents, not the repository's
deployed Pi/provider execution path. The earlier twelve paired plans on `93b2071/acdc3d1` are historical
checks, not the evidence for the final skill version reported here.

### Actual synthetic manuscript revision

See [the paired editing fixture](fixtures/prx-editing/README.md) for the common
brief, original manuscript, local evidence notes, exact source hashes, resulting
TeX/BibTeX, compile results and independent review. The two-reservoir example is
an explicitly synthetic validation document, not a research submission.

The paired applications use the same model/effort and input in separate
contexts. They perform actual editorial revisions, compilation and page
inspection. Scope is preservation of the stipulated science and application of
presentation rules; two synthetic bibliography records intentionally cannot
satisfy a research paper's literature coverage requirements.

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
