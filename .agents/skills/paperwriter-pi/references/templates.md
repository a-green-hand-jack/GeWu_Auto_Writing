# Templates and typography

Requirement 1 (follow the template) and requirement 4 (no layout problems) live
here. Everything in this file was verified by compiling a produced manuscript
and looking at the rendered pages; the comments say what was verified, so a
future edit does not undo it.

## 1. Route the template by the assessed domain

| assessed domain | entrypoint | document class |
|---|---|---|
| physics | run-provided `templates/prx-official/apstemplate.tex` | `\documentclass[aps,prx,reprint,groupedaddress]{revtex4-2}` |
| mathematics | the amsart preamble in §3 | `\documentclass[11pt,reqno]{amsart}` |
| life sciences / AI-ML / anything with no selected venue | the neutral preamble in §4 | `\documentclass[11pt]{article}` |

Routing is by the object of study and the question, not by the form of the
argument: a graph-theoretic result proved by exhaustive computation is
mathematics, a spin-chain result written as a theorem is physics. Record the
route and its reason in `research/assessment.md`, and keep every paper in a
domain group on the same class and preamble.

Never substitute a class because it is easier: no `article` for physics, no
two-column physics format for mathematics. A physics paper must not use PRE,
PRL, or a generic class unless the user asked for that venue.

## 2. Physics — APS PRX (REVTeX 4.2)

Preamble: keep it small and add packages only when used. The produced papers
carry exactly this shape:

```latex
\documentclass[aps,prx,reprint,groupedaddress]{revtex4-2}
\usepackage{amsmath,amssymb}
\usepackage{graphicx}
\usepackage{microtype}
\usepackage{needspace}
\usepackage{placeins}          % provides \FloatBarrier — needed before \bibliography
\usepackage[hidelinks]{hyperref}
\emergencystretch=2em
```

**Front-matter order.** REVTeX takes the abstract as front matter *before*
`\maketitle`, wrapped in its own environment:

```latex
\title{...}
\author{...}
\noaffiliation
\begin{abstract}
...abstract text...
\end{abstract}
\maketitle
```

Bare prose before `\maketitle` — for example `\input` of a file that contains
only abstract text — typesets that prose as body text *above* the title. Either
write the environment in the entrypoint or make the included file wrap itself.
Verified: manuscripts that got this wrong printed the abstract above the title.

**Reference block.** REVTeX's APS mode draws its separator rule but prints no
heading word, and a bare `\section*{References}` confines the heading to one
column. Use exactly this construction:

```latex
\FloatBarrier
\clearpage
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

`\makeatletter`/`\makeatother` are required because `\p@` and `\bib@device` are
internal control sequences. The `\FloatBarrier` stops a pending float from
moving past the bibliography; the `\clearpage` then gives the reference list a
page of its own, because with the barrier alone a float can still land beside it
and its rules read as stray underlines. Verified by render: full-text-width
centred REFERENCES, reference list alone on the final page, both columns
balanced.

## 3. Mathematics — amsart

```latex
\documentclass[11pt,reqno]{amsart}
\usepackage{amsmath,amssymb,amsthm,mathtools}
\usepackage{lmodern}      % must precede microtype
\usepackage{microtype}
\usepackage[T1]{fontenc}
\usepackage{graphicx}
\usepackage{booktabs}
\usepackage{placeins}     % provides \FloatBarrier
\usepackage[hidelinks]{hyperref}
\bibliographystyle{amsplain}
\raggedbottom
```

- `lmodern` before `microtype`: with the default Computer Modern bitmap fonts,
  font expansion is an error rather than a warning.
- Supply `\subjclass` (MSC) and `\keywords`.
- Links active but black: no decorative colour, theorem boxes, or oversized
  headings. `hyperref` always with `hidelinks`.
- amsart prints its own `References` heading, so no manual label is needed —
  but still put `\FloatBarrier` then `\clearpage` before `\bibliography`, for
  the same reason as above. Verified by render: references alone on page 2.
- **Expand `\bysame` after the first BibTeX run.** `amsplain.bst` replaces a
  repeated author list with `\bysame`, which typesets as a long dash readers see
  as a stray underline. Run this inside the workspace, then recompile:

```python
# research/checks/expand_bysame.py — expands the repeated-author dash
import pathlib, re
p = pathlib.Path("paper/main.bbl")
parts = re.split(r"(\\bibitem\{[^}]*\})", p.read_text())
out, prev = [parts[0]], None
for i in range(1, len(parts), 2):
    head, body = parts[i], (parts[i + 1] if i + 1 < len(parts) else "")
    if re.match(r"\s*\\bysame", body) and prev:
        body = re.sub(r"^\s*\\bysame\s*,?\s*", prev + ", ", body, count=1)
    else:
        m = re.match(r"^\s*(.*?),\s*\\emph", body, re.S)
        if m:
            prev = m.group(1).strip()
    out += [head, body]
p.write_text("".join(out))
print("remaining bysame:", p.read_text().count("\\bysame"))
```

  Confirm the rendered reference page shows no line containing only a dash. If
  the expansion fails for an entry, switch that manuscript to
  `\bibliographystyle{plain}` (which repeats authors) and say so in
  `research/validation.md`. Verified: 0 remaining `\bysame` after the pass.

## 4. Neutral single-column (no selected venue)

```latex
\documentclass[11pt]{article}
\usepackage{amsmath,amssymb}
\usepackage{graphicx}
\usepackage{booktabs}
\usepackage{placeins}
\usepackage[hidelinks]{hyperref}
\renewcommand{\refname}{\vspace{-2.2em}\begin{center}\textbf{REFERENCES}\end{center}\vspace{-0.6em}}
```

The `\refname` override exists because `article` prints a left-aligned
`References` heading; the three templates must agree on a centred full-width
heading. Precede `\bibliography` with `\FloatBarrier` then `\clearpage` as in
§2. Verified: heading centred across the text block, 0 LaTeX errors.

## 5. Bibliography hygiene

```bibtex
% escape in every field: _ & % # and unbalanced braces
title  = {Hard squares at activity $z=-1$},
author = {Doe, Jane and Roe, Richard},
```

- **Appendices occupy the region between the conclusion and the bibliography.**
  Put `\appendix` before `\input`ing the appendix files, then the reference
  block, so the bibliography stays the last thing in the paper:

```latex
\input{sections/conclusion}
\appendix
\input{sections/appendix_a}
\FloatBarrier
\clearpage
\bibliography{references}
```

  Without `\appendix` those files print as numbered body sections. Verified by
  render: two papers shipped that way, one with four appendix files reading as
  body sections 9–12.
- Never put a file path, repository name, or internal identifier in a
  bibliography field. Cite a source file in prose with `\texttt{...}` plus a
  locator instead.
- Never put process narration in an entry (retrieval dates, registry names,
  "not independently verified"). A scientific caveat such as "preprint" is
  fine; the drafting process is not.
- Every entry is cited and every citation supports a sentence.

## 6. Compile

```bash
cd WORKSPACE/paper
pdflatex -interaction=nonstopmode main.tex && bibtex main \
  && pdflatex -interaction=nonstopmode main.tex \
  && pdflatex -interaction=nonstopmode main.tex
grep -nE 'Overfull|Underfull|undefined|Warning' main.log | head -40
```

Read every warning location; repair in small batches; recompile after each
batch. Fix overfull boxes wider than a few points locally:

- break unbreakable tokens (hashes, URLs, `\texttt` identifiers) with `\-` or
  `\allowbreak`;
- long equations in a two-column layout go in `aligned`, `split`, or `multline`;
- `\needspace` (already loaded) keeps a heading with its opening paragraph;
- use a starred float only when a display genuinely needs full width.

Never hide overflow warnings, relax margins, shrink text globally, or delete
evidence to make a page fit. If TeX is unavailable, keep the complete source
draft and report compilation as blocked — never claim a compiled paper.
