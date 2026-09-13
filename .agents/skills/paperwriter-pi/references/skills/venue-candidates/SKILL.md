---
name: venue-candidates
description: Generate initial venue candidates from an evidence-linked domain assessment, without granting writing approval or inventing template metadata.
---

# Venue candidates

Use after research intake validation, when the user requests domain/venue
planning. The `assessment.json` contract, its labels and the rules for correcting
a wrong classification live in
[domain-assessment](../domain-assessment/SKILL.md) — produce it there first
rather than restating the schema here.

With a validated package and assessment, run:

```text
paperwriter-research venues --source-home-adam-walker INPUT --package research.json --assessment assessment.json --output venue-candidates.json
```

The command validates source hashes and binds the recommendation to the canonical
research package hash/revision. It rejects dangling or invalidated assessment
evidence. Write the result to `research/venue-candidates.json`, where the native
diagnostics look for the venue's page budget.

Candidates use the user's initial policy: physics defaults to PRX writing format
and includes PRL/PRE as explicit alternatives, life sciences uses Nature
Communications, and AI/ML uses ICLR/ICML. Mathematics and other unsupported
domains must report a policy gap, not default to ICLR. Candidate order is not a
suitability rank, and a candidate is not a selection.

Each candidate carries a template availability of `official-redistributable`,
`official-guidelines-only` or `none`. Adopting a venue's typography is never
evidence of meeting its originality or importance bar; keep style separate from
suitability.

Report the rationale, candidates, uncertainties and blocking reasons. The official
site is a navigation aid, not a checked template source. Do not invent years,
tracks, page limits, licenses, template hashes or venue-specific style contracts.
Do not call the paper submission-ready: selection, current template verification,
Director approval, scientific maturity and novelty review remain pending.
