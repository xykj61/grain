#!/bin/sh
# dated_guard_scan.sh — body for dated_guard_scan.rish.
#
# Port of dated_guard_scan.py. Staged MODIFIED dated paths that already exist
# on main must declare a living ledger header (or freeze-pointer stub).
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
cd "$ROOT"

TMP=$(mktemp -d "${TMPDIR:-/tmp}/dated-guard-scan.XXXXXX")
trap 'rm -rf "$TMP"' EXIT

if ! git diff --cached --name-only --diff-filter=M >"$TMP/staged"; then
  echo "FAIL git diff --cached failed"
  exit 1
fi

grep -E '(^|/)2026[0-9]{4}-[0-9]{6}_[^/]+$' "$TMP/staged" >"$TMP/candidates" || true
if [ ! -s "$TMP/candidates" ]; then
  echo "OK   no staged MODIFIED dated paths"
  exit 0
fi

on_main() {
  path=$1
  for ref in main origin/main; do
    if git cat-file -e "${ref}:${path}" 2>/dev/null; then
      return 0
    fi
  done
  return 1
}

declares_living() {
  head -40 "$1" | tr '[:upper:]' '[:lower:]' | grep -Fq 'living ledger'
}

is_freeze_pointer() {
  path=$1
  size=$(wc -c <"$path" | tr -d ' ')
  [ "$size" -lt 1200 ] || return 1
  low=$(tr '[:upper:]' '[:lower:]' <"$path")
  printf '%s\n' "$low" | grep -Fq 'living twin' || return 1
  printf '%s\n' "$low" | grep -Fq 'immutable after merge'
}

: >"$TMP/out"
reds=0
while IFS= read -r path; do
  [ -n "$path" ] || continue
  if ! on_main "$path"; then
    echo "OK   ${path} (new to main — dated birth allowed)" >>"$TMP/out"
    continue
  fi
  if [ ! -f "$path" ]; then
    echo "FAIL ${path}: missing working tree" >>"$TMP/out"
    reds=$((reds + 1))
    continue
  fi
  if declares_living "$path"; then
    echo "OK   ${path} (living header)" >>"$TMP/out"
  elif is_freeze_pointer "$path"; then
    echo "OK   ${path} (freeze pointer stub)" >>"$TMP/out"
  else
    echo "FAIL ${path}: dated on main without living ledger header — edit TASKS or a living twin" >>"$TMP/out"
    reds=$((reds + 1))
  fi
done <"$TMP/candidates"

cat "$TMP/out"
if [ "$reds" -gt 0 ]; then
  echo "FAIL count=${reds}"
  exit 1
fi
echo "OK   dated-guard clean"
exit 0
