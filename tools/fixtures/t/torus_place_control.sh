#!/bin/sh
# tools/fixtures/t/torus_place_control.sh -- proves the behaviors of
# tools/fixtures/t/torus_place_scan.sh on planted digest populations in a throwaway pen, every
# reading shown from both sides.
#
# WHY A PLANTED POPULATION. The scan reads digests, and a clustered population of REAL names would
# have to be mined -- hashing until enough files share a cell. That is work in the wrong direction:
# what wants proving is the READING, and a reading takes digests. So the digest door is the control
# path, and each population below is built from a rule a reader can check by eye.
#
# WHY MUTATIONS. A refusal proven only in the passing direction cannot be told from a bypass, so
# three guards are cut out of a COPY of the scan and each copy must answer differently. A mutation
# that no longer applies reads like one that passed, so each asserts it was applied first.
#
#   sh tools/fixtures/t/torus_place_control.sh

set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_steps=0
while [ ! -d "$ROOT/tools/fixtures" ]; do
  _steps=$((_steps + 1))
  [ "$_steps" -gt 8 ] && { echo "$0: no tree root" >&2; exit 2; }
  ROOT=$(dirname "$ROOT")
done
SCAN="$ROOT/tools/fixtures/t/torus_place_scan.sh"

PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT INT TERM

pass=0
fail=0
legs=0
LEGS_EXPECTED=31

ok() { legs=$((legs + 1)); pass=$((pass + 1)); echo "ok   $legs $1"; }
no() { legs=$((legs + 1)); fail=$((fail + 1)); echo "FAIL $legs $1"; }
check() { if [ "$2" = "$3" ]; then ok "$1"; else no "$1 -- wanted [$3], read [$2]"; fi; }

field() { awk -v k="$1" -F= '$1 == k { print $2 }' "$2" | tail -1; }

# --- the planted populations --------------------------------------------------------------------
# EVEN: two coprime strides across the byte space, so the leading pair sweeps the grid.
awk 'BEGIN {
  for (i = 0; i < 512; i++) {
    b0 = (i * 37) % 256; b1 = (i * 61) % 256
    s = sprintf("%02x%02x", b0, b1)
    for (j = 2; j < 64; j++) s = s sprintf("%02x", (i * 7 + j * 13) % 256)
    print s
  }
}' > "$PEN/even.txt"

# CLUSTERED: every name lands in the same corner of the grid, whichever grid is chosen.
awk 'BEGIN {
  for (i = 0; i < 512; i++) {
    s = sprintf("%02x%02x", i % 3, (i * 2) % 3)
    for (j = 2; j < 64; j++) s = s sprintf("%02x", (i + j) % 256)
    print s
  }
}' > "$PEN/clustered.txt"

# ONE CELL: every digest identical, so both folds place every name together.
awk 'BEGIN { s = ""; for (j = 0; j < 64; j++) s = s "5a"; for (i = 0; i < 512; i++) print s }' \
  > "$PEN/onecell.txt"

head -4 "$PEN/even.txt" > "$PEN/tiny.txt"
: > "$PEN/empty.txt"

# --- the even population --------------------------------------------------------------------
sh "$SCAN" --digests "$PEN/even.txt" --grid 8 > "$PEN/even.out" 2>&1 || true
check "even: the scan reads its planted population"  "$(field names "$PEN/even.out")" "512"
check "even: the forced grid is honored"             "$(field grid "$PEN/even.out")" "8"
check "even: sixty-four cells follow the grid"       "$(field cells "$PEN/even.out")" "64"
check "even: the torus fold reads even"              "$(field torus_even "$PEN/even.out")" "yes"
check "even: the ring fold reads even too"           "$(field ring_even "$PEN/even.out")" "yes"
check "even: imbalance falls as names arrive"        "$(field imbalance_fell "$PEN/even.out")" "yes"
check "even: the instrument passes its own gate"     "$(field verdict "$PEN/even.out")" "ok"

# --- the clustered population, the stated falsifier ---------------------------------------------
sh "$SCAN" --digests "$PEN/clustered.txt" --grid 8 > "$PEN/clus.out" 2>&1 || true
check "clustered: the torus fold refuses"            "$(field torus_even "$PEN/clus.out")" "no"
check "clustered: the ring fold refuses beside it"   "$(field ring_even "$PEN/clus.out")" "no"
check "clustered: the instrument refuses"            "$(field verdict "$PEN/clus.out")" "refused"

# --- the one-cell population, so the agreement counter is shown moving ---------------------------
sh "$SCAN" --digests "$PEN/onecell.txt" --grid 8 > "$PEN/one.out" 2>&1 || true
check "one cell: identical names still land in two different cells" "$(field folds_agree "$PEN/one.out")" "0"
check "one cell: and the instrument refuses"          "$(field verdict "$PEN/one.out")" "refused"
a=$(field folds_agree "$PEN/even.out")
if [ "$a" -lt 64 ]; then ok "even: the folds agree at chance rather than by construction"
else no "even: the folds agree $a times, which is not chance"; fi

# --- the readings that cannot be taken ----------------------------------------------------------
sh "$SCAN" --digests "$PEN/tiny.txt" > "$PEN/tiny.out" 2>&1 || true
check "too few: the scan declines rather than guessing" "$(field verdict "$PEN/tiny.out")" "unreadable"
check "too few: and claims no evenness either way"      "$(field torus_even "$PEN/tiny.out")" ""
sh "$SCAN" --digests "$PEN/empty.txt" > "$PEN/empty.out" 2>&1 || true
check "empty: an empty population is unreadable"        "$(field verdict "$PEN/empty.out")" "unreadable"

# --- the closed forms, and the precondition under them -------------------------------------------
check "g=8: the torus run-kill length is 2g+1"      "$(field runkill_torus4 "$PEN/even.out")" "17"
check "g=8: the near ring holds five"               "$(field runkill_ring4adj "$PEN/even.out")" "5"
check "g=8: the wide ring holds 4g+1"               "$(field runkill_ring4wide "$PEN/even.out")" "33"
check "g=8: the even split beats every fixed offset" "$(field runkill_evenspread "$PEN/even.out")" "52"
check "g=8: the even split matches C-ceil(C/5)+1"   "$(field runkill_evenspread_closed "$PEN/even.out")" "52"
check "g=8: every closed form holds"                "$(field runkill_closed_forms_hold "$PEN/even.out")" "yes"
check "g=8: the second axis buys no spread"         "$(field second_axis_buys_spread "$PEN/even.out")" "no"

sh "$SCAN" --digests "$PEN/even.txt" --grid 4 > "$PEN/g4.out" 2>&1 || true
check "g=4: the wide ring aliases, so its closed form is named absent" \
  "$(field runkill_ring4wide_closed "$PEN/g4.out")" "na"
check "g=4: a precondition is not a refusal"        "$(field verdict "$PEN/g4.out")" "ok"

# --- the mutations --------------------------------------------------------------------------------
# The mutants live INSIDE the tree, because the scan finds its root by walking up from its own
# location and a copy in /tmp would exit before reading a flag. `.lap/` is the per-ship scratch
# room the read-scope law names, gitignored and reached by named path.
mkdir -p "$ROOT/.lap"
MUTPEN=$(mktemp -d "$ROOT/.lap/torus_place_control.XXXXXX")
trap 'rm -rf "$PEN" "$MUTPEN"' EXIT INT TERM
mutate() { sed "$2" "$SCAN" > "$MUTPEN/$1.sh"; if cmp -s "$SCAN" "$MUTPEN/$1.sh"; then no "$1: the mutation never applied"; else ok "$1: the mutation applied"; fi; }

mutate "m_closed" 's|\[ "\$c" = "na" \] && continue|: |'
sh "$MUTPEN/m_closed.sh" --digests "$PEN/even.txt" --grid 4 > "$PEN/m1.out" 2>&1 || true
check "m_closed: without the precondition an aliasing grid refuses" \
  "$(field verdict "$PEN/m1.out")" "refused"

mutate "m_compare" 's|if \[ "\$rw" -gt "\$tw" \]; then|if [ "$rw" -lt "$tw" ]; then|'
sh "$MUTPEN/m_compare.sh" --digests "$PEN/even.txt" --grid 8 > "$PEN/m2.out" 2>&1 || true
check "m_compare: the spread verdict is read off the two numbers" \
  "$(field second_axis_buys_spread "$PEN/m2.out")" "yes"

mutate "m_even" 's|torus_even=%s\\n", (ct <= crit ? "yes" : "no")|torus_even=yes\\n"|'
sh "$MUTPEN/m_even.sh" --digests "$PEN/clustered.txt" --grid 8 > "$PEN/m3.out" 2>&1 || true
check "m_even: a fold that always answers yes still refuses on the ring half" \
  "$(field verdict "$PEN/m3.out")" "refused"

echo "control_pass=$pass"
echo "control_fail=$fail"
echo "control_legs=$legs"
echo "legs_expected=$LEGS_EXPECTED"
if [ "$legs" -ne "$LEGS_EXPECTED" ]; then
  echo "control_verdict=leg_count_moved"
  exit 0
fi
if [ "$fail" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=failed"; fi
