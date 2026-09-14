# Physical Review X writing profile

## Activation and precedence

Apply only when the selected journal resolves exactly to **PRX / Physical
Review X**. Field and journal are separate: `physics` alone does not select
this profile. The existing project default may resolve a physics manuscript
with **no explicit venue** to PRX; record the choice in
`research/assessment.md`. Explicit PRE, PRB, PRL, PRX Quantum, another journal,
or neutral-format requests exclude this profile. Never match a journal merely
because its name contains `PRX`.

For active PRX work, these rules replace conflicting presentation defaults in
`SKILL.md` and `references/{production,writing,templates,checks}.md`; do not
combine them with the superseded skeleton or reference-page requirements.
Keep all compatible workflow mechanics. `references/constitution.md` always
wins: scientific claims, provenance and citation coverage (§3), the author
line and firewall (§4), scope/reporting, source safety, and the required
production note (§7) are unchanged.

An exact user-supplied article type, template, or class option overrides this
profile's drafting defaults. Record the choice; it does not establish APS
compliance. If the selected journal changes away from PRX, stop applying this
profile. Do not export its rules into other journals or domains.

## Public authority and local practice

Sources checked on 2026-09-14:

- [PRX information for authors](https://journals.aps.org/prx/authors): Research
  Articles have no length limit; context and significance should be accessible
  to physicists outside the specialty. Published references require titles,
  strongly encouraged at submission. A popular summary is distinct from a
  research abstract; its advice to avoid mathematics is not a categorical ban
  on mathematics in article abstracts. The paper must stand alone without
  essential arguments relegated to Supplemental Material.
- [REVTeX home page](https://journals.aps.org/revtex): the listed release is
  4.2f; APS supplies an `apstemplate.tex` sample and supports the `prx` option.
- [PRX example, DOI 10.1103/rpls-mp8z](https://doi.org/10.1103/rpls-mp8z): its
  Introduction, topic-specific scientific sections, Discussion, end matter,
  and appendices illustrate a theoretical argument without a universal
  Model/Method/Results/Limitations/Conclusion skeleton. It is an example,
  not a prescribed replacement skeleton.

The practices below are local editorial guidance, not extra APS mandates.
`templates/prx-official/apstemplate.tex` is an **APS-sample-derived local
drafting template**, not an APS production template. Its historical directory
name and a successful compile do not establish submission compliance. Keep the
APS notices and source license; verify current article-type and submission
requirements when that task is requested.

## Planning, crafting, and scoped revision

Use `writing.md` for its reader-first argument, technical depth, definitions,
related-work reasoning, and language guidance, with these PRX replacements:

- Plan the reader's path from physical question through assumptions and the
  decisive argument to the result, interpretation, and scope. Develop the
  core first and frame it afterwards. Explain why the crucial step works;
  keep the argument needed to believe the central result in the body, with
  subsidiary derivations in titled appendices referenced from the body.
- Organize sections by scientific dependency. Context, model, method, evidence,
  interpretation, and limits must be findable, but need not be separate
  sections with those names. Related work may sit in the introduction or
  beside the relevant result; Discussion may carry the conclusion and limits.
  Combined headings such as `Introduction and model` are valid when they
  describe coherent content. Orient the reader before machinery regardless
  of the first section's title. Do not impose the universal section table,
  separate Related Work/Limitations/Conclusion sections, or an `and` ban.
- State the supported advance and its relation to the closest prior result.
  Do not manufacture novelty because PRX was selected. Contribution bullets
  and a roadmap paragraph are optional tools, not required slots. A coherent
  existing structure should survive a style edit.
- State real limitations where they affect interpretation. No two-limitations
  quota applies; never invent an unrelated weakness or hide a material one.
  A scoped exact result and an extrapolated numerical result need different
  discussions of what remains open.
- Write the abstract last, as self-contained prose giving the question,
  approach, principal result, consequence, and material scope. Useful compact
  mathematics and interpretable numbers are allowed; define symbols before
  argumentative use. There is no local formula ban, numeric ceiling, required
  numerical result, or mandatory 150–250-word range. Apply an actual verified
  article-type limit or explicit user constraint. Avoid inventory, process
  narration, and unexplained detail.
- Keep paragraphs as long as their reasoning needs. Lists may express
  genuinely parallel assumptions, cases, or steps with explanatory context.
  A short complete paragraph is valid; a count of sentences or list items
  does not decide whether an argument is written.

For an existing manuscript, follow `production.md` Revision mode: use a new
authorized `WORKSPACE`, copy the required manuscript/assets there, preserve
the received version in `research/history/`, and edit only the working copy.
Honor the requested section or review scope while updating affected claims
and cross-references. Do not rewrite the whole paper or demand new research
solely to pass a presentation rule. `SOURCE_ROOT` stays read-only.

## Evidence and literature

Select evidence that can support or challenge the actual result:

| Genre | Meaningful support |
|---|---|
| Analytic/theoretical | Explicit model and hypotheses, followable derivation, exactness/approximation boundary, relevant signs/dimensions/limits, physical interpretation; no mandatory datasets, seeds, benchmarks, or numerical abstract result |
| Numerical | Defined observable and algorithm, parameter coverage, material convergence/discretization/finite-size checks, tolerances or uncertainty appropriate to the computation; finite agreement is not proof |
| Experimental | Measurement protocol, units, controls, calibration, uncertainty and competing explanations relevant to the claim |
| Method/tool | Precise method and assumptions, correctness evidence and comparisons appropriate to the claimed benefit; no universal performance claim from one case |
| Expository/partial | Faithful attribution, explanatory reasoning, bounded conclusion; a PRX layout does not establish novelty or venue fit |

A display earns its place by explaining the science, never by meeting a quota.
Keep physical operators, ensembles, normalization, units, and limiting
operations consistent. A finite-size result is not a thermodynamic result;
a limit toward a singular endpoint is not automatically a value at it.

Retain the **constitution §3 coverage checkpoint**: below approximately 20
references for physics or 12 for mathematics, record the searches and missing
prior work. Also retain `production.md` §6 content-inspection requirements
and `checks.md` §5's five-prior-result comparison checkpoint. These are project
evidence-review requirements, not APS acceptance criteria: comply or document
shortcomings, never pad with irrelevant comparisons or decorative citations.

## Native APS assembly and layout

Absent an exact user override, use
`\documentclass[aps,prx,reprint,groupedaddress]{revtex4-2}` and the local sample.

- Keep the abstract inside its environment before `\maketitle`, use native
  title/author/affiliation commands, and follow constitution §§4 and 7 for
  authorship and production disclosure.
- Use native REVTeX/BibTeX behavior, normally `\bibliography{references}`.
  Do not inject a manual `REFERENCES` heading, redefine `\bibsection`, switch
  column grids around it, or force a bibliography-only page. `placeins`,
  `\FloatBarrier`, and `\clearpage` before the bibliography are not required.
  Remove forced patches introduced solely for the superseded house rule in
  the working copy. Preserve a documented exact user/venue override.
- Native `ruledtabular` and its double horizontal rules are valid; compatible
  booktabs tables are also valid. Select normal/starred floats by actual
  width. Preserve defined, consistent physics notation; legitimate
  calligraphic, blackboard-bold, hat, operator, vector, or tensor conventions
  are not defects merely because a generic notation preference differs.
- Judge pages by legibility, information loss, and reading order. Native
  separators, a shared reference/float page, uneven columns, a sparse final
  page, or a short paragraph tail are not automatic defects. Do not enforce
  the three-quarter-column tail quota, terminal-page fill, or column-balance
  targets. Repair clipping, overlap, detached captions, missing glyphs,
  unreadable equations, and genuinely confusing float placement locally;
  do not rewrite scientific content to hit a pixel target.

## Checks and report

Keep input/citation closure, evidence, definitions, firewall, authorship,
bounded execution, compilation, and genuine visual-defect checks. Apply the
replacements above when interpreting section, abstract, table, reference-region,
and paragraph-tail scans: a pattern match needs context before it is a finding.

Read warning locations and rendered front matter, displays, reference region,
and final pages. Record actual files/pages and unresolved findings in
`research/validation.md`. Compilation is not visual inspection; unavailable
rendering or image-reading is a blocked visual gate. After changing the PDF,
rerun affected checks and inspect the changed bytes.

A fresh pass by the writing process is **self-review**, never independent
review, peer review, scientific certification, or acceptance. Report the
output only at the scope allowed by constitution §5. A template probe or
behavioral scenario is not evidence of real-manuscript quality.
