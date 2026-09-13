# Paper-writing principles

Shared rules for every domain and venue. Domain-specific and venue-specific
requirements are selected on demand, never all loaded at once.

## Truthfulness and scope

- Write only what the sources support. Accepted labels, prior PASS logs, an
  author's claims and a model's own summary are not verification.
- State assumptions, parameter regimes, boundary conditions and exclusions.
  A partial result is a legitimate paper when its scope is explicit; do not
  silently upgrade it to a general theorem or a solved open problem.
- Distinguish: analytic derivation, finite numerical check, experiment,
  imported theorem, citation, and assumption. Numerical examples do not prove
  universal statements; one counterexample refutes a universal claim.
- Never fabricate experiments, data, seeds, baselines, citations, authors,
  licenses, novelty, proofs, review results or approval.

## Provenance

- Every substantive claim maps to a source locator (path, version/hash, line or
  region) plus its evidence level. Numeric results carry units, rounding, and
  the transformation that produced them.
- Keep the research package, plan, provenance and review records outside the
  LaTeX source tree. A changed input, template, manuscript byte or compiled PDF
  invalidates the downstream compile, review and visual results bound to it.

## Completeness versus padding

- Cover the technical core, the actual evidence, contextual literature, and an
  honest discussion/limitations/conclusion. Do not inflate weak content into a
  stronger claim, and do not add experiments to a theory paper, plots to meet a
  quota, or citations to look cited.
- A truthful expository paper is better than an invented breakthrough. Length
  follows content and venue rules, not a filler target.

## Review and delivery

- Review is a separate bounded context that re-derives/checks, not an author's
  self-attestation. Resolve factual defects, preserve corrected content, and
  never revert a fix because an aesthetic score fell.
- A complete draft is not submission-ready. Compilation, whole-paper review,
  visual inspection and citation/provenance checks are gates; reviewer scores
  and successful exit codes alone are not acceptance.
