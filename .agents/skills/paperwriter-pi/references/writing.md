# Writing

Requirement 2. A paper is read, not processed: the reader should finish the
introduction knowing what is claimed and why it matters, and finish the paper
believing they could have followed the argument themselves. Everything here
serves that, and it constrains no fact.

## 1. The frame

- **One thread.** State the question in the introduction, answer it in the
  results, and never open a topic you do not close. A reader who has not seen
  the source material must be able to follow the argument end to end.
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

## 2. Sections

Each section is its own `\section`, in the order recorded in `research/plan.md`.
Titles name scientific roles, never process steps, and never join two roles with
"and".

| | first | then | then | end with |
|---|---|---|---|---|
| **physics** | Introduction | Model (setting, conventions, conventions fixed once) | Method / derivation | Results · Discussion · Limitations · Conclusion · appendices |
| **mathematics** | Introduction | Preliminaries (only what is used) | Main result and proof (then sharpness) | Related work · Conclusion · appendices |
| **life sciences / other** | Introduction | the system and what was measured | results with uncertainty | Discussion · Limitations · Conclusion |

The **Introduction is always the first section**, on its own. A manuscript whose
first section is a model, a setting, or a notation list has no introduction and
is a defect. A short paper may fold Limitations into the Discussion as a prose
subsection; it may not drop it.

- *Introduction*: the phenomenon or problem, why it is interesting, what was
  known, what this paper adds, and an informal statement of the main result. A
  reader who stops here should be able to state the claim correctly.
- *Model / problem statement*: complete enough to re-derive — degrees of
  freedom, state or ensemble, observables, units, normalization, boundary
  conditions, parameter regime, and every approximation with what it excludes.
- *Method / derivation*: followable steps, each approximation marked where it
  enters and with its expected error.
- *Results*: what was found, with uncertainty or exactness and the coverage
  actually reached.
- *Discussion*: the mechanism — why this coupling produces this scaling, which
  competing effects balance, what would change the answer qualitatively. A
  discussion that restates the results is the most common reason a correct
  paper reads as weak.
- *Limitations*: prose. Each limitation is a sentence saying what the evidence
  does not establish and what that prevents. State the boundary as a fact about
  scope ("the argument uses finiteness in Step 3; the infinite case is open"),
  never as an apology.
- *Conclusion*: what is now established, at what scope, and what is honestly
  open.

## 3. Depth calibration

The dominant defect is a thin middle: statement, jump, result.

For a physics or computational result, a complete treatment normally contains
the model statement displayed with every symbol defined and units given; the
assumptions and their physical meaning, not just their names; the derivation in
steps; **limit checks presented to the reader** rather than merely performed
(non-interacting, high/low temperature, single site, fully aligned, known
exact cases); dimensional analysis wherever a prefactor or scaling is claimed;
the interpretation; and the regime of validity with its failure modes.

For a mathematical result: the statement displayed with hypotheses spelled out;
a **proof-strategy paragraph** saying what the obstacle is and which idea
removes it — the highest-value paragraph in most papers and the one usually
missing; the proof in justified steps; a worked instance small enough to check
by hand; sharpness — is each hypothesis needed, what breaks without it; and the
scope the result does not reach.

A lemma the main result depends on is **proved, not announced**: the objects it
quantifies over are defined, the construction it relies on is laid out, each
step is justified. Naming a mechanism and stating its conclusion is an
assertion, and a referee will read the main theorem as conditional on it. If it
cannot be brought to that standard, weaken the result to what is established and
say so.

Put the difficulty where it is. Never hide the hard step inside "it is easy to
see": say why a routine step is routine, and give a crux its own lemma.

## 4. Definitions and notation

- Every symbol, acronym, coined term, and named construct is defined before its
  first argumentative use, including in the abstract.
- One concept keeps one name, one meaning, one notation — across statements,
  proofs, examples, figures, captions, and appendices. Never reuse a symbol for
  an incompatible type.
- Fix the conventions that can change the result — empty objects, loops and
  parallel edges, orientation, composition order, duals, normalization,
  coefficient field, index origin, signs, units, Fourier conventions — once, in
  the model or preliminaries section, and never change them silently.
- Notation is a budget: reuse standard notation, and never introduce a symbol
  the paper does not use.
- Distinguish universal, existential, conditional, finite, asymptotic, and
  conjectural claims visibly. A finite-size or finite-coupling result is not a
  general one; every extrapolation is stated as an assumption with its
  justification.
- Write formulas the way they are read. Use `\eqref` rather than "equation 3";
  use `\text{}` for words inside math; take `\mathbb` only for number sets;
  check that every `\ref` resolves and that the accent sits on the right letter.

## 5. The abstract

Continuous prose, written last from the finished paper. It states the question,
the approach, the principal result with its scope, and what it does not claim —
nothing else.

- No formulas. Name the quantity and its role; the identity belongs in the body.
- At most two or three numbers, and only where a number carries a claim.
  Tolerances, grid sizes, fitted coefficients, and residuals belong in a table.
- Keep the actual quantifiers of the result: an abstract that softens or
  strengthens them is a correctness defect, not a style choice.
- No inventory, no counts of checks, no process, no provenance disclaimer.

## 6. Related work

Good related work answers three questions about the closest prior results: what
they established, under which hypotheses, and exactly how this paper differs —
weaker hypotheses, larger class, shorter proof, a refutation, or an independent
route. A list of citations does not do this, and neither does a paragraph of
author names collected at the start.

Cite where the claim is. A citation attached to a sentence it does not support
is worse than no citation; if you did not read the passage, do not characterize
the paper. If a key prior work is inaccessible, record it as unresolved.

## 7. Figures, tables, and numbers

- A display item earns its place by carrying information prose cannot. State in
  the caption what the reader should see: axes with units, what varies, what
  follows. A schematic is labelled a schematic; an analytic curve is not a
  measurement; never plot values you did not compute or invent error bars.
- Captions are self-contained, end in a period, and contain no script names,
  paths, hashes, run identifiers, or build diagnostics.
- Tables use `booktabs` rules — no `\hline`, no vertical rules. Figures are
  vector (PDF) with legible text at print scale and distinguishable lines
  without colour.
- Running prose is the worst place for numeric detail. Tabulate anything
  enumerable; keep in prose only the values a sentence turns on, each with its
  units, precision, and what produced it. A bare number is incomplete.
- Each display item is analysed in one home section and cited elsewhere for its
  takeaway only.

## 8. Language

Write in the scholarly register of the venue: plain, specific, and confident
about what the evidence shows. Prefer the active voice with a real subject — if
a sentence's subject cannot perform its verb, rewrite it.

- Cut borrowed-register filler: *very*, *a lot of*, *obviously*, *huge
  improvement*, *it is important to note*, *in order to*, *plays a key role*.
- Define an abbreviation at first use, once, and use it consistently after.
- Keep tense stable: what was done, in the past; what the paper shows, in the
  present.
- Reserve *prove*, *guarantee*, *verify*, *show*, and *demonstrate* for what the
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

## 9. What never belongs in the manuscript

GeWu's internal vocabulary, platform and host names, repository and file names,
paths, hashes, run identifiers, model and agent names, and row counts. The
author line carries a person's name, not a database label. The full list and the
replacements are in `constitution.md` §4; the one permitted exception is the
production note in §7 there.

## 10. Self-check before assembly

Read the draft as a reader, then answer:

- Can a reader who has never seen the sources state the main claim after the
  introduction, and follow the argument to it?
- Is every symbol, term, and acronym defined before use, once, with one meaning?
- Does every claim's verb match its evidence, and does every number carry units,
  precision, and origin?
- Does the discussion explain a mechanism rather than restate the results?
- Are the limitations specific, in prose, and honest about what they prevent?
- Is the abstract free of formulas, and faithful to the quantifiers of the
  result?
- Is any sentence here only because it sounds good?
