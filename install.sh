#!/usr/bin/env bash
# install.sh — put the paperwriter skill and CLI where an agent can find them.
#
# Two install paths, both supported:
#
#   pi install git:github.com/<owner>/GeWu_Auto_Writing   # Pi users, via package.json
#   ./install.sh                                          # everyone else, or to get the CLI
#
# This script is the second one. The skill is self-contained: the CLI it calls
# lives in its own tools/ directory, so installing the skill installs the tooling
# with it. This script puts the skill where a harness reads it, copies those tools
# onto PATH so the names the skill uses resolve, and finishes by running the
# dependency check so a missing class file or renderer is reported now rather than
# 40 minutes into a run.
#
# Nothing else on the machine is touched, and every action is printed.
set -uo pipefail

# Where is this script, and is a checkout sitting beside it? Piped in from the
# network there is no BASH_SOURCE at all, and $0 is just "bash", so dirname would
# resolve to the caller's current directory -- which meant a piped install could
# silently take its payload from whatever directory the user happened to be in.
SELF="${BASH_SOURCE[0]:-}"
if [ -n "$SELF" ] && [ -f "$SELF" ]; then
  SRC="$(cd "$(dirname "$SELF")" && pwd)"
else
  SRC=""
fi
SKILL_NAME="paperwriter-pi"
SKILL_SRC="$SRC/.agents/skills/$SKILL_NAME"
CLI="gewu-run gewu-batch gewu-revive gewu-verify gewu-lit pdf-pages gewu-doctor"

TARGET="auto"; BIN="$HOME/.local/bin"; WITH_CLI=1; DRY=0; UNINSTALL=0; DOCTOR=1; LINK=0
REPO_SLUG="${GEWU_REPO:-a-green-hand-jack/GeWu_Auto_Writing}"
REF="${GEWU_REF:-main}"; SOURCE_URL="${GEWU_SOURCE:-}"

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
  --ref REF          which git ref to fetch when run without a checkout (default main)
  --source URL       fetch the payload from this tarball instead of GitHub
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
    --ref) REF="${2:?}"; shift 2 ;;
    --source) SOURCE_URL="${2:?}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "install.sh: unknown option '$1'" >&2; usage >&2; exit 2 ;;
  esac
done

say() { printf '%s\n' "$*"; }
run() { if [ "$DRY" = 1 ]; then say "  would: $*"; else "$@"; fi; }

# --- acquire the payload if this script is running on its own ------------------
# Two ways to run this: from a checkout (the usual case for a developer) or piped
# straight from the network, e.g.
#   curl -fsSL https://raw.githubusercontent.com/<slug>/<ref>/install.sh | bash
# In the second case there is no checkout beside the script, so fetch one.
FETCHED=""
fetch_payload() {
  local tmp url try
  tmp="$(mktemp -d)"
  if [ -n "$SOURCE_URL" ]; then
    url="$SOURCE_URL"
  else
    url=""
    for try in "refs/tags/$REF" "refs/heads/$REF"; do
      if curl -fsSL -o "$tmp/p.tar.gz" "https://codeload.github.com/$REPO_SLUG/tar.gz/$try" 2>/dev/null; then
        url="$try"; break
      fi
    done
    [ -z "$url" ] && { echo "install.sh: cannot fetch $REPO_SLUG@$REF (tried tag and branch)" >&2; return 1; }
  fi
  if [ ! -s "$tmp/p.tar.gz" ]; then
    curl -fsSL -o "$tmp/p.tar.gz" "$url" || { echo "install.sh: download failed: $url" >&2; return 1; }
  fi
  tar xzf "$tmp/p.tar.gz" -C "$tmp" || { echo "install.sh: not a usable tarball: $url" >&2; return 1; }
  local root
  root="$(find "$tmp" -maxdepth 2 -type d -name 'GeWu_Auto_Writing-*' | head -1)"
  [ -n "$root" ] || { echo "install.sh: the tarball has no repository root" >&2; return 1; }
  FETCHED="$root"
  say "fetched:  $REPO_SLUG@$REF"
  return 0
}

if [ -z "$SRC" ] || [ ! -d "$SKILL_SRC" ]; then
  if [ "$DRY" = 1 ] && [ -z "$SOURCE_URL" ]; then
    say "no checkout beside this script; would fetch $REPO_SLUG@$REF"
    FETCHED="/tmp/gewu-dry-run-payload"
  else
    fetch_payload || exit 2
  fi
  SRC="$FETCHED"
  SKILL_SRC="$SRC/.agents/skills/$SKILL_NAME"
fi
[ -n "$SRC" ] && [ -d "$SKILL_SRC" ] || { echo "install.sh: no skill found (looked in ${SRC:-an empty source})" >&2; exit 2; }

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
    [ -f "$SKILL_SRC/tools/$t" ] || { say "  !! missing tool $SKILL_SRC/tools/$t"; continue; }
    run cp -f "$SKILL_SRC/tools/$t" "$BIN/$t"
    run chmod +x "$BIN/$t"
  done
fi

# The launchers are project-specific (they name a corpus and a domain map), so
# they are shipped as examples rather than installed onto PATH.
[ -f "$SKILL_SRC/tools/launch-generic.sh" ] && say "  launcher: $SKILL_SRC/tools/launch-generic.sh (run a batch; see INSTALL.md)"

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
  if [ "$DRY" = 1 ]; then say "(skipped in --dry-run)"; else "$SKILL_SRC/tools/gewu-doctor" || true; fi
fi
