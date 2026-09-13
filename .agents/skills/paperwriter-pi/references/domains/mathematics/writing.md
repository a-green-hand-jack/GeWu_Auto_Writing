# Writing a mathematics paper

Load this during planning and drafting when the assessed domain is `mathematics`, and
for the mathematical argument of a `physics` theory paper. It describes what a
competent referee expects to find. It does not relax any truthfulness rule.

## What the reader needs

A referee reads to answer three questions, in this order:

1. **What exactly is claimed?** A precise statement with all quantifiers,
   hypotheses and the class of objects involved.
2. **Why is it true?** An argument they can follow without reconstructing your
   private reasoning.
3. **Why does it matter, and where does it sit?** Relation to what was already
   known, and what remains open.

A draft that answers only (1) is a note, not a paper. Most weak drafts fail on
(2) by compressing the argument, and on (3) by omitting positioning entirely.

## Depth calibration — the most common failure

The dominant defect is stopping too early: a correct theorem statement, a short
proof, and a conclusion. The result is technically true and unpublishable.

For each substantive result, a complete treatment normally contains:

- the **statement**, displayed and labelled, with hypotheses spelled out;
- a **proof strategy paragraph** before the proof — what the obstacle is, what
  idea removes it, why the obvious approach fails. This is the single highest
  value paragraph in most papers and is almost always missing;
- the **proof in followable steps**, each step justified or explicitly cited;
- a **worked instance** small enough to verify by hand, showing the mechanism;
- **sharpness discussion**: is each hypothesis needed? What breaks without it?
  A counterexample for a dropped hypothesis is worth more than another corollary;
- **scope**: what the result does not say, stated so a reader cannot over-read it.

When the source repository is small, this is where the length legitimately comes
from — definitions, intermediate steps, the worked instance, and sharpness — not
from restating the result in more words or adding unsupported generalization.

## Structure follows the argument

Do not fill a fixed template. Let the sections carry argumentative roles:

- **Introduction**: the problem, why it is natural, what was known, what this
  paper adds, and an informal statement of the main result. A reader who stops
  after the introduction should be able to state your theorem correctly.
- **Preliminaries**: only the notation and imported results actually used later.
  Every definition introduced here must be used; unused notation is noise.
- **Main result and proof**: statement, strategy, proof, worked instance.
- **Sharpness / limits of the method**: hypotheses, edge cases, what the
  technique cannot reach.
- **Related work**: positioned against actual results, not a citation list.
- **Conclusion**: what is now known, what is genuinely open, honest next steps.

For a counterexample paper the spine is different: state the claim being refuted
with its exact source and quantifiers, present the witness explicitly, verify
every hypothesis holds and the conclusion fails, then discuss what the refutation
does and does not settle (typically: finite case settled, general case open).

For a certificate/enumeration paper: define the exactly covered set, describe the
checker and its independent verification, report the coverage precisely, and
separate what is proven for that finite set from what remains conjectural.

## Writing DNA: reference-informed composition patterns

These are distilled, reviewed composition patterns from real mathematics papers.
They guide exposition; they are not text to imitate and do not constitute
venue or mathematical acceptance evidence. The runtime receives these abstractions
only; source papers and extraction evidence remain development artifacts.

- Open with the mathematical problem, the strongest relevant prior boundary, the
  contribution, and a short roadmap before introducing technical machinery.
- State definitions and quantifiers before using them. Keep a notation ledger and
  make edge cases, conventions, and imported hypotheses explicit.
- Before a long proof, explain the obstacle and strategy, then isolate and prove
  the decisive lemma or construction. Do not replace the mechanism with a named
  technique or an assertion that a step is routine.
- Keep universal, existential, conditional, asymptotic, conjectural, finite,
  computational, and heuristic claims visibly separate. Match every conclusion
  to the exact scope proved.
- Use a worked example, sharpness discussion, counterexample, or limiting case
  to show why the hypotheses matter.
- Keep the dependency spine in the main text. Move routine casework, verification
  tables, and implementation detail to titled appendices that the body points to.

Apply the smallest pattern set that matches the mathematical paper type:

- **Theory**: definitions, proof strategy, theorem/lemma chain, complete proof,
  sharpness and scope.
- **Counterexample**: exact claim and quantifiers, explicit witness, hypothesis
  checks, failed conclusion, and what remains open.
- **Computer-assisted or enumeration**: exactly covered set, checker or
  certificate, independent verification, reproducibility and finite-scope limit.

## Craft

- **State before you prove.** Never let a result emerge mid-paragraph.
- **Signpost long proofs.** "We first show A, then deduce B, and finally handle
  the degenerate case C." A referee who loses the thread reports it as unclear.
- **Notation is a budget.** Every symbol costs the reader. Reuse standard
  notation; define non-standard notation at first use and never redefine it.
- **Put the difficulty where it is.** Do not hide the hard step inside "it is
  easy to see". If a step is routine, say why it is routine. If it is the crux,
  give it its own lemma.
- **A lemma the main theorem depends on is proved, not announced.** Every
  result the main theorem uses must carry a self-contained proof in the paper:
  the objects it quantifies over are defined, the construction it relies on is
  laid out (a sign-reversing involution is given explicitly, the invariant
  vectors and their action are written, the seed/base values are derived), and
  each step is justified. Naming a mechanism ("by a sign-reversing
  involution"), stating the conclusion, and leaving the mechanism unconstructed
  is an assertion, not a proof — and a referee will read the main theorem as
  conditional on it. If a lemma cannot be proved to that standard, weaken the
  statement of the result to the scope actually established, and say so, rather
  than presenting it as proved. This is the single most common referee-reported
  failure on synthetic proofs.
- **Displayed equations are for equations that are read, referenced or hard to
  parse inline.** Label only what you cite later.
- **Write the abstract last**, from the finished paper. It must contain the
  actual quantifiers of the theorem, not a softened version.

## Related work that does its job

Bad related work is a list. Good related work answers: what did the closest prior
result establish, under which hypotheses, and precisely how does this paper
differ — weaker hypotheses, larger class, shorter proof, or a refutation?

If you cannot access a key prior work, record it as an unresolved reference. Do
not characterize a paper you have not read, and do not manufacture a contrast.

## Limitations without self-destruction

A limitations paragraph should sharpen the contribution, not apologize for it.
State the boundary as a fact about scope: "The argument uses finiteness of X in
Step 3; whether the statement survives for infinite X is open." That is
informative. "This work is only a small step and may not be useful" is noise and
referees read it as a lack of understanding of one's own result.

## Never

Fabricate a theorem, a proof step, a counterexample witness, a citation, or a
novelty claim. Do not upgrade a finite verification into a general theorem, do
not silently strengthen a quantifier between the theorem and the abstract, and do
not present a known textbook result as new. Correct or explicitly scope a known
error; never conceal it to pass a gate.

## The abstract

Write it last, from the finished paper, as continuous prose a mathematician can
read without decoding notation.

- **Name objects in words, not symbols.** "a family of four quadratic forms in
  every dimension above two" reads; "$n \geq 3$ and positive rationals $R$,
  $\kappa$, $d_2,\dots,d_n$" does not. A handful of single symbols is fine when
  the symbol is genuinely the subject; a parameter list is not.
- **No formulas.** If a relation must appear, at most one, short. An abstract
  carrying `$\tau(\mathcal{P}) = 32 > 31 = 2\nu(\mathcal{P}) - 1$` has moved the
  results section into the abstract.
- **No computed values.** Counts, cardinalities, enumeration sizes and numeric
  outputs belong in the results section or a table. Say "an explicit finite
  family refutes the conjecture", not the family's size and both invariants.
- Keep the quantifiers of the actual theorem. Losing them to fit the length is a
  correctness defect, not a style one.

`paper_style` counts these: a span longer than 60 characters, three or more
relational expressions, or more than two reported values all block handoff.

## Where numbers live

Running prose is the worst place for numeric detail. A reader cannot compare
values embedded in sentences, and a reviewer cannot check them.

- Tabulate anything enumerable: parameter sweeps, per-case results, verification
  coverage. A table with units and a caption is checkable; a paragraph of decimals
  is not.
- Keep in prose only the values a sentence genuinely turns on, and give each one
  its meaning: what it is, what produced it, what it establishes.
- Long case enumerations and machine-verification output belong in an appendix.

## Appendices

Mathematics venues have no page limit, so nothing needs cutting — it needs
relocating. Move to an appendix: long case analyses, routine but lengthy
computations, verification tables, and the full statement of imported results
used only once. The main line of the proof should stay readable end to end.

An appendix is not a dumping ground: each one gets a title saying what it
contains and a sentence in the body pointing to it at the place it is needed.

## Figures

A mathematics paper does not need a figure to look complete, and a decorative
plot is worse than none. Include one when it carries information the prose
cannot: the geometry of a construction, the structure of a counterexample, a
poset or complex whose shape is the argument, or a dependency diagram for a long
proof. State in the caption what the reader should see. Never fabricate a plot
from numbers you did not compute.

## Notation as a ledger

Before substantial rewriting, fix each symbol's meaning, object type, domain or
codomain, first definition point, and any deliberate deviation from the source's
convention. Then audit the compiled paper against that record.

Two rules carry most of the weight:

- **Never reuse one symbol for incompatible types.** A referee who meets $\phi$
  as a map and later as a scalar stops trusting the argument.
- **State the conventions that can change the theorem**: empty objects, loops and
  parallel edges, orientation, composition order, duals and closures,
  normalisation, coefficient field, index origin. These are where a correct proof
  most often reads as wrong.

Notation must agree across statements, proofs, examples, figures, appendices and
any computational certificate. A certificate that indexes from 0 while the paper
indexes from 1 is a defect even when both are internally consistent.

## Citing so the citation does its job

A real citation is not necessarily an appropriate citation. Inspect the relevant
theorem and its hypotheses, not the title, the abstract, or the bibliographic
metadata. The failure to avoid is subtle: the reference exists, the authors are
right, and it does not support the sentence it is attached to.

- Put each citation next to the claim it supports. Names collected in an opening
  paragraph support nothing.
- **An imported relation is stated where it is used, and bound to a checkable
  source.** When a later step depends on a result imported from another work
  (an exact relation, a lemma, a cited identity), state the relation's content
  at the point of use — the objects it involves, its hypotheses and any
  convention it assumes — and bind it to a source locator that a reader can
  actually inspect (the concrete passage, not an abstract or landing page). If
  that passage cannot be inspected, record the result as conditional on the
  imported relation, and do not present it as a verified consequence.
- Say how prior work relates: agrees, generalises, gives an alternative proof,
  restricts, or conflicts. Address the strongest apparent scope collision head on
  rather than leaving it for the referee to find.
- Every bibliography entry needs a reason to be cited, and every material claim
  about the literature needs a citation. Neither direction is optional.
- A search that found nothing supports only a dated, coverage-bounded statement:
  "we did not locate", never "first" or "unprecedented".

If a primary source is inaccessible, record it as unresolved and keep drafting.
Do not characterise a paper you have not read.

## What does not belong in the manuscript

The paper is a mathematical document, not a build report.

- **No artifact hashes** in the title, abstract, body, footnotes or references,
  unless the hash is itself an object of study. Byte identity is not mathematical
  correctness. State the evidence directly: an explicit witness, an exact rank, a
  nonzero minor, or the verification procedure with its coverage.
- **No workflow state**: internal holds, pending permissions, review-task status,
  run identifiers, agent names, or model settings in the body.
- **No author-facing placeholders.** An unfilled `\address` or `\author` prints
  its instruction text into the PDF and, through the running head, onto every
  page. Leave the field empty instead.

Scientific scope and genuine limitations stay in the manuscript; engineering
provenance belongs in an excluded manifest.

## Preamble

Keep the preamble small and add packages only when used. `microtype` is worth
loading by default, but it must follow `lmodern`: the default Computer Modern
bitmap fonts make its font expansion a fatal error, not a warning.

```latex
\documentclass[11pt]{amsart}
\usepackage[margin=1in]{geometry}
\usepackage{amsmath,amssymb,amsthm,mathtools}
\usepackage{lmodern}      % scalable fonts; must precede microtype
\usepackage{microtype}
\usepackage[hidelinks]{hyperref}
\raggedbottom
```

Measured on four real manuscripts that had been blocked on overfull boxes, the
worst box before and after adding `lmodern` + `microtype`: 35.1→8.3pt, 44.5→36.9,
28.6→22.3, and 49.6→53.7. It is a real improvement on average and it made one
case worse, so treat it as free hygiene rather than a layout fix — the
compile-repair loop still does the actual work.

Number theorem environments within sections and equations globally unless the
venue says otherwise. Supply `\subjclass` (MSC) and `\keywords`. Keep links
active but black; no decorative colour, theorem boxes, or oversized headings.

## Before calling it done

The compile succeeding is not the check. Inspect every rendered page, then
confirm: theorem scope and result boundary stated; closest-work evidence
recorded; notation in the PDF matches the ledger; every load-bearing claim has a
traceable primary citation; principal proofs explicitly close; no page carries
clipping, overlap, broken glyphs, or a stranded heading.

If an item is not established, report the precise missing evidence rather than
weakening the claim to pass.
