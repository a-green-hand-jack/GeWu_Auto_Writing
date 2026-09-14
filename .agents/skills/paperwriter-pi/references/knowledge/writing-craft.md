# Writing craft

Truthfulness decides whether a paper may be published; craft decides whether it
is read. These rules apply to every domain and paper type. They never license a
claim the sources do not support: when craft and evidence conflict, the evidence
wins and the sentence gets weaker, not the evidence stronger.

## Narrative thread

- One thread runs the whole paper: problem, insight, technical core, evidence,
  consequence. Every section advances it.
- The classic failure is drift: the introduction motivates problem A, the
  technical core solves B, and the results measure C. After any change to the
  framing or the evidence, reread abstract, introduction, core, results and
  conclusion together and check they describe the same paper.
- Work backwards from what the evidence actually establishes. If the sources
  will not support the story, rewrite the story — do not stretch the evidence.

## Define what you use

- Every non-standard term and every acronym gets a definition at first use.
  An acronym first used in the abstract is defined in the abstract, even if it
  is defined again in the body.
- Notation is introduced before it appears in a derivation. One symbol keeps one
  meaning throughout; reusing a symbol for a second quantity is a defect, not a
  space saving.
- A reader who has not read the source repository must be able to follow the
  argument. Terminology invented by the source is defined, not assumed.

## Abstract

Answer four questions in roughly 150-250 words: what problem, why it matters,
what this work does, and what was actually established. Quote at most two or
three numbers, and only where they carry a claim. The abstract is a standalone
unit, not a compressed introduction and not a results table. Scope words in the
title and abstract must match what was really covered.

## Sections

- The technical core explains the mechanism or the argument: problem statement,
  assumptions, definitions, the derivation or construction, and the boundary of
  what it establishes. More results never substitute for an unexplained core.
- Related work is organised by theme and positions this work against it. A list
  of "X did A. Y did B." is a bibliography, not a section.
- Each table and figure has exactly one home where it is analysed in detail.
  Elsewhere, cite the display item and state only the cross-section takeaway.
  Repeating the same numerical walkthrough in results, discussion and conclusion
  reads as padding and hides which analysis is authoritative.
- Discussion interprets; it does not replay the results. Limitations are
  specific and substantive: name at least two real ones, and say what they
  prevent. "Future work will address this" is not a limitation.

## Sections are prose, not bullet lists

A section written entirely as a bullet list is an outline that was never written
up. This applies most often to limitations, discussion, related work, and
conclusions.

- State each limitation as a sentence: what the evidence does not establish, and
  what that prevents a reader from concluding. Two or three real sentences beat
  eight fragments.
- A short list is acceptable only where the items are genuinely parallel and
  genuinely short — three named open cases, four checked regimes. It must not be
  the whole section, and it must be introduced and followed by prose.
- The same rule covers "contributions" lists, method steps, and results: a list
  may summarise, it may not carry the argument.
- A reader must be able to read the section top to bottom as sentences. If the
  section cannot be read that way, rewrite it as prose.

## Claim strength

Match the verb to the evidence:

- One dataset, one instance or one parameter regime does not support
  "consistently", "in general", or "state of the art".
- "Significantly" requires a stated statistical test, not a visible gap.
- A finite numerical check supports "verified for the enumerated cases", never
  "proved". A derivation under stated assumptions supports the statement under
  those assumptions, not its empirical generality.
- Negative and partial results stay in. Removing an inconvenient case to make a
  cleaner story is fabrication by omission.

## Prose

- Prefer plain declaratives. Cut "it is worth noting", "importantly",
  "notably", "we would like to emphasise" — if it matters, state it.
- Avoid the em-dash-heavy, participial-clause-heavy register that machine
  drafting tends to produce; vary sentence length instead.
- Paragraphs carry one idea and usually run more than three sentences. A page of
  two-sentence paragraphs signals an outline that was never written up.
- No editing markers, internal identifiers, absolute paths or references to the
  drafting process survive into the manuscript.

## Definitions, notation and appendices

The objects a reader needs come before the results about them.

- **Build the ledger first.** Before prose, record each symbol, acronym,
  coined term, and named construct with its plain-language definition, its
  units or domain/codomain, its first planned use, and the sections that use
  it. Write it under `research/`.
- **Introduce the object before its property.** State the setting, variables,
  quantifiers, conventions, and boundary conditions before any result about
  them. Do not write a result first and add the definition later.
- **Two scans after drafting.** A first-use scan: list every acronym,
  capitalized construct, and nonstandard symbol, and confirm its definition
  appears earlier in the same paper. A drift scan: confirm one concept keeps
  one name, one meaning, and one notation across body, appendices, and
  captions, including any decomposition count.
- **Disposition every technical detail.** Plan it as `body`, `appendix`, or
  `research-only` before writing it. Routine derivations, long case lists,
  implementation detail, auxiliary tables, and validation logs move out of the
  body; the body states the result and points to the appendix.
- **Appendices are scientific, titled, and referenced.** Every appendix has a
  descriptive title, a purpose, and at least one meaningful reference from the
  body. An appendix never conceals a missing main argument, an unsupported
  claim, or an undefined object.
- **Transient detail belongs in `research/`.** Build and workflow information
  stays out of both the body and the technical appendices.

## Self-checks

Run these on the generated files before handoff; the exact commands are in
`workflows/preflight.md`.

- Every `\input`/`\include` target exists; every planned section is present and
  referenced by the entrypoint.
- Every citation key has a bibliography entry, every entry is cited, and no
  entry carries process narration.
- Numbers agree across sections; acronyms and symbols are defined before use;
  no internal identifiers, paths, or editing markers in the paper.
- Each display item is referenced from the body and appears on or after the
  page that first cites it, never after the bibliography.

These checks catch a checkable subset: conflicting precision, undefined
acronyms, dangling references, citations with no entry, leaked internal
identifiers, misplaced floats. A clean run means those specific defects are
absent; it is not evidence that the paper is good, complete, or true.
