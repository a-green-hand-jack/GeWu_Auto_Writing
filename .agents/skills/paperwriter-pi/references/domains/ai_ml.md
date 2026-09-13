# AI/ML papers

Load this during planning, drafting, and review when the assessed domain is
`ai_ml` or an empirical-computation paper. It relaxes no rule in
`constitution.md`. The obligations below are writing requirements as much as
review criteria: a paper that omits them is incomplete at drafting time, not
merely at review time.

## Obligations

- **Problem and method**: state the task, data, model class, objective, and
  training protocol precisely. A method must be reproducible from the text plus
  the released code.
- **Experiments**: report datasets with sources and licenses, train/validation/
  test splits and leakage controls, hyperparameters, seeds, and compute budgets.
  Multiple seeds are expected for variance-sensitive claims; a single run does
  not support a stable ranking.
- **Baselines**: compare against relevant, correctly configured baselines; do
  not invent a weaker baseline or omit a standard one without justification.
  Report ablations for the claimed components.
- **Metrics**: define them, report uncertainty (std/CI across seeds) where
  meaningful, and do not over-claim from a single metric or a cherry-picked
  subset. Statistical significance needs a stated test and correction.
- **Honesty**: state limitations, failure cases, generalization assumptions, and
  computational cost. Do not claim state of the art from one benchmark, or
  novelty without a literature check.
- **Figures/tables**: axes, units, error bars, seeds, and caption consistency;
  verify the visual content is actually inspected when the model has image
  capability, and record visual review as not performed when it does not.
- **Release statements** must match the venue. Missing reproducibility is a
  blocker for an empirical claim, not a style note.

Report issues with severity and exact section/figure/table location. Leakage,
missing seeds/uncertainty, a fabricated or misconfigured baseline, or an
unsupported state-of-the-art or novelty claim is critical.
