#!/bin/sh
# dated_guard_scan.sh — body for dated_guard_scan.rish.
# Missing Rishi verb: accumulate · filter chained · read bounded — harvest ledger (counsel 20260725.040247)
#
# Staged MODIFIED dated paths that already exist on main must declare a living
# ledger header, freeze-pointer stub, or recorded Radiant pass (Tier 2).
# Tier 1 proof-sealed paths refuse modification outright.
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
cd "$ROOT"

TIER1="tools/fixtures/dated_guard_tier1.txt"
TMP=$(mktemp -d "${TMPDIR:-/tmp}/dated-guard-scan.XXXXXX")
trap 'rm -rf "$TMP"' EXIT

if ! git diff --cached --name-only --diff-filter=M >"$TMP/staged"; then
  echo "FAIL git diff --cached failed"
  exit 1
fi

is_tier1() {
  path=$1
  [ -f "$TIER1" ] || return 1
  while IFS= read -r line; do
    case "$line" in ''|\#*) continue ;; esac
    if [ "$line" = "$path" ]; then
      return 0
    fi
  done <"$TIER1"
  return 1
}

: >"$TMP/out"
reds=0

# Tier 1 — any staged modification of a proof-sealed path is red.
while IFS= read -r path; do
  [ -n "$path" ] || continue
  if is_tier1 "$path"; then
    echo "FAIL ${path}: Tier 1 sealed by proof — never edit (digest/signature/root)" >>"$TMP/out"
    reds=$((reds + 1))
  fi
done <"$TMP/staged"

grep -E '(^|/)2026[0-9]{4}-[0-9]{6}_[^/]+$' "$TMP/staged" >"$TMP/candidates" || true
if [ ! -s "$TMP/candidates" ] && [ "$reds" -eq 0 ]; then
  echo "OK   no staged MODIFIED dated paths; Tier 1 clean"
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

# Recorded Radiant pass — Tier 2 style-only door (TAME §4 · living-vs-dated).
has_radiant_pass() {
  # Forms: "Radiant pass 20260724.223233" · "Radiant pass `stamp`" · optional markdown bold/colon
  head -60 "$1" | grep -Eqi 'Radiant pass[:\*[:space:]]+`?[0-9]{8}[.]?[0-9]{6}`?'
}

if [ -s "$TMP/candidates" ]; then
  while IFS= read -r path; do
    [ -n "$path" ] || continue
    if is_tier1 "$path"; then
      # already counted above
      continue
    fi
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
    elif has_radiant_pass "$path"; then
      echo "OK   ${path} (Radiant pass — Tier 2)" >>"$TMP/out"
    else
      echo "FAIL ${path}: dated on main without living ledger, freeze pointer, or Radiant pass — edit TASKS, a living twin, or record a pass" >>"$TMP/out"
      reds=$((reds + 1))
    fi
  done <"$TMP/candidates"
fi

cat "$TMP/out"
if [ "$reds" -gt 0 ]; then
  echo "FAIL count=${reds}"
  exit 1
fi
echo "OK   dated-guard clean"
exit 0
