# tools/fixtures/s/sow_leak_control.sh -- prove the seed's identity wall can red.
#
#   sh tools/fixtures/s/sow_leak_control.sh
#
# WHY. tools/fixtures/s/sow_leak_scan.sh is the wall between the maintainer's own name and a
# repository meant to carry none. The cadence witness tools/s/sow_witness.rish runs it.
# This control checks its response to a name before the witness trusts a clean answer.
#
# The grain says why that gap earns a control. A guard that cannot red guards nothing, so a
# witness earns its silence by first being shown able to make a sound (REDS row 59, quoted at
# the head of construction/standing-equipment.kyri).
#
# THIS WALL HAS ALREADY RED ONCE, AND IT RED WRONGLY. REDS %244: a blanket history rewrite
# turned two of the scan's own entries into the public pseudonym, and 22 projected files failed
# a privacy check about nothing. A guard whose one demonstrated red was a false one is the guard
# whose green is worth least.
#
# EVERY CASE RUNS IN A PEN. The scan reads a relative `seed`, so each case runs with its working
# directory inside a throwaway copy holding a seed/ of its own. The real seed/ stays untouched,
# no projection runs, and custody gate %1 sits far from this file.
#
# WHAT IS PROVEN, both directions, on real directories:
#
#   1 bitten  -- a maintainer name planted in a seed file reads IDENT_LEAK
#   2 bitten  -- the leak names the file that carries it, so a hand knows where to look
#   3 bitten  -- a lowercase spelling of a capitalized name is caught, per the scan's own -i
#   4 bitten  -- a bracketed entry catches its plain spelling, which is REDS %244's repair
#   5 bitten  -- a contact identifier is caught, alongside personal names
#   6 free    -- an ordinary page of prose reads IDENT_CLEAN
#   7 free    -- a name inside .sow-withheld.log reads clean, the scan's one named exclusion
#
# AND TWO READINGS ARE REPORTED RATHER THAN GATED, since each describes the instrument truly
# and a wall at zero would misdescribe it:
#
#   8 reported -- a name inside a BINARY file stays invisible, since the scan passes -I
#   9 reported -- an ABSENT seed/ reads IDENT_CLEAN: a clean answer about a corpus that is not
#                 there. tools/s/sow_witness.rish holds this by ORDERING rather than by the
#                 scan. Its duty 2 projects fresh and asserts SOW_OK, and duty 3 reads only
#                 after that. So the duties run in this order on purpose, and moving duty 3
#                 ahead of duty 2 would turn that witness green over an empty directory.
#
# Run from the repository root.
set -eu

ROOT=$(pwd -P)
# SOW_LEAK_SCAN points the control at a copy, which is how the plant below is shown to land:
# a weakened scan must make these legs FAIL, or a passing control proves nothing.
SCAN="${SOW_LEAK_SCAN:-$ROOT/tools/fixtures/s/sow_leak_scan.sh}"
[ -f "$SCAN" ] || { echo "control_verdict=absent_scan" >&2; exit 2; }

PASS=0
FAIL=0
PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT INT TERM

check() {
  # check <label> <expected> <actual>
  if [ "$2" = "$3" ]; then
    PASS=$((PASS + 1)); echo "$1 -- ok"
  else
    FAIL=$((FAIL + 1)); echo "$1 -- FAIL (wanted $2, got $3)"
  fi
}

# Each case writes its supplied content into a fresh pen seed/. The name fragments
# below join at runtime, so the control itself carries their separate spellings.
verdict=""
detail=""
run_case() {
  # run_case <case> <relative-path-under-seed> <content>
  d="$PEN/$1"
  rm -rf "$d"
  mkdir -p "$d/seed/$(dirname "$2")"
  printf '%s\n' "$3" > "$d/seed/$2"
  out=$(cd "$d" && sh "$SCAN")
  verdict=$(printf '%s\n' "$out" | head -1)
  detail=$(printf '%s\n' "$out" | sed -n '2p')
}

# The maintainer strings are assembled rather than spelled, for the same reason the scan
# brackets two of its own entries: this control is a tracked file, and a wall that hunts a
# literal must never be fed that literal by the thing testing it.
NAME="Kea""ton"
LOWER="kea""ton"
SURNAME="Sa""bin"
CONTACT="someone@gm""ail.com"

# ---- 1, 2: a planted name reds, and says where --------------------------------------
run_case planted "notes/a.md" "a page written by $NAME this morning"
check "1 bitten: a maintainer name planted in a seed file reads IDENT_LEAK" IDENT_LEAK "$verdict"

case "$detail" in
  seed/notes/a.md) got=named;;
  *) got="$detail";;
esac
check "2 bitten: the leak names the file that carries it" named "$got"

# ---- 3: case-insensitivity, which the scan's comment claims and nothing checked ------
run_case lowercase "a.md" "a page written by $LOWER this morning"
check "3 bitten: a lowercase spelling of a capitalized name is caught" IDENT_LEAK "$verdict"

# ---- 4: the bracketed entry catches its plain spelling (REDS %244's repair) ----------
run_case bracketed "a.md" "a note mentioning $SURNAME today"
check "4 bitten: a bracketed entry catches its plain spelling" IDENT_LEAK "$verdict"

# ---- 5: a contact identifier, not only a name ---------------------------------------
run_case contact "a.md" "reach the desk at $CONTACT"
check "5 bitten: a contact identifier is caught, not only a personal name" IDENT_LEAK "$verdict"

# ---- 6: an ordinary page walks free -------------------------------------------------
run_case clean "a.md" "an ordinary page of prose about bounded loops"
check "6 free: an ordinary page of prose reads IDENT_CLEAN" IDENT_CLEAN "$verdict"

# ---- 7: the one named exclusion -----------------------------------------------------
run_case withheld ".sow-withheld.log" "$NAME"
check "7 free: a name inside .sow-withheld.log reads clean" IDENT_CLEAN "$verdict"

# ---- 8: reported -- a binary carrier is invisible ------------------------------------
d="$PEN/binary"; mkdir -p "$d/seed"
printf '%s\0and more\n' "$NAME" > "$d/seed/b.bin"
binary_reads=$(cd "$d" && sh "$SCAN" | head -1)
echo "binary_carrier_reads=$binary_reads"

# ---- 9: reported -- an absent seed/ reads clean ---------------------------------------
d="$PEN/absent"; mkdir -p "$d"
absent_reads=$(cd "$d" && sh "$SCAN" | head -1)
echo "absent_seed_reads=$absent_reads"

echo "control_cases=$((PASS + FAIL))"
echo "control_fail=$FAIL"
if [ "$FAIL" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=drift"
  exit 1
fi
