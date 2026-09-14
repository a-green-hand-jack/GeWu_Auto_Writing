# Formal-publication preflight

Run this on the complete `WORKSPACE` before calling the result a formal
manuscript. Use only Pi's native `read`, `write`, `edit`, `bash`, `grep`,
`find`, `ls` tools. These checks establish presentation, internal consistency,
and template conformance only; they are not a claim of scientific truth.

## 1. Manuscript boundary

- `paper/main.tex` exists and every `\input{}` / `\include{}` target exists
  inside `paper/`.
- All generated paper files are inside `WORKSPACE`; `SOURCE_ROOT` is untouched.
- The paper has a title, author field, abstract, scientific sections,
  limitations/discussion, conclusion, and references.
- Template conformance: the document class matches the domain recorded in
  `research/assessment.md` — the APS PRX entrypoint
  `templates/prx-official/apstemplate.tex` with
  `\documentclass[aps,prx,reprint,groupedaddress]{revtex4-2}` for physics, the
  amsart house preamble from `references/domains/mathematics.md` for
  mathematics, or the user's selected venue otherwise. A physics paper must not
  use `article`, `amsart`, PRE, PRL, or `pre-generic`; a mathematics paper must
  not be forced into the physics two-column format. Check that every paper in
  the same domain group uses the same class and preamble.
- No table of contents unless requested.

## 2. Internal-metadata firewall

Search only the manuscript under `paper/`, excluding `research/`. Review every
hit instead of relying on one count. Unless the user explicitly requested a
software/artifact paper, none of the following may appear in the title, author
field, abstract, body, caption, conclusion, or bibliography:

```bash
grep -RniE 'GitLab|GitHub|github\.com|gitlab\.com|README|\.md\b|\.py\b|\.sh\b|\.yaml\b|\.yml\b|\.json\b|run[-_ ]?id|commit|hash|sandbox|bwrap|provider|agent|model name|PaperWriter|Pi process|platform rank|issue tracker|source path|local path' paper/
grep -RniE '/home/|/Users/|[A-Za-z]:\\|https?://' paper/
grep -RniE '^\\(title|author)|Author information pending|source-bound expository draft|Solution[ _-]?[0-9]+|top[ _-]?30|Anonymous' paper/
```

The second command also finds legitimate scholarly DOI/URLs — inspect each hit
and retain only necessary scholarly citations. `Anonymous` is allowed when
anonymity is intentional. Platform names, repository identifiers, paths,
hashes, run IDs, and agent/process descriptions are never allowed in the
manuscript; they belong in `research/provenance.md`.

## 3. Title and abstract gate

- The title is reader-facing and derived from the paper's actual scientific
  object, question, mechanism, and bounded result — not from a repository slug,
  requested status, verification tier, folder name, or implementation label.
- The abstract is self-contained, result-first, normally 150–250 words, and
  states the question, scientific approach, principal result, and scope.
- No inventory lists, verifier counts, file names, command descriptions,
  revision history, or repeated provenance disclaimers in the abstract.
- No formulas in the abstract, and no strings of reported values; at most two
  or three numbers, and only where they carry a claim.
- The abstract fits as one intentional front-matter block.

## 4. Definition and appendix gate

- The notation/terminology ledger was built before drafting prose.
- Every symbol, acronym, named object, domain term, and coined construct is
  defined before its first argumentative use, including in the abstract.
- One concept keeps one name and one notation across body, appendices, and
  captions; no definition drift.
- Every technical detail has a recorded disposition (`body`, `appendix`,
  `research-only`). Routine derivations, long case analyses, implementation
  detail, auxiliary tables, and validation logs live in titled appendices or
  `research/`, not in the body.
- Every appendix is scientifically useful, titled, and referenced from the body;
  an appendix never conceals a missing central argument.

## 5. Formal-environment gate

This gate is about presentation and evidence, **not** about domain routing: a
physics paper does not become a mathematics paper by using theorem
environments, and a mathematics paper proved by finite computation may use none.
Route the domain by the object and the question (see `SKILL.md`), and judge
formal environments by the evidence alone.

```bash
grep -RnE '\\begin\{(theorem|proposition|lemma|corollary|definition)\}' paper/
```

Every hit must trace to a provenance record whose evidence is theorem-level: an
explicit hypotheses-plus-proof (or proof-grade derivation) result from the
source. Physics results, finite-size computations, numerically checked
identities, fitted forms, and physical mechanisms are presented as prose
results, displayed equations, derivations, and scoped bounds — never wrapped in
theorem environments. Convert any mismatch to prose headings such as
`Main result`, `Derivation`, `Bound`, or `Physical interpretation`.

## 6. Evidence-language gate

Compare every headline statement in the title, abstract, introduction, results,
and conclusion against `research/provenance.md`. Keep separate language for a
theorem derived here, a source-reported result reproduced as exposition, an
independently rerun check, a finite observation, and an open question. Do not
write `proved`, `exactly verified`, `complete answer`, `resolved`,
`independent validation`, or a universal/asymptotic claim when the evidence is
a source report, spot-check, selected family, or finite census. Retained numbers
must carry interpretable scope, units, precision, and provenance.

## 7. Bibliography gate

```bash
grep -c '\\bibitem' paper/paper.bbl 2>/dev/null || grep -c '\\bibitem' paper/*.bbl
grep -RniE 'verified through|not independently verified|preparation environment|Crossref|retrieved on|consulted on|bibliographic fields|API key' paper/references.bib paper/*.bbl
grep -RniE 'FloatBarrier|placeins' paper/main.tex paper/*.tex
```

- **Every entry is cited and every citation has an entry.** Delete unused
  `.bib` entries; an entry with no citation has no reason to exist.

```bash
grep -o '\\cite[a-z]*{[^}]*}' -R paper/ | sed 's/.*{//;s/}//' | tr ',' '\n' | sed 's/ //g' | sort -u > /tmp/cited.txt
grep -oE '^@[a-zA-Z]+\{[^,]+' paper/references.bib | sed 's/.*{//' | sort -u > /tmp/entries.txt
comm -23 /tmp/entries.txt /tmp/cited.txt   # entries never cited
comm -13 /tmp/entries.txt /tmp/cited.txt   # citations with no entry
```

- **No provenance narration in the bibliography.** Verification notes such as
  "verified through the Crossref registry (date)", "not independently verified
  in the preparation environment", or retrieval dates do not belong in a
  reference entry; they are internal records and belong in
  `research/literature.md`. A bibliography note may state a scientific caveat
  (for example that a work is a preprint), never the drafting process.
- **Coverage is stated, not implied, and thin coverage is a defect.** Count the
  entries and the distinct works cited. A research article that engages its
  field normally reaches at least ~20 references in physics and ~12 in
  mathematics; below that the manuscript is almost always under-positioned.
  If the count is below those floors, `research/literature.md` must record the
  searches actually run, the specific prior works that should have been
  relevant, and why they are absent. Never pad with uncited, unread, or
  decorative entries — every entry must be cited and every citation must
  support a claim — but do not treat a short list as acceptable by default
  either. Check that the related-work discussion positions this paper against
  at least five concrete prior results by name, not as a citation list.

## 8. Float and reference-region gate

The reference list is the final scholarly component and must read as one
labeled block.

- The preamble loads `placeins`, and `\FloatBarrier` (or the template's
  equivalent float-flushing directive) appears immediately before
  `\bibliography` — in the amsart entrypoint as well as the PRX one. Dropping it
  lets pending floats pile up beside or after the reference block.
- No figure or table appears after the bibliography, and no float shares a page
  with the start of the reference list in a way that leaves the references
  squeezed into a fragment of a page.
- The reference list is labeled **and the label spans the text width**. For the
  PRX entrypoint the class prints a separator rule but no heading word, and a
  bare `\section*{References}` centres the heading inside a single column — a
  defect a rendered-page check catches immediately. Require the construction in
  `references/domains/physics.md` (separator device plus a centred heading
  between `\onecolumngrid` and `\twocolumngrid`), and confirm on the rendered
  last page that the word REFERENCES is centred across the full text width and
  that both columns are balanced at the reference block.
- For amsart, the class prints its own `References` heading; confirm on the
  rendered page that it exists.
- Check for full-width rules on the reference page (a `table*`/`figure*` sharing
  the page): render the page and look, or render and analyze pixel rows.

## 9. Front-matter and reference-page gate

Both defects below were found by rendering pages 1 and the reference page of
delivered manuscripts; source inspection alone did not catch either.

**Front matter order (PRX entrypoint).** The abstract must be inside its own
environment and before `\maketitle`:

```bash
grep -nE '\\(title|author|noaffiliation|maketitle)|\\begin\{abstract\}|\\end\{abstract\}' paper/*.tex | head -20
grep -rn 'abstract' paper/sections/*.tex | head            # an abstract file must carry the environment
```

Flag any entrypoint whose first `\begin{abstract}` comes after `\maketitle`,
and any file `\input` before `\maketitle` that contains prose but no abstract
environment — that prose is typeset above the title. Then render page 1 and
confirm the title is the topmost element.

**Reference page isolation and repeated-author dashes.**

```bash
grep -n 'FloatBarrier\|clearpage\|bibliography{' paper/main.tex
grep -c '\\bysame' paper/*.bbl 2>/dev/null          # must be 0 after expansion
```

- `\FloatBarrier` and `\clearpage` must both precede `\bibliography`, so the
  reference list starts on a page of its own. A table or figure sharing that
  page leaves its rules above the references, where they read as stray
  underlines.
- Run the `\bysame` expansion in `references/domains/mathematics.md` after the
  first BibTeX run; the count above must be 0 (or the style switched to
  `plain` and recorded).
- Render the reference page and confirm: the heading is present and centred as
  required, the list is the only thing on the page, and no line consists only
  of a dash or a rule.

## 10. LaTeX and source gate

```bash
grep -RniE '^\\documentclass|tableofcontents|colorlinks|\\textcolor|\\href|\\url' paper/
grep -RniE 'Draft title|TODO|TBD|placeholder|Author information pending|\?\?|undefined' paper/
grep -RniE 'needs_review|review-only|source-bound|workflow|pending verification' paper/
```

Require `hyperref` with `hidelinks`, no colored table of contents, no visible
template markers, and no unresolved placeholders. In two-column templates use
`aligned`/`split`/`multline` for long equations and starred floats only when a
display genuinely needs full width.

## 11. Compile and visual gate

Compile the manuscript (engine → bibtex → engine ×2) and read every warning
location: undefined references, overfull boxes wider than a few points, missing
glyphs, and font problems. Repair layout defects locally (break long tokens,
keep a heading with its opening paragraph, keep a float away from an unfinished
sentence or display). Never hide overflow, relax margins, shrink text globally,
or delete evidence to pass.

Then inspect the rendered first page, every figure/table page, the reference
page, and the final two pages:

- no clipped titles, labels, equations, or captions; no missing-glyph boxes;
- no section heading stranded at the bottom of a page; no page beginning with a
  lowercase continuation or a one-word fragment;
- floats appear on or after the page that first references them, never after
  the bibliography;
- figure text legible at print scale; lines/categories distinguishable without
  colour; captions self-contained;
- front matter reads cleanly with required licence notices retained.

If the model cannot read images, or rendering is unavailable, record visual
inspection as blocked. Never infer visual success from a compiler exit code.

## 12. Verification-script gate

```bash
# checks must live in the workspace, not in temporary space
grep -rnE '/tmp/|\$HOME|~/[a-z]' paper/../research/checks/ 2>/dev/null | head
find research/checks -maxdepth 1 -name '*.py' -o -maxdepth 1 -name '*.sh' | wc -l
# unbounded loops and missing guards
grep -rnE 'while +True|while +1:|until .*converge' research/checks/ 2>/dev/null | head
grep -rLnE 'timeout|deadline|MAX|CAP' research/checks/*.py 2>/dev/null | head
```

Every check script belongs under `research/checks/` with its output beside it.
Flag any script that lives in temporary space, contains an unbounded loop, or
states no coverage and no cap. `research/validation.md` must record, per check,
the coverage reached and whether it completed or hit its cap; a claim that rests
on a capped or absent check is marked conditional in the manuscript.

## 13. Attribution and prose-shape gate

```bash
# production note present, and the author line is not a placeholder when the
# platform record names authors
grep -rnE 'acknowledgments|Production and authorship' paper/*.tex paper/sections/*.tex | head
grep -rnE '\\author\{' paper/*.tex | head
# list-dominated sections: an itemize-heavy section file is an outline
for f in paper/sections/*.tex; do
  items=$(grep -c '\\item' "$f"); lines=$(grep -cvE '^\s*$' "$f")
  [ "$lines" -gt 0 ] && [ $((items * 100 / lines)) -gt 45 ] && echo "LIST-DOMINATED: $f ($items items / $lines lines)"
done
```

- The manuscript has a production note naming the source Solution, its authors,
  the collaborating agents, the harness and the model, and the checks performed;
  the note sits before the appendices and is the only place those names appear.
- The author line uses the Solution's own authorship from
  `gewu-top30/AUTHORSHIP.json`; a placeholder is a defect when the record names
  real authors, and an invented name is a fabrication.
- No section is list-dominated: limitations, discussion, related work and
  conclusion are prose. Flag every `LIST-DOMINATED` hit and rewrite it as
  sentences before delivery.

## 14. Proofread pass

Load `references/skills-imported/proofreading/SKILL.md` and run its six checks
against the LaTeX sources (abbreviations, math notation, introduction structure,
grammar/style, figures and tables, statistics). Report line-level findings. A
proofread that changes wording must not also certify the same text; re-run the
affected consistency checks afterwards.

## 15. Final report

Record in `research/validation.md`: the commands actually run and their
results, the files and pages inspected, the bibliography size and coverage
justification, remaining warnings, and blocked gates. Do not write
`submission-ready`, `scientifically verified`, or `visually approved` unless the
exact gates and evidence support those phrases.
