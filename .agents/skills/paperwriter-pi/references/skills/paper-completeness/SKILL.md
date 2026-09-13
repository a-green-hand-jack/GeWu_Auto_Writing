---
name: paper-completeness
description: Turn a small solution repository into a complete, source-faithful academic manuscript.
---

# Paper completeness

Before full-draft writing, build a coverage matrix from the actual source
package. Every row needs a planned section, source locator, and status
(`supported`, `inferred`, `unresolved`, or `out_of_scope`). Never use word count
to hide an empty row.

For a theory or mathematics paper, normally cover the abstract, problem and
context, definitions and notation, assumptions and scope, technical statement,
derivation or proof in readable steps, exact or finite verification protocol,
results and interpretation, verified related work, limitations and open cases,
discussion, conclusion and references. For empirical work replace proof
obligations with data, protocol, baselines, uncertainty and reproducibility.
Always include sections required by the selected template and venue guidance.

Write in bounded passes. Finish the technical core before polishing the
abstract, and do not assemble `main.tex` until every planned section has
substantive paragraphs, equations or tables where justified, and evidence
links. A section is incomplete when it only restates a README or gives model
instructions. Expand explanation and derivation, never unsupported claims or
filler. Keep execution status distinct from source claims.

Before handoff, check that `main.tex` uses the inventoried entrypoint and inputs
every planned section, cited BibTeX keys exist, and the matrix has no silent
omissions. Run the native diagnostics for the deterministic part of this:
`paper_coverage` (section files, both word-budget bounds, main.tex inclusion,
venue page budget), `paper_consistency` (numbers reported differently across
sections, duplicate or dangling labels, acronyms used before definition),
`paper_bibcheck` (citations against `references.bib` in both directions, plus
BibTeX characters that break compilation) and `paper_leakcheck` (absolute paths,
internal identifiers, editing markers). Their word estimate and pattern matches
are warning signals, never a scientific or submission approval, and a clean run
only means those specific defects are absent. Compilation and visual review
remain separate gates.
