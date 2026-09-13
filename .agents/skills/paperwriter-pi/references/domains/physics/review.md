# Physics manuscript review

Combine with math (derivations) and numerical (finite checks) obligations
according to the actual evidence. These are independent checks, not a substitute
for a careful reading.

- Recover and restate the Hamiltonian/equations of motion, state or ensemble,
  observables, units, normalization, boundary conditions and permitted parameter
  regime. The paper must not silently change the model.
- Check symmetries and conservation laws against the stated model, not a nearby
  model. Distinguish classical, quantum and effective/approximate treatments.
- Check degeneracies, zero/equal couplings, projector definitions, and the order
  of time, size, temperature, field and continuum limits. A finite-size result
  is not automatically a thermodynamic-limit result; track every extrapolation
  assumption.
- A finite-size counterexample refutes a finite-size universal equality without
  settling the thermodynamic limit; do not impose the extra task. A finite-grid
  computation does not establish an infinite-system claim.
- A convenient formula may have a finite parameter limit while the underlying
  basis or operator construction becomes singular. Check claimed endpoint limits
  only when they are material, and resolve 0/0 or diverging cases explicitly.
- Verify signs, prefactors, dimensions and normalization using tractable limits
  (non-interacting, high/low temperature, single site, fully aligned states).
  These constrain validity; they are not a replacement for the full argument.
- State uncertainty and consult precise external results when domain knowledge is
  uncertain; do not invent an authoritative citation.

Report issues with severity critical/warning/info, exact equation/file location,
and the independent check performed. Missing or wrong units, unstated boundary
conditions, a hidden model change, or an over-claimed limit are critical unless
explicitly scoped.
