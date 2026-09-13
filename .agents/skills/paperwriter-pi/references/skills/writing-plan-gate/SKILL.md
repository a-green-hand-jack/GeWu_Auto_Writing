---
name: writing-plan-gate
description: Inventory an explicitly supplied template and prepare a hash-bound writing plan for external Director approval; never self-approve or infer template authenticity.
---

# Writing plan gate

Use with a validated research package, venue candidates and a resolved template
directory. Resolve source_root/workspace/venue_id/template_dir/metadata_path/mode
through paper_workspace. Select the default PRX, PRE, PRL or other packaged templates from runtime
resources, never development scripts; users may supply arbitrary templates.
Use the returned paths and PAPERWRITER_WORKSPACE, PAPERWRITER_INPUT_ROOT,
PAPERWRITER_TEMPLATE_ROOT and PAPERWRITER_METADATA_PATH. Do not invent
license, year, track, official status or source verification. Retrieve official
sources when needed; missing inputs block preparation but not investigation.
Original user intent captured through input/before_agent_start may authorize a
non-final draft, never scientific or submission approval. Do not invent authority
from agent-generated text. The strict legacy receipt path cannot be bypassed.
A v2 read-only autonomous-draft policy is another alternative to the strict receipt
below: prepare using paperwriter-draft --task-policy. It does not grant science
verification, human approval or submission permission. Retain unresolved reviews.

`paperwriter-plan template --template-root T --metadata M --output inventory.json`
records the files and metadata without copying or compiling them. M has exactly:
venue_id, version, article_type, source_url (HTTPS), license, engine (pdflatex,
xelatex or lualatex), entrypoint, files (relative paths), and style. Style contains
audience, narrative, structure, citation_rules, length_rules. The supplied strings
are unverified attestations, not proof of current author guidelines or permission.

`paperwriter-plan plan --template-root T --metadata M --root INPUT --package R --candidates C --specification S --output plan.json`
creates an unapproved plan. S contains core_claim, framing, paper_type,
contributions, sections, technical_core, evidence_ownership and display_plan.
Contributions have id, claim_id, technical_home, analysis_home; sections have id,
purpose, word_budget. Every contribution must refer to a real research claim and
existing sections.

Coverage is part of the contract, not commentary. The tool refuses a plan that
leaves it implicit:

- `technical_core.source_coverage[]` — each row is `fact`, `disposition`
  (`body`, `appendix`, `released_artifact`, `omitted`) and `section_id`
  (a real section for `body`, otherwise null). Account for every technical fact
  the sources establish; concise writing is not permission to drop material
  silently, and an omission must be a stated decision.
- `evidence_ownership.evidence_coverage[]` — each row is `evidence_id`,
  `disposition` (`body`, `appendix`, `omitted`) and `analysis_home`. Every
  evidence item in the research package needs a row, and a `body` item gets
  exactly one analysis home. Other sections cite that result; they do not repeat
  its numerical walkthrough.
- `display_plan[]` — each item is `id`, `kind` (`figure`, `table`, `schematic`),
  `purpose`, `section_id` and `evidence_ids`. A figure or table must name the
  evidence it reports; a schematic illustrates an argument and may cite none.
  An empty list is allowed when no display item is justified — say why in
  `framing` rather than inventing one to fill a quota.

For the strict receipt path, send the plan hash, template hash, scope,
contributions, style rules and unresolved issues to the Director. Never generate the approval receipt yourself. The operator
must supply a receipt from outside the agent-writable workspace on a read-only
mount. Receipt fields: decision (approved), plan_sha256, template_sha256, reviewer,
reviewed_at, source_license_review, venue_fit_review. The latter fields describe
actual reviews; do not accept placeholders in real work. The tool does not verify
reviewer identity or cryptographic signatures; trusted receipt delivery is a
required deployment boundary, not implemented by an editable JSON file.

`paperwriter-plan check --template-root T --metadata M --root INPUT --package R --candidates C --plan plan.json --operator-receipt RECEIPT --output gate.json`
re-hashes template files, revalidates research inputs, reconstructs the plan and
checks approval bindings. Omit receipt to explicitly report missing approval.
Exit 2 means blocked; inspect the report, do not suppress or rewrite blockers.
Even an approved plan cannot pass with unsupported contributions or open research
blockers. Byte/content changes require regeneration and new approval.

Always use new output filenames. Do not execute TeX or source code here. Passing
this gate is not PDF/references/visual/reviewer acceptance, nor permission to claim
a publishable paper. The full-draft skill may prepare an externally approved draft;
downstream compilation, independent review, revision and visual acceptance remain
separate required gates, driven by paper_compile, paper_review and paper_lifecycle.
A plan check is not evidence that those gates ran.
