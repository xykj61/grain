#!/bin/sh
# tools/fixtures/r/reds_pin_capacity_control.sh -- prove the capacity meter on real files.
#
# WHAT THIS IS FOR. `reds_pin_capacity_scan.sh` reports a deadlock and gates a broken trail. A
# refusal proven only in the passing direction cannot be told from a bypass, so every refusal here
# is planted and then removed, and every welcome is asserted as hard as every refusal. The pen holds
# real markdown files in a throwaway directory; nothing here reads the tree's own ledger.
#
#   sh tools/fixtures/r/reds_pin_capacity_control.sh
#
# Exit 0 when every case behaves, 1 otherwise. Prints one line per case and a verdict.
set -eu

SCAN=tools/fixtures/r/reds_pin_capacity_scan.sh
[ -f "$SCAN" ] || { echo "control: run from the repository root; $SCAN is not here" >&2; exit 2; }
ROOT=$(pwd)

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM

fails=0
ok=0
say() {
  if [ "$2" = "yes" ]; then ok=$((ok + 1)); else fails=$((fails + 1)); fi
  echo "case: $1 = $2"
}

# A row of a named size, open or closed, written the way the ledger writes one.
row() { # row <n> <open|closed> <bytes>
  printf '**REDS %%%s (`20260829.000000`) -- a planted row.** *What went wrong:* %s *What it taught:* %s\n' \
    "$1" "$(head -c "$3" < /dev/zero | tr '\0' 'x')" \
    "$([ "$2" = open ] && echo 'This row stands **OPEN** on a plant.' || echo 'This row reads **CLOSED**.')"
}

build() { # build <dir> <n-open-pin-rows> <n-closed-pin-rows> <row-bytes>
  d=$1; nopen=$2; nclosed=$3; bytes=$4
  rm -rf "$d"; mkdir -p "$d"
  { echo '# REDS -- a pen ledger'; echo; } > "$d/REDS.md"
  i=0
  while [ "$i" -lt "$nopen" ]; do i=$((i + 1)); row "$i" open "$bytes" >> "$d/REDS.md"; done
  j=0
  while [ "$j" -lt "$nclosed" ]; do j=$((j + 1)); row $((100 + j)) closed "$bytes" >> "$d/REDS.md"; done
  : > "$d/recital.md"
}

shelf() { # shelf <dir> <rows-name> <n> <open|closed>
  f="$2/REDS-planted-rows-$3.md"
  { echo '# REDS -- a folded row'; echo; row "$3" "$4" 40; } > "$f"
  echo "REDS-planted-rows-$3.md"
}

recite() { echo "*Row %$2 folded to [\`REDS-planted-rows-$2.md\`](REDS-planted-rows-$2.md).*" >> "$1/recital.md"; }

run_scan() { # run_scan <dir> [extra env assignments...]
  d=$1; shift
  ( cd "$ROOT" && env REDS_PIN="$d/REDS.md" REDS_ARCHIVE_GLOB="$d/REDS-*rows-*.md" \
      REDS_RECITAL="$d/recital.md" "$@" sh "$SCAN" 2>&1 ) || true
}
run_status() { # like run_scan, but yields the exit code
  # `cmd && s=0 || s=$?` rather than `( cmd ); echo $?` -- under `set -e` a subshell that exits
  # non-zero aborts the command substitution BEFORE the echo runs, so every expected refusal came
  # back as an empty string and read as a pass. Three cases read `no` for that reason on this
  # control's first run, and the fault was in the harness rather than in the scan (kin: REDS %311,
  # where a wall read a needle its own harness supplied). A `&&`/`||` list suspends `set -e`.
  d=$1; shift
  if ( cd "$ROOT" && env REDS_PIN="$d/REDS.md" REDS_ARCHIVE_GLOB="$d/REDS-*rows-*.md" \
      REDS_RECITAL="$d/recital.md" "$@" sh "$SCAN" >/dev/null 2>&1 ); then s=0; else s=$?; fi
  echo "$s"
}

has() { case "$1" in *"$2"*) echo yes ;; *) echo no ;; esac; }

# ---- 1. a clean pen walks free ---------------------------------------------------------------
build "$pen/a" 2 1 100
out=$(run_scan "$pen/a" REDS_PIN_BOUND=100000)
say "clean pen reads ok"                    "$(has "$out" 'verdict=ok')"
say "clean pen exits 0"                     "$([ "$(run_status "$pen/a" REDS_PIN_BOUND=100000)" = 0 ] && echo yes || echo no)"
say "clean pen is not deadlocked"           "$(has "$out" 'pin_deadlocked=0')"
say "clean pen counts three rows"           "$(has "$out" 'pin_rows=3')"
say "clean pen counts two open"             "$(has "$out" 'pin_open_rows=2')"
say "clean pen counts one foldable"         "$(has "$out" 'pin_foldable_rows=1')"

# ---- 2. the deadlock, from both sides ---------------------------------------------------------
# All rows open AND no headroom: the state the living pin was in on 20260829.
build "$pen/b" 3 0 200
bytes=$(wc -c < "$pen/b/REDS.md" | tr -d ' ')
out=$(run_scan "$pen/b" REDS_PIN_BOUND="$bytes")
say "no headroom + no foldable row deadlocks" "$(has "$out" 'pin_deadlocked=1')"
say "the deadlock names itself in a detail"   "$(has "$out" 'detail: pin_deadlocked')"
say "a deadlocked pin fits zero rows"         "$(has "$out" 'rows_that_fit=0')"
say "a deadlocked pin still exits 0"          "$([ "$(run_status "$pen/b" REDS_PIN_BOUND="$bytes")" = 0 ] && echo yes || echo no)"

# The same pin with one foldable row is NOT a deadlock -- the fold tool has a lawful move.
build "$pen/c" 3 1 200
bytes=$(wc -c < "$pen/c/REDS.md" | tr -d ' ')
out=$(run_scan "$pen/c" REDS_PIN_BOUND="$bytes")
say "a foldable row breaks the deadlock"      "$(has "$out" 'pin_deadlocked=0')"

# The same all-open pin with headroom is NOT a deadlock -- it is simply a busy ledger.
build "$pen/d" 3 0 200
bytes=$(wc -c < "$pen/d/REDS.md" | tr -d ' ')
out=$(run_scan "$pen/d" REDS_PIN_BOUND=$((bytes + 100000)))
say "headroom breaks the deadlock"            "$(has "$out" 'pin_deadlocked=0')"
say "headroom fits more than zero rows"       "$([ "$(echo "$out" | sed -n 's/^rows_that_fit=//p')" -gt 0 ] && echo yes || echo no)"

# ---- 3. the recital trail, gated at zero, proven both ways ------------------------------------
build "$pen/e" 1 0 100
shelf "$pen/e" "$pen/e" 55 closed >/dev/null
recite "$pen/e" 55
out=$(run_scan "$pen/e" REDS_PIN_BOUND=100000 UNRECORDED_SHELVES_CEILING=0)
say "a recited shelf on disk is clean"        "$(has "$out" 'verdict=ok')"
say "a recited shelf leaves no phantom"       "$(has "$out" 'phantom_recital_shelves=0')"

# Plant: a recital line whose shelf is not on disk.
recite "$pen/e" 66
out=$(run_scan "$pen/e" REDS_PIN_BOUND=100000 UNRECORDED_SHELVES_CEILING=0)
say "a phantom recital line refuses"          "$(has "$out" 'verdict=recital_trail_broken')"
say "the phantom is named in a detail"        "$(has "$out" 'detail: phantom_recital')"
say "a phantom recital line exits 1"          "$([ "$(run_status "$pen/e" REDS_PIN_BOUND=100000 UNRECORDED_SHELVES_CEILING=0)" = 1 ] && echo yes || echo no)"

# Remove the plant: the same bytes read green again, so the refusal is the plant's and not the pen's.
grep -v 'rows-66' "$pen/e/recital.md" > "$pen/e/recital.tmp" && cat "$pen/e/recital.tmp" > "$pen/e/recital.md"
out=$(run_scan "$pen/e" REDS_PIN_BOUND=100000 UNRECORDED_SHELVES_CEILING=0)
say "removing the phantom returns green"      "$(has "$out" 'verdict=ok')"

# ---- 4. unrecorded shelves, a ratchet proven from both sides -----------------------------------
shelf "$pen/e" "$pen/e" 77 closed >/dev/null   # on disk, never recited
out=$(run_scan "$pen/e" REDS_PIN_BOUND=100000 UNRECORDED_SHELVES_CEILING=1)
say "one unrecorded shelf at a ceiling of 1"  "$(has "$out" 'verdict=ok')"
say "the unrecorded shelf is counted"         "$(has "$out" 'unrecorded_shelves=1')"
out=$(run_scan "$pen/e" REDS_PIN_BOUND=100000 UNRECORDED_SHELVES_CEILING=0)
say "one unrecorded shelf past a ceiling of 0" "$(has "$out" 'verdict=unrecorded_shelves_above_ceiling')"
say "past the unrecorded ceiling exits 1"     "$([ "$(run_status "$pen/e" REDS_PIN_BOUND=100000 UNRECORDED_SHELVES_CEILING=0)" = 1 ] && echo yes || echo no)"

# ---- 5. a live red on a shelf, the ratchet this lap was written for ----------------------------
build "$pen/f" 1 0 100
shelf "$pen/f" "$pen/f" 88 open >/dev/null
recite "$pen/f" 88
out=$(run_scan "$pen/f" REDS_PIN_BOUND=100000 SHELF_OPEN_ROWS_CEILING=1)
say "an open shelf row is counted"            "$(has "$out" 'shelf_open_rows=1')"
say "it names the exiled row"                 "$(has "$out" 'detail: shelf_open %88')"
say "at a ceiling of 1 it walks free"         "$(has "$out" 'verdict=ok')"
out=$(run_scan "$pen/f" REDS_PIN_BOUND=100000 SHELF_OPEN_ROWS_CEILING=0)
say "past a ceiling of 0 it refuses"          "$(has "$out" 'verdict=shelf_open_rows_above_ceiling')"
say "past the shelf-open ceiling exits 1"     "$([ "$(run_status "$pen/f" REDS_PIN_BOUND=100000 SHELF_OPEN_ROWS_CEILING=0)" = 1 ] && echo yes || echo no)"

# A CLOSED row on a shelf is the ordinary case and must never be counted.
build "$pen/g" 1 0 100
shelf "$pen/g" "$pen/g" 99 closed >/dev/null
recite "$pen/g" 99
out=$(run_scan "$pen/g" REDS_PIN_BOUND=100000 SHELF_OPEN_ROWS_CEILING=0)
say "a closed shelf row counts zero"          "$(has "$out" 'shelf_open_rows=0')"
say "a closed shelf row walks free"           "$(has "$out" 'verdict=ok')"

# ---- 5b. the one gated cell: over the bound WITH a lawful fold (REDS %517) ----------------------
# The 2x2 this scan crosses -- headroom against foldability -- with every neighbouring cell shown
# free, since a refusal proven only in the failing direction cannot be told from a wall that always
# refuses. One open row and one closed row, so a lawful fold always exists except where stated.
build "$pen/h" 1 1 100
size=$(wc -c < "$pen/h/REDS.md" | tr -d ' ')
out=$(run_scan "$pen/h" REDS_PIN_BOUND=$((size - 10)))
say "over bound + foldable refuses"           "$(has "$out" 'verdict=over_bound_foldable')"
say "the refusal names the remedy"            "$(has "$out" 'reds_fold.sh')"
say "over bound + foldable exits 1"           "$([ "$(run_status "$pen/h" REDS_PIN_BOUND=$((size - 10)))" = 1 ] && echo yes || echo no)"
out=$(run_scan "$pen/h" REDS_PIN_BOUND="$size")
say "AT the bound + foldable walks free"      "$(has "$out" 'verdict=ok')"
out=$(run_scan "$pen/h" REDS_PIN_BOUND=$((size + 500)))
say "under bound + foldable walks free"       "$(has "$out" 'verdict=ok')"

# The cell beside it: over the bound with NOTHING foldable is the state only a bound raise resolves,
# and raising a bound is Keaton's word -- so it is reported and never gated. This is the scan
# header's own argument, asserted rather than promised.
build "$pen/i" 2 0 100
size=$(wc -c < "$pen/i/REDS.md" | tr -d ' ')
out=$(run_scan "$pen/i" REDS_PIN_BOUND=$((size - 10)))
say "over bound + none foldable walks free"   "$(has "$out" 'verdict=ok')"
say "and is still named a deadlock"           "$(has "$out" 'pin_deadlocked=1')"
say "over bound + none foldable exits 0"      "$([ "$(run_status "$pen/i" REDS_PIN_BOUND=$((size - 10)))" = 0 ] && echo yes || echo no)"

# ---- 5c. who holds an open row (added 20260910) -------------------------------------------------
# The reading is a proxy over a row's own text, so it is proven from both sides on planted rows: a
# row naming Keaton counts, a row naming a custody gate counts, an ordinary open row does not, and
# a CLOSED row naming Keaton counts for nothing at all, since a closed row holds nobody up.
held_row() { # held_row <n> <open|closed> <phrase>
  printf '**REDS %%%s (`20260829.000000`) -- a planted row.** *What went wrong:* xxx *Standing:* %s. This row reads **%s**.\n' \
    "$1" "$3" "$([ "$2" = open ] && echo OPEN || echo CLOSED)"
}
mkdir -p "$pen/j"; : > "$pen/j/recital.md"
{ echo '# REDS -- a pen ledger'; echo
  held_row 1 open "the repair wants Keaton's word"
  held_row 2 open "held behind custody gate %1"
  held_row 3 open "the sweep is a lap's own"
  held_row 4 closed "this one wanted Keaton's word once"
} > "$pen/j/REDS.md"
out=$(run_scan "$pen/j" REDS_PIN_BOUND=100000)
say "four rows, three open"                   "$(has "$out" 'pin_open_rows=3')"
say "two of the three read held"              "$(has "$out" 'pin_held_rows=2')"
say "the Keaton row is named"                 "$(has "$out" 'detail: pin_held %1')"
say "the custody row is named"                "$(has "$out" 'detail: pin_held %2')"
say "an ordinary open row is not held"        "$([ "$(has "$out" 'detail: pin_held %3')" = no ] && echo yes || echo no)"
say "a closed row is never held"              "$([ "$(has "$out" 'detail: pin_held %4')" = no ] && echo yes || echo no)"
say "held rows gate nothing"                  "$(has "$out" 'verdict=ok')"
# And a pen with no held row reads zero rather than silence, so an empty reading is legible.
out=$(run_scan "$pen/a" REDS_PIN_BOUND=100000)
say "a pen with no held row reads zero"       "$(has "$out" 'pin_held_rows=0')"
say "a pen with no held row is all unheld"   "$(has "$out" 'pin_unheld_rows=2')"

# ---- 5c-2. the complement, on the mixed pen -----------------------------------------------------
# Three open rows, two of them held: the unheld reading must be the third and nothing else. Derived
# from PIN_OPEN - PIN_HELD, so this leg is what proves the arithmetic rather than the prose.
out=$(run_scan "$pen/j" REDS_PIN_BOUND=100000)
say "the mixed pen counts one unheld"         "$(has "$out" 'pin_unheld_rows=1')"
say "unheld is the complement of held"        "$([ "$(( $(echo "$out" | sed -n 's/^pin_open_rows=//p') - $(echo "$out" | sed -n 's/^pin_held_rows=//p') ))" = "$(echo "$out" | sed -n 's/^pin_unheld_rows=//p')" ] && echo yes || echo no)"

# ---- 5d. the deadlock names its doors ----------------------------------------------------------
# The foldable cell has named its remedy since %517; the deadlocked cell named none, which is what
# sent five ships in one morning to re-derive the same three options. Proven from both sides: the
# doors line rides with the deadlock and stays away from every other state.
out=$(run_scan "$pen/b" REDS_PIN_BOUND="$(wc -c < "$pen/b/REDS.md" | tr -d ' ')")
say "the deadlock names its doors"            "$(has "$out" 'detail: pin_deadlock_doors')"
say "the doors line names the recital"        "$(has "$out" 'REDS-fold-recital.md')"
say "the doors line names the fleet's door"  "$(has "$out" "the FIRST door is the fleet's own")"
# Read from the DOORS line alone rather than from the output as a whole: the pin_unheld detail
# carries the same count one line above, so a needle taken from the whole stream stayed green
# against a doors line reverted to its elder wording -- the leg proved nothing it claimed.
doors=$(echo "$out" | sed -n 's/^detail: pin_deadlock_doors //p')
say "the doors line carries the count"        "$(has "$doors" '3 of 3 open rows name no hand outside the loop')"
say "a deadlock names its unheld rows"        "$(has "$out" 'detail: pin_unheld')"

# An all-held deadlock reads zero unheld, so the message stops promising a door the fleet lacks.
mkdir -p "$pen/k"
{
  echo '# REDS -- a pen ledger'; echo
  held_row 1 open "the repair wants Keaton's word"
  held_row 2 open "held behind custody gate %1"
} > "$pen/k/REDS.md"
: > "$pen/k/recital.md"
out=$(run_scan "$pen/k" REDS_PIN_BOUND="$(wc -c < "$pen/k/REDS.md" | tr -d ' ')")
say "an all-held pin deadlocks"               "$(has "$out" 'pin_deadlocked=1')"
say "an all-held deadlock reads zero unheld"  "$(has "$out" 'pin_unheld_rows=0')"
say "and still names the three held doors"    "$(has "$out" "each is Keaton's word")"
out=$(run_scan "$pen/a" REDS_PIN_BOUND=100000)
say "a healthy pin names no doors"            "$([ "$(has "$out" 'detail: pin_deadlock_doors')" = no ] && echo yes || echo no)"

# ---- 6. misuse refuses rather than guessing ----------------------------------------------------
if ( cd "$ROOT" && env REDS_PIN="$pen/absent/REDS.md" sh "$SCAN" >/dev/null 2>&1 ); then code=0; else code=$?; fi
say "an absent pin exits 2"                   "$([ "$code" = 2 ] && echo yes || echo no)"

echo "cases_ok=$ok"
echo "cases_failed=$fails"
if [ "$fails" -gt 0 ]; then echo "control_verdict=behaviors_changed"; exit 1; fi
echo "control_verdict=ok"
