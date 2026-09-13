---
name: visual-receipt
description: Verify an external per-page visual review receipt against the exact compiled PDF and rendered page hashes without claiming scientific or publication acceptance.
---

# Visual receipt

The operator/reviewer must actually inspect every final rendered page. Neither
successful compilation nor extracted PDF text proves visual quality. Apply the
layout criteria in
[layout criteria](../../domains/layout.md):
overflow, rendering defects, whitespace, stranded headings, float placement,
caption self-containment, figure legibility and page count against the venue
limit. Recording "looks fine" without those specific observations is not an
inspection.

Before inspecting images, run
`paperwriter-capabilities --provider P --model M --require-vision`; if it exits
nonzero, record visual evidence as unreviewed instead of fabricating observations.

For the local model-observation path, inspect EVERY rendered page with an
image-capable active model, then write a JSON record outside paper/:
`{source:"model", visual_review:"performed", pdf_sha256, pages:[{page:1,
sha256, observation:"specific observations of this actual page"}], blockers:[]}`.
Use consecutive one-based page numbers and actual rendered-image hashes.
Record it with `paper_lifecycle(action="record", phase="visual",
outcome="passed", artifact="checks/<unique-record>.json")`. The tool rejects
missing pages, stale hashes, blockers, and models that lack declared image input.
These are model observations, never an operator approval receipt. Do not invent
observations to fill the record; report missing vision as an explicit blocker.

Only after actual page inspection may a visual-capable independent reviewer
provide structured observations. The private-plugin reviewer returns JSON and
the main process validates/persists it; it does not save transcripts. This is not
author scientific approval. For the strict external receipt path, only the
external reviewer may provide a receipt containing
schema_version=1, reviewer, reviewed_at (ISO timestamp with timezone), pdf_sha256,
and pages. Every page entry contains file, sha256, decision (pass or fail), and
concrete observations. File names/hashes come from compile-report.json. Do not
create receipts for unseen pages or infer pass from the absence of compiler errors.

Run `paperwriter-visual-check --compiled-dir COMPILED --operator-receipt RECEIPT
--output REPORT`. Receipt must be in an operator-controlled read-only mount; report
must be fresh and outside compiled artifacts. This tool has no approve command.

The checker rejects stale PDF/render hashes, missing or duplicate page reviews,
failed pages, blank observations and compile blockers. Any changed PDF bytes require
new rendering and inspection. A changed screenshot requires renewed review too.

A pass proves receipt/artifact binding and coverage, not reviewer identity,
scientific validity, copyright, citation correctness or submission readiness.
Never modify compile metadata to hide failures. Use paper_lifecycle verify/deliver
to recompute actual artifact hashes; a saved passed flag cannot replace this gate.
Missing visual capability/observations means incomplete, even after the time or
round limit. Reference and provenance checks,
whole-manuscript review and final Director handoff remain separate gates.
