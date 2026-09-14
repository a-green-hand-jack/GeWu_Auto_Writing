# Checks

<!-- prx-profile:start -->
For selected PRX / Physical Review X, apply
[the PRX profile](venues/prx.md) to presentation and section checks. Its
review criteria replace conflicting heading/quota/reference-page checks below,
including treating an abstract input as a body section. Keep citation/input
closure, scientific scope, authorship, real compilation and visual evidence
checks. Other venues, including PRX Quantum, retain the existing checks.
<!-- prx-profile:end -->

Mechanical checks for the completed `WORKSPACE`, run before calling the result a
manuscript. Each one below caught a real defect in a delivered paper; the
commands are the ones that worked. These establish presentation and internal
consistency only — never scientific truth.

Run them from `WORKSPACE` after `paper/main.tex` and the `.bbl` exist.

## 1. Boundary and skeleton

Every input resolves, and the first section is an Introduction:

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
print("first three:", titles[:3])
print("merged introduction:", [t for t in titles if re.search(r"(?i)^introduction\s+and\b|\band\s+introduction\b", t)])
print("missing files:", [t for t in titles if t.startswith("(MISSING")])
print("section files without \\section:", [t for t in titles if t.startswith("(NO ")])
PY
```

Defects: a first section that is not an Introduction; a title joining two roles
with "and" (`Introduction and model`); a missing or `\section`-less section
file; a title naming a process (`Build report`) instead of a scientific role.

Also check the appendices (`writing.md` §3): every appendix has a title naming
its content, is referred to from the body at the place it is needed, and holds
detail rather than a load-bearing step of the argument.

```bash
grep -rnE '\\appendix|^\\section' paper/sections/*appendix*.tex | head
grep -rnoE 'Appendix~?[A-Z]|appendix [A-Z]' paper/sections/*.tex | wc -l
```

## 2. Firewall and author line

```bash
# internal vocabulary must not reach the manuscript (constitution §4)
grep -RniE 'Solution[ _-]?[0-9]+|top[ _-]?30|funnel|black[- ]?box|evidence tier|verification tier|source-bound|platform rank' paper/
grep -RniE 'GitLab|GitHub|README|\.md\b|\.py\b|\.sh\b|\.yaml\b|\.json\b|run[-_ ]?id|commit|hash|provider|agent|model|harness' paper/
grep -RniE '/home/|/Users/|[A-Za-z]:\\' paper/
# the author line is a whitelisted exception: compare it to the record instead
grep -nE '^\\author\{|^\\collaboration\{' paper/*.tex
grep -nE '^\\author\{|^\\collaboration\{' paper/*.tex \
  | sed -E 's/.*\{(.*)\}\s*$/\1/' | tr ';' '\n' | sed 's/^ *//;s/ *$//' | sort -u
```

The `\author{}` and `\collaboration{}` values must match
`gewu-top30/AUTHORSHIP.json` display forms **verbatim** — that record is a
whitelist, so a GeWu label there is expected, not a violation. Exclude those two
fields when reading the first three greps. The production note
(`constitution.md` §7) is the only other place harness, model, platform, or host
names may appear.

Review every hit: the second pattern also matches legitimate scholarly words
("model", "agent" in a scientific sense), so read the line, do not just count.
Defects: a platform label, handle, or role in the author line; a path, file
name, or hash anywhere in the manuscript; internal vocabulary in the text.
The production note (`constitution.md` §7) is the only place harness, model,
platform, or host names may appear.

## 3. Front matter

```bash
grep -nE '\\(title|author|noaffiliation|maketitle)|\\begin\{abstract\}|\\end\{abstract\}' paper/*.tex
```

The abstract must be inside its own environment and before `\maketitle`
(`templates.md` §2). Flag an entrypoint whose first `\begin{abstract}` comes
after `\maketitle`, and any file `\input` before `\maketitle` that contains
prose but no abstract environment — that prose typesets above the title. Then
render page 1 and confirm the title is the topmost element, the author line is a
publication author line, and the abstract is one front-matter block,
self-contained and result-first, normally 150–250 words, with at most two or
three numbers and no formulas.

## 4. Reference region

```bash
grep -n 'FloatBarrier\|clearpage\|bibliography{\|bibsection' paper/main.tex
grep -c '\\bysame' paper/main.bbl 2>/dev/null     # must be 0 for amsart
grep -c '\\bibitem' paper/main.bbl
```

Require `\FloatBarrier` **and** `\clearpage` before `\bibliography`, and the
reference-block construction from `templates.md` §2–§4. Then render the
reference page and confirm: the word REFERENCES is present and centred across
the full text width, the list is the only thing on the page, no line contains
only a dash or a rule, and no float shares the page.

## 5. Bibliography

```bash
grep -o '\\cite[a-z]*{[^}]*}' -R paper/ | sed 's/.*{//;s/}//' | tr ',' '\n' | sed 's/ //g' | sort -u > /tmp/cited.txt
grep -oE '^@[a-zA-Z]+\{[^,]+' paper/references.bib | sed 's/.*{//' | sort -u > /tmp/entries.txt
comm -23 /tmp/entries.txt /tmp/cited.txt     # entries never cited
comm -13 /tmp/entries.txt /tmp/cited.txt     # citations with no entry
grep -RniE 'verified through|not independently verified|retrieved on|consulted on|API key' paper/references.bib paper/main.bbl
```

Defects: an unused entry, a citation with no entry, and any process narration in
a reference (retrieval dates, registry names, "not independently verified").
Count the entries against the floors in `constitution.md` §3, and check that
related work positions the paper against at least five concrete prior results by
name.

## 6. Prose shape

```bash
for f in paper/sections/*.tex; do
  items=$(grep -c '\\item' "$f"); lines=$(grep -cvE '^\s*$' "$f")
  [ "$lines" -gt 0 ] && [ $((items * 100 / lines)) -gt 45 ] && echo "LIST-DOMINATED: $f ($items items / $lines lines)"
done
```

Limitations, discussion, related work, and conclusion are prose. A section that
is a bullet list is an outline, not a section: rewrite it as sentences before
delivery.

## 7. Formal environments

```bash
grep -RnE '\\begin\{(theorem|proposition|lemma|corollary|definition)\}' paper/
```

Each hit must trace to theorem-grade evidence: explicit hypotheses, a precise
statement, and a proof or proof-level derivation. Finite computations,
numerically checked identities, fitted forms, and physical mechanisms are
presented as prose results, displayed equations, and scoped bounds — convert the
mismatch to a prose heading such as `Main result`, `Derivation`, or
`Physical interpretation`.

## 8. Compile and rendered pages

Compile per `templates.md` §6, then render and look at the first page, every
figure and table page, the reference page, and the last two pages:

```bash
pdftoppm -png -r 110 paper/main.pdf /tmp/page    # or any renderer available
```

- no clipped titles, labels, equations, or captions; no missing-glyph boxes;
- no section heading stranded at the bottom of a page; no page starting with a
  one-word fragment;
- floats appear at or after the page that first references them, never after the
  bibliography;
- figure text legible at print scale; captions self-contained;
- no overfull box wider than a few points remains in `main.log`;
- no line consisting of a single character or a lone word after a display;
- a paragraph's last line should fill roughly three quarters of the column — a
  stub tail of one or two words is a defect, not a rounding error;
- paragraphs are of varied length: a page of many very short paragraphs reads as
  a list and needs merging into a real argument.

Only claim a page-level observation after reading that page's image. If the
model cannot read images or no renderer exists, record the visual gate as
blocked — never infer it from the exit code or the source.

## 9. Language pass

A last read of the finished prose, on two dimensions, changing no claim, number,
or citation:

- **Proofread** — abbreviations defined at first use; mathematical notation
  consistent and defined; introduction structure as `writing.md` prescribes;
  grammar and tense; figures and tables referenced and explained; statistics
  stated with their test.
- **Machine-drafting tells** (`writing.md` §9) — the triadic lists, "not only…
  but also", empty intensifiers, "it is worth noting", uniform sentence rhythm,
  and em-dash weather that make a text read as generated.

A pass that changes wording must not also certify the same text: re-run the
consistency checks in §1–§7 over anything it touched.

*The proofread categories above follow Jakob Thumm's MIT-licensed
paper-proofreading checklist; the wording and the scope here are our own.*
