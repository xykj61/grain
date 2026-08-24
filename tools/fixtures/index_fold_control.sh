#!/bin/sh
# tools/fixtures/index_fold_control.sh -- prove the index-fold guard from both sides.
#
# WHY. A refusal proven only in the passing direction cannot be told from a bypass. Every
# behavior below is exercised on a real directory tree in a throwaway pen, so the scan is asked
# the same question a room asks it, rather than a question shaped to the answer.
#
# WHAT IT PROVES -- five refusals bitten, seven honest readings left free:
#
#   BITTEN                                        FREE
#   1  a stale row in the enforced room           1  a row whose day still has flat logs
#   2  a stale row when its whole day has folded  2  a row whose day has a SPRIGLESS flat log
#   3  318 stale rows against a ceiling of 317    3  a table delimiter row (opens "|-")
#   4  an elder list-shape stale row              4  a prose line opening "- " with no stamp
#   5  a stale row beside a free one              5  a room with no date/ fold at all
#                                                 6  a room with no README.md at all
#                                                 7  317 ratchet rows, exactly at the ceiling
#
# USAGE
#   sh tools/fixtures/index_fold_control.sh
#
# Driven by tools/i/index_fold_witness.rish. Run from the repository root.
set -eu

SCAN=$(cd "$(dirname "$0")" && pwd)/index_fold_scan.sh
[ -f "$SCAN" ] || { echo "control=absent detail=no_scan"; exit 1; }

PEN=$(mktemp -d "${TMPDIR:-/tmp}/index-fold-control.XXXXXX")
trap 'rm -rf "$PEN"' EXIT

pass=0
fail=0

note() {
  if [ "$1" = ok ]; then
    pass=$((pass + 1))
    echo "ok   $2"
  else
    fail=$((fail + 1))
    echo "FAIL $2"
  fi
}

# Build one room: name, flat log basenames (space separated), index row lines (newline in $3).
room() {
  name=$1
  flats=$2
  rows=$3
  mkdir -p "$PEN/$name/date/20260101"
  : >"$PEN/$name/date/20260101/keep"
  for f in $flats; do
    [ "$f" = "-" ] && continue
    : >"$PEN/$name/$f"
  done
  {
    echo "# $name"
    echo
    echo "| Stamp | Log | What |"
    echo "|---|---|---|"
    printf '%s\n' "$rows"
  } >"$PEN/$name/README.md"
}

reset_pen() {
  rm -rf "$PEN"
  mkdir -p "$PEN"
}

census() {
  ( cd "$PEN" && sh "$SCAN" )
}

# --- 1. the enforced room, one stale row: BITTEN ---------------------------------------------
reset_pen
room session-logs "-" "| \`20260813.101010\` | [a](date/20260813/20260813-101010_a.kyri) | folded |"
out=$(census)
echo "$out" | grep -q '^stale_rows_gated=1$' && note ok "1 bitten: a stale row in the enforced room counts against the gate" || note no "1 bitten: a stale row in the enforced room counts against the gate"
echo "$out" | grep -q '^verdict=stale_index_rows$' && note ok "1 bitten: the verdict refuses" || note no "1 bitten: the verdict refuses"

# --- 2. FREE: the day still has a flat log ----------------------------------------------------
reset_pen
room session-logs "20260813-101010_a.kyri" "| \`20260813.101010\` | [a](20260813-101010_a.kyri) | still flat |"
out=$(census)
echo "$out" | grep -q '^stale_rows_gated=0$' && note ok "2 free: a row whose day still has a flat log is left alone" || note no "2 free: a row whose day still has a flat log is left alone"

# --- 3. FREE: the flat log carries no sprig (REDS %178) ---------------------------------------
reset_pen
room session-logs "20260813-101010.bron" "| \`20260813.101010\` | [a](20260813-101010.bron) | sprigless |"
out=$(census)
echo "$out" | grep -q '^stale_rows_gated=0$' && note ok "3 free: a SPRIGLESS flat log holds its day open, since the sprig is optional" || note no "3 free: a SPRIGLESS flat log holds its day open, since the sprig is optional"

# --- 4. FREE: a table delimiter row is not an index row ---------------------------------------
reset_pen
room session-logs "-" "|---|---|---|"
out=$(census)
echo "$out" | grep -q '^stale_rows_gated=0$' && note ok "4 free: a table delimiter row names no day" || note no "4 free: a table delimiter row names no day"

# --- 5. FREE: prose opening with a dash is not an index row -----------------------------------
reset_pen
room session-logs "-" "- a bullet of ordinary prose, carrying no stamp at all"
out=$(census)
echo "$out" | grep -q '^stale_rows_gated=0$' && note ok "5 free: a prose bullet with no stamp names no day" || note no "5 free: a prose bullet with no stamp names no day"

# --- 6. BITTEN: the elder list shape is read too ----------------------------------------------
reset_pen
room session-logs "-" "- \`20260813.101010\` — [a](date/20260813/20260813-101010_a.bron) — elder shape"
out=$(census)
echo "$out" | grep -q '^stale_rows_gated=1$' && note ok "6 bitten: the elder list-shape row is read, not skipped" || note no "6 bitten: the elder list-shape row is read, not skipped"

# --- 7. BITTEN: one stale beside one free, counted apart --------------------------------------
reset_pen
room session-logs "20260814-101010_b.kyri" "| \`20260813.101010\` | [a](date/20260813/20260813-101010_a.kyri) | folded |
| \`20260814.101010\` | [b](20260814-101010_b.kyri) | flat |"
out=$(census)
echo "$out" | grep -q '^stale_rows_gated=1$' && note ok "7 bitten: a stale row is counted while its free neighbour is not" || note no "7 bitten: a stale row is counted while its free neighbour is not"

# --- 8. FREE: a room with no date/ fold is skipped entirely -----------------------------------
reset_pen
mkdir -p "$PEN/plainroom"
printf '# plainroom\n\n| `20260813.101010` | [a](20260813-101010_a.kyri) | no fold here |\n' >"$PEN/plainroom/README.md"
out=$(census)
echo "$out" | grep -q '^rooms_measured=0$' && note ok "8 free: a room with no date/ fold is not measured" || note no "8 free: a room with no date/ fold is not measured"

# --- 9. FREE: a directory with no README.md is skipped ----------------------------------------
reset_pen
mkdir -p "$PEN/noindex/date/20260101"
out=$(census)
echo "$out" | grep -q '^rooms_measured=0$' && note ok "9 free: a directory with no README.md is not measured" || note no "9 free: a directory with no README.md is not measured"

# --- 10/11. the ratchet ceiling, proven from both sides ---------------------------------------
# No override exists and none is wanted, so the ceiling is proven by planting rows against it.
build_ratchet() {
  n=$1
  reset_pen
  mkdir -p "$PEN/otherroom/date/20260101"
  : >"$PEN/otherroom/date/20260101/keep"
  {
    echo "# otherroom"
    echo
    i=0
    while [ "$i" -lt "$n" ]; do
      printf '| `20260813.%06d` | [x](date/20260813/20260813-%06d_x.md) | folded |\n' "$i" "$i"
      i=$((i + 1))
    done
  } >"$PEN/otherroom/README.md"
}

build_ratchet 317
out=$(census)
echo "$out" | grep -q '^ratchet_under_ceiling=yes$' && note ok "10 free: 317 ratchet rows sit exactly at the ceiling and pass" || note no "10 free: 317 ratchet rows sit exactly at the ceiling and pass"
echo "$out" | grep -q '^verdict=ok$' && note ok "10 free: the verdict holds at the ceiling" || note no "10 free: the verdict holds at the ceiling"

build_ratchet 318
out=$(census)
echo "$out" | grep -q '^ratchet_under_ceiling=no$' && note ok "11 bitten: 318 ratchet rows cross the ceiling" || note no "11 bitten: 318 ratchet rows cross the ceiling"
echo "$out" | grep -q '^verdict=stale_index_rows$' && note ok "11 bitten: the verdict refuses over the ceiling" || note no "11 bitten: the verdict refuses over the ceiling"

# --- 12. the enforced room is reported even when it is clean ----------------------------------
reset_pen
room session-logs "20260813-101010_a.kyri" "| \`20260813.101010\` | [a](20260813-101010_a.kyri) | flat |"
out=$(census)
echo "$out" | grep -q '^room=session-logs stale=0 roster=enforce$' && note ok "12 free: the enforced room is reported at zero, rather than vanishing" || note no "12 free: the enforced room is reported at zero, rather than vanishing"

echo "control_pass=$pass"
echo "control_fail=$fail"
if [ "$fail" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=misread"
  exit 1
fi
