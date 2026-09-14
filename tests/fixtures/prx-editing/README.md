# Paired synthetic manuscript revision

This is a small, self-contained editorial test, not an external research paper
or a PRX submission. The two bibliography entries are explicitly synthetic
local notes. Their contents, fictional authorship record, original TeX, common
brief and source hashes are included; no private manuscript or chat is used.

## Execution

- Baseline skill: `b61f40d7ed1e4b4fffeed1b4d63511a4b3532927`.
- Candidate skill: `81b84956765d0a79d4e662d6d63811a27525181b`.
- One fresh Codex subagent per variant, requested model `gpt-6-astra`, effort
  `high`; same initial brief and read-only source. Each could revise its own
  workspace, compile locally and inspect pages. Neither was authorized to read
  the other variant, browse, add research, or run cloud jobs.
- The parent requested progress and bounded completion; these were interactive
  applications, not automated identical-transcript trials. A separate
  `gpt-6-astra/high` reviewer established the [rubric](review-rubric.md) from the
  source before seeing either output, then examined actual TeX and PDF pages.
  Artifact disclosures can reveal the workflow; this was not a blinded study.
- The original input compiles to two pages. Both applications copied and
  preserved all five source files; final original-source hashes still match
  `manifest.json`.

`baseline/` and `candidate/` contain the actual final TeX/BibTeX sources, not
handwritten expected outputs. Packaging removes one trailing ASCII space in
the baseline entropy paragraph; both author and packaged hashes are recorded,
and the rebuilt layout text is unchanged. They are frozen observations, not recommended
new paper templates. The manuscript's disclosures describe its state at the
end of each author's revision, before the independent review reported here.
PDFs and build products are not committed. `manifest.json` records source and
reviewed-PDF hashes, fresh compilation steps and page counts.

## Observed comparison

| Item | Baseline | Candidate |
|---|---|---|
| Scientific sections, excluding production note and appendix | Eight; splits model/relaxation and discussion/conclusion, adds Related work | Five; retains the original scientific sequence and combined headings |
| Bibliography | Manual REFERENCES block, column switching and forced new page | Native REVTeX bibliography; no manual heading or forced bibliography page |
| Table | Converted to booktabs | Retained native ruledtabular and all cells |
| Final pages | 3, including a sparse references-only page | 2, with native references below the scientific text/end matter |
| Original numbered equations | All eight retained | All eight retained |
| Local citations | Both remain explicitly synthetic | Both remain explicitly synthetic |
| Literature gaps | Two local notes, no external coverage; recorded, not padded | Same |

Both authors made local language changes and corrected compilation/layout
issues before freezing their output. The candidate removed an empty date label
and changed a bottom-only float placement that interrupted a word. The baseline
fixed a table row terminator, a BibTeX output-location issue and awkward line
breaks. These recoveries are included in the execution history; a successful
final compile is not a claim that the first attempt passed.

## Rebuild

From either `baseline/` or `candidate/`, with REVTeX and the usual TeX packages
installed, run:

```sh
pdflatex -interaction=nonstopmode -halt-on-error main.tex
bibtex main
pdflatex -interaction=nonstopmode -halt-on-error main.tex
pdflatex -interaction=nonstopmode -halt-on-error main.tex
pdftoppm -png -r 120 main.pdf page
```

A clean copy of each packaged source was independently rebuilt with pdfTeX
1.40.25 / TeX Live 2023, BibTeX 0.99d, REVTeX 4.2f and Poppler 24.02.0. All four
commands returned zero for each variant; page counts were 3 and 2. Extracted
layout text matched the respective author-reviewed PDFs exactly. The rebuilt
PDF hashes can differ because of PDF creation metadata; compare input/source
hashes and inspected content rather than expecting bit-reproducible PDFs.

## Review and limits

See [independent review](independent-review.md) for equation/qualification
checks and page-specific observations. All five final PDF pages were inspected
by a reviewer who did not author either revision. Remaining native column
breaks, short paragraph tails and package warnings are recorded; their mere
presence is not a submission defect or a failed scientific claim.

This pair demonstrates an actual presentation-rule difference in one small
analytic fixture. It does not estimate model reliability, validate the deployed
Pi/provider runtime, establish PRX novelty or manuscript suitability, or show
that real research papers improve. Current venue policy, external literature
coverage, empirical validity and real-manuscript evaluation remain outside
this test. Those limits do not prevent review of the scoped skill repair.
