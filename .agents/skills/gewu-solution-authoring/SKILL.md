---
name: gewu-solution-authoring
description: Organize a scientific or Code Package Solution repository using the GeWu README contract and submission workflow.
---

# GeWu Solution Authoring

## Repository contract

A Solution is an active Internal GitLab project in the submitting owner's personal namespace. The only mandatory file is the root `README.md`; code, manuscript, paper, data, tests, figures, and other supporting material are optional and may use any layout.

The root README may start with one optional H1, then must contain exactly these H2 sections in this order:

```markdown
## Problem

Self-contained description of the Problem or addressed Problem boundary.

### Problem References

- https://git.gewu-lab.ai/<owner>/<problem-repo>/-/blob/main/README.md

## Solution

Self-contained description of the Solution in this repository.

## Open Questions
```

`Problem` must contain nonempty prose and exactly one direct-child `### Problem References` heading. That heading must be followed immediately by an unordered list containing one or more absolute HTTPS Markdown links, or exactly `- None`. Do not mix links with `- None`. `Solution` must contain nonempty self-contained prose. `Open Questions` may be empty; if populated, each question is a unique direct-child H3 with a self-contained body. No other H2 is permitted.

## Prepare a submission

1. Confirm the Solution project is owned by the submitting user and is Internal.
2. Validate the README against this contract.
3. Push the exact commit to be reviewed using HTTPS.
4. Record the numeric GitLab project ID and the full 40-character lowercase commit SHA.
5. In the `publisher` GitLab group, inspect accessible Internal Journal/Registry projects and choose the target whose scope and grade fit the Solution.
6. For a Code Package, choose a lowercase ASCII hyphen-separated `package_id` (1–64 bytes) and a valid full `package_version` (for example `1.0.0` or `1.0.0-rc.1`).

## Intake Issue

Create one Issue in the selected Journal or Registry with exactly one marker and one fenced YAML block.

Scientific Solution:

````markdown
<!-- matrixlab:solution-intake:v1 -->
```yaml
solution_project_id: 123
solution_sha: aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
```
````

Code Package: add `package_id` and `package_version` to the same YAML block. Replace all examples with exact values. Do not create duplicate intakes.

## Status handling

Use both the original intake Issue and its linked submission Merge Request:

- Open Issue, no MR: initial processing; wait unless an exact value needs prompt correction.
- Closed Issue, no MR: read the Editor decision; do not assume acceptance.
- Open MR: review is in progress; do not edit the Journal/Registry record or submission branch.
- Merged MR and closed Issue: accepted.
- Closed MR without merge and closed Issue: rejected.
- Ambiguous open state: preserve evidence and ask a maintainer; do not create duplicates.

## Revision requests

Only respond to a maintainer's current revision request. Read its revision number, reviewed SHA, and linked MR. Resolve current unresolved Reviewer discussions, push one changed commit to the same Solution project, and verify the new SHA differs from the reviewed SHA. Then post exactly one comment in the original intake Issue:

````markdown
<!-- matrixlab:solution-revision:v1 -->
```yaml
revision: 1
solution_sha: bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
```
````

Use the requested revision number and exact new SHA. Add no prose or additional code block. At most two revision rounds are supported.
