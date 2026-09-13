# Whole-paper review

A bounded re-read of the finished manuscript with a different stance from the
author's: assume nothing is true until the source or the artifact shows it.
Read the complete set of sections, the plan, and `research/provenance.md`
together. Do not edit while reviewing.

## What to check

Dimensions, applied to substance rather than to prose polish:

- **Correctness** — signs, prefactors, units, quantifiers, assumptions, and
  whether each derivation or protocol supports the claim built on it.
- **Technical completeness** — the model/problem statement, the argument, the
  evidence, and the boundary of what is established are all present; no result
  arrives without its scope.
- **Clarity** — a reader who has not seen the source repository can follow the
  argument; every symbol and term is defined before use.
- **Scope discipline** — claim verbs match evidence levels; finite checks are
  not presented as proofs; limitations are specific.
- **References** — each citation is inspected content, supports the sentence it
  is attached to, and is not a decoration; the closest prior work is addressed.
- **Reproducibility** — numbers trace to a recorded transformation and source;
  the protocol is stated to the standard the domain expects.
- **Presentation** — structure, displays, and captions serve the argument.

Then load the domain review checklist in `references/domains/<domain>.md` and
apply it in addition to the shared dimensions above. When rendered pages
exist, also apply `references/domains/layout.md` page by page.

## Loaded checks for this stage

- `references/skills-imported/visual-inspection.md` — the page-level layout
  contract applied whenever rendered pages exist.
- `references/skills-imported/proofreading/SKILL.md` — the six systematic
  proofread checks (abbreviations, math notation, introduction structure,
  grammar/style, figures and tables, statistics).
- `references/skills-imported/anti-ai-tone.md` — the white-list rewrite rules
  for machine-drafting tells; information-conserving, structure-preserving.

A stage that edits must not also certify the same text: after any non-trivial
prose change, run at least one independent pass from a different category and
report its result.

## Visual review

Only claim a page-level observation after actually reading the rendered image
of that page. If the active model cannot read images, or rendering is
unavailable, record visual review as not performed and say so; never infer
visual quality from a compiler exit code, the LaTeX source, or a text
extraction. Any change to the PDF bytes invalidates the previous visual
review.

## Recording issues

For each issue record: a stable id, severity (`critical` / `blocker` /
`warning` / `info`), exact file and location, the independent check actually
performed, and the requested fix. Write the review into `research/validation.md`.

The outcome is `revise` or `ready_for_delivery_report`. There is no
"accepted" outcome: a passing review is a bounded consistency statement, never
scientific certification or submission approval.

## Revision discipline

- Fix factual defects with support; keep corrected content.
- Cascade every change to the abstract, conclusion, tables, bibliography, and
  provenance statements that depend on it.
- Work in bounded batches; after each batch re-run the affected consistency
  checks, recompile if needed, and re-inspect changed pages.
- Never revert a factual correction because an aesthetic judgement regressed.
- When the review finds an unsupported claim that cannot be supported, weaken
  the claim to what the evidence establishes and state the gap.
- Report unresolved issues explicitly. A round limit or a timeout stops the
  work; it never accepts it.
