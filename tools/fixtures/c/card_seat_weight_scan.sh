#!/bin/sh
# card_seat_weight_scan.sh -- what each seat holds on the shared operator card.
#
#   sh tools/fixtures/c/card_seat_weight_scan.sh [--blocks]
#
# WHY THIS READING EXISTS. `construction/ITINERARY.md` is one page eight ships write into, and a
# living pin over its byte bound refuses EVERY commit on EVERY ship -- so one seat's overflow stops
# the pier rather than the seat. On `20260917` the card read over its 40,960 bound five times, at
# 0158, 1848, 2010, 2044 and 2211, and each crossing cleared only when a seat noticed and shelved.
#
# Nothing measured the page by WRITER, so no seat could see its own share. The card's total was
# visible to `pin_bound_touch_scan.sh` and the total is the one number a seat cannot act on.
#
# WHAT IT READS. A seat block opens on a line beginning `**<SEAT>` where the name is one of the
# live roster's seats in capitals, and runs to the next such line or the next Markdown heading,
# whichever comes first. That is the shape eight hands already write, rather than a form invented
# here -- which is why the reading needs no cooperation to start working.
#
# WHAT IT REPORTS AND NEVER GATES. Every number here is a first census of a page eight hands share.
# A gate over it would refuse a peer's honest lap for a total that peer cannot see while writing,
# and this tree has already written down what such a gate becomes: one somebody turns off. Whether
# a ceiling follows is a word for Keaton once the distribution has been watched.
#
# WHAT IT CANNOT SEE, named rather than left for a reader to find:
#
#   * Whether a block is a LIVE account or a one-line pointer at a shelved one. Both are the seat's
#     bytes on the page, which is what the bound counts, so the reading is honest for its purpose
#     and silent about intent.
#   * The standing prose -- the card's own structure, gates and itineraries -- which is reported as
#     the remainder rather than attributed to anyone.
#   * A seat writing under another seat's header, which reads as the header's owner.
#
# Read by a hand, and by `.claude/rules/the-writer-sheds.md`.

set -u

root=${CARD_WEIGHT_ROOT:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}
card="$root/construction/ITINERARY.md"
roster_scan="$root/tools/fixtures/f/fleet_roster_scan.sh"

want_blocks=no
[ "${1:-}" = "--blocks" ] && want_blocks=yes

[ -f "$card" ] || { echo "detail: no card at $card"; echo "verdict=card_missing"; exit 1; }

# The seat names come from the roster rather than a list typed here, so a ship seated tomorrow is
# measured on the lap it arrives. A roster this cannot read refuses rather than guessing a set.
if [ -x "$roster_scan" ] || [ -f "$roster_scan" ]; then
  seats=$(sh "$roster_scan" --live 2>/dev/null | tr 'a-z' 'A-Z' | tr '\n' ' ')
else
  echo "detail: no roster reader at $roster_scan -- the seat set would have to be guessed"
  echo "verdict=roster_missing"; exit 1
fi
[ -n "$(printf '%s' "$seats" | tr -d ' ')" ] || { echo "detail: the roster named no live seat"; echo "verdict=no_seats"; exit 1; }

total=$(wc -c < "$card" | tr -d ' ')
bound=$(sh "$root/tools/fixtures/l/living_pin_max_bytes.sh" construction/ITINERARY.md 2>/dev/null)
case "$bound" in ''|*[!0-9]*) bound=40960 ;; esac

echo "card_bytes=$total"
echo "card_bound=$bound"
echo "card_headroom=$((bound - total))"
echo "seats_live=$(printf '%s' "$seats" | wc -w | tr -d ' ')"

awk -v seats="$seats" -v want_blocks="$want_blocks" '
  BEGIN {
    n = split(seats, a, " ")
    for (i = 1; i <= n; i++) if (a[i] != "") live[a[i]] = 1
    cur = ""; carried = 0
  }
  # A heading closes whatever block was open: a seat account never spans a section.
  /^#/ { cur = ""; next }
  {
    if (match($0, /^\*\*[A-Z][A-Z]+/)) {
      name = substr($0, 3, RLENGTH - 2)
      if (name in live) { cur = name; blocks[name]++ }
      else cur = ""
    }
    if (cur != "") { bytes[cur] += length($0) + 1; carried += length($0) + 1 }
  }
  END {
    for (s in bytes) printf "seat %s bytes=%d blocks=%d\n", s, bytes[s], blocks[s]
    printf "seat_bytes_total=%d\n", carried
    printf "standing_prose_bytes=%d\n", TOTAL - carried
    printf "seat_share_per_mille=%d\n", (TOTAL > 0 ? carried * 1000 / TOTAL : 0)
    m = 0; for (s in blocks) if (blocks[s] > m) m = blocks[s]
    printf "blocks_max_one_seat=%d\n", m
    printf "seats_over_one_block=%d\n", cnt_over(blocks)
  }
  function cnt_over(b,   s, c) { c = 0; for (s in b) if (b[s] > 1) c++; return c }
' TOTAL="$total" "$card" | sort

echo "verdict=read"
