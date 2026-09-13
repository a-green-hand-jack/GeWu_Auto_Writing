# Evidence levels

Classify every claim by the strongest evidence that actually supports it, and
say what that evidence does and does not establish. A single claim may need
several levels; the weakest decisive link determines its status.

## Levels

| Level | What it is | What it establishes |
|---|---|---|
| `derivation` | A self-contained symbolic or analytic argument, with assumptions and endpoints | The statement under the stated assumptions; not empirical generality |
| `exact_certificate` | Independent enumeration/symbolic arithmetic with a reproducible checker and full coverage statement | The finitely-checked instances only, not the general statement |
| `numerical_check` | Bounded floating-point evaluation with tolerances | Agreement within tolerance for the enumerated cases; not a proof, and a small residual can mask forward error |
| `experiment` | A reproducible protocol with data, seeds/units, uncertainty, and no train/test leakage | The observed result under that protocol; generalizability needs stated assumptions |
| `citation` | A published source whose relevant content was inspected | That the cited work states/supports the attributed point; metadata alone does not establish content |
| `assumption` | A declared modelling or scope choice | A premise, not a conclusion; downstream results are conditional on it |

## Rules

- Do not relabel a lower level as a higher one to pass a gate. `needs_review`
  stays pending until it is independently checked; invalidated evidence blocks
  any claim that depends on it.
- Provenance must record the transformation for every number (formula -> value,
  units, rounding, source of the input data).
- For theory work, seeds/baselines/datasets are applicability checks, not
  mandatory fields; forcing them fabricates experiment structure.
- For empirical work, missing protocol, uncertainty or leakage handling is a
  blocker, not a style note.

## Citations

- Record identifier (DOI/stable URL), bibliographic fields, metadata source and
  retrieval hash, plus the exact supporting passage when available. Mark
  metadata-only inspection as such; do not attribute unseen technical results
  to a source you could not read.
- Use references to support, not to decorate. An inaccessible key reference is an
  unresolved item, not a silent gap.
