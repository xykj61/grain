#!/bin/sh
# tools/fixtures/index_fold_scan.sh -- an index folds with the room it describes.
#
# WHY. A room folds its files by day into date/YYYYMMDD/ and its README.md indexes them. The
# fold moved files down and left every row in place, so for a month the one file a reader opens
# first was the only one growing without a ceiling: session-logs/README.md reached 2,895,849
# bytes against the 24,576 its own header declares, with 1,880 rows standing above its title
# and no table delimiter under any of them (REDS %182).
#
# WHAT IT READS. For each room carrying both README.md and date/, every index row is matched to
# a day, and each day is asked one question: does the room still hold a flat log from it? A day
# with no flat log left has folded, and its rows belong on date/README-index-YYYYMMDD.md rather
# than in the living pin.
#
#   stale_rows_gated   -- stale rows in a room on the ENFORCE list. HELD AT ZERO.
#   stale_rows_ratchet -- stale rows everywhere else, under a ceiling that only falls.
#   pin bytes          -- each living pin's size, reported beside living_pin_max_bytes.
#
# A room earns ENFORCE the same way it earns the room bound: by being carried across once, its
# rows shelved and its front door rewritten by a hand. session-logs holds that seat from
# 20260824.052329, when 2,193 rows moved onto 26 dated shelves. The other four rooms measured
# that day -- active-designing 86, counsel 112, expanding-prompts 78, waymarks 41 -- are real and
# ride the ratchet until each gets its own round, since folding a room's index also rewrites its
# front door, and four front doors written in a hurry is how a fix becomes its own red.
#
# The gate is the ROW RULE rather than the byte count, and the reason is worth saying. A byte
# ceiling would red on ordinary work, since every lap adds rows; the row rule never does, because
# a row only becomes stale when its logs fold, and the same tool folds both:
#
#   rye run tools/rye/session_logs_archive.rye index-fold [--room NAME]
#
# The byte bound then follows for free: fold the room to today and the pin holds one day's rows.
# Reporting pin_bytes without gating it is the honest half -- the pin cannot reach its bound
# while days sit flat, and folding the room is Keaton's word (.claude/rules/session-logs.md).
#
# USAGE
#   sh tools/fixtures/index_fold_scan.sh          # census -- key=value lines
#   sh tools/fixtures/index_fold_scan.sh list     # every stale row, one per line
#
# Driven by tools/i/index_fold_witness.rish. Proven both ways by index_fold_control.sh.
# Run from the repository root.
set -eu

MODE="${1:-census}"
MAX_BYTES=24576

# Rooms whose index has been folded once by a hand, front door and all. Zero stale rows here.
ENFORCE="session-logs"

# Every other room's stale rows, measured 20260824.052329 and allowed only to fall.
RATCHET_CEILING=317

TMP=$(mktemp -d "${TMPDIR:-/tmp}/index-fold.XXXXXX")
trap 'rm -rf "$TMP"' EXIT

: >"$TMP/stale"
rooms=0
pins=""

# A room qualifies when it carries both an index and a day fold. Discovery rather than a roster,
# so a room that folds tomorrow is measured the same way (REDS %170 -- a guard nobody runs).
for readme in */README.md; do
  [ -f "$readme" ] || continue
  room=${readme%/README.md}
  [ -d "$room/date" ] || continue
  rooms=$((rooms + 1))

  # Days whose logs are still flat in the room. A dated basename is the WHOLE stamp, and the
  # sprig after it is optional (REDS %178) -- the same shape the fold and the resolver read.
  ls -1 "$room" 2>/dev/null \
    | grep -E '^[0-9]{8}-[0-9]{6}[_.]' \
    | cut -c1-8 | sort -u >"$TMP/flat"

  # Every day the index names. Two row shapes have been written here and both are read: a table
  # row and the elder list item. A table delimiter row opens "|-" and is refused by the space.
  awk -v room="$room" '
    /^[|-] / {
      line = $0
      body = substr(line, 3)
      gsub(/^[ `]+/, "", body)
      if (body ~ /^[0-9]{8}[.-][0-9]{6}/) {
        print substr(body, 1, 8) "\t" room "\t" FNR "\t" substr(line, 1, 110)
      }
    }
  ' "$readme" >"$TMP/rows"

  while IFS='	' read -r day r ln text; do
    [ -n "$day" ] || continue
    if ! grep -qx "$day" "$TMP/flat"; then
      printf '%s\t%s\t%s\t%s\n' "$r" "$day" "$ln" "$text" >>"$TMP/stale"
    fi
  done <"$TMP/rows"

  bytes=$(wc -c <"$readme" | tr -d ' ')
  pins="${pins}${room}=${bytes} "
done

if [ "$MODE" = "list" ]; then
  cat "$TMP/stale"
  exit 0
fi

gated=0
ratchet=0
while IFS='	' read -r r day ln text; do
  [ -n "$r" ] || continue
  hit=no
  for e in $ENFORCE; do
    [ "$r" = "$e" ] && hit=yes
  done
  if [ "$hit" = yes ]; then
    gated=$((gated + 1))
  else
    ratchet=$((ratchet + 1))
  fi
done <"$TMP/stale"

echo "rooms_measured=$rooms"
for pin in $pins; do
  room=${pin%%=*}
  bytes=${pin#*=}
  if [ "$bytes" -gt "$MAX_BYTES" ]; then
    echo "pin_over_bound=$room bytes=$bytes max=$MAX_BYTES"
  else
    echo "pin_ok=$room bytes=$bytes"
  fi
done
echo "living_pin_max_bytes=$MAX_BYTES"

# An ENFORCED room is always reported, at zero as loudly as at any other number -- a room that
# drops out of a discovery-only meter is a room whose pass nobody witnessed (REDS %170).
for e in $ENFORCE; do
  n=$(awk -F'\t' -v r="$e" '$1 == r { c++ } END { print c + 0 }' "$TMP/stale")
  echo "room=$e stale=$n roster=enforce"
done

echo "stale_rows_gated=$gated"
echo "stale_rows_ratchet=$ratchet"
echo "stale_rows_ratchet_ceiling=$RATCHET_CEILING"
if [ "$ratchet" -le "$RATCHET_CEILING" ]; then
  echo "ratchet_under_ceiling=yes"
else
  echo "ratchet_under_ceiling=no"
fi
if [ "$gated" -eq 0 ] && [ "$ratchet" -le "$RATCHET_CEILING" ]; then
  echo "index_follows_room=yes"
  echo "verdict=ok"
else
  echo "index_follows_room=no"
  echo "verdict=stale_index_rows"
fi
