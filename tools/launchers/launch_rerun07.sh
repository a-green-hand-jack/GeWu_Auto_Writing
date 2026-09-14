#!/usr/bin/env bash
# Bounded re-run of 07 only, after it burned an hour in an unbounded check loop
# with its script written into /tmp.
#
# Carries the two fixes this incident motivated:
#   * skill  : research/checks/ with output beside it, hard caps in code, pilot
#              before scaling, two failures -> change strategy, budget reserve
#   * runner : --no-progress stops a task whose workspace stops changing even
#              while the CPU is busy
# The previous workspace (literature already retrieved) is carried over so the
# task resumes instead of restarting.
set -uo pipefail

BASE="$HOME/GeWu_Auto_Writing/paperwriter-pi-runs"
OLD="$BASE/20260913T221413Z-round2-domain-routed"
SLUG="07-sun-aklt-transfer-matrix-spectrum"
SKILL_SRC="$HOME/GeWu_Auto_Writing/.agents/skills/paperwriter-pi"
TS=$(date -u +%Y%m%dT%H%M%SZ)
export GEWU_BATCH_BASE="$BASE"   # gewu-batch resolves run names under this base
RUN="$BASE/${TS}-rerun07-bounded"

mkdir -p "$RUN/$SLUG"
cp -r "$SKILL_SRC" "$RUN/skill"
mkdir -p "$RUN/tool" && cp -f "$HOME/GeWu_Auto_Writing/bin/gewu-run" "$RUN/tool/gewu-run"

# carry over the research material already gathered
cp -r "$OLD/$SLUG/workspace" "$RUN/$SLUG/workspace"

# rebuild the task prompt from the round-2 one, with the new workspace and an
# explicit statement of the bounded-verification rules
sed "s|^WORKSPACE (the only writable output location): .*|WORKSPACE (the only writable output location): $RUN/$SLUG/workspace|" \
    "$OLD/$SLUG/task.md" > "$RUN/$SLUG/task.md"
cat >> "$RUN/$SLUG/task.md" <<'EXTRA'

Additional requirement for this re-run (a previous attempt failed here): the
workspace already contains the literature you retrieved, so continue from it.

Every verification you run must be bounded and visible:
- put check scripts under `research/checks/` with their output beside them;
  never write a script or its output to /tmp, $HOME, or anywhere outside the
  workspace — such a run loses its provenance and shows no progress;
- state the finite coverage and a hard cap (seconds, maximum size, maximum
  iterations) in the script, enforce the cap in code, print the coverage
  actually reached, and wrap the run in `timeout`;
- pilot the smallest case first and scale only if it finishes quickly;
- if the same check fails or hangs twice, change strategy instead of patching it
  a third time: shrink the covered range, replace the computation with an
  analytic argument or a smaller exact certificate, or mark the dependent claim
  conditional;
- reserve at least a third of the run for drafting, compilation, preflight and
  review; a single check may not consume the run;
- record in research/validation.md what was verified, what was not, and the
  coverage reached, and weaken any claim that depends on the unchecked part.

See workflows/production.md section 7b.
EXTRA

echo "RUN=$RUN"
setsid nohup bash "$RUN/tool/gewu-run" --task-dir "$RUN/$SLUG" \
    --skill "$RUN/skill/SKILL.md" --timeout 7200 --stall 1200 \
    --no-progress 2400 --retries 2 > "$RUN/$SLUG.log" 2>&1 < /dev/null &
sleep 25
echo "pid=$(cat "$RUN/$SLUG/pid" 2>/dev/null) alive=$(pgrep -fc "$RUN/$SLUG/task.md")"
echo "carried files: $(find "$RUN/$SLUG/workspace" -type f | wc -l)"
echo "frozen skill md: $(find "$RUN/skill" -name '*.md' | wc -l)"
grep -c 'no-progress' "$RUN/tool/gewu-run"
