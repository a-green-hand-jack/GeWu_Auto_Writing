# Visual Inspection Memory

Project-local memory for manuscript visual checks after a PDF build or any layout-affecting manuscript change. This is an Agent-facing quality gate, not a substitute for scientific validation.

## When To Use

Use this memory after compiling the paper when a task changes any of the following:

- figures, tables, captions, floats, equations, macros, section structure, page budget, or venue style;
- paragraphing, compression, line breaks, or substantial prose layout;
- release candidates, arXiv/Overleaf synchronization, or Human-facing PDF review.

Run the narrowest build needed first. Then inspect the rendered PDF pages that could be affected; for release or broad formatting work, inspect the full PDF.

## Visual Check Items

### 1. Basic Layout

- Check whether figures and tables appear near the text that introduces them.
- Check whether figure/table sizes are proportionate to the surrounding text.
- Check whether labels, legends, axis text, table text, and caption text are readable and visually compatible with body text.
- Check for clipped content, overlapping elements, awkward float placement, large blank gaps, widows/orphans, and broken references.

### 2. Avoid Single-Character Lines

Look for lines that contain only one visible character or one isolated word fragment. Check all of these surfaces:

- body paragraphs;
- captions;
- table cells;
- footnotes or statement paragraphs;
- equations with short trailing text.

If a single-character line appears, prefer a low-churn fix: local wording adjustment, nonbreaking space, slightly rebalanced sentence, table column tweak, or figure/table sizing adjustment. Do not change scientific meaning merely to fix layout.

### 3. Visual Density And Rhythm

- Author requirement: the final line of each ordinary prose paragraph should
  occupy at least three quarters of its column width. Check rendered PDF glyph
  positions as well as the image; source-line lengths do not establish this.
  Apply the check to the active refinement batch and state the inspected scope.
  Headings, display equations, algorithm steps, and table cells are distinct
  layout objects, not ordinary prose paragraphs. Check captions separately.
- Prefer concise rephrasing or removal of redundancy to fix short tails. Do not
  pad prose with filler, stretch interword spaces, or change scientific meaning
  merely to reach the length threshold. Check that reflow has not moved a short
  tail or orphan to the next column or page.
- Pages should look orderly and balanced, not ragged or chaotic.
- Avoid sequences where one line is very long and the next is extremely short unless the structure requires it.
- Check that figures, equations, and tables do not create excessive whitespace or visually crush the prose.
- Prefer consistent caption and float rhythm across adjacent pages.

### 4. Avoid Over-Paragraphing

- Do not split every sentence or small idea into a separate paragraph.
- A normal dense technical paragraph should usually contain a coherent unit of information: motivation, boundary, mechanism, implication, or evidence.
- Merge adjacent micro-paragraphs when they are part of the same move and do not need separate emphasis.
- Keep short paragraphs only when they serve a real rhetorical or structural purpose, such as a transition, warning, contribution list lead-in, or limitation statement.

### 5. Figure Space Utilization And Fit-Height Legibility

- Compose every figure to fill its allotted area densely. Flag large empty
  margins, sparse panels, or a small figure floating in whitespace.
- The figure should be placed at the full column/text width unless a documented
  reason requires otherwise.
- Acceptance test: set the PDF viewer to fit-page-height and confirm that every
  axis label, tick, legend entry, annotation, panel tag, and callout inside the
  figure is clearly legible, and that in-figure text is not smaller than the
  caption text. Fix an illegible figure by tightening its composition, not by
  enlarging the caption or accepting a shrunken figure.
- This is a rendered-PDF check: render the page and read the figure; do not
  judge from source or from the standalone image.

## Reporting Contract

When reporting a visual inspection, include:

- build command and whether it succeeded;
- pages inspected;
- findings grouped by layout, single-character lines, density/rhythm, and paragraphing;
- changes made, if any;
- unresolved visual issues that require Human choice or broader rewriting.

Do not claim visual approval without actually inspecting the rendered PDF.
