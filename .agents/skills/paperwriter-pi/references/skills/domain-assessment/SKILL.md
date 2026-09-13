---
name: domain-assessment
description: Classify a staged solution repo by domain, paper type and evidence maturity from actual content, then select the applicable domain knowledge and review criteria.
---

# Domain assessment

Use after research intake validation. Read the mapped evidence and source
content, never only directory names, titles or README keywords.

Classify into exactly one `domain` and one `paper_type`:

- `domain`: `physics`, `mathematics`, `life_sciences`, `ai_ml`, `mixed`, or
  `unknown`.
- `paper_type`: `theory`, `computation`, `method`, `empirical`, `benchmark`,
  `system`, or `unknown`. Match the actual evidence, not a wish. `computation`
  covers exact enumeration or certificate work: it is not `empirical`, because a
  finite check is not a measurement.

These are the exact values the research package schema enforces; the tool
rejects anything else rather than guessing a near match.

Create `assessment.json` with exactly:

```json
{
  "domain": "physics",
  "paper_type": "theory",
  "rationale": "Explain the research question and the technical evidence motivating these labels.",
  "evidence_ids": ["an_existing_evidence_id"],
  "uncertainties": ["Novelty and venue suitability have not been independently assessed."]
}
```

Labels must match the research package `project`. If they are wrong, correct the
mapping in a new package revision before recommending venues. `mixed`/`unknown`
are valid; a math result with application vocabulary is not automatically
biology, and an empirical paper is not automatically a method paper.

Then record the domain knowledge route. Domain knowledge lives in
`../../domains/<domain>/` and has two files with different load points:

| File | Loaded by | When |
|---|---|---|
| `writing.md` | planning and drafting | before the writing plan, and again before prose |
| `review.md` | whole-paper review | at review time, in the reviewer's fresh context |

Directory names match the schema `domain` values exactly, so route without
translating (load on demand, never all at once):

- `physics` -> `../../domains/physics/`; PRX is the default writing format unless
  the user selects another venue; a `theory` paper also loads
  `../../domains/mathematics/writing.md` and `../../domains/mathematics/review.md`
- `mathematics` -> `../../domains/mathematics/`
- `life_sciences` -> `../../domains/life_sciences/`
- `ai_ml` -> `../../domains/ai_ml/`
- `mixed`/`unknown` -> load the applicable subset explicitly and record the
  unresolved classification as a limitation

`../../domains/layout.md` is domain-independent and applies at review time
whenever rendered pages exist.

Add the selected paths to `assessment.json` as `domain_knowledge` so later stages
route without re-deciding:

```json
"domain_knowledge": {
  "writing": ["../../domains/physics/writing.md", "../../domains/mathematics/writing.md"],
  "review": ["../../domains/physics/review.md", "../../domains/mathematics/review.md"]
}
```

Domain writing guidance is not optional context. A paper drafted without it
reads as generic and is the most common cause of a technically correct but
weak manuscript.

Run `paperwriter-research venues --root INPUT --package research.json
--assessment assessment.json --output venue-candidates.json`. It validates
source hashes and binds the recommendation to the research package hash/revision.
Candidates come from data-driven venue rules; candidate order is not a rank.

Report the rationale, candidates, uncertainties and blocking reasons. Do not
invent years, page limits, licenses or template hashes. Do not call the paper
submission-ready: selection, current template/license verification, scientific
maturity, novelty review and Director approval remain pending.
