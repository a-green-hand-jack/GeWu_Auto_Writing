# ICLR 2026 (AI / machine learning)

The official ICLR 2026 conference style, taken unmodified from the ICLR
Master-Template archive.

```latex
\documentclass{article}
\usepackage{iclr2026_conference,times}
\input{math_commands.tex}
\usepackage{hyperref}\usepackage{url}
```

Then `\title{}`, `\author{}`, `\maketitle`, `\begin{abstract}`, and
`\bibliographystyle{iclr2026_conference}` with `\bibliography{}`.

## Two things that differ from the other three venues

- **Submission is anonymous.** The style hides the author block unless
  `\iclrfinalcopy` is set, and a non-anonymous submission is rejected without
  review. Decide deliberately which copy you are producing; if it is the
  anonymous one, the author line is `Anonymous` and the source-repository
  citation moves into the acknowledgments or is omitted, and record that choice
  in `research/assessment.md`. Do not leave a real author block under an
  anonymous-style submission.
- **There are page limits and a required structure** (title, abstract,
  introduction, method, results, discussion, references, appendices), and the
  style file itself constrains fonts and spacing. Check the current author guide
  rather than assuming: <https://iclr.cc/Conferences/2026/AuthorGuide>.

## Provenance

`iclr2026_conference.{sty,bst,bib,tex}`, `fancyhdr.sty`, `natbib.sty` and
`math_commands.tex` come from the ICLR Master-Template archive commit
`a28d335b0d46a3c39b205704a65faf41c9748433` (sha256
`b6d63b29992e153f804bb6d170c57db156c011b5bedf96a9f31d58813b909acf`), as recorded
in `template-metadata.json`. The upstream style files are unmodified.
`guidelines.md` records the normalisation notes. The upstream kit is
distribution-only, so it is vendored here rather than fetched at run time.
