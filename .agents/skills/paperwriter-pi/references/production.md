# Production

The full-draft procedure, using Pi's native tools. One run: read, plan, gather
literature, write to the template, compile, check, review, report. Persist
progress as files — after any interruption, resume by re-reading the files, not
by trusting a claimed state. `constitution.md` governs every step.

## Workspace

```text
WORKSPACE/
├── paper/                  # ONLY LaTeX, bibliography, template assets, final figures
│   ├── main.tex, sections/, references.bib, figures/
└── research/               # everything internal
    ├── inventory.md        # source list, exclusions with reasons
    ├── assessment.md       # domain, journal, contribution, template source
    ├── plan.md             # section plan, notation ledger, dispositions
    ├── provenance.md       # claim -> locator -> evidence level
    ├── literature.md       # the reference record, in the schema of §5
    ├── validation.md       # checks run, results, blocked gates
    ├── checks/             # verification scripts, their output, LKM raw responses
    └── history/            # prior versions, kept before a revision
```

`SOURCE_ROOT` is never modified. If it already contains a manuscript, treat it
as evidence to assess, not as permission to copy unsupported conclusions.

## 1. Inventory

Inspect the whole source scope, with line numbers, without executing it. List
every top-level source in `research/inventory.md` and record exclusions with
reasons. For a collection of repositories, inventory every entry — no silent
omissions — and write one comparative manuscript unless the user asked for one
per entry.

## 2. Evidence map

Build `research/provenance.md`: each substantive claim with its source locator
and evidence level, and each number with its transformation (formula → value,
units, rounding, input). Newly read evidence is source-reported until you
re-derive or re-run it yourself; mark it reproduced once you do.

## 3. Assessment

Write `research/assessment.md` as short prose: the domain and the nature of the
paper (theory, computation, method, empirical, survey) with a rationale grounded
in the actual evidence; the strongest contribution the sources support, and its
scope; **the journal and the template actually used**, with the source of that
template (`templates.md` §1) and any switch away from the default; and any
residual ambiguity, recorded as a limitation.

## 4. Plan

Write `research/plan.md` before any prose:

- the sections the journal's format calls for, with each section's purpose and a
  realistic length budget. The plan is the backbone: `main.tex` inputs exactly
  these sections;
- the notation ledger: every symbol, acronym, and named construct, with its
  plain definition, units or domain/codomain, and first planned use;
- a disposition for every technical fact: `body`, `appendix`, or
  `research-only`, defaulting to `appendix` whenever a reader needs it only to
  *check* the argument rather than to follow it (`writing.md` §3). An omission
  is a stated decision, never a silent drop;
- which display items and references are justified, and by what. A figure only
  to meet a quota is a defect; if none is justified, say so in one line.

## 5. Literature — through LKM

Engaging the field is the point: a paper that does not position itself among
the prior results is a write-up, not a paper.

**LKM is the primary route.** Bohrium's Large Knowledge Model is reachable from
the host through the governed helper `tools/gewu-lit`, which wraps the `bohr`
CLI, caches every raw response under `research/checks/literature_raw/`, and
bounds each call. Use it in this order:

```bash
gewu-lit search "<topic or claim>" --top-k 20      # papers, claims, reasoning chains
gewu-lit reasoning "<question the paper answers>"  # reasoning chains and evidence
gewu-lit graph <paper-id>                          # citations and neighbours of a hit
gewu-lit parse <local.pdf>                         # questions, conclusions, reasoning steps
gewu-lit verify references.bib                     # resolve every DOI/arXiv, compare titles
```

- `search` and `reasoning` find what the field established, including work the
  source never cited; `graph` walks forward and backward from a key paper;
  `parse` extracts content from a PDF you already hold. `bohr pdf parse` gives
  layout, text, tables and formulae when you need the full text itself.
- Start from the source's own references and named authors, then work the
  topic's key terms, then follow citations in both directions.
- For each result the manuscript relies on or improves, find the work that
  established it and cite it at the point of use.
- Never place an API key in a URL or a file. If LKM or a publisher is
  unreachable, record the blocked retrieval and continue with what you have; a
  network failure is a missing check, never permission to invent a citation.

**Record every reference in `research/literature.md` in one machine-readable
table**, so the gate in `checks.md` §6 can count it:

```markdown
| key | identifier | source | scope | supports |
|---|---|---|---|---|
| onsager1944 | 10.1103/PhysRev.65.117 | Crossref | metadata-only | the 2D solution (attribution only) |
| wei2018exact | arXiv:1805.01366 | LKM full text | full-text | the rewriting that the section 3 estimate reproduces |
```

`scope` is exactly one of `full-text`, `abstract`, `metadata-only`. There is no
fourth value: "content-known", "well-known" and "canonical" are not
verifications, and a row carrying one of them counts as `metadata-only`.

**Two floors, both checked mechanically.**

- **At least half the references are content-level** (`full-text` or `abstract`
  — the content was actually read this run). A `metadata-only` entry may carry
  attribution and historical statements only; it can never support a technical
  statement. If fewer than half reach content level, LKM retrieval is
  unfinished: go back to §5 and read more, rather than relabelling a row.
- **At least 25 references** for a research article. Below that,
  `research/literature.md` records the queries actually run, the specific prior
  works that should have been relevant, and why they are absent. Never pad with
  uncited, unread or decorative entries — every entry is cited, and every
  citation supports a sentence.

**Every identifier must resolve.** `gewu-lit verify references.bib` resolves each
DOI and arXiv identifier and compares the returned title with the entry. A 404,
an unresolvable identifier, or a title that does not match is a defect: fix the
identifier or delete the entry. Never write a plausible-looking identifier, and
never write an entry you cannot verify exists. Entries with no identifier at all
are allowed only for books and pre-digital papers, and each must be verifiable
by hand (publisher, edition, year).

## 6. Figures and tables

Include a display item only when it carries information prose cannot. Record its
purpose, axes or columns with units, input data and provenance, transformation,
and caption caveats. A schematic is labelled a schematic; an analytic curve is
not a measurement; never plot values you did not compute or invent error bars.
Each item is analysed in exactly one section and cited elsewhere for its
takeaway only.

## 7. Independent checks — bounded

Checks earn trust, but an unbounded one is worse than none: it consumes the run,
produces no evidence, and hides the manuscript's real state.

- **Inside the workspace.** A script lives at `research/checks/<name>.py` and
  writes its output beside itself. Never `/tmp`, never the home directory: a
  check whose script is missing from `research/` did not happen.
- **Bounded before it runs.** State the exact finite coverage and a hard cap in
  the script header and in `research/validation.md`, enforce the cap in code,
  print the coverage reached, and run it under `timeout <cap>` too. An unbounded
  loop or "until it converges" is a defect, not diligence.
- **Pilot first.** Run the smallest case; if it does not finish in seconds, do
  not scale it up — shrink the checked range instead.
- **Two failures means change strategy, not a third patch.** Reduce the coverage
  to what completes, replace the computation with an analytic argument or a
  smaller exact check, or mark the dependent claim conditional and say so.
- **Reserve the budget.** At least a third of the run belongs to literature,
  drafting, compilation, checks and review. A single check that has produced
  nothing after ~15 minutes gets the previous rule.

Record in `research/validation.md` what was verified, what was not, and the
coverage reached; weaken or condition any claim resting on the unchecked part.

## 8. Write to the template, then assemble

**The paper is written to the requirements of its journal.** The format decides
the section spine, the front-matter order, the abstract, the reference style and
the page budget; `templates.md` gives the entrypoint and the constructions that
matter for each venue, and `writing.md` carries cautions about what tends to go
wrong. Do not import a structure from another venue and do not treat any section
list in this bundle as a required skeleton.

Build `paper/main.tex` from the entrypoint for the assessed domain, input every
planned section, remove instructional placeholder text, keep required licence
notices, and use `hyperref` with `hidelinks`. Then four things that a delivered
round got wrong:

- **`\appendix` is required as soon as any section file is appendix material.**
  A file named `appendix_*.tex` that is `\input` without `\appendix` prints as a
  numbered *body* section, so protocols and long derivations end up in the body
  and the paper reads as if it has no appendices.
- **Appendices come after the conclusion and before the bibliography**, and the
  bibliography is the last thing in the paper.
- **Every appendix is referred to from the body** at the point it is needed.
- **Proof and theorem environments come from `amsthm`** (`templates.md` §6).
  Never hand-roll a proof environment, and never italicise the proof body.

Run one language pass over the finished prose (`writing.md` §9) before final
assembly: fix the machine-drafting tells, change no claim, number or citation.

Attribution: copy the author and collaboration display forms verbatim from the
authorship record supplied with the run, whatever it names, and cite the source
repository or repositories as ordinary references in the bibliography
(`constitution.md` §4 and §7). No harness, model, provider, host or process words
anywhere in the manuscript.

## 9. Compile and inspect

Compile `engine → bibtex → engine ×2` (`templates.md` §8), read every warning
location, and repair in small bounded batches, recompiling after each. Then
render the pages and look at them: the first page, the reference page, and the
last two. `checks.md` lists what to confirm and the commands that catch each
defect.

If TeX or a renderer is unavailable, or the active model cannot read images,
record that gate as blocked. Never infer a visual pass from a compiler exit code
or from the source text.

## 10. Review

Re-read the whole manuscript in a different stance from the author's — assume
nothing is true until the source or the artifact shows it. Read the sections,
the plan, and `provenance.md` together, and check substance rather than polish:

- **correctness** — signs, prefactors, units, quantifiers, assumptions;
- **completeness** — model or problem, argument, evidence, and scope all
  present; every result arrives with its boundary;
- **clarity** — a reader who has not seen the sources can follow it, and every
  symbol is defined before use;
- **scope discipline** — claim verbs match evidence levels (constitution §2);
- **references** — each citation supports its sentence, the identifiers resolve,
  and the closest prior work is addressed;
- **presentation** — structure, displays, and captions serve the argument, and
  the template's requirements are met.

Fix supported defects in bounded batches, cascade each fix to the abstract,
conclusion, tables, and bibliography, and re-run the affected checks. Any change
to the PDF bytes invalidates the previous visual inspection. Never revert a
factual correction because an aesthetic judgement regressed; never leave a claim
you cannot support — cut it to what the evidence establishes.

## 11. Report

**Verify the deliverable first.** Confirm `paper/main.tex` and the compiled PDF
exist before writing the report. A run that ends with no `paper/main.tex` has not
done the task, however it went; say so plainly instead of reporting success.
Write every file with the `write` tool at a path inside the workspace — never
`mkdir` the tree, never `rm`, `mv` or `rmdir` over the workspace, and never use a
brace or comma path form.

Report the `WORKSPACE`, the files created, source coverage including exclusions,
the literature record (count, content-level fraction, unresolved identifiers),
the checks actually performed with their results, and the blocked gates. Label
the output as source draft / compiled / visually inspected / reviewed. Never
convert a clean textual self-check into scientific approval.

## Revision mode

For a scoped revision: read the plan, provenance, and unresolved issues first,
confirm the sources have not changed, and keep the previous version under
`research/history/`. Change only what the request requires, but update every
affected cross-reference, derived assertion, abstract, and conclusion. Any
content change invalidates the compile, review, and visual results bound to it —
rerun them. A reframing additionally needs a fresh assessment and plan.