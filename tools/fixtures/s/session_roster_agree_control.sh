#!/bin/sh
# tools/fixtures/s/session_roster_agree_control.sh -- prove the roster-agreement guard from both sides.
#
# WHY. A refusal proven only in the passing direction cannot be told from a bypass. Every behavior
# below is exercised on real files in a throwaway pen, so the scan is asked the same question the
# session-logs room asks it.
#
# WHAT IT PROVES -- refusals bitten, and every one of them lifted again:
#
#   BITTEN                                            FREE
#   1  the two rosters spell one day differently      1  two rosters agreeing with the shelf
#   2  a roster number above the shelf's own rows     2  an elder list-shape shelf, counted
#   3  a roster number below them                     3  `open` on today's day, in both rosters
#   4  a shelf neither roster's table names           4  a shelf one roster names in prose only,
#   5  a roster row naming an absent shelf file          at the ceiling of one
#   6  a second one-sided shelf, over the ceiling     5  a day cell of bare digits, never read
#   7  a missing pin, refused rather than counted        as the count
#   8  an empty date room, refused at zero            6  `open` on a day already past, reported
#                                                        and never gated
#
# USAGE
#   sh tools/fixtures/s/session_roster_agree_control.sh
#
# Driven by tools/s/session_roster_agree_witness.rish. Run from the repository root.
set -eu

SCAN=$(cd "$(dirname "$0")" && pwd)/session_roster_agree_scan.sh
[ -f "$SCAN" ] || { echo "control=absent detail=no_scan"; exit 1; }

PEN=$(mktemp -d "${TMPDIR:-/tmp}/session-roster-control.XXXXXX")
trap 'rm -rf "$PEN"' EXIT

pass=0
fail=0
note() {
  if [ "$1" = ok ]; then pass=$((pass + 1)); echo "ok   $2"
  else fail=$((fail + 1)); echo "FAIL $2"; fi
}

reset_pen() {
  rm -rf "$PEN/tree"
  mkdir -p "$PEN/tree/session-logs/date"
}

# shelf NAME ROWS -- a table shelf carrying ROWS stamp lines.
shelf() {
  f="$PEN/tree/session-logs/date/README-index-$1.md"
  {
    echo "# Session logs -- $1"
    echo
    echo "| Stamp | Log | What it recorded |"
    echo "|---|---|---|"
    i=0
    while [ "$i" -lt "$2" ]; do
      printf '| `%s.0000%02d` | [a](%s/%s-0000%02d_a.kyri) | a row |\n' "$1" "$i" "$1" "$1" "$i"
      i=$((i + 1))
    done
  } > "$f"
}

# list_shelf NAME ROWS -- the elder shape this room wrote through 20260722.
list_shelf() {
  f="$PEN/tree/session-logs/date/README-index-$1.md"
  {
    echo "# Session logs -- $1"
    echo
    i=0
    while [ "$i" -lt "$2" ]; do
      printf -- '- `%s.0000%02d` -- [a](%s/%s-0000%02d_a.bron) -- a row\n' "$1" "$i" "$1" "$1" "$i"
      i=$((i + 1))
    done
  } > "$f"
}

pin_head() {
  { echo "# Session logs"; echo; echo "| Day | Rows | Shelf |"; echo "|---|---:|---|"; } > "$PEN/tree/session-logs/README.md"
}
chapters_head() {
  { echo "# Session-logs roster"; echo; echo "| Chapter | Range | Count | Index |"; echo "|--------|-------|------:|-------|"; } > "$PEN/tree/session-logs/CHAPTERS.md"
}
pin_row() {
  printf '| `%s` | %s | [`date/README-index-%s.md`](date/README-index-%s.md) |\n' "$1" "$2" "$1" "$1" >> "$PEN/tree/session-logs/README.md"
}
chapters_row() {
  printf '| %s | `%s` | %s | [`date/README-index-%s.md`](date/README-index-%s.md) |\n' "$1" "$1" "$2" "$1" "$1" >> "$PEN/tree/session-logs/CHAPTERS.md"
}

scan() { SESSION_ROSTER_ROOT="$PEN/tree" SESSION_ROSTER_TODAY=20260909 sh "$SCAN" "${1:-count}" 2>&1 || true; }

# rewrite FILE FROM TO -- one substitution, in place, without `sed -i`. BSD sed spells that flag
# with a mandatory argument and GNU sed without one, so an in-place edit is a borrowed tool wearing
# a granted one's name; a temporary and a redirect through the original inode are POSIX and keep
# the file's mode besides (`.claude/rules/exec-bit.md`).
rewrite() {
  sed "s#$2#$3#" "$1" > "$1.tmp" && cat "$1.tmp" > "$1" && rm -f "$1.tmp"
}

# --- the honest tree every later plant is measured against -----------------------------------
build_clean() {
  reset_pen
  pin_head; chapters_head
  shelf 20260907 4;  pin_row 20260907 4;  chapters_row 20260907 4
  shelf 20260908 3;  pin_row 20260908 3;  chapters_row 20260908 3
  shelf 20260909 2;  pin_row 20260909 open; chapters_row 20260909 open
  list_shelf 20260722 5; pin_row 20260722 5; chapters_row 20260722 5
}

build_clean
out=$(scan)
echo "$out" | grep -q '^verdict=ok$' && note ok "1 free: two rosters agreeing with every shelf" || note no "1 free: two rosters agreeing with every shelf"
echo "$out" | grep -q '^shelves=4$' && note ok "2 free: all four shelves derived, table and list shapes alike" || note no "2 free: all four shelves derived, table and list shapes alike"
echo "$out" | grep -q '^stale=0$' && note ok "3 free: an elder list shelf counts as 5, never as 0" || note no "3 free: an elder list shelf counts as 5, never as 0"
echo "$out" | grep -q '^open_stale=0$' && note ok "4 free: open on today's day is honest" || note no "4 free: open on today's day is honest"
echo "$out" | grep -q '^one_sided=0$' && note ok "5 free: a day both rosters name is never one-sided" || note no "5 free: a day both rosters name is never one-sided"

# A day cell is bare digits too, so a scan reading the FIRST bare cell reads the day as the count.
# That misreading answered stale=91 on this scan's first run against the living tree.
echo "$out" | grep -q '^disagree=0$' && note ok "6 free: the day cell's bare digits are never read as the count" || note no "6 free: the day cell's bare digits are never read as the count"

# --- 1 bitten: the two rosters spell one day differently --------------------------------------
build_clean
rewrite "$PEN/tree/session-logs/CHAPTERS.md" '^| 20260907 | `20260907` | 4 |' '| 20260907 | `20260907` | 3 |'
out=$(scan)
echo "$out" | grep -q '^disagree=1$' && note ok "7 bitten: pin 4 against chapters 3 on one day" || note no "7 bitten: pin 4 against chapters 3 on one day"
echo "$out" | grep -q '^verdict=drift$' && note ok "8 bitten: the verdict refuses on a disagreement" || note no "8 bitten: the verdict refuses on a disagreement"
scan list | grep -q '^disagree: 20260907' && note ok "9 bitten: the list names the day that disagrees" || note no "9 bitten: the list names the day that disagrees"
build_clean
out=$(scan)
echo "$out" | grep -q '^verdict=ok$' && note ok "10 lifted: removing the disagreement returns the reading to ok" || note no "10 lifted: removing the disagreement returns the reading to ok"

# --- 2 and 3 bitten: a number above and a number below the shelf's own rows -------------------
build_clean
rewrite "$PEN/tree/session-logs/README.md" '^| `20260908` | 3 |' '| `20260908` | 9 |'
rewrite "$PEN/tree/session-logs/CHAPTERS.md" '^| 20260908 | `20260908` | 3 |' '| 20260908 | `20260908` | 9 |'
out=$(scan)
echo "$out" | grep -q '^stale=2$' && note ok "11 bitten: both rosters reading 9 above a 3-row shelf" || note no "11 bitten: both rosters reading 9 above a 3-row shelf"
echo "$out" | grep -q '^disagree=0$' && note ok "12 bitten: two rosters wrong the SAME way still agree, and stale is what catches them" || note no "12 bitten: two rosters wrong the same way still agree"

build_clean
rewrite "$PEN/tree/session-logs/README.md" '^| `20260908` | 3 |' '| `20260908` | 1 |'
out=$(scan)
echo "$out" | grep -q '^stale=1$' && note ok "13 bitten: a roster number below the shelf's rows" || note no "13 bitten: a roster number below the shelf's rows"
build_clean
out=$(scan)
echo "$out" | grep -q '^stale=0$' && note ok "14 lifted: restoring the number returns stale to zero" || note no "14 lifted: restoring the number returns stale to zero"

# --- 4 bitten: a shelf neither roster's table names -------------------------------------------
build_clean
shelf 20260906 7
out=$(scan)
echo "$out" | grep -q '^uncounted=1$' && note ok "15 bitten: a shelf on disk that neither roster names" || note no "15 bitten: a shelf on disk that neither roster names"
echo "$out" | grep -q '^verdict=drift$' && note ok "16 bitten: the verdict refuses on an uncounted shelf" || note no "16 bitten: the verdict refuses on an uncounted shelf"
pin_row 20260906 7; chapters_row 20260906 7
out=$(scan)
echo "$out" | grep -q '^uncounted=0$' && note ok "17 lifted: naming it in both rosters clears the reading" || note no "17 lifted: naming it in both rosters clears the reading"

# --- 5 bitten: a roster row naming a shelf file that is absent --------------------------------
build_clean
pin_row 20260905 12; chapters_row 20260905 12
out=$(scan)
echo "$out" | grep -q '^phantom=2$' && note ok "18 bitten: two roster rows naming an absent shelf file" || note no "18 bitten: two roster rows naming an absent shelf file"
shelf 20260905 12
out=$(scan)
echo "$out" | grep -q '^phantom=0$' && note ok "19 lifted: writing the shelf clears the phantom" || note no "19 lifted: writing the shelf clears the phantom"

# --- 6: the one-sided ratchet, shown from both sides of its ceiling ---------------------------
build_clean
shelf 20260905 6; pin_row 20260905 6
out=$(scan)
echo "$out" | grep -q '^one_sided=1$' && note ok "20 free: one shelf named by the pin alone sits at the ceiling" || note no "20 free: one shelf named by the pin alone sits at the ceiling"
echo "$out" | grep -q '^one_sided_ok=yes$' && note ok "21 free: the ceiling of one holds" || note no "21 free: the ceiling of one holds"
echo "$out" | grep -q '^verdict=ok$' && note ok "22 free: a shelf one roster names in prose passes" || note no "22 free: a shelf one roster names in prose passes"
shelf 20260904 6; chapters_row 20260904 6
out=$(scan)
echo "$out" | grep -q '^one_sided=2$' && note ok "23 bitten: a second one-sided shelf crosses the ceiling" || note no "23 bitten: a second one-sided shelf crosses the ceiling"
echo "$out" | grep -q '^one_sided_ok=no$' && note ok "24 bitten: the ceiling refuses at two" || note no "24 bitten: the ceiling refuses at two"
echo "$out" | grep -q '^verdict=drift$' && note ok "25 bitten: the verdict refuses over the ceiling" || note no "25 bitten: the verdict refuses over the ceiling"

# --- 7: an open row for a day already past is reported, never gated ---------------------------
build_clean
rewrite "$PEN/tree/session-logs/README.md" '^| `20260908` | 3 |' '| `20260908` | open |'
rewrite "$PEN/tree/session-logs/CHAPTERS.md" '^| 20260908 | `20260908` | 3 |' '| 20260908 | `20260908` | open |'
out=$(scan)
echo "$out" | grep -q '^open_stale=2$' && note ok "26 free: yesterday still reading open is counted in both rosters" || note no "26 free: yesterday still reading open is counted in both rosters"
echo "$out" | grep -q '^verdict=ok$' && note ok "27 free: and never gated -- the day-close pays it" || note no "27 free: and never gated -- the day-close pays it"

# --- 8: the refusals that keep a zero from reading as a pass ----------------------------------
build_clean
rm "$PEN/tree/session-logs/README.md"
out=$(scan)
echo "$out" | grep -q 'refused: session-logs/README.md is absent' && note ok "28 bitten: an absent pin refuses rather than counting zero" || note no "28 bitten: an absent pin refuses rather than counting zero"

reset_pen
pin_head; chapters_head
out=$(scan)
echo "$out" | grep -q 'refused: no shelf index files' && note ok "29 bitten: an empty date room refuses at zero (REDS %170)" || note no "29 bitten: an empty date room refuses at zero"

# The ceiling refuses the whole corpus instead of hiding its last shelf.
build_clean
i=0
while [ "$i" -lt 509 ]; do
  : > "$PEN/tree/session-logs/date/README-index-overflow-$i.md"
  i=$((i + 1))
done
out=$(scan)
echo "$out" | grep -q 'refused: 513 shelves exceed 512' && note ok "30 bitten: an oversized corpus refuses before counting" || note no "30 bitten: an oversized corpus refuses before counting"
build_clean
out=$(scan)
echo "$out" | grep -q '^verdict=ok$' && note ok "31 lifted: restoring the bounded corpus returns ok" || note no "31 lifted: restoring the bounded corpus returns ok"

# --- 9: a count run names what refused, and stays quiet when nothing did ----------------------
# `list` has always named the day. The witness has only ever asked for `count`, so a fleet pass
# reading `stale=3` named no day at all and a hand had to know a second spelling existed. These
# legs hold the naming to the gated kinds: a clean tree says nothing extra, an `open_stale` row is
# a duty rather than a refusal, a one-sided shelf AT its ceiling is an honest reading -- and each
# of those three is proven silent on a tree where the reading is genuinely non-zero, since a
# silence proven only at zero cannot be told from a printer that never fires.
build_clean
out=$(scan)
naming=$(echo "$out" | grep -cE '^(disagree|stale|uncounted|phantom|one_sided): ' || true)
[ "$naming" -eq 0 ] && note ok "32 free: a green count run names nothing" || note no "32 free: a green count run names nothing"

build_clean
rewrite "$PEN/tree/session-logs/README.md" '^| `20260908` | 3 |' '| `20260908` | 9 |'
out=$(scan)
echo "$out" | grep -q '^stale: 20260908 -- pin reads 9, the shelf holds 3' && note ok "33 bitten: a count run names the day behind stale" || note no "33 bitten: a count run names the day behind stale"
echo "$out" | grep -q '^verdict=drift$' && note ok "34 bitten: and still refuses" || note no "34 bitten: and still refuses"
build_clean
out=$(scan)
echo "$out" | grep -q '^stale: ' && note no "35 lifted: repairing the number takes the naming away" || note ok "35 lifted: repairing the number takes the naming away"

# An `open_stale` row is a duty the next day-close pays, so it is never what refused. Planted
# BESIDE a real refusal, so the leg reads a filter rather than an empty report file.
build_clean
rewrite "$PEN/tree/session-logs/README.md" '^| `20260908` | 3 |' '| `20260908` | open |'
rewrite "$PEN/tree/session-logs/CHAPTERS.md" '^| 20260908 | `20260908` | 3 |' '| 20260908 | `20260908` | 9 |'
out=$(scan)
echo "$out" | grep -q '^stale: 20260908 -- chapters reads 9' && note ok "36 bitten: the gated row is named" || note no "36 bitten: the gated row is named"
echo "$out" | grep -q '^open_stale: ' && note no "37 free: an open row for a past day is never named as the refusal" || note ok "37 free: an open row for a past day is never named as the refusal"
echo "$out" | grep -q '^open_stale=1$' && note ok "38 free: and is still counted, so a hand can ask for it with list" || note no "38 free: and is still counted, so a hand can ask for it with list"
scan list | grep -q '^open_stale: 20260908' && note ok "39 free: list still prints every reading" || note no "39 free: list still prints every reading"

# A one-sided shelf AT the ceiling is an honest reading; over it, it is the refusal itself.
build_clean
shelf 20260905 6; pin_row 20260905 6
rewrite "$PEN/tree/session-logs/README.md" '^| `20260907` | 4 |' '| `20260907` | 8 |'
out=$(scan)
echo "$out" | grep -q '^one_sided: ' && note no "40 free: a one-sided shelf at its ceiling is not named as the refusal" || note ok "40 free: a one-sided shelf at its ceiling is not named as the refusal"
build_clean
shelf 20260905 6; pin_row 20260905 6
shelf 20260904 6; chapters_row 20260904 6
out=$(scan)
echo "$out" | grep -q '^one_sided: ' && note ok "41 bitten: over the ceiling it IS the refusal, and is named" || note no "41 bitten: over the ceiling it IS the refusal, and is named"

echo "control_pass=$pass"
echo "control_fail=$fail"
if [ "$fail" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=misread"; exit 1; fi
