# Definition-first writing and appendix policy

Formal papers must establish the objects that readers need before using them.
This rule applies to ordinary terms, domain jargon, acronyms, named
constructs, symbols, indices, sets, graphs, operators, distributions,
statistics, and theorem labels.

## Definition-first protocol

1. Before drafting prose, build a notation and terminology ledger under
   `research/`. For each item record its first planned use, plain-language
   definition, mathematical domain/codomain or units, assumptions, and the
   sections that use it.
2. Introduce the scientific object before its property, result, algorithm, or
   comparison. State the setting, variables, quantifiers, and boundary
   conditions before writing a theorem or conclusion about them.
3. Expand every acronym at first use. Define every nonstandard symbol before
   or at its first use. Define every coined term in one plain sentence before
   using it as an argumentative noun.
4. A theorem, proposition, lemma, or corollary must state its hypotheses and
   domain before its conclusion. A proof sketch does not excuse an undefined
   object or an omitted quantifier.
5. Do not introduce unexplained labels, metaphors, named mechanisms, or
   technical words merely because they appeared in a source file. If a source
   uses an unfamiliar name, either define it in the paper or omit it from the
   paper and retain it only in provenance notes.
6. After drafting, perform a first-use scan: list every acronym, capitalized
   construct, nonstandard mathematical symbol, and domain term; verify that a
   reader can find its definition earlier in the same paper.
7. Perform a second cross-section scan for definition drift. A term has one
   canonical name, one meaning, one notation, and one decomposition count
   throughout the paper, including appendices and captions.

Do not write a result first and add a definition later. If a definition cannot
be supplied from the source evidence, mark the item unresolved in `research/`
and do not use it as if it were established.

## Main text versus appendix

The main text carries the shortest complete scientific argument needed for a
reader to understand the question, assumptions, method, central derivation,
principal results, limitations, and conclusion. It is not a source dump or an
implementation log.

Move material to a titled appendix when it is technically useful but would
interrupt the main argument, including:

- routine algebra, lengthy derivations, proof details, and case analyses;
- complete finite enumerations, auxiliary tables, sensitivity checks, and
  secondary figures;
- extended notation tables and definitions needed only for a specialized
  subsection;
- algorithm pseudocode or implementation details required for reproducibility;
- detailed validation matrices, checker inventories, and artifact-level
  reproducibility details.

The paper body may state the essential method and the reason a derivation or
check matters, then point to `Appendix A` or another named appendix. Every
appendix must have a descriptive title, a purpose, and at least one meaningful
reference from the body. An appendix is not a place to hide a missing main
argument, unsupported claim, or unresolved definition.

Keep transient agent/runtime/build information out of both the main text and
technical appendices. Store it in `research/` records. A formal appendix may
contain scientific implementation detail; it must not contain provider names,
agent prompts, run IDs, local paths, shell logs, platform status, or machine
failure diagnostics.

## PRX-compatible structure

For this project, the neutral formal-paper structure uses the official APS PRX
REVTeX template. A typical paper has an accessible abstract and introduction,
scientific model or methods, central results, discussion/conclusion, then
`\\appendix` sections before the bibliography. Do not add a table of contents
unless the user explicitly requests one. Keep the title page focused on the
paper's scientific identity.
