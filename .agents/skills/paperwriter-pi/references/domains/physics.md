# Physics papers

Load this during planning, drafting, and review when the assessed domain is
`physics`. It describes what a referee expects; it relaxes no rule in
`constitution.md`.

**Which problems belong here.** Physics is about physical systems and physical
questions: Hamiltonians and equations of motion, spin chains, statistical-
mechanics models, entanglement and quantum information of physical states,
transport, thermodynamics, measurement statistics. A physical model solved by
graph-theoretic or combinatorial means is still physics. Purely mathematical
objects — graphs, designs, matchings, enumeration, extremal or colouring
problems, counterexamples to mathematical conjectures — belong to
`mathematics`, however they are proved and however few theorems they use.

**Template.** A physics manuscript uses the official APS PRX entrypoint
`templates/prx-official/apstemplate.tex` with
`\documentclass[aps,prx,reprint,groupedaddress]{revtex4-2}`. Do not substitute
`article`, `amsart`, PRE, PRL, or `pre-generic` unless the user selected another
venue.

Keep `placeins` and the `\FloatBarrier` before the bibliography, and build
the reference block with the APS separator device plus an explicit centred
heading. REVTeX's APS mode draws its separator rule but prints no heading word,
and a bare `\section*{References}` puts the heading inside one column, which is
not how an APS page looks. Use exactly:

```latex
\FloatBarrier
\makeatletter
\renewcommand{\bibsection}{%
  \par
  \onecolumngrid
  \vspace{19\p@}%
  \bib@device{\textwidth}{245.5\p@}%
  \vspace{3\p@}%
  \begin{center}{\bfseries REFERENCES}\end{center}%
  \vspace{4\p@}%
  \twocolumngrid
  \nobreak
}
\makeatother
\bibliography{references}
```

`\makeatletter`/`\makeatother` are required because `\p@` and `\bib@device`
are internal control sequences. Verified by compiling a produced manuscript:
full-text-width centred REFERENCES, better column balance, entries intact.

## What the reader needs

A physics referee reconstructs the work and then checks it. They need, in order:

1. **The model**, stated precisely enough to be re-derived: Hamiltonian or
   equations of motion, degrees of freedom, state or ensemble, observables,
   units, normalization, boundary conditions, and the parameter regime.
2. **The derivation or protocol**, with approximations named and justified.
3. **The result**, with its regime of validity and its uncertainty.
4. **The physical interpretation** — what mechanism produces this behaviour.

A draft that reports a result without letting the reader rebuild the model is
rejected regardless of correctness. Stating the model completely is the paper's
foundation, not padding.

## Depth calibration — the most common failure

The dominant defect is a thin middle: model, jump, result. For each substantive
result a complete treatment normally contains:

- the **model statement**, displayed, with every symbol defined and units given;
- the **assumptions and their physical meaning** — not just "we assume weak
  coupling" but what that excludes and when it fails;
- the **derivation in followable steps**, with each approximation marked where
  it enters and its expected error;
- **limit checks presented to the reader**, not merely performed:
  non-interacting limit, high/low temperature, single site, decoupled or fully
  aligned states. Showing the formula reduces correctly is the fastest way to
  earn a referee's trust, and it belongs in the paper;
- **dimensional analysis** wherever a prefactor or scaling is claimed;
- **interpretation**: the mechanism, not a restatement of the formula in words;
- **regime of validity and failure modes**.

When the source is a small computation, the length comes from the model, the
derivation, the limit checks, and the interpretation — never from inflating a
finite computation into a general claim.

## Derivations and formal statements

Physics results are presented as physics: prose, display equations,
derivations, and explicitly scoped bounds.

- **Default presentation.** Use prose headings such as `Exact result`,
  `Main result`, `Derivation`, `Bound`, or `Physical interpretation`, with
  displayed equations and a stated validity regime. This is the normal style for
  a physics paper.
- **Formal environments are the exception.** A numbered `Theorem`,
  `Proposition`, `Lemma`, or `Corollary` appears only when the source itself
  establishes a theorem-grade result: explicit hypotheses, a precise
  statement, and a proof or proof-level derivation. Finite-size computations,
  numerically checked identities, fitted forms, and physical mechanisms are
  never wrapped in theorem environments, however cleanly they can be
  restated. If it is not a theorem, write it as a physics result.
- **Quantifier discipline.** Keep universal, existential, conditional, finite,
  asymptotic, and conjectural claims visibly distinct. A finite-size or
  finite-coupling result is not automatically a general one; every
  extrapolation is stated as an assumption with its justification.
- **Prove what you depend on.** A relation imported from another work is stated
  at the point of use — the objects it involves, its hypotheses, its
  conventions — and bound to a source locator a reader can inspect. If that
  passage cannot be inspected, the downstream result is presented as
  conditional on the imported relation, not as established.
- **Notation is a ledger.** Every symbol has one meaning, one domain/codomain or
  unit, and one first definition point; conventions (signs, units, Fourier and
  normalization conventions, index ordering) are fixed once in the model
  section and never changed silently.

## Numerical and finite-size work

Every computation you run is bounded and recorded: keep the script and its
output under `research/checks/` inside the workspace (never `/tmp` or the home
directory), state the finite coverage and a hard cap in the script, wrap it in a
wall-clock guard, and print the coverage actually reached. A check that needs a
third patch, or that has run for more than ~15 minutes without a result, is
replaced by a smaller exact check, an analytic argument, or a claim marked
conditional — see `workflows/production.md` §7b. Do not spend the run looping.

When the evidence is computational, the protocol is part of the result:

- system sizes, parameters, discretization, tolerances, and the convergence
  criterion actually used;
- what was verified independently — a conserved quantity, a sum rule, a known
  limit, an identity that must hold;
- the **exact finite coverage**: which sizes, which couplings, which
  separations, reported as a fact and not as evidence of generality;
- extrapolation, if any, with its assumptions stated as assumptions.

A finite-size result is not a thermodynamic-limit result. A finite grid does not
establish an infinite-system claim. State the gap explicitly; a referee who
finds it glossed stops trusting the rest.

## Structure follows the physics

- **Introduction**: the phenomenon, why it is interesting, what is established,
  what this paper contributes, informally stated.
- **Model**: complete and self-contained, with conventions fixed here.
- **Method / derivation**: analytic steps, or the computational protocol.
- **Results**: what was found, with uncertainty and coverage.
- **Discussion**: mechanism, limits of validity, relation to known results,
  what would falsify or extend this.
- **Conclusion**: what is now established, at what scope.

Do not impose an experimental-paper skeleton on a theory paper, and do not add
a figure to meet a quota.

## Composition patterns

Apply the smallest pattern set that matches the assessed paper type:

- **Theory**: model definitions, assumptions, derivation, limits, and the scope
  of what is established, in prose and equations.
- **Computation**: model, algorithm, reproducible protocol, finite coverage,
  convergence/accuracy, and a comparison baseline.
- **Experiment**: physical question, apparatus and measurement model, controls,
  uncertainty, sensitivity, and failure/noise analysis.

Across all three: open with the reader-facing problem, the specific gap, and
the contribution; give intuition before full machinery; separate the formal
result from the calibration examples; and end each major result by stating what
is established, under which assumptions, and what remains unresolved. Keep
measured, computed, derived, and assumed quantities visibly distinct.

## Craft

- **Fix conventions once**, in the model section. Silent convention changes
  mid-paper are a classic critical defect.
- **Every number carries units, precision, and provenance.** A bare number in a
  table is incomplete.
- **Figures earn their place.** State the scientific purpose, axes with units,
  what the reader should see, and what the figure does not show. A schematic is
  not data; an analytic curve is not a measurement.
- **Write the abstract last**, with the actual regime and the actual scope.

## Interpretation is not decoration

The discussion is where physics papers are won or lost. Explain the mechanism:
why this coupling produces this scaling, which competing effects were balanced,
what would change the answer qualitatively. A discussion that restates the
results section in prose is the most common reason a technically correct paper
reads as weak.

## Never

Fabricate data, error bars, baselines, a protocol, a citation, or a novelty
claim. Do not present an approximate treatment as exact, change the model
silently between sections, claim a limit you did not resolve, or extend a finite
result to the thermodynamic limit without stating the extrapolation as an
assumption. Correct or explicitly scope known errors.

## The abstract

Continuous prose, written last. State the system, what was derived or computed,
the result, and its regime of validity.

- **No formulas.** Name the quantity and its role; the identity belongs in the
  model section.
- **No reported values.** Tolerances, grid sizes, fitted coefficients, and
  residuals belong in the results section or a table.
- **Give the regime.** An abstract without the parameter range, the order of the
  expansion, or the approximation used has omitted the paper's scope.

## Where numbers live

A physics draft can accumulate hundreds of reported values in prose and become
unreadable while every number is individually correct.

- Every parameter sweep, convergence study, and coefficient comparison becomes a
  table with units, precision, and a caption stating what was varied.
- In prose keep only the values the argument turns on, each with its units and
  what produced it.
- Numerical protocol detail — solver, tolerances, grid — goes to a methods
  subsection or an appendix, stated once, not repeated per result.

## Appendices

Article-length Physical Review journals have no page limit, so extended material
is relocated rather than cut. Appendices carry: the full derivation whose result
the body quotes, parameter and convergence tables, the numerical protocol, and
limit checks worked in full. The body states the result, the check performed,
and points to the appendix.

## Figures

Every figure needs a scientific purpose stated in the caption: axes with units,
what varies, and what the reader should conclude. A schematic of the geometry is
often the most useful figure in a theory paper and is honest as long as it is
labelled a schematic. An analytic curve is not a measurement, and a plot of
values you did not compute is fabrication. If a result is better read as a
table, use a table.

## Review checklist

Applied during whole-paper review, in addition to the shared dimensions in
`workflows/review.md`:

- Recover and restate the Hamiltonian/equations of motion, state or ensemble,
  observables, units, normalization, boundary conditions, and the permitted
  parameter regime. The paper must not silently change the model.
- Check symmetries and conservation laws against the stated model, not a nearby
  model. Distinguish classical, quantum, and effective/approximate treatments.
- Check degeneracies, zero/equal couplings, projector definitions, and the order
  of time, size, temperature, field, and continuum limits. A finite-size result
  is not automatically a thermodynamic-limit result; track every extrapolation
  assumption.
- A finite-size counterexample refutes a finite-size universal equality without
  settling the thermodynamic limit; do not impose the extra task. A finite-grid
  computation does not establish an infinite-system claim.
- A convenient formula may have a finite parameter limit while the underlying
  basis or operator construction becomes singular. Check claimed endpoint
  limits only when they are material, and resolve 0/0 or diverging cases
  explicitly.
- Verify signs, prefactors, dimensions, and normalization using tractable limits
  (non-interacting, high/low temperature, single site, fully aligned states).
  These constrain validity; they do not replace the full argument.
- Check that no ordinary physical result has been promoted into a theorem
  environment without theorem-level evidence, and that no finite computation is
  presented as a general statement.
- State uncertainty and consult precise external results when domain knowledge
  is uncertain; do not invent an authoritative citation.

Report issues with severity `critical`/`warning`/`info`, exact equation/file
location, and the independent check performed. Missing or wrong units, unstated
boundary conditions, a hidden model change, or an over-claimed limit are
critical unless explicitly scoped.
