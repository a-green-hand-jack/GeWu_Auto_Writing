# Skills for the writing and review stages

Reference material this bundle loads at specific stages. It fills gaps the
constitution and the workflows deliberately leave to a dedicated pass: a
structured pre-submission proofread, a rendered-page visual contract, an explicit
anti-AI-tone white list, and a structure/argument guide.

They are reference material only. This bundle stays prompt-only: load the file
with `read` and apply its checks by inspecting the LaTeX and the rendered pages.
The Python scripts bundled under `proofreading/scripts/` are optional (they need
PDFs and extra dependencies); they are not part of this pipeline.

| File | Load when | What it adds |
|---|---|---|
| `proofreading/SKILL.md` | after compilation, before delivery | six systematic checks: abbreviations, math notation, introduction structure, grammar/style, figures/tables, statistics; report mode gives line-level findings |
| `visual-inspection.md` | whenever rendered pages exist | page-level layout contract: float proximity, clipping and widows, single-character lines, paragraph-tail density (last line should fill ~3/4 of the column), over-paragraphing, figure fit-height legibility, and the reporting contract |
| `anti-ai-tone.md` | after the draft is complete, before final assembly | white-list rewrite rules for machine-drafting tells; strictly information-conserving, never changes structure, claims, numbers, or citations |
| `scientific-writing.md` | while planning and drafting sections | argument-first structure: what each section must establish, abstract-as-argument, claims versus evidence |
| `academic-voice/SKILL.md` | prose passes | scholarly register instead of corporate tone |
| `better-usage/SKILL.md` | prose passes | subject/verb/object clarity, hidden actors, vague relations |
| `scientific-english-editor/SKILL.md` | prose passes | grammar, non-native English, sentence concision |

Boundaries that carry over: none of these may add, remove, weaken, or strengthen
a claim, number, equation, citation, or result. A skill that edits must not also
certify the same text; run at least one independent pass from a different
category (see `workflows/review.md`).

Attribution: `proofreading/` is Jakob Thumm's MIT-licensed paper-proofreading
skill; its own `LICENSE` and `README.md` are kept alongside, as that licence
requires.