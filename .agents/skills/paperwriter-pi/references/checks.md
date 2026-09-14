# Checks

Mechanical checks for the completed `WORKSPACE`, run before calling the result a
manuscript. Each one below caught a real defect in a delivered paper; the
commands are the ones that worked. These establish presentation and internal
consistency only — never scientific truth.

Run them from `WORKSPACE` after `paper/main.tex` and the `.bbl` exist.

## 1. Boundary and planned sections

```bash
python3 - <<'PY'
import os, re, glob
ent = sorted(glob.glob("paper/*.tex"))[0]
base = os.path.dirname(ent)
titles = []
for m in re.finditer(r"\\input\{([^}]*)\}|\\section\*?\{([^}]*)\}", open(ent, errors="ignore").read()):
    if m.group(1):
        f = m.group(1)
        fp = os.path.join(base, f if f.endswith(".tex") else f + ".tex")
        if os.path.exists(fp):
            mm = re.search(r"\\section\*?\{([^}]*)\}", open(fp, errors="ignore").read())
            titles.append(mm.group(1) if mm else "(NO \\section: %s)" % f)
        else:
            titles.append("(MISSING FILE: %s)" % f)
    else:
        titles.append(m.group(2))
print("sections:", titles)
print("missing files:", [t for t in titles if t.startswith("(MISSING")])
print("files without \\section:", [t for t in titles if t.startswith("(NO ")])
PY
```

Defects: a file the plan lists is missing or unreachable; a `\input` target does
not exist; a file that is `\input` as a section contains no `\section`.

There is deliberately **no test for a required section order or for a section
named Introduction.** The journal decides the spine, and the venues here differ;
a bundle that imposed its own skeleton produced the wrong structure in three
successive rounds. What is checked is that the entrypoint realises the plan, and
that section titles name scientific roles rather than process steps
(`Build report`, `Independent checks`).

## 2. Firewall, author line, source-repository citation

```bash
# internal vocabulary must not reach the manuscript (constitution section 4)
grep -RniE 'Solution[ _-]?[0-9]+|top[ _-]?30|funnel|black[- ]?box|evidence tier|verification tier|source-bound|platform rank' paper/
grep -RniE 'GitLab|GitHub|README|\.md\b|\.py\b|\.sh\b|\.yaml\b|\.json\b|run[-_ ]?id|commit|hash|provider|glm|harness|pi harness' paper/
grep -RniE '/home/|/Users/|[A-Za-z]:\\' paper/
grep -nE '^\\author\{|^\\collaboration\{' paper/*.tex
```

Read every hit instead of counting: the second pattern also matches legitimate
scientific words (a "model", a `glm`-like label such as `\label{eq:siglm}`, a
citation to a software paper). Defects: internal vocabulary in the text; a path,
file name or hash; an **agent, model, harness or provider word anywhere** —
there is no longer any permitted place for one (`constitution.md` §7).

The source repository appears as a reference. Confirm each citation is an
ordinary bibliography entry and that the text cites it:

```bash
grep -rn 'bethesda\|repository\|github\|gitlab\|GeWu\|Solution' paper/references.bib paper/*.bbl 2>/dev/null | head
```

The `\author{}` and `\collaboration{}` values must match
`gewu-top30/AUTHORSHIP.json` display forms **verbatim** — that record is a
whitelist, so a GeWu label there is expected, not a violation. Report only a
value absent from the record, an invented name, or a placeholder substituted for
a display form the record has.

## 3. Front matter

```bash
grep -nE '\\(title|author|noaffiliation|maketitle)|\\begin\{abstract\}|\\end\{abstract\}' paper/*.tex
```

The order is the venue's, and it differs:

- **PRX and amsart**: `\begin{abstract}` **before** `\maketitle`. Flag an
  entrypoint whose first `\begin{abstract}` comes after `\maketitle`, and any
  file `\input` before `\maketitle` that holds prose but no abstract
  environment — that prose typesets above the title.
- **Nature (`nature.cls`)**: `\maketitle` then `affiliations` then `abstract`,
  title under 90 characters.
- **ICLR**: anonymous unless `\iclrfinalcopy`; a real author block under an
  anonymous submission is a defect.

Then render page 1 and confirm the title is the topmost element, the author line
is a whitelisted display form, and the abstract is one block within the venue's
length.

## 4. Reference region

```bash
grep -n 'FloatBarrier\|clearpage\|bibliography{\|bibsection' paper/main.tex
grep -n '\\appendix' paper/main.tex
ls paper/sections/*appendix* 2>/dev/null
grep -c '\\bysame' paper/main.bbl 2>/dev/null     # must be 0 for amsart
grep -c '\\bibitem' paper/main.bbl
```

- `\FloatBarrier` **and** `\clearpage` precede `\bibliography`, so the reference
  list gets a page of its own and no float shares it.
- For PRX, the `\bibsection` construction of `templates.md` §2 is present.
- **Every `appendix*` file is preceded by `\appendix`** and the bibliography
  comes last: `awk '/\\appendix/{a=NR} /\\bibliography/{b=NR} END{print a,b}'`.
  An appendix file `\input` without `\appendix` prints as a numbered body
  section — a delivered paper shipped four of them that way.
- Every appendix is referred to from the body.
- `\bysame` is 0 for amsart after expansion.

Then render the reference page: the word REFERENCES (or the venue's heading) is
present and spans the text width, the list is the only thing on the page, and no
line consists only of a dash or a rule.

## 5. Proof and theorem environments

```bash
grep -rn 'newenvironment{proof}\|renewenvironment{proof}' paper/            # must be empty
grep -rn 'itshape\|emph' paper/main.tex | grep -i proof                      # must be empty
grep -rn 'begin{proof}' paper/sections/*.tex | wc -l
grep -rn 'usepackage{amsthm}' paper/main.tex
grep -rn 'qedhere' paper/sections/*.tex | wc -l
```

Defects: a hand-rolled `proof` environment (three delivered papers defined their
own); `\itshape` in a proof definition — one paper italicised the entire proof
body and the proof read as an emphasised quotation; `amsthm` not loaded; a proof
that ends with a display and contains no `\qedhere` (the QED square then drops to
a line of its own, which is loudest in a two-column layout).

## 6. Literature record

The record is `research/literature.md`, one table with `scope` in exactly
`full-text` / `abstract` / `metadata-only`.

```bash
# content-level fraction and count, per the schema in production.md section 5
python3 - <<'PY'
import re
rows = [l for l in open("research/literature.md", errors="ignore") if l.strip().startswith("|")]
data = [r for r in rows if not set(r.strip()) <= set("|-: \n")]
ft = sum(1 for r in data if re.search(r"(?i)full[- ]?text", r))
ab = sum(1 for r in data if re.search(r"(?i)\babstract\b", r) and not re.search(r"(?i)full[- ]?text", r))
md = sum(1 for r in data if re.search(r"(?i)metadata|title-level|content-known|canonical", r))
tot = ft + ab + md
print(f"references={tot} content-level={ft+ab} ({100*(ft+ab)/tot:.0f}%)" if tot else "no rows")
PY
gewu-lit verify paper/references.bib
```

Defects: fewer than half the entries at content level; fewer than 25 references
without a recorded justification; any row whose `scope` is not one of the three
values (`content-known`, `well-known`, `canonical` count as `metadata-only`); a
`metadata-only` entry carrying a technical statement in the `supports` column;
an identifier that fails to resolve or whose title does not match the entry; an
entry with no identifier that is not a book or pre-digital paper.

## 7. Theorem-grade evidence

```bash
grep -RnE '\\begin\{(theorem|proposition|lemma|corollary|definition)\}' paper/
```

Each hit must trace to theorem-grade evidence: explicit hypotheses, a precise
statement, and a proof or proof-level derivation. Finite computations,
numerically checked identities, fitted forms and physical mechanisms are
presented as prose results, displayed equations and scoped bounds — convert the
mismatch to a prose heading such as `Main result`, `Derivation`, or
`Physical interpretation`.

## 8. Prose shape

```bash
for f in paper/sections/*.tex; do
  items=$(grep -c '\\item' "$f"); lines=$(grep -cvE '^\s*$' "$f")
  [ "$lines" -gt 0 ] && [ $((items * 100 / lines)) -gt 45 ] && echo "LIST-DOMINATED: $f ($items items / $lines lines)"
done
```

Discussion, related work, conclusion and any limitations prose are sentences. A
section that is a bullet list is an outline: rewrite it before delivery.

## 9. Compile and rendered pages

Compile per `templates.md` §8, then render and look at the first page, every
figure and table page, the reference page, and the last two pages:

```bash
pdf-pages paper/main.pdf /tmp/pages --dpi 140     # or pdftoppm where present
```

- no clipped titles, labels, equations or captions; no missing-glyph boxes;
- no section heading stranded at the bottom of a page; no page starting with a
  one-word fragment;
- no line consisting of a single character or a lone word after a display;
- a paragraph's last line fills roughly three quarters of the column — a stub
  tail of one or two words is a defect, not a rounding error;
- floats appear at or after the page that first references them, never after the
  bibliography;
- figure text legible at print scale; captions self-contained;
- no overfull box wider than a few points remains in `main.log`;
- **proofs**: the body is upright, `Proof.` is italic, the QED square sits at the
  end of the last line, and nothing overlaps the theorem box above.

Only claim a page-level observation after reading that page's image. If the
model cannot read images or no renderer exists, record the visual gate as
blocked — never infer it from the exit code or the source.

## 10. Language pass

A last read of the finished prose, changing no claim, number or citation:

- **Proofread** — abbreviations defined at first use; notation consistent and
  defined; grammar and tense; figures and tables referenced and explained;
  statistics stated with their test.
- **Machine-drafting tells** (`writing.md` §9) — triadic lists, "not only… but
  also", empty intensifiers, "it is worth noting", uniform sentence rhythm, and
  em-dash weather that make a text read as generated.

A pass that changes wording must not also certify the same text: re-run §1–§8
over anything it touched.

## 11. Report

Record in `research/validation.md`: the commands run and their results, the pages
inspected, the literature record (count, content-level fraction, unresolved
identifiers), remaining warnings, and the blocked gates. Do not write
`submission-ready`, `scientifically verified` or `visually approved` unless the
gates and evidence support those words.