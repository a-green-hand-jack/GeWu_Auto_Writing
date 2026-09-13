#!/usr/bin/env bash
set -euo pipefail

HOST='115.190.218.195'
USER_NAME='jieke'
KEY_FILE="${GEWU_ECS_KEY_FILE:-$HOME/.ssh/id_ed25519}"

if [[ ! -r "$KEY_FILE" ]]; then
  printf 'SSH key not found or unreadable: %s\n' "$KEY_FILE" >&2
  exit 1
fi

exec ssh \
  -o IdentitiesOnly=yes \
  -i "$KEY_FILE" \
  -o ServerAliveInterval=30 \
  -o ServerAliveCountMax=3 \
  "$USER_NAME@$HOST" "$@"
