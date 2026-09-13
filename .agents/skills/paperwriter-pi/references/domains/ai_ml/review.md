# AI/ML manuscript review

For machine-learning and empirical-computation papers. Combine with numerical
(statistics/conditioning) obligations.

- Problem and method: state the task, data, model class, objective and training
  protocol precisely. A method must be reproducible from the text plus code.
- Experiments: report datasets with sources/licenses, train/validation/test
  splits and leakage controls, hyperparameters, seeds, and compute budgets.
  Multiple seeds are expected for variance-sensitive claims; a single run does
  not support a stable ranking.
- Baselines: compare against relevant, correctly configured baselines; do not
  invent a weaker baseline or omit a standard one without justification.
  Report ablations for the claimed components.
- Metrics: define them, report uncertainty (std/CI across seeds) where
  meaningful, and do not over-claim from a single metric or cherry-picked
  subset. Statistical significance needs a stated test and correction.
- Honesty: state limitations, failure cases, generalization assumptions and
  computational cost. Do not claim SOTA from one benchmark, or novelty without
  a literature check.
- Figures/tables: axes, units, error bars, seeds, and caption consistency; verify
  the visual content is actually inspected when the model has image capability.
- Code/data release statements match the venue; missing reproducibility is a
  blocker for empirical claims.

Report issues with severity and exact section/figure/table location. Leakage,
missing seeds/uncertainty, a fabricated or misconfigured baseline, or an
unsupported SOTA/novelty claim is critical.
