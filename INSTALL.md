# Install

This bundle turns a source repository — a code repository, a Solution repository,
a small collection of them — into a complete, honest manuscript: it plans the
paper against the journal's own template, retrieves and verifies the literature,
drafts, compiles, renders and checks the result, and reports what it could not
do. It is a **prompt-only** capability: the skill is Markdown, the agent does the
work, and the CLI only runs batches, renders pages and checks gates.

Two ways in. Pick one.

## 1. Pi users: install as a package

```bash
pi install git:github.com/a-green-hand-jack/GeWu_Auto_Writing
```

`package.json` declares the skill, so Pi puts it where it looks for skills and
you are done. Pin a tag if you want a fixed version:

```bash
pi install git:github.com/a-green-hand-jack/GeWu_Auto_Writing@v1.0.0
```

This gives you the skill. It does **not** put the CLI on your PATH — for that,
run the installer below (or call the scripts by path, e.g.
`<checkout>/tools/gewu-verify`).

## 2. Any agent: run the installer

```bash
git clone https://github.com/a-green-hand-jack/GeWu_Auto_Writing
cd GeWu_Auto_Writing
./install.sh                 # skill into ~/.agents/skills, CLI into ~/.local/bin
```

Options that matter:

| option | why you would use it |
|---|---|
| `--target agents\|pi\|claude\|codex\|dir:PATH` | put the skill where your harness reads it (default: the first of those that exists, else `~/.agents/skills`) |
| `--bin DIR` | install the CLI elsewhere than `~/.local/bin` |
| `--link` | symlink the skill from the checkout, so edits are live while you develop |
| `--no-cli` | skill only |
| `--dry-run` | print every action and change nothing |
| `--uninstall` | remove the skill and the CLI this installer added |

`~/.agents/skills` is the cross-harness location: Pi reads it directly, and
Claude Code or Codex can be pointed at it (`"skills": ["~/.agents/skills"]` in
that harness's settings).

The installer ends by running the dependency check, so a missing class file is
reported now rather than forty minutes into a run.

## Requirements

`gewu-doctor` checks all of this and prints the exact remedy for whatever is
missing. Required:

| need | why |
|---|---|
| `pi` (or another agent that reads this skill) | owns the model, the session and the tool loop |
| TeX Live with `revtex4-2.cls` and `amsart.cls` | Physical Review X and Annals of Mathematics compile against them (`tlmgr install revtex amscls`) |
| `bibtex`, `pdflatex` | the compile loop |
| `python3` + `pypdfium2` | page rendering without a system Poppler; every visual gate depends on it (`python3 -m pip install --user --break-system-packages pypdfium2`) |

Optional:

| need | effect if absent |
|---|---|
| `bohr` CLI, logged in, with an access key | LKM literature retrieval and content-level verification fall back to public APIs, which rate-limit hard (arXiv answers 429) |
| system `pdftoppm` | `pdf-pages` uses pypdfium2 instead; either is fine |

The Nature Communications and ICLR styles travel with the skill because TeX Live
does not carry them. See **Third-party files** below before you redistribute.

## What is installed, and what is not

Installed: the skill (6 Markdown files plus the four journal template
directories) and the CLI — `gewu-run`, `gewu-batch`, `gewu-revive`,
`gewu-verify`, `gewu-lit`, `pdf-pages`, `gewu-doctor`.

Not installed, because it is ours and not yours: the corpus the skill was first
run over, the run directories of past batches, the authorship record, and the
operator memory files. The example launchers in `tools/launchers/` are shipped as
history, not onto your PATH: they name our corpus and our domain map. Use
`tools/launchers/launch-generic.sh` instead.

## Quickstart

Write a manifest — one entry per paper, tab-separated:

```tsv
# slug               source path                domain        title hint (optional)
ising-chain          ~/repos/ising-chain        physics       finite-size density of states
hard-square          ~/repos/hard-square        mathematics
pdpc-cycle           ~/repos/pdpc-cycle         life_sciences
```

Then:

```bash
# 1. what will be done, without launching anything
tools/launchers/launch-generic.sh --manifest entries.tsv --out ~/runs --dry-run

# 2. run it (freezes the skill and the runner into the run directory)
tools/launchers/launch-generic.sh --manifest entries.tsv --out ~/runs --name mybatch

# 3. watch it
export GEWU_BATCH_BASE=~/runs
gewu-batch watches mybatch          # or: status / gates / report / tail / show

# 4. check the papers against the gates in the skill
gewu-verify ~/runs/<run-directory>

# 5. collect the PDFs and an INDEX
gewu-batch handover --out ~/runs/<run-directory>-final <run-directory>
```

The launcher runs one agent per entry, with a provider health check before it
starts, a stall watchdog, a no-progress watchdog, retries after real failures,
and a separate budget for provider faults so a flaky provider does not consume a
task's retries. If a task dies anyway, `gewu-revive <run-dir>` restarts it from
its own workspace.

## Third-party files

The skill vendors journal templates that TeX Live does not carry. Each directory
states its own origin; check the terms before redistributing this bundle.

| directory | origin | status |
|---|---|---|
| `templates/prx-official/` | APS Physical Review template | carries `SOURCE-LICENSE.txt`; read it before redistribution |
| `templates/nature-comms/` | CTAN `nature` package, version 1.0, 2004, by Peter Czoschke | LPPL; the author states it is not an official Nature template and may not match current requirements |
| `templates/iclr-2026/` | ICLR Master-Template archive, commit `a28d335b…`, sha256 `b6d63b29…` | recorded in `template-metadata.json` as distribution-only; the upstream kit is unmodified |
| `templates/annals-of-mathematics/` | written for this bundle | the AMS `amsart` conventions; Annals publishes no LaTeX class |

## Layout

```text
install.sh                    installer (this document's subject)
package.json                  Pi package manifest: the skill, for pi install
.agents/skills/paperwriter-pi the skill
    SKILL.md                  role, the four requirements, routing, file map
    references/               constitution, production, templates, writing, checks
    templates/                the four journal templates
tools/                        the CLI
    gewu-run                  one task, with watchdogs and retries
    gewu-batch                list, watch, gate, report, collect a batch
    gewu-revive               restart a task the provider killed
    gewu-verify               the mechanical gates, in one command
    gewu-lit                  literature through LKM, with caching and budgets
    pdf-pages                 render PDF pages to PNG
    gewu-doctor               dependency check
    launchers/                launch-generic.sh + the history of our own batches
```

## Uninstall

```bash
./install.sh --uninstall
```

That removes the skill and the CLI this installer added. It leaves TeX, the
python packages and the LKM CLI alone — remove those yourself if you want them
gone.