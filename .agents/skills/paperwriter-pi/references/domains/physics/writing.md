# Writing a physics paper

Load this during planning and drafting when the assessed domain is `physics`.
For a theory paper also load `../math/writing.md` for the derivation. This
describes what a referee expects; it relaxes no truthfulness rule.

## What the reader needs

A physics referee reconstructs your work in their head. They need, in order:

1. **The model**, stated precisely enough to be re-derived: Hamiltonian or
   equations of motion, degrees of freedom, state or ensemble, observables,
   units, normalization, boundary conditions, and the parameter regime.
2. **The derivation or protocol**, with approximations named and justified.
3. **The result**, with its regime of validity and its uncertainty.
4. **The physical interpretation** — what mechanism produces this behaviour.

A draft that reports a result without letting the reader rebuild the model is
rejected regardless of correctness. Stating the model completely is not padding;
it is the paper's foundation.

## Depth calibration — the most common failure

The dominant defect is a thin middle: model, jump, result. For each substantive
result a complete treatment normally contains:

- the **model statement**, displayed, with every symbol defined and units given;
- the **assumptions and their physical meaning** — not just "we assume weak
  coupling" but what that excludes and when it fails;
- the **derivation in followable steps**, with each approximation marked at the
  point it enters and its expected error;
- **limit checks presented to the reader**, not merely performed. Non-interacting
  limit, high/low temperature, single site, decoupled or fully aligned states —
  showing your formula reduces correctly is the fastest way to earn a referee's
  trust, and it belongs in the paper;
- **dimensional analysis** where a prefactor or scaling is claimed;
- **interpretation**: the mechanism, not a restatement of the formula in words;
- **regime of validity and failure modes**.

When the source is a small computation, the length comes from the model, the
derivation, the limit checks and the interpretation — never from inflating a
finite computation into a general claim.

## Numerical and finite-size work

If the evidence is computational, the protocol is part of the result:

- system sizes, parameters, discretization, tolerances, and the convergence
  criterion actually used;
- what was verified independently (a conserved quantity, a sum rule, a known
  limit, an identity that must hold);
- the **exact finite coverage**: which sizes, which couplings, which separations.
  Report it as a fact, not as evidence of generality;
- extrapolation, if any, with its assumptions stated as assumptions.

A finite-size result is not a thermodynamic-limit result. A finite grid does not
establish an infinite-system claim. State the gap explicitly; a referee who finds
you glossing it stops trusting the rest.

## Structure follows the physics

- **Introduction**: the phenomenon, why it is interesting, what is established,
  what this paper contributes, informally stated.
- **Model**: complete and self-contained, with conventions fixed here.
- **Method / derivation**: analytic steps, or the computational protocol.
- **Results**: what was found, with uncertainty and coverage.
- **Discussion**: mechanism, limits of validity, relation to known results,
  what would falsify or extend this.
- **Conclusion**: what is now established, at what scope.

Do not impose an experimental-paper skeleton on a theory paper, and do not add a
figure to meet a quota. Section structure must match the science.

## Writing DNA: reference-informed composition patterns

These are distilled, reviewed composition patterns from real physics papers.
They guide exposition; they are not text to imitate and do not constitute
venue or scientific acceptance evidence. The runtime receives these abstractions
only; source papers and extraction evidence remain development artifacts.

- Open with a reader-facing problem, the specific gap, and the contribution. A
  formal mathematical theorem should appear only when the source establishes a
  theorem-level result; otherwise introduce the result through physical
  motivation, derivation, and interpretation. An algorithm or apparatus should
  appear only after the reader knows why it resolves the gap.
- For theory and computation, give intuition before the full formal machinery,
  then separate the formal result from the examples or numerical calibration.
  Numerical checks establish the stated finite claim or tightness; they do not
  replace a proof or widen its scope.
- For experiments, move from physical motivation to the signal/model, then the
  measurement protocol, apparatus, sensitivity and known noise. Preserve a
  section roadmap when the chain has several stages.
- Use appendices or supplemental material for derivations, implementation and
  noise detail only after the main text states the result and points to why the
  detail matters. The main paper must remain self-contained.
- End each major result by stating what is established, under which assumptions,
  and what remains unresolved. Keep projected capability, measured data,
  computed values and proven statements visibly distinct.

Apply the smallest pattern set that matches the assessed paper type:

- **Theory**: model definitions, assumptions, derivation, limits, and proof
  scope. Use a numbered `Theorem`, `Proposition`, `Lemma`, or `Corollary` only
  when the source contains a genuinely formal statement with explicit
  hypotheses and a proof or proof-level derivation. This is not the default
  style for physics. For ordinary physical results, use prose headings such as
  `Exact result`, `Main result`, `Derivation`, `Bound`, or `Physical
  interpretation`; do not wrap equations, finite computations, or physical
  observations in mathematical theorem environments.
- **Computation**: model, algorithm, reproducible protocol, finite coverage,
  convergence/accuracy and comparison baseline.
- **Experiment**: physical question, apparatus and measurement model, controls,
  uncertainty, sensitivity and failure/noise analysis.

## Craft

- **Fix conventions once**, in the model section: signs, units (or explicit
  natural units), Fourier and normalization conventions, index ordering. Silent
  convention changes mid-paper are a classic critical defect.
- **Every number carries units, precision and provenance.** A bare number in a
  table is incomplete.
- **Distinguish measured, computed, derived and assumed quantities** in the prose
  as well as in the provenance record.
- **Figures must earn their place.** State the scientific purpose, axes with
  units, what the reader should see, and what the figure does not show. A
  schematic is not data; an analytic curve is not a measurement.
- **Write the abstract last**, with the actual regime and the actual scope.

## Interpretation is not decoration

The discussion is where physics papers are won or lost. Explain the mechanism:
why does this coupling produce this scaling, which competing effects were
balanced, what would change the answer qualitatively. A discussion that restates
the results section in prose is the most common reason a technically correct
paper reads as weak.

## Never

Fabricate data, error bars, baselines, a protocol, a citation or a novelty claim.
Do not present an approximate treatment as exact, change the model silently
between sections, claim a limit you did not resolve, or extend a finite result to
the thermodynamic limit without stating the extrapolation as an assumption.
Correct or explicitly scope known errors rather than concealing them.

## The abstract

Write it last, as continuous prose. A physics abstract states the system, what
was derived or computed, the result, and its regime of validity.

- **No formulas.** `$b^2=\lambda^2+\eta+a^2(\hat{\bm s}\cdot\bm n)^2$` in an
  abstract is unreadable and tells the reader nothing they can act on. Name the
  quantity and its role instead; the identity belongs in the model section.
- **No reported values.** Tolerances, grid sizes, fitted coefficients and
  residuals belong in the results section or a table.
- **Give the regime.** An abstract without the parameter range, the order of the
  expansion, or the approximation used has omitted the paper's actual scope.

`paper_style` counts these: a span longer than 60 characters, three or more
relational expressions, or more than two reported values all block handoff.

## Where numbers live

A physics draft can accumulate hundreds of reported values in prose — tolerances,
sizes, couplings, separations, residuals — and become unreadable while every
number is individually correct.

- Every parameter sweep, convergence study and coefficient comparison becomes a
  table with units, precision and a caption stating what was varied.
- In prose keep only values the argument turns on, each with its units and what
  produced it.
- Numerical protocol detail — solver, tolerances, launch radius, grid — goes to a
  methods subsection or an appendix, stated once, not repeated per result.

## Appendices

Article-length Physical Review journals have no page limit, so extended material
is relocated rather than cut. Appendices carry: the full derivation whose result
the body quotes, parameter and convergence tables, the numerical protocol, and
limit checks worked in full. The body then states the result, the check that was
performed, and points to the appendix.

## Figures

Every figure needs a scientific purpose stated in the caption: axes with units,
what varies, and what the reader should conclude. A schematic of the geometry is
often the most useful figure in a theory paper and is honest as long as it is
labelled a schematic. An analytic curve is not a measurement, and a plot of
values you did not compute is fabrication. If a result is better read as a table,
use a table.
