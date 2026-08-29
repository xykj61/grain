#!/bin/sh
# tools/fixtures/r/reds_fold_control.sh -- prove the fold loom on planted trees, both directions.
#
# WHY BOTH DIRECTIONS. A refusal proven only in the passing direction cannot be told from a bypass,
# which is why every guard in this tree is shown refusing and welcoming (REDS %240's own lesson).
# Each case below builds a real pin and a real shelf in a throwaway pen, runs the loom, and reads
# what it did rather than what it said.
#
#   sh tools/fixtures/r/reds_fold_control.sh
#
# Prints one line per behavior and a verdict. Exits non-zero if any behavior misses.
set -eu

root=$(pwd)
pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM

pass=0
fail=0
note() { echo "  $1"; }
ok()   { pass=$((pass + 1)); note "ok   $1"; }
bad()  { fail=$((fail + 1)); note "MISS $1"; }

# A pen holds a pin with four rows and a shelf with a header, the shapes the real ledger uses.
build_pen() {
  rm -rf "$pen/t"
  mkdir -p "$pen/t/construction/archive"
  {
    echo '# REDS'
    echo ''
    echo '**Rows: 4**'
    echo ''
    echo '**REDS %1 (`20260101.000000`) -- a closed row with a root link.** *Repaired:* see [the tool](../tools/l/a.rish) and the shelf [b](archive/REDS-b-rows-2.md).'
    echo ''
    echo '**REDS %2 (`20260101.000001`) -- a closed row with no links at all.** *Repaired:* nothing to follow.'
    echo ''
    echo '**REDS %3 (`20260101.000002`) -- a row that is still live.** *Surfaced:* it waits. OPEN, GATE.'
    echo ''
    echo '**REDS %4 (`20260101.000003`) -- a closed row naming a bare path `../tools/l/b.rish` in prose.** *Repaired:* the words stand.'
    echo ''
  } > "$pen/t/construction/REDS.md"
  {
    echo '# REDS -- a planted shelf (rows %1, %2)'
    echo ''
    echo '**Folded:** from [`../REDS.md`](../REDS.md).'
    echo ''
    echo '---'
  } > "$pen/t/construction/archive/REDS-planted-rows-1-2.md"
  cp "$root/tools/fixtures/r/reds_fold.sh" "$pen/t/tools_reds_fold.sh" 2>/dev/null || true
  # The pen mirrors the folded letter room (letter fold, seated 20260828): the fold tool reaches
  # its reanchor sibling by the r/ path the real tree now keeps.
  mkdir -p "$pen/t/tools/fixtures/r"
  cp "$root/tools/fixtures/r/reds_fold.sh" "$pen/t/tools/fixtures/r/reds_fold.sh"
  cp "$root/tools/fixtures/r/reds_fold_reanchor.sh" "$pen/t/tools/fixtures/r/reds_fold_reanchor.sh"
}

run_fold() {
  # $1 shelf, rest rows. Echoes output; returns the tool's exit code.
  ( cd "$pen/t" && sh tools/fixtures/r/reds_fold.sh "$@" 2>&1 )
}

echo "reds-fold-control: the loom, proven on planted trees"

# --- 1. the welcome: two closed rows move, links re-anchored, pin loses them ---
build_pen
out=$(run_fold construction/archive/REDS-planted-rows-1-2.md 1 2) && rc=0 || rc=$?
[ "$rc" -eq 0 ] && ok "a clean fold succeeds" || bad "a clean fold succeeds (rc=$rc: $out)"
shelf="$pen/t/construction/archive/REDS-planted-rows-1-2.md"
pin="$pen/t/construction/REDS.md"
grep -q '](\.\./\.\./tools/l/a\.rish)' "$shelf" && ok "a ](../ link is re-anchored to ](../../" || bad "a ](../ link is re-anchored to ](../../"
grep -q '](REDS-b-rows-2\.md)' "$shelf" && ok "a ](archive/ link drops the directory" || bad "a ](archive/ link drops the directory"
grep -q '](\.\./REDS\.md)' "$shelf" && ok "the shelf header's ](../REDS.md) is left alone" || bad "the shelf header's ](../REDS.md) is left alone"
grep -q 'REDS %1 ' "$shelf" && grep -q 'REDS %2 ' "$shelf" && ok "both rows reach the shelf" || bad "both rows reach the shelf"
grep -q 'REDS %1 ' "$pin" && bad "the moved rows leave the pin" || ok "the moved rows leave the pin"
grep -q 'REDS %3 ' "$pin" && grep -q 'REDS %4 ' "$pin" && ok "the unmoved rows stay on the pin" || bad "the unmoved rows stay on the pin"
grep -q '^$' "$pin" && ok "the pin keeps its blank-line shape" || bad "the pin keeps its blank-line shape"

# --- 2. prose is not a link ---
build_pen
run_fold construction/archive/REDS-planted-rows-1-2.md 4 >/dev/null 2>&1 || true
grep -q '`\.\./tools/l/b\.rish`' "$shelf" && ok "a bare path in prose is left byte-identical" || bad "a bare path in prose is left byte-identical"

# --- 3. the refusals ---
build_pen
out=$(run_fold construction/archive/REDS-planted-rows-1-2.md 3) && rc=0 || rc=$?
[ "$rc" -ne 0 ] && ok "an OPEN row refuses" || bad "an OPEN row refuses"
case "$out" in *row_open*) ok "the OPEN refusal names itself" ;; *) bad "the OPEN refusal names itself ($out)" ;; esac
grep -q 'REDS %3 ' "$pin" && ok "a refused fold leaves the pin untouched" || bad "a refused fold leaves the pin untouched"

build_pen
out=$(run_fold construction/archive/REDS-planted-rows-1-2.md 9) && rc=0 || rc=$?
[ "$rc" -ne 0 ] && ok "an absent row refuses" || bad "an absent row refuses"
case "$out" in *row_absent*) ok "the absent-row refusal names itself" ;; *) bad "the absent-row refusal names itself" ;; esac

build_pen
mkdir -p "$pen/t/construction/archive"
cp "$shelf" "$pen/t/construction/archive/REDS-planted-row-1.md"
out=$(run_fold construction/archive/REDS-planted-row-1.md 1) && rc=0 || rc=$?
[ "$rc" -ne 0 ] && ok "a shelf without 'rows-' refuses" || bad "a shelf without 'rows-' refuses"
case "$out" in *shelf_unnamed*) ok "the shelf-name refusal names itself" ;; *) bad "the shelf-name refusal names itself" ;; esac

build_pen
out=$(run_fold construction/archive/REDS-absent-rows-9.md 1) && rc=0 || rc=$?
[ "$rc" -ne 0 ] && ok "a missing shelf refuses" || bad "a missing shelf refuses"
case "$out" in *shelf_absent*) ok "the missing-shelf refusal names itself" ;; *) bad "the missing-shelf refusal names itself" ;; esac

build_pen
out=$(run_fold construction/archive/REDS-planted-rows-1-2.md 1 2 3 4 5 6 7 8 9 10 11 12 13) && rc=0 || rc=$?
[ "$rc" -ne 0 ] && ok "past the row bound refuses" || bad "past the row bound refuses"
case "$out" in *too_many_rows*) ok "the bound refusal names itself" ;; *) bad "the bound refusal names itself" ;; esac

# The bound proven from both sides: twelve is welcomed as far as the row check, thirteen never is.
build_pen
out=$(run_fold construction/archive/REDS-planted-rows-1-2.md 1 2 5 6 7 8 9 10 11 12 13 14) && rc=0 || rc=$?
case "$out" in *too_many_rows*) bad "twelve rows pass the bound" ;; *) ok "twelve rows pass the bound (refused later, on the absent row)" ;; esac

# --- 4. the mask guard ---
printf 'a row carrying @@REDS_PIN_SELF@@ already\n' > "$pen/masked.txt"
out=$(sh "$root/tools/fixtures/r/reds_fold_reanchor.sh" < "$pen/masked.txt" 2>&1) && rc=0 || rc=$?
[ "$rc" -ne 0 ] && ok "the re-anchor mask collision refuses" || bad "the re-anchor mask collision refuses"

# --- 5. idempotence: a shelf folded twice does not double-anchor ---
build_pen
run_fold construction/archive/REDS-planted-rows-1-2.md 1 >/dev/null 2>&1 || true
grep -q '](\.\./\.\./\.\./' "$shelf" 2>/dev/null && bad "one fold never produces a ](../../../ link" || ok "one fold never produces a ](../../../ link"

echo "pass=$pass"
echo "fail=$fail"
if [ "$fail" -eq 0 ]; then echo "verdict=ok"; else echo "verdict=behavior_missed"; exit 1; fi
