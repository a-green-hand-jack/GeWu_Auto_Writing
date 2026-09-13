# Domain-adaptive review

The whole-paper review must apply the review criteria that match the paper's
domain and paper type, not one generic rubric for everything.

1. Read the domain assessment (`assessment.json` from the domain-assessment
   skill) and the venue candidates. Note `domain` and `paper_type`, and use the
   recorded `domain_knowledge.review` route when present.
   Load only the matching criteria from the runtime domain directory:
   - `physics` -> `../domains/physics/review.md`, plus `../domains/mathematics/review.md` for theory
   - `mathematics` -> `../domains/mathematics/review.md`
   - `life_sciences` -> `../domains/life_sciences/review.md`
   - `ai_ml` -> `../domains/ai_ml/review.md`
   - `mixed`/`unknown` -> apply the relevant subset explicitly and record the
     unresolved classification as a review limitation.
   Additionally load `../domains/layout.md` whenever rendered pages exist; it is
   domain-independent and is the only place that says what a page inspection must
   actually check.
2. Run `paperwriter-capabilities --provider P --model M --require-vision` before
   claiming any pixel-level observation. A text-only model must mark figures,
   plots and scanned pages as unreviewed and calibrate the outcome accordingly;
   it must not infer visual content from filenames or text extraction.
3. Check the domain obligations (units/limits/order of limits for physics;
   quantifiers/proof-vs-certificate for math; methods/statistics/ethics for life
   sciences; baselines/seeds/leakage for AI-ML) in addition to the shared
   correctness, completeness, clarity, scope, references, reproducibility and
   presentation dimensions.
4. Report issues with stable ids, severity, exact location, the independent check
   performed, and the requested fix. The outcome remains `revise` or
   `ready_for_next_gate`; it is never `accepted_for_publication`, and a
   reviewer's pass is not scientific certification.

Different domains have different requirements; a single generic prompt is not
sufficient. Select the criteria from the evidence, and record exactly which
reference files were applied in the review JSON.
