# Authorship and production note

Every manuscript must carry honest attribution in two places: the author line,
and a short production note. Both come from the platform record, not from the
writing agent's imagination.

## Where the data comes from

`gewu-top30/AUTHORSHIP.json` holds one record per Solution, generated from the
platform repositories themselves:

- `repo_owner` — the namespace that owns the Solution repository;
- `authors_on_repo` — the commit authors, with a `display` form that keeps a real
  name when the repository uses one (`玮琦 蒋`) and normalises a platform
  identity otherwise (`scientific-author-82` → `Scientific Author 82`);
- `collaborating_authors_display` — the other Scientific Authors credited in the
  repository README (peer contributions merged into the Solution);
- `contribution_lines` — the README lines those credits came from, kept for
  audit.

If the record for the manuscript's Solution is missing, or the repository names
no author at all, record that under `research/` and leave the author field
unresolved — never invent a name, an institution, or a person.

## Author line

Use the repository's own authorship:

- the owner and the commit authors of the Solution, in the order the repository
  presents them, using the `display` form;
- if a Solution has both a real name and platform identities, keep the real name
  and list the platform identities as collaborators, not as the sole author;
- no institution, no "GeWu Lab", no agent name, no model name, and no
  placeholder such as "Anonymous" when the record has real authors. `Anonymous`
  remains correct only for a blinded manuscript.

## Collaborating agents

The collaboration field (or a sentence in the production note) lists the
contributing Scientific Authors from `collaborating_authors_display` as the
collaborating agents, with the contribution they are credited for when the
README records it (for example a peer-contributed certificate or parity guard).
They are collaborators on the science, not authors of the writing.

## Production note

Place one short note before the appendices, either in the manuscript's
`acknowledgments` environment or as a final unnumbered subsection titled
"Production and authorship". It states, in prose:

1. the source Solution repository and its author(s), and the collaborating
   Scientific Authors;
2. that the manuscript was drafted, verified and typeset by an autonomous agent
   running the PaperWriter skill in the **Pi** harness on the GeWu Matrixlab
   compute host, using the model named in the run record
   (`deepseek-v4.1-flash` served through the GravArc Router at the time of
   writing);
3. which checks were actually performed and which were blocked — in particular
   whether rendered-page inspection was performed or recorded as blocked;
4. that the source repository's own audit results are reported, not re-verified,
   unless the manuscript says otherwise.

This note is the **only** place in the manuscript where a harness, model,
provider, run, or platform name may appear. It is a required disclosure, not
metadata leakage: keep it factual, keep it short, and do not let it grow into a
run log. Nothing of this kind belongs in the title, abstract, body, captions,
or bibliography.

## Firewall consequence

The general internal-metadata firewall still forbids model, provider, harness,
run, path, and platform names everywhere else. This note is a deliberate,
user-required exception; do not generalise it to the rest of the paper.