# Layout and typesetting review criteria

Apply these when rendered pages are available. Reading LaTeX source is not a
layout review: only the rendered page shows overflow, float placement and
whitespace. If the active model cannot read images, record every item here as
`not_performed` rather than inferring it from the source.

Report each finding with a page number, a severity and a concrete observation.
Severity `critical` means a reader loses information or the venue's rules are
broken; `warning` means the reading experience is clearly harmed; `info` is a
suggestion.

## Per page

- **Overflow.** Text or floats crossing the margin, into the gutter, or off the
  page. An overfull box wider than a few points is a defect, not a warning.
- **Rendering.** Formulas typeset correctly, no literal LaTeX commands, no
  missing-glyph boxes, no unresolved `??` from a failed reference pass.
- **Whitespace.** Any block of blank space larger than about a quarter page, and
  in two-column layouts, uneven column balance on the same page.
- **Headings.** No section heading stranded at the bottom of a page with its
  first paragraph overleaf.

## Floats and display items

- Each figure or table appears on or after the page that first references it,
  and not pushed to the end of the paper.
- In a two-column layout, anything needing full width uses the starred float
  form rather than being squeezed into one column.
- Captions are self-contained: a reader who has not reached the body text can
  tell what the display item shows and what the axes or columns mean.
- Table rules follow the booktabs convention: no vertical rules, no double
  horizontal rules.

## Readability of figures

- Text inside a figure is at least roughly 70% of the body font size and legible
  at print scale.
- Lines and categories remain distinguishable without colour, or the palette is
  colour-blind safe. Colour alone must not be the only encoding.
- Resolution is sufficient that labels are sharp rather than interpolated.

## Whole document

- Page count against the venue limit, counting everything the venue counts.
- Display-item density suits the paper type. A predominantly empirical paper
  with no figures at all is a finding; a short theory paper with none may be
  entirely correct — say which case applies rather than applying a quota.
- Front matter reads cleanly: title, authors, abstract block, and no template
  placeholder text left in place. Required licence notices stay.
- Every figure or table referenced in the body exists, and every included one is
  referenced somewhere.

## What a pass means

A pass here means the rendered pages are legible and well formed for the exact
PDF bytes inspected. It says nothing about correctness, novelty or suitability,
and it expires the moment the PDF changes: new bytes require a new render and a
new inspection.
