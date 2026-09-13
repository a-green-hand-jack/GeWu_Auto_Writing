# Mathematics manuscript review

Combine with physics or numerical references when the object is a physical model
or a computational certificate; these rules cover the mathematical argument.

- Separate universal statements (all objects in a class) from existential,
  conditional, and finite statements. Match the quantifiers in the abstract and
  conclusion to the actual theorem; never weaken or strengthen silently.
- For proofs: identify assumptions, imported theorems and their hypotheses,
  induction/limits/existence arguments, and whether the chain closes. A "proof
  by enumeration" is not a proof unless the enumeration is itself proven complete.
- For counterexamples: one explicit witness refutes a universal claim; verify the
  witness actually satisfies all hypotheses and violates the conclusion.
- For certificates/exact computation: state the checker, the exactly covered set,
  and the independent identity or witness that was verified. Full coverage of a
  finite set does not prove the general statement.
- Check definitions, non-degeneracy, base cases, edge cases (n=0, empty, equal
  parameters), orientation/sign conventions, and dependencies on an unproven
  lemma.
- Distinguish "new theorem" from "new proof of a known result" from "worked
  example"; do not claim novelty without evidence. A textbook result written
  self-containedly is not a discovery.
- Verify a representative nontrivial instance and a limiting/degenerate instance
  by independent hand computation when feasible; record what was checked.

Report issues with severity and exact equation/lemma/file location. A missing
hypothesis, an unproven imported claim, an over-general quantifier, or a silent
"finite implies infinite" step is critical.
