#!/bin/sh
# tools/fixtures/l/locality_key_control.sh -- proves the behaviors of
# tools/fixtures/l/locality_key_scan.sh on planted populations in a throwaway pen, every reading
# shown from both sides.
#
# WHY A PLANTED POPULATION. The scan prices one key against another over real bytes, and the
# finding it reports is a large trade. A control run on the same real bytes would prove only that
# the tree is what it is. What wants proving is the READING -- that the instrument would say NO if
# the trade were absent -- so each population below is built from a rule a reader checks by eye,
# and the populations that carry no trade are as load-bearing as the ones that do.
#
# WHY MUTATIONS. A refusal proven only in the passing direction cannot be told from a bypass, so
# four guards are cut out of a COPY of the scan and each copy must answer differently. A mutation
# that no longer applies reads like one that passed, so each asserts it was applied first.
#
#   sh tools/fixtures/l/locality_key_control.sh

set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_steps=0
while [ ! -d "$ROOT/tools/fixtures" ]; do
  _steps=$((_steps + 1))
  [ "$_steps" -gt 8 ] && { echo "$0: no tree root" >&2; exit 2; }
  ROOT=$(dirname "$ROOT")
done
SCAN="$ROOT/tools/fixtures/l/locality_key_scan.sh"

PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT INT TERM
# The pen is entered rather than merely named: a control that stays in the live tree writes its
# fixtures into it, and the cd is checked at the edge so the refusal is by name rather than by
# surprise.
cd "$PEN" || { echo "$0: could not enter the pen $PEN" >&2; exit 2; }
[ "$(pwd -P)" = "$(CDPATH= cd -- "$PEN" && pwd -P)" ] || { echo "$0: pen not entered" >&2; exit 2; }

pass=0
fail=0
legs=0
LEGS_EXPECTED=43

ok() { legs=$((legs + 1)); pass=$((pass + 1)); echo "ok   $legs $1"; }
no() { legs=$((legs + 1)); fail=$((fail + 1)); echo "FAIL $legs $1"; }
check() { if [ "$2" = "$3" ]; then ok "$1"; else no "$1 -- wanted [$3], read [$2]"; fi; }
above() { if awk -v a="$2" -v b="$3" 'BEGIN { exit !(a > b) }'; then ok "$1"; else no "$1 -- [$2] not above [$3]"; fi; }
below() { if awk -v a="$2" -v b="$3" 'BEGIN { exit !(a < b) }'; then ok "$1"; else no "$1 -- [$2] not below [$3]"; fi; }

field() { awk -v k="$1" -F= '$1 == k { print $2 }' "$2" | tail -1; }

# --- the planted populations ---------------------------------------------------------------------
# Each row is: room, 128-char digest hex, 4-char prefix hex, path. The digest column is always
# swept evenly across the byte space by two coprime strides, so the DIGEST key reads even in every
# population and the only thing that changes between them is the PREFIX column and the room column.
# That isolation is the point: one variable moves at a time.

# TRADED: rooms are real groups, and each room's files share a prefix -- the shape a locality key
# has on a real corpus. Expect the prefix to cluster hard and to recover rooms well.
awk 'BEGIN {
  for (i = 0; i < 512; i++) {
    r = int(i / 64)
    printf "room%d ", r
    for (j = 0; j < 64; j++) printf "%02x", (i * 37 + j * 11) % 256
    printf " %02x%02x path%d\n", r * 4, (i % 3), i
  }
}' > traded.txt

# FLAT: the same rooms, and a prefix swept evenly across the whole space. A locality key that
# carried nothing on this corpus would look like this, and the scan must say so.
awk 'BEGIN {
  for (i = 0; i < 512; i++) {
    r = int(i / 64)
    printf "room%d ", r
    for (j = 0; j < 64; j++) printf "%02x", (i * 37 + j * 11) % 256
    printf " %02x%02x path%d\n", (i * 71) % 256, (i * 29) % 256, i
  }
}' > flat.txt

# SCRAMBLED: prefixes cluster exactly as in TRADED, yet rooms are assigned round-robin so a cell
# holds every room equally. Clustering without correlation -- the population that separates
# "the key is uneven" from "the key leaks the room".
awk 'BEGIN {
  for (i = 0; i < 512; i++) {
    printf "room%d ", i % 8
    for (j = 0; j < 64; j++) printf "%02x", (i * 37 + j * 11) % 256
    printf " %02x%02x path%d\n", int(i / 64) * 4, (i % 3), i
  }
}' > scrambled.txt

# WRAPEDGE: one room whose names alternate between cell 0 and cell 63 of a 64-cell ring. The
# cyclic distance between neighbours is 1 and the unwrapped distance is 63, so this population
# reads the wrap itself rather than a mean over a sweep.
awk 'BEGIN {
  for (i = 0; i < 16; i++) {
    printf "room0 "
    if (i % 2 == 0) { for (j = 0; j < 64; j++) printf "00" } else { for (j = 0; j < 64; j++) printf "ff" }
    printf " 0102 path%d\n", i
  }
}' > wrapedge.txt

printf 'room0 %s 0102 p1\nroom0 %s 0102 p2\n' \
  "$(awk 'BEGIN { for (j = 0; j < 64; j++) printf "aa" }')" \
  "$(awk 'BEGIN { for (j = 0; j < 64; j++) printf "bb" }')" > tiny.txt

# --- the traded population -----------------------------------------------------------------------
sh "$SCAN" --rows traded.txt --grid 8 > traded.out 2>&1
check "traded: the reading is taken"                "$(field verdict traded.out)"        "ok"
check "traded: the rows door is named as the source" "$(field source traded.out)"        "rows_file"
check "traded: every planted row is read"            "$(field names traded.out)"         "512"
check "traded: the grid is the one asked for"        "$(field cells traded.out)"         "64"
check "traded: the evenly swept digest reads even"   "$(field digest_even traded.out)"   "yes"
check "traded: the shared-prefix key does not"       "$(field prefix_even traded.out)"   "no"
check "traded: so evenness is sold"                  "$(field evenness_sold traded.out)" "yes"
check "traded: and the room is sold with it"         "$(field confidentiality_sold traded.out)" "yes"
check "traded: same-room names sit closer"           "$(field roomdist_closer traded.out)" "yes"
above "traded: the prefix chi clears its critical"   "$(field chi_prefix traded.out)"    "$(field chi_critical traded.out)"
below "traded: the digest chi does not"              "$(field chi_digest traded.out)"    "$(field chi_critical traded.out)"
above "traded: prefix recovery beats digest recovery" "$(field room_recovery_prefix traded.out)" "$(field room_recovery_digest traded.out)"
check "traded: the recovery identity holds"          "$(field recovery_in_range traded.out)" "yes"

# --- the flat population: the scan must be able to say NO ----------------------------------------
sh "$SCAN" --rows flat.txt --grid 8 > flat.out 2>&1
check "flat: the reading is taken"                   "$(field verdict flat.out)"         "ok"
check "flat: an evenly swept prefix reads even"      "$(field prefix_even flat.out)"     "yes"
check "flat: so nothing is sold"                     "$(field evenness_sold flat.out)"   "no"
check "flat: and no room is recovered"               "$(field confidentiality_sold flat.out)" "no"
check "flat: same-room names sit no closer"          "$(field roomdist_closer flat.out)" "no"
below "flat: the prefix chi sits under its critical" "$(field chi_prefix flat.out)"      "$(field chi_critical flat.out)"

# --- the scrambled population: uneven WITHOUT leaking --------------------------------------------
sh "$SCAN" --rows scrambled.txt --grid 8 > scrambled.out 2>&1
check "scrambled: the reading is taken"              "$(field verdict scrambled.out)"    "ok"
check "scrambled: the clustered prefix is uneven"    "$(field prefix_even scrambled.out)" "no"
check "scrambled: evenness is sold"                  "$(field evenness_sold scrambled.out)" "yes"
check "scrambled: yet the room is NOT"                "$(field confidentiality_sold scrambled.out)" "no"

# --- the wrap itself -----------------------------------------------------------------------------
sh "$SCAN" --rows wrapedge.txt --grid 8 > wrap.out 2>&1
check "wrapedge: cells 0 and 63 sit one apart on a 64-cell ring" \
  "$(field roomdist_digest wrap.out)" "1.000"

# --- the rows door reports what it cannot read ---------------------------------------------------
check "rows: no file to edit, so no probe is claimed" "$(field edit_probes traded.out)"  "0"
check "rows: and locality reads unread, never yes"    "$(field locality_bought traded.out)" "unread"

# --- refusals ------------------------------------------------------------------------------------
sh "$SCAN" --rows tiny.txt --grid 2 > tiny.out 2>&1
check "tiny: a population under the floor is unreadable" "$(field verdict tiny.out)"     "unreadable"
: > empty.txt
sh "$SCAN" --rows empty.txt --grid 2 > empty.out 2>&1
check "empty: an empty rows file is unreadable"      "$(field verdict empty.out)"        "unreadable"
if sh "$SCAN" --rows nosuch.txt > missing.out 2>&1; then
  no "missing: an absent rows file is refused"
else
  ok "missing: an absent rows file is refused"
fi
if sh "$SCAN" --nonsense > flag.out 2>&1; then
  no "flag: an unknown flag is refused"
else
  ok "flag: an unknown flag is refused"
fi

# --- the live tree, where the probes actually run ------------------------------------------------
sh "$SCAN" --names 48 > live.out 2>&1
check "live: the reading is taken on real bytes"     "$(field verdict live.out)"         "ok"
check "live: no digest survives a deep edit"         "$(field edit_survive_digest live.out)" "0"
check "live: every prefix does"                      "$(field edit_survive_prefix live.out)" \
  "$(field edit_probes live.out)"
check "live: so locality is bought"                  "$(field locality_bought live.out)" "yes"

# --- the mutations -------------------------------------------------------------------------------
# The mutant copies live under the tree's own scratch room rather than in the pen, because the
# scan finds its root by walking up from its own location and a copy in /tmp has no tree above it.
MUTPEN=$(mktemp -d "$ROOT/.lap/locality_key_control.XXXXXX")
trap 'rm -rf "$PEN" "$MUTPEN"' EXIT INT TERM
mutate() {
  sed "$2" "$SCAN" > "$MUTPEN/$1.sh"
  if cmp -s "$SCAN" "$MUTPEN/$1.sh"; then no "$1: the mutation applied"; else ok "$1: the mutation applied"; fi
}

mutate "m_plurality" 's|if (roomtotal\[r\] > plur) plur = roomtotal\[r\]|plur = 0|'
sh "$MUTPEN/m_plurality.sh" --rows "$PEN/traded.txt" --grid 8 > m1.out 2>&1 || true
check "m_plurality: a lost baseline still leaves the range identity readable" \
  "$(field recovery_in_range m1.out)" "yes"
check "m_plurality: and the baseline it prints is the wrong one" \
  "$(field plurality_room_share m1.out)" "0.0000"

mutate "m_wrap" 's|return (d < cells - d) ? d : cells - d|return d|'
sh "$MUTPEN/m_wrap.sh" --rows "$PEN/wrapedge.txt" --grid 8 > m2.out 2>&1 || true
check "m_wrap: without the wrap the same two cells read the long way round" \
  "$(field roomdist_digest m2.out)" "63.000"

mutate "m_best" 's|if (ppair\[k\] > pbest\[c\]) pbest\[c\] = ppair\[k\]|pbest[c] += ppair[k]|'
sh "$MUTPEN/m_best.sh" --rows "$PEN/scrambled.txt" --grid 8 > m3.out 2>&1 || true
check "m_best: summing instead of maxing recovers everything and breaks the identity check" \
  "$(field room_recovery_prefix m3.out)" "1.0000"

mutate "m_probe" 's|\[ "\$x2" = "\$x" \] && SURV_PREFIX=\$(( SURV_PREFIX + 1 ))|:|'
sh "$MUTPEN/m_probe.sh" --names 48 > m4.out 2>&1 || true
check "m_probe: a prefix probe that never counts refuses the reading" \
  "$(field verdict m4.out)" "refused"

echo "control_pass=$pass"
echo "control_fail=$fail"
echo "control_legs=$legs"
echo "legs_expected=$LEGS_EXPECTED"
if [ "$legs" -ne "$LEGS_EXPECTED" ]; then
  echo "control_verdict=leg_count_moved"
  exit 0
fi
if [ "$fail" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=failed"; fi
