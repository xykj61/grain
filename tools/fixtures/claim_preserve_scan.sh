#!/bin/sh
# claim_preserve_scan.sh — before/after claim-token and modality identity for a Radiant pass.
# Missing Rishi verb: accumulate · filter chained · read bounded — harvest ledger (counsel 20260725.040247)
# Modality seated 20260725.110354 — counsel the-runway; obligation drift stops the wave.
#
# Env:
#   CLAIM_PRESERVE_FILES — newline-separated relative paths (required for a pass)
#   CLAIM_PRESERVE_BASE  — git ref for BEFORE (default: HEAD)
#
# Also asserts pinned digests in known homes are unchanged vs BASE:
#   tools/waymark_derive.rish corpus_digest / corpus_count_pin
#   linengrow/seva_b0_fold.rye expected_demo_root_hex
#
# Exit 1 on any mismatch — STOP the wave; do not resolve.
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
cd "$ROOT"

BASE=${CLAIM_PRESERVE_BASE:-HEAD}
# The extractor now speaks Rishi (Python → perl → Rishi molt 20260809): its own
# match/find/sort/unique, no shell or perl. Before and after use the same extractor,
# so the claim comparison holds regardless of the ASCII/Unicode edge on rare non-ASCII.
EXTRACT="rishi/bin/rishi run tools/fixtures/claim_preserve_extract.rish"
TMP=$(mktemp -d "${TMPDIR:-/tmp}/claim-preserve.XXXXXX")
trap 'rm -rf "$TMP"' EXIT

if [ -z "${CLAIM_PRESERVE_FILES:-}" ]; then
  echo "FAIL CLAIM_PRESERVE_FILES empty — name every file the pass touches"
  exit 1
fi

printf '%s\n' "$CLAIM_PRESERVE_FILES" | sed '/^$/d' >"$TMP/files"
reds=0

# Drop Radiant-pass, Erratum, and Living-pointer lines so recorded Tier-2
# doors can open without pretending the new stamp or pointer was always there.
normalize_body() {
  # stdin → stdout
  grep -viE 'Radiant pass|[Ee]rratum|[Ll]iving pointer' || true
}

while IFS= read -r path; do
  [ -n "$path" ] || continue
  if [ ! -f "$path" ]; then
    echo "FAIL missing working tree: ${path}"
    reds=$((reds + 1))
    continue
  fi
  if ! git cat-file -e "${BASE}:${path}" 2>/dev/null; then
    echo "FAIL ${path}: not in ${BASE} — claim_preserve compares an existing file"
    reds=$((reds + 1))
    continue
  fi
  git show "${BASE}:${path}" >"$TMP/before_raw"
  normalize_body <"$TMP/before_raw" >"$TMP/before_body"
  normalize_body <"$path" >"$TMP/after_body"
  $EXTRACT "$TMP/before_body" | sort -u >"$TMP/before"
  $EXTRACT "$TMP/after_body" | sort -u >"$TMP/after"
  if ! cmp -s "$TMP/before" "$TMP/after"; then
    echo "FAIL claim tokens drifted: ${path}"
    echo "--- only in BEFORE (${BASE}) ---"
    comm -23 "$TMP/before" "$TMP/after" | head -40
    echo "--- only in AFTER (worktree) ---"
    comm -13 "$TMP/before" "$TMP/after" | head -40
    reds=$((reds + 1))
  else
    echo "OK   claim tokens identical: ${path}"
  fi
  # Modality — per-file obligation counts must hold (recommend→require is red).
  # The counter now speaks Rishi (Python → Rishi molt 20260809): compare its
  # before/after counts, each file normalized inside the counter.
  git show "${BASE}:${path}" >"$TMP/before_mod_raw"
  rishi/bin/rishi run tools/fixtures/claim_preserve_modality.rish count "$TMP/before_mod_raw" >"$TMP/mod_before" 2>/dev/null
  rishi/bin/rishi run tools/fixtures/claim_preserve_modality.rish count "$path" >"$TMP/mod_after" 2>/dev/null
  if ! cmp -s "$TMP/mod_before" "$TMP/mod_after"; then
    echo "FAIL modality drift: ${path}"
    diff "$TMP/mod_before" "$TMP/mod_after" | grep '^[<>]' | head
    reds=$((reds + 1))
  fi
  # Wrong beliefs stay visible — silent five→four rewrites are red.
  if grep -Fq 'five remotes' "$TMP/before_raw"; then
    if ! grep -Fq 'five remotes' "$path"; then
      echo "FAIL ${path}: removed historical 'five remotes' — use an erratum line instead"
      reds=$((reds + 1))
    fi
  fi
done <"$TMP/files"

# Pinned digests must not move
pin_check() {
  file=$1
  pattern=$2
  label=$3
  if [ ! -f "$file" ]; then
    echo "FAIL pin home missing: ${file}"
    reds=$((reds + 1))
    return
  fi
  if ! git cat-file -e "${BASE}:${file}" 2>/dev/null; then
    echo "OK   pin home new at ${BASE}: ${file} (skip)"
    return
  fi
  before=$(git show "${BASE}:${file}" | grep -E "$pattern" | head -1 || true)
  after=$(grep -E "$pattern" "$file" | head -1 || true)
  if [ "$before" != "$after" ]; then
    echo "FAIL pinned digest moved (${label}): ${file}"
    echo "  before: ${before}"
    echo "  after:  ${after}"
    reds=$((reds + 1))
  else
    echo "OK   pinned digest held (${label}): ${file}"
  fi
}

pin_check "tools/waymark_derive.rish" 'corpus_digest[[:space:]]*=' "flw corpus"
pin_check "tools/waymark_derive.rish" 'corpus_count_pin[[:space:]]*=' "flw count"
pin_check "linengrow/seva_b0_fold.rye" 'expected_demo_root_hex[[:space:]]*=' "HAWM root"

if [ "$reds" -gt 0 ]; then
  echo "FAIL claim_preserve count=${reds}"
  exit 1
fi
echo "OK   claim_preserve clean — tokens and modality identical; pins held"
exit 0
