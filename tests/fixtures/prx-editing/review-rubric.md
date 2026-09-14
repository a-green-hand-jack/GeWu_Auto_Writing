# Independent review rubric — synthetic two-reservoir editing test

Status: established from source materials and brief before inspecting either output. No presumption that either output improves the source. Outputs remain unread.

## Scope and evidence

Read: `brief.md`; source `main.tex`, `model-note.md`, `algebra-note.md`, `references.bib`, and `gewu-top30/AUTHORSHIP.json`. The fixture is an elementary exact calculation, explicitly synthetic, with no research novelty, experiment, apparatus validation, external literature, or submission-readiness claim. PRX is a selected format, not evidence of suitability or acceptance. Review later uses actual TeX/BibTeX, compiled PDF pages, change log, and validation notes. Agent self-reports do not establish scientific or visual correctness.

## Scientific invariants

1. **Model/domain.** Positive constant heat capacities C1,C2 and conductance G; positive initial temperatures; forward times t >= 0. Both bodies are internally equilibrated and represented by one temperature each; the pair is isolated and contact heat storage negligible. Entropy differential dSi = Ci dTi/Ti is stipulated for these equilibrium bodies. No small-temperature-difference expansion is needed within the stipulated linear-contact model. Exactness of its solution does not validate the contact law for arbitrary real bodies.
2. **Balances/conservation.** C1 dT1/dt = -G(T1-T2), C2 dT2/dt = +G(T1-T2). The conserved quantity is C1 T1 + C2 T2. The weighted mean T* = (C1 T10 + C2 T20)/(C1+C2) is fixed by initial energy, not an independent bath temperature. Both approach T* for G > 0 as t -> infinity.
3. **Relaxation.** Delta = T1-T2; lambda = G(1/C1+1/C2); dDelta/dt = -lambda Delta; Delta(t) = Delta0 exp(-lambda t). T1 = T* + C2 Delta/(C1+C2); T2 = T* - C1 Delta/(C1+C2). Equivalent Ti = T* + (Ti0-T*) exp(-lambda t). Signs, heat-capacity weights, exponent, and inverse-time dimension must agree. Initial conditions and conserved energy are recovered.
4. **Positivity.** For t >= 0 and G > 0, Ti(t) is a convex combination of positive Ti0 and T*. Thus both temperatures stay strictly positive, including unequal initial temperatures without a linearized entropy approximation. Rewording must preserve the time domain and positivity premises.
5. **Entropy.** S(t)-S(0) = sum_i Ci ln[Ti(t)/Ti0], with entropy defined up to additive constants. dS/dt = G Delta(t)^2/[T1(t)T2(t)] >= 0. Under G > 0, equality at finite time requires equal temperatures; unequal initial temperatures give strictly positive production at every finite time and approach zero asymptotically. Label exchange reverses signed heat flux but preserves entropy production. Delta S_infinity = sum_i Ci ln(T*/Ti0) >= 0. Dimensions: entropy/time for dS/dt. No invented microscopic or empirical interpretation.
6. **Equal capacities/bath limit.** C1=C2=C gives the arithmetic mean and lambda=2G/C. C2 -> infinity at fixed finite time, fixed C1,G and fixed initial temperatures gives T2(t) -> T20, T* -> T20, lambda -> G/C1, and T1(t) -> T20+(T10-T20)exp(-Gt/C1). The fixed-quantity qualifications must remain discoverable where the limit is stated; do not silently turn a finite body into an unchanged bath.
7. **Zero conductance/order of limits.** G -> 0+ gives lambda -> 0+ and divergent relaxation time; the conserved weighted mean remains defined. Exactly G=0 makes every initial pair stationary, with no generic common-temperature relaxation. For unequal initial temperatures, taking t -> infinity first at G > 0 yields T*, while taking G -> 0+ first at finite t retains initial temperatures. A table saying the mean is unchanged must not imply equilibration at G=0.
8. **Boundaries.** Constant material parameters, internal equilibrium, and no resolved spatial gradients delimit all exact results. No proof of a microscopic mechanism, experimental accuracy, new transport law, measurements, fitted parameters, unsupported novelty, or PRX significance may be inserted.

## Editorial, provenance, and artifact rubric

- **Authorship/disclosure (hard gate):** preserve the documented display name `Synthetic Test Author`, fictional identity, explicit synthetic-fixture identification, and a production disclosure. Do not fabricate affiliation, ORCID, contributions, real collaborators, research origin, or submission status. Production disclosure can be rephrased or placed differently without losing meaning.
- **Citations (hard gate):** retain meaning and provenance of both synthetic local notes. Bibliography entries must not become external scholarship; no fabricated references or invented literature coverage. An unmet external-literature requirement belongs honestly in validation notes. Relocated citations must still support the adjacent model/algebra statements.
- **Source protection (hard gate):** verify original source bytes against the pre-output snapshot below; output edits confined to assigned workspaces. Source immutability does not by itself establish lack of cross-variant inspection; that requires available execution evidence, otherwise state unverified.
- **TeX/math inspection:** compare mathematical content and limiting qualifiers directly, including table cells, captions, abstract, appendix, and cross-references. A notation change is acceptable if complete and consistent. Compilation is a mechanical check, not a scientific check.
- **Structure and language:** identify actual section moves, merges, additions, deletions, abstract/conclusion changes, and changes to equation/table placement. Judge clarity, logical dependencies, redundancy, and whether qualifications remain close enough to claims to avoid misleading readings. Reorganization is permitted by the brief; neither retention nor departure is intrinsically better. Do not reward cosmetic section renaming as substantive improvement.
- **PDF inspection:** inspect every rendered page at readable scale. Record real clipping, overlap, unreadable math, table overflow, bad column/page breaks, heading separation, blank or sparse pages, inconsistent spacing, unresolved references, and visibly broken bibliography. Distinguish confirmed visual defects from log warnings or stylistic preference. Ordinary short final columns or whitespace alone are not automatic failures; explain any demonstrated reading impact.
- **Delivery/validation honesty:** require actual revised TeX/BibTeX, a PDF if compilation succeeds, concise change log, and validation notes including performed/skipped checks, resources read, and unmet literature/coverage constraints. Check reported compilation success, page count, reference resolution, and visual inspection against artifacts. Do not equate completion of this bounded task with submission readiness.

## Decision method

Review blinded labels A/B as far as artifact identity permits. Inspect each independently before comparative judgment. For each report: scientific invariants PASS/FAIL/UNVERIFIED with exact file or equation evidence; provenance/source protection result; actual structural changes; page-specific visual findings; validation honesty; and overall bounded-task verdict. Classify claim-changing or provenance violations as critical, readability/structural defects by actual consequence, and mere preferences explicitly as preferences. Any comparative conclusion must trace to concrete differences; ties or regressions are allowed. No external fetches or new research are part of this review.

## Pre-output source snapshot (SHA-256)

- `source/algebra-note.md`: `6159641c8fe304eeb4631db9117d4b16bcd3584cfb4d88102a7c521f0e2e7cd2`
- `source/gewu-top30/AUTHORSHIP.json`: `365078a01333ec11375f96a359085b7ad8bec13caa1dd0e402ff2cfad04886fe`
- `source/main.tex`: `7a9c1d235eb94f5e69f21b48f3ece3053e96d803733ed589d1b76b31e0044f0c`
- `source/model-note.md`: `e88d12def92878d4539fdbf30f33db06d6e56ee0c07624e7e3c2e3b1269ee65e`
- `source/references.bib`: `da22b9950330213cf3ed40196b14d620ba7c899d07595a0c7aa7ae33e4907bb8`
