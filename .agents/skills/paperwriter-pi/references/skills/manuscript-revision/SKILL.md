---
name: manuscript-revision
description: Apply a scoped Patch or authorized Reframe to an existing manuscript, preserving checkpoints and cascading evidence, citation, compilation and review invalidation.
---

# Patch and Reframe

The designated previous manuscript is legitimate input only for explicit revision
requests, not an independent Full Draft. Read its plan, provenance, unresolved
issues and check reports before changing it. Check that the source/template hashes
still match; if not, re-index changed evidence and do not inherit verified status.

Use paper_workspace in the requested revision/resume mode and the returned paths;
paper_lifecycle status/verify must recheck actual artifact hashes, not a saved
conversation. Before mutation use paper_checkpoint to create a private source
checkpoint outside paper/ with a hash manifest. Never overwrite a previous checkpoint, original input or last valid PDF.
Use native file tools, not a parallel model/session engine.

Patch: identify requested change and the affected claims, equations, sections,
figures, table rows, abstract/conclusion assertions and bibliography keys. Change
only what is required, but update ALL affected references and derived assertions.
Record revision.json with mode, base/current manuscript manifests, request scope,
changed files, affected claim IDs, dispositions and invalidated checks. A typo-only
patch still invalidates the PDF/visual hash; material changes require scientific
and whole-paper re-review. Preserve untouched source bytes where feasible.

Reframe: requires explicit task authorization for the new scope, audience or venue.
Do not call a style edit proof of higher novelty. Make a new plan/venue assessment,
recheck template/license rules, map old supported contributions to new sections and
remove unsupported upgraded claims. Legacy hash-bound plan approvals become stale;
a delegated draft policy only authorizes venues within its explicit allowlist.
A changed template needs a new operator policy, not an author-edited receipt.

Call paper_compile for isolated local recompilation, then paper_review for the
private-plugin whole-paper review; reviewer JSON is persisted by the main process.
Fix compile errors in small batches and recompile without ending the main run.
Inspect every new PDF page, and use paper_lifecycle verify/deliver to re-bind
actual artifact hashes. Keep six compile attempts, three valid review rounds and
7,200/10,800-second budgets. Timeout is not an effective revise review. Stop after the configured
round limit with remaining issues; never declare ready because iterations ended.
Rollback restores a chosen source checkpoint into a NEW directory and invalidates
all downstream reports. Never automatically revert a factual correction because
an aesthetic score fell. State exactly which behavior was exercised by the run.
