# Launchers

One script per batch. A launcher builds the per-Solution task directories under
a new timestamped run directory and starts one `gewu-run` per task. It freezes
the skill, the runner, and `AUTHORSHIP.json` into that run directory, so a run
stays reproducible even after the skill changes.

Copy the newest launcher for a new round, bump the run name in `RUN=`, and change
only what the round is testing. Keep the old ones: they document what each round
was for and how a delivered defect was addressed.

## Environment

| variable | meaning |
|---|---|
| `ONLY="slug slug"` | restrict the launcher to those Solutions (used to re-run a few papers) |
| `MODEL` | writing model, set inside the script (currently `glm-5.3`) |
| `GEWU_MODEL` | read by `gewu-revive` when it restarts a killed task |
| `MAX_FAULTS` | provider-fault budget per task (default 12, set by `gewu-run`) |

## Per task

- `--stall 1200` / `--no-progress 2400` / `--retries 3`, plus a provider health
  check before the batch starts, so a router outage does not take the batch down.
- The task prompt carries the domain route, the template, the section-skeleton
  rule, the body/appendix rule, the attribution whitelist, and the filesystem
  discipline (write inside the workspace, never `mkdir` the tree, never `rm`/`mv`).

## Rounds

| launcher | run | what it was for |
|---|---|---|
| `launch_top30_prx_batch.sh`, `launch_math_batch.sh` | `top30-prx-*`, `math5-*` | first physics and mathematics batches |
| `launch_round2.sh` … `launch_round5.sh` | `round2-*` … `round5-*` | template, reference-page, prose-shape and attribution fixes |
| `launch_round6.sh` | `round6b-slim` | slimmed 6-file skill with GLM; stopped over workspace damage |
| `launch_round7.sh` | `round7-fixed` | full re-run after the runner was fixed to start pi inside the workspace |
| `launch_round8.sh` | `round8-fix` | re-run of the 6 papers round 7 delivered with appendix or limitations defects |
| `launch_round9.sh` | `round9-lkm` | LKM literature integration; stopped and superseded |
| `launch_round10.sh` | `round10-final` | all 30, prompt re-audited against the rewritten skill; 30/30, all 14 gates passing |
| `launch_round11.sh` | `round11-prose` | all 30, after the prose-shape rule was relocated to `writing.md` §9 and the gate taught to count labelled paragraphs. 30/30, 0 gate failures; labelled paragraphs 8.4% -> 2.2% |

Round 6 (`round6-slim`) and round 6b are superseded; their run directories carry
`SUPERSEDED.md` / `STOPPED.md`.

## Retired requirements

**The production note is gone.** Until round 8 every launcher told the agent to
add a "Production and authorship" subsection before the appendices, disclosing
the source repository, the collaborating agents, the harness, the model and the
checks performed. That was wrong on two counts: it required a field no journal
asks for, and it put tooling and platform names into the manuscript.

What replaced it: the source repository is cited **as an ordinary reference** in
the bibliography — one entry per repository, several where a paper derives from
several — and no harness, model, provider, host, agent, prompt, run or check word
appears anywhere in the manuscript. The requirement is stated in
`references/constitution.md` §7 and the wording the agent receives is in each
launcher's `Attribution` block. The launchers from rounds 4–8 have been updated
in place; `git log -p` still shows what they used to say.

