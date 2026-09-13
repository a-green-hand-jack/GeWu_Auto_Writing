---
name: manuscript-review
description: Review a complete manuscript against supplied research evidence and plan, report correctness and unsupported claims, without editing or granting submission approval.
---

# Manuscript review

Read the complete supplied LaTeX sections, research package, source evidence,
plan and provenance. This is a separate bounded review task, not a continuation
that assumes the author's claims are correct. Do not modify the manuscript.

The main agent invokes paper_review through the private reviewer plugin with
persist_session=false and output_transcript=false. The reviewer's ONLY tools are
read, grep, find and ls. Author-side writing/compilation instructions do not apply
to this role. There is no bash, write/edit, paper_* tool, network lookup or nested
agent capability in the reviewer. Do not attempt those operations. Do not spawn another reviewer
or session engine, write a report, or modify any manuscript/check artifact.
Return structured JSON; the main process validates and persists review.json
outside paper source with:
- manuscript source hashes and plan/research hashes;
- dimensions: correctness, technical completeness, clarity, scope discipline,
  references, reproducibility and presentation;
- issues: stable id, severity (critical/blocker/warning/info), file/location, specific
  problem, supporting evidence and requested fix;
- unresolved evidence gaps and proposed checks;
- outcome: revise or ready_for_next_gate (never accepted_for_publication).

## Domain criteria

Read the research assessment's `domain` (or its recorded `domain_knowledge.review`
route), then load the matching reference from the runtime domain directory —
never all at once:

- physics -> `../../domains/physics/review.md` (theory also needs `../../domains/mathematics/review.md`)
- mathematics -> `../../domains/mathematics/review.md`
- life_sciences -> `../../domains/life_sciences/review.md`
- ai_ml -> `../../domains/ai_ml/review.md`

Whenever rendered pages are available, also load `../../domains/layout.md` and apply
it page by page; it is domain-independent. Read the review-context JSON supplied
in the task. The parent runs the same `paper_consistency`, `paper_bibcheck` and
`paper_leakcheck` diagnostics as the author's tools and binds those results to the
current source/evidence. Treat the results as leads to check, not verdicts or
proof of complete coverage. These scans cover top-level .tex and references.bib;
read nested sections and other .bib files independently. A missing, unavailable,
stale or truncated diagnostic is a limitation, never a clean result. Do not call
these tools yourself or substitute a shell command. Verify substantive claims
against actual source locators, not just the author's summaries.

Apply those obligations in addition to the dimensions below. The context JSON
also reports image_input from the active native model declaration, not a live
capability probe. If true, use read on the actual rendered PNG pages and only
claim visual_review=performed after inspecting them. If false/unknown, or image
reading fails, mark visual_review=not_performed and explain the limitation.
Never run a capability command, infer visual content from filenames/text
extraction, or treat a declared capability as an inspection receipt.

Check formula signs/units/assumptions, inferred versus measured quantities,
contribution/evidence alignment, omitted negative results, unsupported novelty,
abstract/conclusion consistency, figure honesty and provenance coverage.
The reviewer has no external retrieval tool. Read supplied literature evidence
and state which citations cannot be independently checked; the author must obtain
missing evidence through its authorized tools. Missing external literature is a
blocker for a real submission; a no-literature synthetic fixture may pass only its
explicitly limited test, not real acceptance.
Do not hallucinate related work, numeric scores or verification of unseen sources.
If only source files are supplied, report visual_review=not_performed. Reading
LaTeX does not inspect rendered PDF pages.

Before revision the main agent uses paper_checkpoint to preserve source outside
the writable paper directory. Validate actual source/plan/research/compile hashes
before accepting review output; an edited or stale manuscript invalidates it.
Timeout, transport failure or malformed JSON is an environment failure, not a
valid revise outcome. At most three valid review rounds are allowed. Changes require re-review of affected claims/sections and new
compilation and visual inspection. Terminating at a round/time limit leaves
critical issues blocking; it does not make the draft ready.

This skill provides model review, not an independent scientific guarantee or a
complete deterministic validator. Final gates must be applied separately.
