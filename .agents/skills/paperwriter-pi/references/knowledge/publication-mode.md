# Formal-publication mode

This project produces formal academic manuscripts, not repository reports,
platform submissions, or software documentation. Unless the user explicitly
requests a technical report, use this mode for every manuscript.

## Publication identity

- Choose a descriptive scientific title from the paper's actual scientific
  content, not from a requested status, repository label, folder name, venue
  name, or evidence tier. First identify the object/problem, central question,
  method or structural idea, and strongest bounded result; draft several
  reader-facing candidates and select the shortest precise one. Do not use a
  repository slug, Solution number, problem ID, model name, run label,
  verification status, or implementation phrase as the title. Words such as
  `exact`, `complete`, `verified`, and `resolved` are allowed only when they
  describe a scientifically established result at the scope stated in the
  title, never merely the workflow status.
- Use one consistent house template for the whole batch. For this project,
  the default is the official APS PRX REVTeX template at
  `templates/prx-official/apstemplate.tex`, whose class must remain
  `\\documentclass[aps,prx,reprint,groupedaddress]{revtex4-2}`. Do not use
  `article`, `amsart`, PRE, PRL, or `pre-generic` for this batch unless the user
  explicitly selects another venue.
- Keep the front matter minimal and publication-like: title, legitimate author
  attribution, abstract, and required metadata only. Never put a platform name,
  model name, agent name, Git provider, repository, file path, timestamp, run
  ID, or internal status in the author line.
- Never invent authorship. Use only explicit source attribution. If the source
  does not establish publishable authorship, use `Anonymous` for a blinded
  manuscript or `Authors to be supplied by the submitting authors` for an
  unblinded working draft. Never use "Author information pending," "source-
  bound expository draft," a repository owner, a platform identity, or an agent
  identity in the author field. Record the unresolved authorship gate under
  `research/`, not as a fake institutional identity.
- Do not imply that a generated draft has been accepted, certified, peer
  reviewed, or approved for submission.

## Internal-metadata firewall

The paper body communicates the scientific argument. Internal traceability
belongs in `research/` and does not belong in the title, author line, abstract,
main prose, captions, or conclusion.

Keep the following out of the formal manuscript unless it is itself a
scientific object required by the venue:

- GitLab/GitHub URLs, repository URLs, issue links, platform links, and local
  paths;
- names of internal README, Markdown, Python, shell, YAML, JSON, or notebook
  files;
- script commands, source-tree descriptions, agent prompts, model/provider
  names, job IDs, timestamps, hashes, and orchestration details;
- raw row counts, exhaustive finite-case logs, implementation traces, or
  machine-generated bookkeeping that does not support a scientific claim;
- unexplained high-precision decimals, long integers, parameter dumps, or
  identifiers copied from source artifacts.

A reproducibility statement may describe a public artifact at the level
required by the venue, but it must not turn the paper into a file manifest.
Move source locators and detailed provenance to `research/provenance.md`.

## Numerical discipline

Report a number only when it supports a stated claim and the reader can
interpret its units, scale, uncertainty, and origin. Use justified precision;
round values that do not warrant many significant digits. Replace lists of
implementation values with a compact scientific summary or a table. Preserve
exact values in provenance notes when needed for auditability, not in the body
by default.

## Content discipline

- The abstract states the question, approach at the scientific level, main
  result, and limitation or scope. It does not describe the writing process.
- Methods explain definitions, assumptions, derivations, and reproducible
  scientific procedures. They do not narrate source-file inspection or script
  plumbing.
- Results interpret patterns and theorem consequences. Detailed code or
  implementation belongs in a separate artifact, not in the formal article.
- Limitations state what the evidence does not establish without exposing
  irrelevant internal workflow details.
- Use citations for scholarly literature. Source-repository links are evidence
  locators for research notes, not substitutes for literature citations.

## House-style checks

Before delivery, verify that all papers in a batch share the same document
class, margin/column policy, heading hierarchy, bibliography style,
hyperlink policy, title/author policy, and front-matter structure. For this
project use the bundled official APS PRX entrypoint
`templates/prx-official/apstemplate.tex` for every paper in the batch.
Hyperlinks must be unobtrusive and black (`hidelinks`) unless a specified venue
requires a visible color scheme. Do not include a table of contents in a
normal article unless the venue or user requests one.

Apply local layout controls before global compression: keep a heading with its
opening paragraph; when a formal theorem or proposition is genuinely used,
keep its statement with the opening proof lines; do not let a float interrupt
an unfinished sentence or display, and do not allow a page to begin with a
lowercase continuation or a one-word fragment.
Use captions and numbered labels for every figure and table. A bibliography
must be the final scholarly component; no float may pass it.

Read every rendered first page and representative interior/final pages. A
formal-publication pass is incomplete if internal metadata appears in the
manuscript, if placeholder front matter is unexplained, if template choices
vary across papers, or if a visual defect is merely inferred from source text.

## Definition and appendix gate

Before drafting the abstract or results, load
`references/knowledge/definition-order-and-appendices.md`. Create the
notation/terminology ledger first. Do not use an acronym, symbol, named object,
coined term, theorem label, or domain phrase before defining it and stating
its scope. Plan each technical item as `body`, `appendix`, `supplement`, or
`research-only`; move routine derivations, long cases, implementation details,
auxiliary tables, and validation logs out of the body and into a titled,
body-referenced appendix or research record.

## Required preflight

Before compilation, perform the checks in
`references/workflows/publication-preflight.md` with native Pi tools. The
preflight is a required writing gate, not a scientific-validity claim. If it
finds internal metadata in the manuscript, an unresolved placeholder, a
missing section target, an inconsistent citation, a visible template marker,
or an evidence-level mismatch, repair the source and rerun the check. Record
full locators and detailed machine/runtime facts only under `research/`.

## Adapted editorial sources

The claim-first headings, reader-path checks, compression pass, style audit,
and claim-evidence alignment in this file are adapted for this project from:

- SNL-UCSB, `paper-writing-skill`, MIT License, commit
  `676f8520bba54208eb4fe1d41620e365d9af6a24`:
  https://github.com/SNL-UCSB/paper-writing-skill
- ldwww-divesss, `academic-paper-writing-skill`, MIT License, commit
  `0dcd6856573ae96a1e80342d5df1224752bb0d28`:
  https://github.com/ldwww-divesss/academic-paper-writing-skill

This is a local adaptation, not a claim that either upstream project endorses
this workflow. Their plugin installers, agents, and runtime code are not part
of this bundle.
