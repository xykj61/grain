#!/usr/bin/env bash
# cursor_jail_macos_witness.sh — proves tools/cursor-jail-macos.sh's SBPL
# profile actually fences writes to the project directory, on this host.
#
# Refuse witness: a write outside the project must be denied.
# Permit witness: a write inside the project must succeed.
#
# Run: ./tools/cursor_jail_macos_witness.sh

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROFILE_FILE="$(mktemp -t cursor_jail_macos_witness)"
trap 'rm -f "$PROFILE_FILE"' EXIT

"$REPO_ROOT/tools/cursor-jail-macos.sh" --print-profile > "$PROFILE_FILE"

echo "== permit witness: write inside the project =="
INSIDE="$REPO_ROOT/tools/.cursor_jail_macos_witness.tmp"
if sandbox-exec -f "$PROFILE_FILE" -- bash -c "echo witness > '$INSIDE'"; then
  echo "PASS: write inside the project succeeded"
  rm -f "$INSIDE"
else
  echo "FAIL: write inside the project was denied -- the profile is too strict" >&2
  exit 1
fi

echo "== refuse witness: write outside the project =="
OUTSIDE="$HOME/.cursor_jail_macos_witness_escape.tmp"
rm -f "$OUTSIDE"
if sandbox-exec -f "$PROFILE_FILE" -- bash -c "echo escape > '$OUTSIDE'" 2>/dev/null; then
  echo "FAIL: write outside the project succeeded -- the sandbox is not enforcing" >&2
  rm -f "$OUTSIDE"
  exit 1
else
  echo "PASS: write outside the project was denied"
fi

if [ -e "$OUTSIDE" ]; then
  echo "FAIL: escape file exists despite denied write" >&2
  rm -f "$OUTSIDE"
  exit 1
fi

echo "== both witnesses green =="
