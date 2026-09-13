# Formal-publication preflight

Run this checklist on the complete writable `WORKSPACE` before calling the
result a formal manuscript. Use only Pi's native `read`, `write`, `edit`,
`bash`, `grep`, `find`, and `ls` tools. These checks establish presentation
and source consistency only; they do not establish scientific truth.

## 1. Manuscript boundary

- Confirm `paper/main.tex` exists and every `\input{}` or `\include{}` target
  exists inside `paper/`.
- Confirm all generated paper files are inside `WORKSPACE`; source files remain
  untouched.
- Confirm the paper has a title, author field, abstract, scientific sections,
  limitations/discussion, conclusion, and references.
- Use one house template for the batch: this project's default is the official
  APS PRX entrypoint `templates/prx-official/apstemplate.tex`. Do not use
  `article`, `amsart`, PRE, PRL, or `pre-generic` for this batch. Do not add a
  table of contents unless requested.
- Check that the document class, bibliography style, hyperlink policy, heading
  hierarchy, and front matter match the other papers in the same batch.

## 2. Publication metadata firewall

Search only the manuscript sources under `paper/`, excluding `research/`.
Review every hit rather than relying on one broad count. The following must
not occur in the title, author field, abstract, body, caption, conclusion, or
bibliography unless the user explicitly requests a software/artifact paper:

```bash
grep -RniE 'GitLab|GitHub|github\.com|gitlab\.com|README|\.md\b|\.py\b|\.sh\b|\.yaml\b|\.yml\b|\.json\b|run[-_ ]?id|commit|hash|sandbox|bwrap|provider|agent|model name|PaperWriter|Pi process|platform rank|issue tracker|source path|local path' paper/
grep -RniE '/home/|/Users/|[A-Za-z]:\\|https?://' paper/
```

The second command will also find legitimate scholarly DOI/URLs. Inspect each
hit: retain only a necessary scholarly citation or venue-required artifact
link. Move internal locators, commands, hashes, timestamps, and file names to
`research/provenance.md`.

Check front matter specifically:

```bash
grep -RniE '^\\(title|author\)|Author information pending|source-bound expository draft|Solution[ _-]?[0-9]+|top[ _-]?30|Anonymous' paper/
```

`Anonymous` is allowed when anonymity is intentional. Repository identifiers,
platform names, and agent/process descriptions are not allowed in the author
field.

## 3. Abstract and title gate

- The title is reader-facing and is derived from the paper's actual scientific
  object, question, mechanism, and bounded result. It does not copy a
  repository slug, requested status, verification tier, folder name, or
  implementation label. The title is selected after the technical core is
  understood, not before source inspection.
- The abstract is self-contained, result-first, and normally 150--250 words
  unless a venue specifies otherwise. It contains the question, scientific
  approach, principal result, and bounded scope/limitation.
- Remove inventory lists, verifier counts, file names, command descriptions,
  revision history, and repeated provenance disclaimers from the abstract.
- The abstract must fit as one intentional front-matter block. If it crosses a
  page, shorten it or deliberately place it on its own page; do not accept an
  accidental sentence split.

## 4. Definition and appendix gate

- Build the notation/terminology ledger before drafting prose.
- Define every symbol, acronym, named object, domain term, coined construct,
  and theorem hypothesis before its first argumentative use.
- For each technical detail, record `body`, `appendix`, `supplement`, or
  `research-only` disposition before writing it.
- Keep the main text focused on the shortest complete scientific argument.
  Move routine derivations, long case analyses, implementation details,
  auxiliary tables/figures, notation expansions, and detailed validation
  matrices to a titled appendix or research record.
- Every appendix must be scientifically useful, have a descriptive title, and
  be referenced from the body. Do not use an appendix to conceal an undefined
  object, unsupported claim, or missing central argument.

## 5. Evidence-language gate

Compare every headline statement in the title, abstract, introduction, results,
and conclusion with `research/provenance.md` and `research/validation.md`.
Use separate language for:

- a theorem actually derived in the manuscript;
- a source-reported theorem or computation reproduced as exposition;
- an independently rerun spot-check;
- a finite empirical observation;
- an inference or open question.

Do not write `proved`, `exactly verified`, `complete answer`, `resolved`,
`independent validation`, or a universal/asymptotic claim when the evidence
only supports a source report, spot-check, selected family, finite census, or
proof sketch. If a number is retained, its scope, units, precision and
provenance must be clear. Preserve full precision only in research records
unless it is scientifically necessary in the paper.

## 6. Prose and structure gate

- Draft the technical core before the abstract and rewrite the abstract last.
- Headings state the scientific role or bounded conclusion, not an internal
  workflow step. Replace headings such as `Reproducing the repository's
  numbers`, `Independent checks`, or `Build report` with scientific headings,
  or move them to research notes.
- Keep one controlling vocabulary for each concept and one count for each
  decomposition across all sections.
- Remove repeated evidence disclaimers. State the policy once near the start,
  explain evidence in one focused section, and use short local qualifiers only
  when the evidence level changes.
- Remove implementation narration. Explain algorithms and procedures at the
  scientific level; do not narrate which script, file, command, or agent did
  the work.
- Ensure the conclusion synthesizes durable findings, scope, and open questions
  instead of repeating the abstract or an audit log.

## 7. LaTeX and visual gate

Before compilation, inspect the source for:

```bash
grep -RniE '^\\documentclass|tableofcontents|colorlinks|\\textcolor|\\href|\\url|section[[:space:]]*[0-9]' paper/
grep -RniE 'Draft title|TODO|TBD|placeholder|Author information pending|\\?\\?|undefined' paper/
```

For this batch, require exactly the PRX REVTeX class in every main entrypoint:

```text
\\documentclass[aps,prx,reprint,groupedaddress]{revtex4-2}
```

Use `hyperref` with `hidelinks`, no colored table of contents, and no visible
template markers. A paper with an `article` or `amsart` class fails the template
gate even if it compiles. Use `needspace` or equivalent local
controls where appropriate. After compilation, inspect the rendered first,
interior, figure/table, and final pages:

- no clipped titles, labels, equations, or captions;
- no section number/title collisions or mid-word heading hyphenation;
- no float between an unfinished sentence, theorem, proof, or list item;
- no heading stranded at the bottom of a page;
- no page beginning with a lowercase continuation or one-word fragment;
- no figure/table after the bibliography;
- all figures/tables have captions, labels, readable scales, and body
  cross-references;
- references are the final scholarly component and have a consistent style;
- final-page whitespace is proportionate and intentional.

If a model cannot read images, record visual inspection as blocked. Never infer
visual success from `pdflatex` exit code or source inspection.

## 8. Final report

Record under `research/validation.md`:

- commands actually run and their results;
- files and pages inspected;
- remaining warnings and blocked gates;
- source coverage and evidence limitations.

Do not write `submission-ready`, `scientifically verified`, or `visually
approved` unless the exact required gates and their evidence support those
phrases. A clean preflight means the manuscript is internally consistent and
presented in the selected house style.
