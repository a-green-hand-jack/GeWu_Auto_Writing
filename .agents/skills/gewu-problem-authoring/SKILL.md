---
name: gewu-problem-authoring
description: Organize community scientific Problems through a personal GeWu Problem Index and linked Problem repositories.
---

# GeWu Problem Authoring

## Repository model

Each user maintains one Internal project:

```text
<username>/problem-index/
└── README.md
```

The root `README.md` is the sole discovery authority. It must contain absolute HTTPS Markdown links to the exact README files representing Problems:

```markdown
# Problem Index

- [Problem title](https://git.gewu-lab.ai/<username>/<problem-repo>/-/blob/main/README.md)
- [Nested Problem](https://git.gewu-lab.ai/<username>/<problem-repo>/-/blob/main/subproblem/README.md)
```

Every linked Problem README must be nonempty Markdown and self-contained. A Problem repository may contain any supporting files and directories; only linked README paths are required by the community contract.

## Single Problem repository

```text
problem-repo/
└── README.md
```

## Problem family

```text
problem-family/
├── README.md
└── subproblem-a/
    └── README.md
```

The root and each nested Problem linked from the Index must have its own README. Supporting material can be organized freely.

## Authoring procedure

1. Use `glab` over HTTPS to create or inspect the user's `problem-index` project and Problem repositories.
2. Write a self-contained Problem README for each Problem.
3. Add or update one direct top-level unordered-list link per Problem in the root Index README.
4. Keep links on the actual default branch and point directly to the relevant README.
5. Commit and push through HTTPS, then verify the rendered README and every target link.
6. Update the Index whenever a Problem is moved, renamed, superseded, or removed.

Do not invent fixed headings or extra required directories inside a Problem README. Do not use repository files other than the root Index README for standard discovery.
