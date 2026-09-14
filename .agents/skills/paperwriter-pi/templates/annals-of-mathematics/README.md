# Annals of Mathematics (mathematics)

Annals of Mathematics publishes no LaTeX class of its own, and none exists on
CTAN; mathematics submissions to it follow the **AMS `amsart`** conventions.
`amsart.cls` is part of TeX Live (`amscls`), so this directory vendors only the
entrypoint, not a class.

```latex
\documentclass[11pt,reqno]{amsart}
\usepackage{amsmath,amssymb,amsthm,mathtools}
\usepackage{lmodern}   % must precede microtype
...
\bibliographystyle{amsplain}
```

`main.tex` in this directory is the working entrypoint: it already loads the
packages in the right order, declares the theorem environments with `amsthm`,
and shows the section spine, the appendix placement and the bibliography.

## Points that matter here

- **`lmodern` before `microtype`.** With the default Computer Modern bitmap
  fonts, font expansion is an error rather than a warning.
- **`\subjclass` (MSC) and `\keywords` are required.**
- **The abstract precedes `\maketitle`** in amsart. `\date{}` suppresses the
  date line.
- **Theorem environments are `amsthm`'s**, numbered within sections, and the
  `proof` environment is `amsthm`'s as well. Do not define your own `proof` and
  never italicise the proof body.
- **Appendices go after the conclusion and before the bibliography**, and the
  bibliography ends the paper. Put `\FloatBarrier` and `\clearpage` before
  `\bibliography` so the reference list gets its own page.
- **`amsplain` emits `\bysame`** for a repeated author list, which prints as a
  long dash readers read as a stray underline; expand it after the first BibTeX
  run (the script is in `references/templates.md`).
- Links stay black (`hidelinks`): no decorative colour, theorem boxes or
  oversized headings.
