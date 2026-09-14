# Writing

Requirement 2. A paper is read, not processed: the reader should finish the
introduction knowing what is claimed and why it matters, and finish the paper
believing they could have followed the argument themselves. Everything here
serves that, and it constrains no fact.

## 1. The frame

- **One thread.** State the question where the format asks for it, answer it in
  the results, and never open a topic you do not close. A reader who has not
  seen the source material must be able to follow the argument end to end.
- **Abstraction before machinery.** Say what is going on in words before the
  first equation, and give the intuition for a step before its formal
  derivation. Deriving first and explaining afterwards is what makes a correct
  paper unreadable.
- **Depth over breadth.** One mechanism explained completely beats five results
  listed. If the source is small, the paper's length comes from definitions,
  intermediate steps, limit checks, worked instances, context, and limitations
  — never from restating the same result in more words.
- **Name quantities, not symbols**, when writing prose, especially in the title
  and abstract ("the ground-state energy of the finite chain", not `E_0(N)`).

## 2. Follow the journal's requirements

**The template decides the structure.** Each venue has its own required sections,
front matter, abstract rules, page budget and reference style, and `templates.md`
§1 says which template each domain uses. Take the spine from the journal, not
from this bundle: nothing here is a required section list.

What this file carries instead are **cautions** — the things that go wrong in
manuscripts of each kind, whatever order the venue puts them in.

*Physics and computational papers.* A referee reconstructs the work and then
checks it. Give the model completely enough to be re-derived — degrees of
freedom, state or ensemble, observables, units, normalization, boundary
conditions, parameter regime — then the derivation, the result with its regime of
validity, and the physical interpretation. The dominant defect is a thin middle:
model, jump, result. A draft that reports a result without letting the reader
rebuild the model is rejected regardless of correctness.

*Mathematics papers.* A referee asks three questions in order: what exactly is
claimed (with quantifiers and hypotheses), why is it true, and where does it sit.
Most weak drafts fail the second by compressing the argument and the third by
omitting positioning. A lemma the main result depends on is **proved, not
announced**: the objects it quantifies over are defined, the construction it
relies on is laid out, each step justified. Naming a mechanism and stating its
conclusion is an assertion, and a referee will read the main theorem as
conditional on it. If it cannot be brought to that standard, weaken the result to
what is established and say so.

*Life-sciences and machine-learning papers.* The venue's own structure rules
dominate, and both expect the protocol or experimental design to be stated
before results, uncertainty to be quantified, and the comparison to a stated
baseline. Follow the author guide rather than a generic skeleton.

Across all of them: put the difficulty where it is. Never hide a hard step inside
"it is easy to see" — say why a routine step is routine, and give a crux its own
lemma or subsection.

**Limitations.** State the boundaries of what you established, somewhere the
reader will meet them — usually at the end of the discussion, and it can be a
short paragraph or a subsection. A separate `Limitations` section is **not**
required, and a section that merely lists a few hedges is worse than two honest
sentences in the discussion. Each limitation says what the evidence does not
establish and what that prevents. State the boundary as a fact about scope ("the
argument uses finiteness in Step 3; the infinite case is open"), never as an
apology.

## 3. Body and appendix

The body carries the argument; the appendix carries the evidence that would slow
a reader down. A referee should be able to follow the paper end to end without
opening an appendix — and every appendix exists because the body points to it at
the moment it is needed.

**The body keeps:** the question; the model or problem statement; the strategy
and the load-bearing steps of the argument; the result with its scope; the
interpretation; the boundaries. **Everything else moves out.**

**An appendix carries:** full derivations whose results the body quotes; lengthy
but routine algebra and case analyses; parameter, convergence and coverage
tables; numerical protocols; long verification output; imported statements used
once; and the worked detail behind a step whose *idea* the body already explains.

- Move detail, never delete it. These venues have no page limit: an overloaded
  body is a relocation problem, not a cutting problem.
- Every appendix has a title naming its content, and the body refers to it where
  it is needed ("the full case analysis is in Appendix B").
- An appendix never conceals a missing central argument. If the load-bearing
  step lives only in an appendix, the body's argument is incomplete.
- The test for a paragraph: does the reader need it to **follow** the argument,
  or only to **check** it? Following stays in the body; checking goes to an
  appendix.
- `\appendix` must actually be emitted before those files are `\input`
  (`templates.md` §6, `production.md` §8); a delivered round shipped four
  appendix files that printed as numbered body sections.

## 4. Depth calibration

The dominant defect is a thin middle: statement, jump, result.

For a physics or computational result, a complete treatment normally contains the
model statement displayed with every symbol defined and units given; the
assumptions and their physical meaning, not just their names; the derivation in
steps with each approximation marked where it enters and its expected error;
**limit checks presented to the reader** rather than merely performed
(non-interacting, high/low temperature, single site, fully aligned, known exact
cases); dimensional analysis wherever a prefactor or scaling is claimed; the
mechanism, not a restatement of the formula in words; and the regime of validity
with its failure modes.

For a mathematical result: the statement displayed with hypotheses spelled out; a
**proof-strategy paragraph** saying what the obstacle is and which idea removes
it — the highest-value paragraph in most papers and the one usually missing; the
proof in justified steps; a worked instance small enough to check by hand; and
sharpness — is each hypothesis needed, what breaks without it.

## 5. Definitions and notation

- Every symbol, acronym, coined term and named construct is defined before its
  first argumentative use, including in the abstract.
- One concept keeps one name, one meaning, one notation — across statements,
  proofs, examples, figures, captions and appendices. Never reuse a symbol for
  an incompatible type.
- Fix the conventions that can change the result — empty objects, loops and
  parallel edges, orientation, composition order, duals, normalization,
  coefficient field, index origin, signs, units, Fourier conventions — once, in
  the model or preliminaries, and never change them silently.
- Notation is a budget: reuse standard notation, and never introduce a symbol
  the paper does not use.
- Distinguish universal, existential, conditional, finite, asymptotic and
  conjectural claims visibly. A finite-size or finite-coupling result is not a
  general one; every extrapolation is stated as an assumption with its
  justification.
- Write formulas the way they are read. Use `\eqref` rather than "equation 3";
  use `\text{}` for words inside math; take `\mathbb` only for number sets;
  check that every `\ref` resolves and that accents sit on the right letter.

## 6. The abstract

Continuous prose, written last from the finished paper, within the length the
venue sets. It states the question, the approach, the principal result with its
scope, and what it does not claim — nothing else.

- No formulas. Name the quantity and its role; the identity belongs in the body.
- At most two or three numbers, and only where a number carries a claim.
  Tolerances, grid sizes, fitted coefficients and residuals belong in a table.
- Keep the actual quantifiers of the result: an abstract that softens or
  strengthens them is a correctness defect, not a style choice.
- No inventory, no counts of checks, no process, no provenance disclaimer.
  Nature-family venues require a single paragraph with no citations.

## 7. Related work and citations

Good related work answers three questions about the closest prior results: what
they established, under which hypotheses, and exactly how this paper differs —
weaker hypotheses, larger class, shorter proof, a refutation, or an independent
route. A list of citations does not do this, and neither does a paragraph of
author names collected at the start.

Cite where the claim is. A citation attached to a sentence it does not support is
worse than no citation; if you did not read the content, you may use the entry
for an attribution or historical statement only (`constitution.md` §3). Never
characterize a paper you have not read, and do not manufacture a contrast.

## 8. Figures, tables and numbers

- A display item earns its place by carrying information prose cannot. State in
  the caption what the reader should see: axes with units, what varies, what
  follows. A schematic is labelled a schematic; an analytic curve is not a
  measurement; never plot values you did not compute or invent error bars.
- Captions are self-contained, end in a period, and contain no script names,
  paths, hashes, run identifiers, or build diagnostics.
- Tables use `booktabs` rules — no `\hline`, no vertical rules. Figures are
  vector with legible text at print scale and distinguishable lines without
  colour.
- Running prose is the worst place for numeric detail. Tabulate anything
  enumerable; keep in prose only the values a sentence turns on, each with its
  units, precision, and what produced it. A bare number is incomplete.
- Each display item is analysed in one home section and cited elsewhere for its
  takeaway only.

## 9. Language

Write in the scholarly register of the venue: plain, specific, and confident
about what the evidence shows. Prefer the active voice with a real subject — if a
sentence's subject cannot perform its verb, rewrite it.

- Cut borrowed-register filler: *very*, *a lot of*, *obviously*, *huge
  improvement*, *it is important to note*, *in order to*, *plays a key role*.
- Define an abbreviation at first use, once, and use it consistently after.
- Keep tense stable: what was done, in the past; what the paper shows, in the
  present.
- Reserve *prove*, *guarantee*, *verify*, *show* and *demonstrate* for what the
  evidence actually reaches (`constitution.md` §2).
- Match the noun: *validate* needs data, *prove* needs a proof, *suggest*
  matches a trend.

Machine-drafting tells, which a careful reader notices immediately — remove
them:

- triadic lists ("fast, accurate, and robust") used as rhythm rather than
  content;
- the "not only… but also" and "not X, but Y" reversal cadences;
- consecutive sentences with the same skeleton, and paragraphs all the same
  length;
- a paragraph opening with a comment that has no referent ("This is crucial.");
- the summary colon ("The key insight is: …");
- idealised personification metaphors, and em-dashes as a tic rather than
  punctuation;
- a vague summary word standing in for a concrete number the paper already has.

This pass may change wording and rhythm. It may never change a claim, a number,
a citation, or the structure of the argument.

## 10. What never belongs in the manuscript

GeWu's internal vocabulary, platform and host names, repository and file names,
paths, hashes, run identifiers, and any agent, model, provider or process word.
The source repository appears in exactly one way: as a citation in the
bibliography. The author line carries the authorship record's display form, not
a database label invented by you. The full list and the replacements are in
`constitution.md` §4 and §7.

## 11. Self-check before assembly

Read the draft as a reader, then answer:

- Does the manuscript meet the journal's requirements — sections, front matter,
  abstract, reference style, length?
- Can a reader who has never seen the sources state the main claim early, and
  follow the argument to it?
- Is every symbol, term and acronym defined before use, once, with one meaning?
- Does every claim's verb match its evidence, and does every number carry units,
  precision and origin?
- Do the boundaries appear where the reader will meet them, stated as facts
  about scope?
- Is the abstract faithful to the quantifiers of the result and free of
  formulas, process and inventory?
- Is the detail in the appendices rather than the body, with the body pointing
  to it?
- Is any sentence here only because it sounds good?