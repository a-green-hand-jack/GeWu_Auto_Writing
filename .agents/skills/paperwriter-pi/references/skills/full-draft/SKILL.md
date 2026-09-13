---
name: full-draft
description: Write a complete source-bound paper under captured user draft authorization or strict plan approval, then drive isolated compilation, review, revision and hash-verified delivery.
---

# Full draft

Required: source-bound research.json, venue candidates, template metadata/files,
plan.json, and real authorization. First use paper_workspace with source_root,
workspace, venue_id, template_dir, metadata_path and mode. Follow its returned
paths and PAPERWRITER_WORKSPACE, PAPERWRITER_INPUT_ROOT,
PAPERWRITER_TEMPLATE_ROOT and PAPERWRITER_METADATA_PATH, not assumed container paths. The original user's writing
request captured through input/before_agent_start permits a non-final draft; it
never grants scientific or submission approval. Keep legacy receipts strict.
For a delegated
version-2 autonomous-draft policy use --task-policy instead of --operator-receipt.
That policy permits a draft with pending scientific reviews, not submission-ready
or claims of human approval. Do not fabricate verification to pass the strict gate.
Known invalidated core evidence still blocks the corresponding claim. Read
../../workflows/paper-production.md for the full task, not only preparation.

For the strict legacy receipt path prepare with
`paperwriter-draft --source-root INPUT --package R --candidates C
--template-root T --metadata M --plan P --operator-receipt RECEIPT --output PAPER
--manifest MANIFEST`. All paths are explicit. Receipt is typically under
/run/paperwriter-approval. Inputs/templates are read-only. Manifest is outside PAPER.
For the ordinary path, use the workspace preparation's captured-user draft
authorization. A failed preparation blocks writing; do not fabricate receipts or
fall back to bypassing the tool.

Before semantic preparation, load [paper-completeness](../paper-completeness/SKILL.md),
[paper architecture](../../knowledge/paper-architecture.md) and the domain writing
guide routed by domain-assessment (`../../domains/<domain>/writing.md`; a physics
theory paper also loads `../../domains/mathematics/writing.md`). The domain guide states
the depth this field expects for each result — apply it when setting section
budgets and again before writing each section. Build the content coverage and
section budgets with the plan. Use `paper_prepare` once with the complete mapping,
assessment and specification; it deterministically validates and atomically writes
the bound artifacts. After preparation, read the bound plan, source evidence and
template. Use its returned section paths and dependency order, writing each
evidence-ready section with native backend file tools and persisting it. If planning missed a required
scientific explanation, revise the plan through writing-plan-gate before changing
its scope; a strict receipt must be renewed, while a delegated policy allows
replanning within its existing scope. Do not silently alter a bound plan:

1. Technical core: precise problem, assumptions, definitions, mechanisms or proof,
   derivations, algorithm, limitations of the argument. Match the paper type;
   never impose experiments on a theory paper.
2. Results/evaluation: only actual approved evidence, with protocol, comparison,
   uncertainty or exactness and scope. A proof may stand on its own; do not invent
   experiments, baselines, statistics or a mandatory plot.
3. Introduction and related work: motivate without unsupported novelty. Actively
   retrieve and inspect relevant literature using literature-and-figures; verified
   supplied bibliography is useful but not the only allowed way to obtain references.
4. Abstract, discussion, limitations and conclusion: consistent with the core and
   evidence; no new unsupported results.
5. Assemble main.tex with the real template and all planned sections. Remove
   instructional template placeholder text, not required license notices.

Do not stop after copying a template or producing a few short section files.
Before assembly, verify that each section has substantive explanatory content,
that the returned entrypoint inputs every section, and that the paper contains
the problem, context, definitions, technical argument, evidence, interpretation,
limitations and conclusion appropriate to its paper type. Run `paper_diagnostics`
once for the bound deterministic source snapshot rather than repeating separate
coverage/consistency/bibliography/leak calls on unchanged files.

Each section should be a separate safe-named .tex file matching plan section IDs.
Track progress outside PAPER in draft-state.json; on resume inspect files rather
than trusting a claimed complete state. Never overwrite previous manuscript
versions during Patch or Reframe without a new output/checkpoint.

Write paper-provenance.json outside PAPER with:
- plan hash and research package hash;
- every substantive claim: research claim_id and exact LaTeX file/section location;
- every numeric result/table cell: evidence_id, source location, units and any
  transformation; equation labels/counts are not empirical measurements;
- each result figure: source data, generation method and applicable evidence;
- known unsupported or unreviewed items as blockers, not as silently verified rows.

If diagrams are justified, use truthful schematic LaTeX or supplied approved
assets. Do not fabricate statistical plots or execute unknown repo scripts. Do
not make up a bibliography to reach a citation quota. Missing essential verified
references block final delivery.

## LaTeX hygiene (compile-breaking defects are real)

Before handing off, run the native `paper_latex_lint` tool over `paper/` and fix
every reported blocker. It is deterministic and cheap: unbalanced inline math
delimiters, unclosed environments, a missing `\input` target, a `\cite` key with
no bibliography entry, or an unescaped `_`/`&`/`%`/`#` in a BibTeX field each
break the build outright. Prose care alone has repeatedly failed to prevent
these; run the tool. `ready_for_compile_handoff` must be true before you exit.

The lint does not predict overfull boxes — those depend on font metrics and line
breaking, so only the isolated compiler can find them. It does warn about
genuinely unbreakable tokens (long hashes, URLs, `\texttt` identifiers). Break or
`\-`-hyphenate such tokens, or move them out of the abstract and narrow columns.
An overfull box wider than a few points is a layout defect, not just a warning;
when the compiler reports one, repair it rather than accepting it.

Call paper_compile to run local isolated TeX and record its report; do not hand
completion responsibility to a developer script or run TeX in the credential-
bearing shell. Linux bwrap is auto-detected; no isolation means blocked unless
the user explicitly authorizes trusted-host fallback. cleanenv is not a sandbox.
On failure, checkpoint and repair a small implicated batch, then recompile rather
than ending the main run. Do not spend an incremental compile while planned
sections are missing: the lifecycle reserves a later compile for a review-driven
revision. Use paper_review for private-plugin independent review; reviewer JSON is
persisted by the main process and reusable only for the identical
source/evidence/PDF binding. Each review round has one bounded attempt; timeout
requires a new user invocation rather than a repeated long call. Revise supported
material only while a later compile remains available, then recompile and inspect
every new PDF page. Use paper_lifecycle status/record/verify/
deliver against actual hashes. Keep 7,200/10,800-second budgets, three valid review
rounds and six compile attempts; timeout is not a valid revise review.

Finish with full source files and honest state; source-only work is partial, not
a complete reviewed draft. Never self-grant submission-ready.
Report absent gates explicitly. Do not announce publication success. A complete
manuscript is a writing artifact, not evidence of originality or scientific truth.
