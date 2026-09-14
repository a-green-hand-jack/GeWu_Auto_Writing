#!/usr/bin/env bash
# install.sh — put the paperwriter skill and CLI where an agent can find them.
#
# Two install paths, both supported:
#
#   pi install git:github.com/<owner>/GeWu_Auto_Writing   # Pi users, via package.json
#   ./install.sh                                          # everyone else, or to get the CLI
#
# This script is the second one. It copies the skill into a skills directory that
# the target harness reads, copies the CLI into a bin directory on PATH, and
# finishes by running the dependency check so a missing class file or renderer is
# reported now rather than 40 minutes into a run.
#
# Nothing else on the machine is touched, and every action is printed.
set -uo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_NAME="paperwriter-pi"
SKILL_SRC="$SRC/.agents/skills/$SKILL_NAME"
CLI="gewu-run gewu-batch gewu-revive gewu-verify gewu-lit pdf-pages gewu-doctor"

TARGET="auto"; BIN="$HOME/.local/bin"; WITH_CLI=1; DRY=0; UNINSTALL=0; DOCTOR=1; LINK=0

usage() { sed -n '3,18p' "$0" | sed 's/^# \{0,1\}//'; cat <<'EOF'

Options:
  --target auto|agents|pi|claude|codex|dir:PATH   where the skill goes (default auto)
  --bin DIR          where the CLI goes (default ~/.local/bin)
  --with-cli         install the CLI (default)
  --no-cli           skill only
  --link             symlink the skill from this checkout instead of copying
  --dry-run          print the plan, change nothing
  --uninstall        remove a previous install of this skill and CLI
  --no-doctor        skip the dependency check at the end
  -h, --help         this text
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --target) TARGET="${2:?}"; shift 2 ;;
    --bin) BIN="${2:?}"; shift 2 ;;
    --with-cli) WITH_CLI=1; shift ;;
    --no-cli) WITH_CLI=0; shift ;;
    --link) LINK=1; shift ;;
    --dry-run) DRY=1; shift ;;
    --uninstall) UNINSTALL=1; shift ;;
    --no-doctor) DOCTOR=0; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "install.sh: unknown option '$1'" >&2; usage >&2; exit 2 ;;
  esac
done

say() { printf '%s\n' "$*"; }
run() { if [ "$DRY" = 1 ]; then say "  would: $*"; else "$@"; fi; }

[ -d "$SKILL_SRC" ] || { echo "install.sh: no skill at $SKILL_SRC — run this from the repository root" >&2; exit 2; }

# --- where does the skill go -------------------------------------------------
resolve_target() {
  case "$TARGET" in
    agents) echo "$HOME/.agents/skills" ;;
    pi)     echo "$HOME/.pi/agent/skills" ;;
    claude) echo "$HOME/.claude/skills" ;;
    codex)  echo "$HOME/.codex/skills" ;;
    dir:*)  echo "${TARGET#dir:}" ;;
    auto)
      # Prefer a directory the machine already uses, so the skill lands where an
      # agent is already looking. ~/.agents/skills is the cross-harness location
      # (Pi reads it directly; Claude Code and Codex can be pointed at it).
      for d in "$HOME/.agents/skills" "$HOME/.pi/agent/skills" "$HOME/.claude/skills" "$HOME/.codex/skills"; do
        [ -d "$d" ] && { echo "$d"; return; }
      done
      echo "$HOME/.agents/skills" ;;
    *) echo "install.sh: bad --target '$TARGET'" >&2; exit 2 ;;
  esac
}
SKILLS_DIR="$(resolve_target)"
DEST="$SKILLS_DIR/$SKILL_NAME"

# --- uninstall ---------------------------------------------------------------
if [ "$UNINSTALL" = 1 ]; then
  say "uninstalling"
  [ -e "$DEST" ] && run rm -rf "$DEST" && say "  removed skill $DEST" || say "  no skill at $DEST"
  for t in $CLI; do
    [ -f "$BIN/$t" ] && { run rm -f "$BIN/$t"; say "  removed $BIN/$t"; }
  done
  [ "$DRY" = 0 ] && say "done. Left in place: TeX, python packages, and the LKM CLI — remove those yourself if you want them gone."
  exit 0
fi

# --- install -----------------------------------------------------------------
say "source:  $SKILL_SRC"
say "skill:   $DEST   ($(find "$SKILL_SRC" -type f | wc -l) files, $(du -sh "$SKILL_SRC" | cut -f1))"
[ "$WITH_CLI" = 1 ] && say "cli:     $BIN/{$(echo "$CLI" | tr ' ' ',')}"
say ""

run mkdir -p "$SKILLS_DIR"
if [ "$LINK" = 1 ]; then
  say "  linking (edits in this checkout are live)"
  run rm -rf "$DEST"
  run ln -s "$SKILL_SRC" "$DEST"
else
  # Copy always, so the installed skill keeps working if the checkout moves. The
  # hidden .git directory, if any, is not part of a skill.
  run rm -rf "$DEST"
  run mkdir -p "$DEST"
  if [ "$DRY" = 0 ]; then
    ( cd "$SKILL_SRC" && tar cf - --exclude='.git' . ) | ( cd "$DEST" && tar xf - )
  fi
fi

if [ "$WITH_CLI" = 1 ]; then
  run mkdir -p "$BIN"
  for t in $CLI; do
    [ -f "$SRC/tools/$t" ] || { say "  !! missing tool $SRC/tools/$t"; continue; }
    run cp -f "$SRC/tools/$t" "$BIN/$t"
    run chmod +x "$BIN/$t"
  done
fi

# The launchers are project-specific (they name a corpus and a domain map), so
# they are shipped as examples rather than installed onto PATH.
[ -d "$SRC/tools/launchers" ] && say "  examples left in $SRC/tools/launchers (see its README)"

# --- PATH advice -------------------------------------------------------------
case ":$PATH:" in
  *":$BIN:"*) ;;
  *) say ""
     say "NOTE: $BIN is not on your PATH. Add it, for example:"
     say "  echo 'export PATH=\"$BIN:\$PATH\"' >> ~/.profile && . ~/.profile"
     ;;
esac

say ""
say "next:"
say "  1. make sure the target harness reads $SKILLS_DIR"
say "     (Pi reads ~/.agents/skills and ~/.pi/agent/skills; for Claude Code or Codex,"
say "      add \"$SKILLS_DIR\" to that harness's skills list)"
say "  2. run: gewu-doctor"

if [ "$DOCTOR" = 1 ]; then
  say ""
  say "--- dependency check ---"
  if [ "$DRY" = 1 ]; then say "(skipped in --dry-run)"; else "$SRC/tools/gewu-doctor" || true; fi
fi