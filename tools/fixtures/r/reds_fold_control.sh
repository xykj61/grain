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
    echo '**REDS %5 (`20260101.000004`) -- a booked row whose prose still says the seat is OPEN for a word.** *Repaired:* instances fixed. **BOOKED (`20260101.000004`)** -- the remainder is a seat.'
    echo ''
    echo '**REDS %6 (`20260101.000005`) -- a row marked open in bold.** *Surfaced:* it waits. **OPEN, gated** -- the word is pending.'
    echo ''
    echo '**REDS %7 (`20260101.000006`) -- a closed row wearing its bold marker.** *Repaired:* proven. **CLOSED (`20260101.000006`)** -- on metal.'
    echo ''
    echo '**REDS %8 (`20260101.000007`) -- a second closed row wearing its marker.** *Repaired:* proven. **CLOSED (`20260101.000007`)** -- on metal.'
    echo ''
    echo '**REDS %9 (`20260101.000008`) -- a third closed row wearing its marker.** *Repaired:* proven. **CLOSED (`20260101.000008`)** -- on metal.'
    echo ''
  } > "$pen/t/construction/REDS.md"
  {
    echo '# REDS -- a planted shelf (rows %1, %2)'
    echo ''
    echo '**Folded:** from [`../REDS.md`](../REDS.md).'
    echo ''
    echo '---'
  } > "$pen/t/construction/archive/REDS-planted-rows-1-2.md"
  # The trail the loom writes needs somewhere to land, so the pen carries a recital with a header
  # and no rows -- the shape the real one had on its first day.
  {
    echo '# REDS fold recital -- a planted trail'
    echo ''
    echo '*Folded off the living pin [`../REDS.md`](../REDS.md).*'
  } > "$pen/t/construction/archive/REDS-fold-recital.md"
  cp "$root/tools/fixtures/r/reds_fold.sh" "$pen/t/tools_reds_fold.sh" 2>/dev/null || true
  # The pen mirrors the folded letter room (letter fold, seated 20260828): the fold tool reaches
  # its reanchor sibling by the r/ path the real tree now keeps.
  mkdir -p "$pen/t/tools/fixtures/r"
  cp "$root/tools/fixtures/r/reds_fold.sh" "$pen/t/tools/fixtures/r/reds_fold.sh"
  cp "$root/tools/fixtures/r/reds_fold_reanchor.sh" "$pen/t/tools/fixtures/r/reds_fold_reanchor.sh"
}

run_fold() {
  # $1 shelf, rest rows. Echoes output; returns the tool's exit code. Every elder case below was
  # written before the loom wrote the trail, so this helper supplies a planted clause and a PINNED
  # stamp when the case names neither -- a control that read the wall clock would prove a different
  # thing every minute.
  case " $* " in *" --why "*) ;; *) set -- "$@" --why "the planted fold" ;; esac
  case " $* " in *" --stamp "*) ;; *) set -- "$@" --stamp 20260101.010203 ;; esac
  run_fold_raw "$@"
}

run_fold_raw() {
  # Verbatim, for the cases that prove what a missing option does.
  ( cd "$pen/t" && sh tools/fixtures/r/reds_fold.sh "$@" 2>&1 )
}

recital() { echo "$pen/t/construction/archive/REDS-fold-recital.md"; }
trail_lines() { grep -c 'folded to' "$(recital)" 2>/dev/null || true; }

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
out=$(run_fold construction/archive/REDS-planted-rows-1-2.md 42) && rc=0 || rc=$?
[ "$rc" -ne 0 ] && ok "an absent row refuses" || bad "an absent row refuses"
case "$out" in *row_absent*) ok "the absent-row refusal names itself" ;; *) bad "the absent-row refusal names itself" ;; esac

# --- door B: the marker decides, both directions ---
build_pen
out=$(run_fold construction/archive/REDS-planted-rows-1-2.md 5) && rc=0 || rc=$?
[ "$rc" -eq 0 ] && ok "a BOOKED row folds though its prose carries the bare word OPEN" \
  || bad "a BOOKED row folds though its prose carries the bare word OPEN ($out)"
grep -q 'REDS %5 ' "$pen/t/construction/REDS.md" && bad "the folded BOOKED row leaves the pin" \
  || ok "the folded BOOKED row leaves the pin"

build_pen
out=$(run_fold construction/archive/REDS-planted-rows-1-2.md 6) && rc=0 || rc=$?
[ "$rc" -ne 0 ] && ok "a row marked OPEN in bold refuses" || bad "a row marked OPEN in bold refuses"
case "$out" in *row_open*) ok "the bold-OPEN refusal names itself" ;; *) bad "the bold-OPEN refusal names itself ($out)" ;; esac

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

# --- 6. the trail line: what the fold already knows, written where the trail is read -----------
# WHY THESE CASES EXIST. A fold that lands without its recital line is a fold nobody can follow,
# and `tools/fixtures/r/reds_pin_capacity_scan.sh` counts exactly that as `unrecorded_shelves`. It
# fired twice on `20260830`, so the line moved from a hand into the loom -- and the loom's line is
# only worth having if it says what a hand would have said.

build_pen
out=$(run_fold construction/archive/REDS-planted-rows-1-2.md 7 8 --why "two rows that taught one thing" --stamp 20260101.010203) && rc=0 || rc=$?
[ "$rc" -eq 0 ] && ok "a fold naming its clause succeeds" || bad "a fold naming its clause succeeds ($out)"
case "$out" in *recital_line=written*) ok "the fold reports the trail line written" ;; *) bad "the fold reports the trail line written ($out)" ;; esac
grep -q 'folded to \[`REDS-planted-rows-1-2.md`\](REDS-planted-rows-1-2.md)' "$(recital)" \
  && ok "the trail names the shelf the capacity scan greps for" || bad "the trail names the shelf the capacity scan greps for"
grep -q 'on `20260101.010203`' "$(recital)" && ok "the trail carries the stamp it was given" || bad "the trail carries the stamp it was given"
grep -q 'both \*\*CLOSED\*\*' "$(recital)" && ok "two marked rows read 'both **CLOSED**'" || bad "two marked rows read 'both **CLOSED**'"
grep -q 'Rows %7 and %8 folded' "$(recital)" && ok "two rows read as a pair" || bad "two rows read as a pair"
grep -q 'taught one thing\.\*$' "$(recital)" && ok "the clause closes with the period the hand omitted" || bad "the clause closes with the period the hand omitted"
[ "$(trail_lines)" = 1 ] && ok "one fold writes exactly one trail line" || bad "one fold writes exactly one trail line ($(trail_lines))"

run_fold construction/archive/REDS-planted-rows-1-2.md 9 --why "a second fold." --stamp 20260101.010204 >/dev/null 2>&1 || true
[ "$(trail_lines)" = 2 ] && ok "a second fold appends rather than replaces" || bad "a second fold appends rather than replaces ($(trail_lines))"
grep -c 'second fold\.\.' "$(recital)" | grep -q '^0$' && ok "a clause already ending in a period gains no second one" || bad "a clause already ending in a period gains no second one"

build_pen
run_fold construction/archive/REDS-planted-rows-1-2.md 7 8 9 --why "the range case" --stamp 20260101.010205 >/dev/null 2>&1 || true
grep -q 'Rows %7-%9 folded' "$(recital)" && ok "three consecutive rows compress to a range" || bad "three consecutive rows compress to a range"
grep -q 'each \*\*CLOSED\*\*' "$(recital)" && ok "three marked rows read 'each **CLOSED**'" || bad "three marked rows read 'each **CLOSED**'"

build_pen
run_fold construction/archive/REDS-planted-rows-1-2.md 7 --why "one row" --stamp 20260101.010206 >/dev/null 2>&1 || true
grep -q '^\*Row %7 folded' "$(recital)" && ok "one row reads 'Row' rather than 'Rows'" || bad "one row reads 'Row' rather than 'Rows'"
grep -q '`, \*\*CLOSED\*\* --' "$(recital)" && ok "one row carries the bare status word" || bad "one row carries the bare status word"

build_pen
run_fold construction/archive/REDS-planted-rows-1-2.md 5 7 --why "a booked row beside a closed one" --stamp 20260101.010207 >/dev/null 2>&1 || true
grep -q '\*\*BOOKED\*\* and \*\*CLOSED\*\*' "$(recital)" && ok "a mixed fold names both status words" || bad "a mixed fold names both status words"

build_pen
run_fold construction/archive/REDS-planted-rows-1-2.md 1 2 --why "rows carrying no bold marker" --stamp 20260101.010208 >/dev/null 2>&1 || true
grep -q 'on `20260101.010208` -- rows carrying no bold marker' "$(recital)" \
  && ok "an unmarked row drops the status clause rather than inferring one" \
  || bad "an unmarked row drops the status clause rather than inferring one"

build_pen
out=$(run_fold_raw construction/archive/REDS-planted-rows-1-2.md 7) && rc=0 || rc=$?
[ "$rc" -ne 0 ] && ok "a fold naming no clause refuses" || bad "a fold naming no clause refuses"
case "$out" in *why_absent*) ok "the missing-clause refusal names itself" ;; *) bad "the missing-clause refusal names itself ($out)" ;; esac
grep -q 'REDS %7 ' "$pen/t/construction/REDS.md" && ok "a clauseless fold leaves the pin untouched" || bad "a clauseless fold leaves the pin untouched"
[ "$(trail_lines)" = 0 ] && ok "a refused fold writes no trail line" || bad "a refused fold writes no trail line"

build_pen
out=$(run_fold_raw construction/archive/REDS-planted-rows-1-2.md 7 --why "") && rc=0 || rc=$?
[ "$rc" -ne 0 ] && ok "an empty clause refuses" || bad "an empty clause refuses"

build_pen
long=$(awk 'BEGIN{ s=""; while (length(s) < 1025) s = s "x"; print s }')
out=$(run_fold construction/archive/REDS-planted-rows-1-2.md 7 --why "$long") && rc=0 || rc=$?
[ "$rc" -ne 0 ] && ok "a clause past the bound refuses" || bad "a clause past the bound refuses"
case "$out" in *why_too_long*) ok "the clause-bound refusal names itself" ;; *) bad "the clause-bound refusal names itself ($out)" ;; esac

# The bound from the other side, so the refusal can never be mistaken for a bypass.
build_pen
atbound=$(awk 'BEGIN{ s=""; while (length(s) < 1024) s = s "x"; print s }')
out=$(run_fold construction/archive/REDS-planted-rows-1-2.md 7 --why "$atbound") && rc=0 || rc=$?
[ "$rc" -eq 0 ] && ok "a clause exactly at the bound is welcomed" || bad "a clause exactly at the bound is welcomed ($out)"

build_pen
out=$(run_fold construction/archive/REDS-planted-rows-1-2.md 7 --why "$(printf 'a curly quote \342\200\231 rides in')") && rc=0 || rc=$?
[ "$rc" -ne 0 ] && ok "a clause carrying a byte outside printable ASCII refuses" || bad "a clause carrying a byte outside printable ASCII refuses"
case "$out" in *why_non_ascii*) ok "the ASCII refusal names itself" ;; *) bad "the ASCII refusal names itself ($out)" ;; esac

build_pen
out=$(run_fold construction/archive/REDS-planted-rows-1-2.md 7 --why "a clause" --stamp 2026) && rc=0 || rc=$?
[ "$rc" -ne 0 ] && ok "a stamp of the wrong shape refuses" || bad "a stamp of the wrong shape refuses"
case "$out" in *stamp_shape*) ok "the stamp refusal names itself" ;; *) bad "the stamp refusal names itself ($out)" ;; esac

build_pen
rm -f "$(recital)"
out=$(run_fold construction/archive/REDS-planted-rows-1-2.md 7 --why "a clause") && rc=0 || rc=$?
[ "$rc" -ne 0 ] && ok "a missing recital refuses" || bad "a missing recital refuses"
case "$out" in *recital_absent*) ok "the missing-recital refusal names itself" ;; *) bad "the missing-recital refusal names itself ($out)" ;; esac
grep -q 'REDS %7 ' "$pen/t/construction/REDS.md" && ok "a fold refused for its trail leaves the pin untouched" || bad "a fold refused for its trail leaves the pin untouched"

build_pen
out=$(run_fold construction/archive/REDS-planted-rows-1-2.md 7 --wat now) && rc=0 || rc=$?
[ "$rc" -ne 0 ] && ok "an option the tool does not know refuses" || bad "an option the tool does not know refuses"
case "$out" in *unknown_option*) ok "the unknown-option refusal names itself" ;; *) bad "the unknown-option refusal names itself ($out)" ;; esac

# The clock, read rather than pinned: shape only, since the value moves every second.
build_pen
out=$(run_fold_raw construction/archive/REDS-planted-rows-1-2.md 7 --why "the clock is read") && rc=0 || rc=$?
[ "$rc" -eq 0 ] && ok "a fold naming no stamp reads the one clock" || bad "a fold naming no stamp reads the one clock ($out)"
echo "$out" | grep -qE '^stamp=[0-9]{8}\.[0-9]{6}$' && ok "the read stamp carries the one-clock shape" || bad "the read stamp carries the one-clock shape"

echo "pass=$pass"
echo "fail=$fail"
if [ "$fail" -eq 0 ]; then echo "verdict=ok"; else echo "verdict=behavior_missed"; exit 1; fi
