# Nature Communications (life sciences)

Life-sciences manuscripts use the Nature-family format: single column, title
under 90 characters, a separate affiliations environment, an abstract of one
paragraph, numbered references in Nature style.

```latex
\documentclass{nature}
\bibliographystyle{naturemag}
...
\begin{document}
\maketitle
\begin{affiliations} ... \end{affiliations}
\begin{abstract} ... \end{abstract}
```

## Provenance and its limits — read this before relying on it

`nature.cls`, `nature-template.tex` and `naturemag.bst` are the **CTAN `nature`
package, version 1.0, dated 24 February 2004**, by Peter Czoschke. Its own header
says it was written "for personal purposes and without any connection to the
Nature Publishing Group" and that the author "in no way claim[s] that documents
generated with this file fully comply with their current style requirements".

So this is a Nature-*family* starting point, not the current Nature
Communications template. Current Nature Communications submissions use
Springer Nature's own `sn-jnl` bundle, which is **not on CTAN and not in TeX
Live**; this run's hosts cannot reach it (CTAN answers 403 from the compute host,
and the publisher's template is behind their site).

If a run can obtain the official Springer Nature template, it should use that
instead, and record the switch and its source in `research/assessment.md`. What
the manuscript must not do is invent a format and call it Nature's: state in
`research/assessment.md` which template was used and where it came from.

The format requirements that do not depend on the class, and that this class
already satisfies: single column; title under 90 characters; one-paragraph
abstract without citations or formulae; numbered references; figures with
standalone captions; no page limit.