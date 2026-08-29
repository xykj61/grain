#!/bin/sh
# radiant_pass_ledger_update.sh -- set or refresh a file's pass stamp in the ledger.
# Usage: sh tools/fixtures/r/radiant_pass_ledger_update.sh <relpath> <stamp>
set -eu
# Root by upward walk (seated 20260828): the letter fold moved this script one
# directory deeper, and fixed ../.. depth arithmetic is what broke. The walk finds
# the first ancestor holding rishi/bin and tools/fixtures -- git-free so pen copies
# outside a repository still resolve -- bounded at 8 steps, loud past the bound.
ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$ROOT/rishi/bin" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done
cd "$ROOT"
LEDGER=tools/fixtures/r/radiant_pass_ledger.txt
path=${1:?"usage: radiant_pass_ledger_update.sh <relpath> <stamp>"}
stamp=${2:?"usage: radiant_pass_ledger_update.sh <relpath> <stamp>"}
TMP=$(mktemp)
trap 'rm -f "$TMP"' EXIT
: >"$TMP"
found=0
while IFS= read -r line || [ -n "$line" ]; do
  case "$line" in
    ''|\#*) printf '%s\n' "$line" >>"$TMP"; continue ;;
  esac
  p=${line%%	*}
  if [ "$p" = "$path" ]; then
    printf '%s\t%s\n' "$path" "$stamp" >>"$TMP"
    found=1
  else
    printf '%s\n' "$line" >>"$TMP"
  fi
done <"$LEDGER"
if [ "$found" -eq 0 ]; then
  printf '%s\t%s\n' "$path" "$stamp" >>"$TMP"
fi
mv "$TMP" "$LEDGER"
echo "OK   ledger ${path} → ${stamp}"
