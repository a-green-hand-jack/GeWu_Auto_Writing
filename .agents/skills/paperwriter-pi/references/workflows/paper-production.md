# Complete paper production

Use this workflow for a Full Draft request. The native backend stays in one long
run while it reads, plans and writes; do not restart for each chapter. Checkpoints
are actual manuscript files, not a reason to stop. Allow 7,200 seconds for the
draft and 10,800 seconds for the complete lifecycle. Ordinary paperwriter tasks
use this workflow; a compatibility run command is not required.

Start with paper_workspace(source_root, workspace, venue_id, template_dir,
metadata_path, mode). Use its returned paths and PAPERWRITER_WORKSPACE,
PAPERWRITER_INPUT_ROOT, PAPERWRITER_TEMPLATE_ROOT, PAPERWRITER_METADATA_PATH.
The workspace override is optional, not a demand for pre-staged container paths.
Read paper_lifecycle status and verify on recovery; recompute actual artifact
hashes rather than replaying a raw conversation. Original user authorization is
captured through input/before_agent_start; a writing request permits a non-final
draft, never scientific or submission approval. Keep legacy receipts strict.

1. Inspect the complete explicit staged input without executing it. Accept a
   directory, archive (list entries first, never auto-extract blindly), or non-Git
   collection; build a source inventory and research package with
   paperwriter-research discover/map/validate. Read the schema via
   paperwriter-research schema. Preserve pending verification; hash/shape checks
   do not establish scientific truth. Reconstruct derivations transparently and
   distinguish them from computations and source assertions.
2. Assess domain, paper type, maturity and actual supported contribution with the
   domain-assessment skill; generate candidates with paperwriter-research venues
   (data-driven venue rules). Record the domain knowledge route in
   `assessment.json`: `../domains/<domain>/writing.md` is loaded for planning and
   drafting, `../domains/<domain>/review.md` for the later review. A `physics`
   theory paper routes to both `physics` and `mathematics`.
   Select the default PRX, PRE, PRL or other packaged templates from runtime resources, or accept the
   user's explicit template directory/metadata. Never depend on a development
   template-generation script. Read source/license/style records, or retrieve
   official sources. Never equate adopting journal typography with meeting its
   originality/importance requirement, and honor the template availability three
   states (official-redistributable / official-guidelines-only / none).
3. Generate the template inventory and source-bound plan through the native
   `paper_prepare` transaction whenever possible. Supply the complete mapping,
   domain/venue assessment and specification once; the deterministic runtime
   validates and atomically publishes the research package, venue candidates,
   plan and draft manifest. It owns paths, hashes and status while the model owns
   scientific interpretation. Use the legacy `paper_draft_prepare` only for
   resume/compatibility or a precise transaction correction. Include technical
   and analysis home for every contribution and realistic word budgets. Also
   write a short figure/literature plan with applicability and sources. Neither
   route permits self-created scientific approval.
4. Load `paper-completeness` and the routed `../domains/<domain>/writing.md`,
   then create a coverage matrix before prose. The domain writing guide defines
   what depth this field expects for each result; apply it to the section budgets
   rather than defaulting to a minimal outline. Use the transaction's returned
   `section_paths`, `section_dependencies` and `writing_order`; write a
   dependency-ready technical section as soon as its bound evidence is available,
   without waiting on unrelated prose. Write the technical core,
   proofs/analysis/results, contextual introduction and related work,
   abstract/discussion/limitations/conclusion. Revisit all sections for
   consistency. Use all justified research content; do not inflate a weak source
   into a stronger claim, or omit a critical caveat to achieve an attractive story.
   For a small solution repository, spend the available budget on definitions,
   intermediate derivations, evidence interpretation, related-work context and
   limitations. Complete rather than merely outline. Before assembly, confirm
   that every planned section has substantive content and that main.tex inputs
   each one. Persist progress throughout the run.
5. Obtain genuine references and semantic support; bibliography metadata alone is
   insufficient. Use literature-and-figures. Request independent computation in a
   credential-free worker when useful; report exact finite coverage and limitations.
6. Assemble paper/main.tex, sections, references.bib, and justified figure assets.
   Sidecars live under research/, never inside paper/: research/research.json,
   research/plan.json, research/venue-candidates.json, research/draft-state.json,
   research/paper-provenance.json, research/literature.json and the lifecycle
   record research/lifecycle.json. The native diagnostics resolve these paths by
   default, so keep the layout. Provenance must locate substantive claims,
   equations, numeric rows, figures and citations, including transformations.
   Use stable IDs and current hashes; do not state all checks passed by default.
   Before handoff run paper_coverage, paper_consistency, paper_bibcheck,
   paper_leakcheck, paper_latex_lint, paper_style and paper_literature, and fix
   what they report.
   paper_style is where the abstract, the placement of reported values and the
   appendix are decided by counting rather than by assertion. A copied
   template with placeholder headings is not a draft: `paper_lifecycle` re-checks
   coverage when a compile is recorded and routes back to drafting if the planned
   sections are missing, unreferenced by main.tex or empty. A clean compile of an
   empty template is not progress. `paper_latex_lint` must report
   `ready_for_compile_handoff` true: unbalanced inline math, an unclosed
   environment or a missing `\input` target fails the compiler outright, and each
   is a pure lexical property that costs nothing to check here.
7. Invoke `paper_compile`; it calls the local isolated compiler, returns the
   structured report/render paths and records lifecycle state. Do not run TeX in
   the credential-bearing shell. Linux bwrap is automatically detected; missing
   isolation is blocked. Trusted-host fallback needs explicit user authorization;
   cleanenv is not a sandbox, and Docker is not a user prerequisite. Do not spend
   an incremental compile on an incomplete manuscript: finish the planned sections
   first. The lifecycle reserves capacity for a possible review-driven revision
   and rejects duplicate recording of the same immutable report.
   A failed compile returns diagnostics without terminating the main run. Take
   `paper_checkpoint`, repair a small batch of implicated sources, lint and call
   `paper_compile` again, up to six compile attempts. Fix reported overfull boxes;
   source lint cannot predict their layout. Do not record guessed success.
8. When the lifecycle asks for review, take a `paper_checkpoint`, then run
   `paper_review`. It delegates to the private reviewer plugin with a fresh
   context and read-only diagnostics (persist_session/output_transcript false).
   The reviewer returns JSON; the main process validates and writes the report,
   and it verifies afterwards
   that the manuscript was not modified during the review; a reviewer that edited
   the paper invalidates its own report. A valid report may be reused only for the
   identical source, evidence and compiled-PDF binding. Each review round has one
   bounded attempt; timeout, transport failure or invalid JSON is an environment
   failure requiring a new user invocation, not a repeated long call or a valid
   scientific verdict. The review applies the domain criteria selected in step 2
   (see workflows/domain-review.md) plus the layout criteria when rendered pages
   exist. Resolve critical and blocking factual defects with manuscript-revision,
   cascade to abstract, conclusion, tables, bibliography and provenance, record
   the revision only while a later compile remains available, and invoke
   `paper_compile` again. Three valid review rounds is a stop limit: reaching it
   leaves unresolved issues blocked, never accepted.
9. Inspect every final rendered page, record actual observations and hashes, and
   issue a delivery report distinguishing complete draft from submission-ready.
   Draft completion requires content, compilation, whole-paper review and visual
   inspection; missing novelty or final venue approval can still block submission.
   Use `paper_lifecycle` verify/deliver against actual source, compile, review and
   PDF/page hashes. `paper_lifecycle` never grants scientific or submission
   approval. Missing gates or exhausted budgets require an honest partial/blocked
   report, not a complete reviewed-draft claim.

For Patch/Reframe see manuscript-revision. Never edit original input or silently
consume an earlier finished manuscript during an independent Full Draft task.
