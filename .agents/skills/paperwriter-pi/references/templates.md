# Templates and typography

Requirement 1 (follow the template) and requirement 4 (no layout problems) live
here. Every LaTeX construction below was verified by compiling a produced
manuscript and looking at the rendered pages; the notes say what was verified, so
a later edit does not undo it.

## 1. One venue per domain

The venue is not a free choice, and it is not "a neutral format": each domain has
its journal. `SKILL.md` fixes the domains; this table fixes the template.

| domain | journal | source | entrypoint |
|---|---|---|---|
| physics | Physical Review X (APS) | TeX Live `revtex4-2`, plus the vendored official APS entrypoint `templates/prx-official/apstemplate.tex` | `\documentclass[aps,prx,reprint,groupedaddress]{revtex4-2}` |
| mathematics | Annals of Mathematics | TeX Live `amsart` (`amscls`); entrypoint `templates/annals-of-mathematics/main.tex` | `\documentclass[11pt,reqno]{amsart}` |
| life sciences | Nature Communications | vendored `templates/nature-comms/` | `\documentclass{nature}` |
| AI / machine learning | ICLR | vendored `templates/iclr-2026/` | `\documentclass{article}` + `\usepackage{iclr2026_conference,times}` |

Where TeX Live already carries the class (`revtex4-2`, `amsart`), nothing is
vendored beyond the entrypoint. Where it does not (Nature, ICLR), the style files
travel with this bundle, and each of those directories carries a `README.md`
stating exactly where they came from, including the caveat that the CTAN `nature`
class is from 2004 and is not the current Nature Communications template.

If the user names a different venue, verify that venue's current template and
licence yourself and record the source in `research/assessment.md`. Never invent
page limits, years, or licence terms, and never invent a format and call it the
journal's.

## 2. Physics — Physical Review X

Preamble, kept small; add packages only when used:

```latex
\documentclass[aps,prx,reprint,groupedaddress]{revtex4-2}
\usepackage{amsmath,amssymb}
\usepackage{graphicx}
\usepackage{microtype}
\usepackage{needspace}
\usepackage{placeins}          % \FloatBarrier, needed before \bibliography
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

Bare prose before `\maketitle` — for instance `\input` of a file holding only
abstract text — typesets above the title. Verified: manuscripts that got this
wrong printed the abstract above the title.

**Reference block.** APS mode draws a separator rule but prints no heading word,
and a bare `\section*{References}` confines the heading to one column:

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
internal. `\FloatBarrier` stops a pending float from crossing the bibliography;
`\clearpage` then gives the reference list a page of its own, because with the
barrier alone a float can still land beside it and its rules read as stray
underlines. Verified by render: full-text-width centred REFERENCES, reference
list alone on the final page, columns balanced.

## 3. Mathematics — Annals of Mathematics

`templates/annals-of-mathematics/main.tex` is the working entrypoint; it already
has the packages in the right order, the theorem environments, and the spine.

```latex
\documentclass[11pt,reqno]{amsart}
\usepackage{amsmath,amssymb,amsthm,mathtools}
\usepackage{lmodern}      % must precede microtype
\usepackage{microtype}
\usepackage[T1]{fontenc}
\usepackage{graphicx}
\usepackage{booktabs}
\usepackage{placeins}
\usepackage[hidelinks]{hyperref}
\bibliographystyle{amsplain}
\raggedbottom
```

- `lmodern` before `microtype`: with the default Computer Modern bitmap fonts,
  font expansion is an error rather than a warning.
- `\subjclass` (MSC) and `\keywords` are required; `\date{}` suppresses the date.
- **The abstract precedes `\maketitle`** in amsart.
- amsart prints its own `References` heading, so no manual label is needed — but
  still put `\FloatBarrier` then `\clearpage` before `\bibliography`.
- **Expand `\bysame` after the first BibTeX run.** `amsplain.bst` replaces a
  repeated author list with `\bysame`, which typesets as a long dash readers see
  as a stray underline:

```python
# research/checks/expand_bysame.py -- expands the repeated-author dash
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

  Confirm the rendered reference page has no dash-only line. If the expansion
  fails for an entry, switch that manuscript to `\bibliographystyle{plain}` and
  say so in `research/validation.md`.

## 4. Life sciences — Nature Communications

```latex
\documentclass{nature}
\bibliographystyle{naturemag}
...
\title{...}                    % under 90 characters
\author{...}
\begin{document}
\maketitle
\begin{affiliations} ... \end{affiliations}
\begin{abstract} ... \end{abstract}
```

Single column, one-paragraph abstract with no citations or formulae, numbered
references. Read `templates/nature-comms/README.md` first: the class is the CTAN
`nature` package of 2004, not the current Nature Communications template, and the
README says what that means for honesty about the format.

## 5. AI and machine learning — ICLR

```latex
\documentclass{article}
\usepackage{iclr2026_conference,times}
\input{math_commands.tex}
\usepackage{hyperref}\usepackage{url}
```

`templates/iclr-2026/README.md` carries two things that differ from the other
venues: submission is **anonymous** unless `\iclrfinalcopy` is set, and the venue
enforces page limits and a required structure. Decide which copy you are
producing and record it; do not ship a real author block under an anonymous-style
submission.

## 6. Theorem and proof environments

Use `amsthm`. One delivered paper hand-rolled its own environment:

```latex
% WRONG -- this is the defect, do not reproduce it
\newenvironment{proof}{\par\medskip\noindent\textit{Proof.}\ \itshape}%
  {\nobreak\hfill$\square$\par\medskip}
```

`\itshape` has no argument, so it italicised the **entire proof body**; rendered,
the proof read as an emphasised quotation rather than an argument, which is what
"the proof environment is a mess" meant. Two other papers hand-rolled proof
environments as well.

- Load `amsthm` and declare environments with `\newtheorem` (`theorem`,
  `proposition`, `lemma`, `corollary`, `definition`, `remark`), numbered within
  sections unless the venue says otherwise.
- Use amsthm's own `proof`: upright body, italic `Proof.` label, right-aligned
  QED. Never define your own, and never italicise the body.
- A proof ending in a display needs `\qedhere` inside the display, or the QED
  square drops to a line of its own. In a two-column layout this is the most
  visible defect there is.
- A named variant (`\begin{proof}[Proof of Theorem 2]`) must still come from
  amsthm; do not fake it with `\noindent\textit{...}`.
- Theorem environments themselves stay reserved for theorem-grade evidence
  (`checks.md` §7).

## 7. Bibliography hygiene

- Escape `_ & % #` and unbalanced braces in every field.
- Never put a file path, repository name, or internal identifier in a
  bibliography field — except the source-repository citation, which is a
  reference in its own right (`constitution.md` §7).
- Never put process narration in an entry (retrieval dates, registry names,
  "not independently verified"). A scientific caveat such as "preprint" is fine.
- Every entry is cited and every citation supports a sentence.

## 8. Compile

```bash
cd WORKSPACE/paper
pdflatex -interaction=nonstopmode main.tex && bibtex main \
  && pdflatex -interaction=nonstopmode main.tex \
  && pdflatex -interaction=nonstopmode main.tex
grep -nE 'Overfull|Underfull|undefined|Warning' main.log | head -40
```

Read every warning location, repair in small batches, recompile after each. Fix
overfull boxes wider than a few points locally: break unbreakable tokens
(hashes, URLs, `\texttt` identifiers) with `\-` or `\allowbreak`; put long
equations in `aligned`/`split`/`multline` in two-column layouts; use `\needspace`
(already loaded) to keep a heading with its opening paragraph; reserve starred
floats for displays that genuinely need full width.

Never hide overflow warnings, relax margins, shrink text globally, or delete
evidence to make a page fit. If TeX is unavailable, keep the complete source
draft and report compilation as blocked — never claim a compiled paper.