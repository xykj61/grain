#!/bin/sh
# tools/fixtures/r/reds_pin_capacity_scan.sh -- can the ledger still accept a row?
#
# WHAT THIS IS FOR. Four meters read `construction/REDS.md` today, and every one of them asks
# whether what is written is CONSISTENT: the spine runs 1..N without a gap, a closed row does not
# still read OPEN, a number is not rebound against the anointed remote, a headline is measured
# rather than recited. Not one asks whether anything more can be WRITTEN.
#
# So on `20260829` the pin stood at 24,571 bytes of the 24,576 its own header declares -- five bytes
# of headroom against a median row of 1,983 -- with all nine of its rows marked OPEN, and every one
# of those meters read green. A ledger that cannot accept a row has stopped being a ledger, and it
# stops SILENTLY, because consistency and capacity are different questions and only one of them was
# ever asked.
#
# WHY THE PIN DEADLOCKS, structurally rather than by accident. `tools/fixtures/r/reds_fold.sh`
# refuses `row_open` on purpose, and its reason is right: "the pin keeps what is open; folding one
# would hide live work on a shelf nobody reads for live work." That rule has a floor under it --
# it assumes rows eventually close. When every row stays open the fold tool has no lawful move, the
# pin cannot grow, and the next red has nowhere to land.
#
# Measured `20260829`: not one of the nine open rows was open on an unrepaired defect. Each was
# open on a ratchet (%311, %334), on a seat awaiting Keaton's word (%306, %326, %327, %328), or on
# booked future work (%291, %301, %330). `.claude/rules/reds-first.md` is explicit that a ratchet
# books nothing and a seat is a person's to speak -- so the pin's single OPEN flag carries two
# meanings at once, live defect and booked remainder, and the fold tool can only read the flag.
#
# WHAT THE FLEET DID INSTEAD, honestly and on the record: rows %335, %336 and %337 were born
# directly onto single-row shelves under `construction/archive/`, each saying so in its own header
# and each recorded in `REDS-fold-recital.md`. That keeps the spine gapless and the trail readable.
# It also leaves a live red -- %337 -- sitting exactly where `reds_fold.sh` refuses to put one, so a
# lap reading the pin under reds-first sees nine of the ten open reds. This scan measures that, so
# the next lap MEETS the number rather than rediscovering it.
#
# WHAT IS GATED, at zero:
#   phantom_recital_shelves  a recital line naming a shelf file that is not on disk. The recital is
#                            the only trail from a folded row back to the lap that folded it, and a
#                            line pointing at nothing is a trail that ends mid-sentence. Measured 0.
#
# WHAT IS RATCHETED, under ceilings that only fall:
#   unrecorded_shelves  a shelf on disk carrying no recital line (62). The recital was itself
#                       folded off the pin on `20260825.183336`, so shelves older than that day
#                       predate their own trail. Not-yet-uniform rather than wrong, which is a
#                       ratchet by this tree's own definition.
#   shelf_open_rows     a row whose declared status is OPEN living on a shelf rather than the pin
#                       (2: %337, and %338, this scan's own booking). It falls to zero the day the
#                       pin can hold them. It rose from 1 to 2 the moment %338 was written, because
#                       a row about a ledger with no room had no room to be written in -- which is
#                       the reading rather than a flaw in it.
#
# WHAT IS REPORTED, never gated: pin_bytes, pin_bound, pin_headroom, pin_rows, pin_open_rows,
# pin_fold_refused_rows, pin_foldable_rows, median_row_bytes, rows_that_fit, pin_deadlocked.
#
# WHY CAPACITY IS REPORTED AND NOT GATED. A full pin wants a person: raising a page's bound is
# Keaton's word, seated that way once already for `session-logs/README.md`. A gate here would red on
# every ordinary lap until he speaks, and a gate that reds on ordinary work is a gate someone turns
# off. So the deadlock is printed loudly and refuses nothing.
#
# HOW A ROW IS READ -- two questions, two readings, on purpose. A row is a line beginning
# `**REDS %N` or `**REDS #N`, and this scan asks two different things of it:
#
#   FOLDABILITY -- would reds_fold.sh accept this row? That tool refuses on the whole uppercase
#   word OPEN anywhere in the line, (^|[^A-Za-z])OPEN([^A-Za-z]|$), so this reading uses exactly
#   that test. Asking a different question here would report a capacity the fold tool will not honour.
#
#   DECLARED STATUS -- is this row still live? That is the LAST bold marker on the line beginning
#   OPEN or CLOSED, the same reading reds_status_consistency_scan.sh takes, because a row that
#   closes writes the newer word after the older one.
#
# The two differ, and the difference is why both are here. Measured `20260829`: five shelf rows
# carry the bare word OPEN and only ONE of them, %337, is actually open. The other four -- %162,
# %163, %251, %288 -- record their own open history in prose and read closed or unmarked. A first
# draft of this scan used the fold test for both questions and reported five live reds on shelves,
# which is four more than exist. The witness proves this reading against
# reds_status_consistency_scan.sh's own count rather than this comment promising they agree.
#
# It does not reach whether an open row DESERVES to be open. That is a lap's judgment and a
# person's word, and a meter that guessed at it would be closing reds by arithmetic.
#
#   sh tools/fixtures/r/reds_pin_capacity_scan.sh
#   REDS_PIN=pen/REDS.md REDS_ARCHIVE_GLOB="pen/REDS-*rows-*.md" \
#     REDS_RECITAL=pen/recital.md REDS_PIN_BOUND=4096 sh tools/fixtures/r/reds_pin_capacity_scan.sh
#
# Exit 0 clean - 1 a gated reading above zero or a ratchet above its ceiling - 2 misuse.
# Purely local: it reads markdown and counts bytes.
set -eu

# WHY THESE NUMBERS. Both are readings measured on `20260829`, held so they can only fall. Neither
# is a target; each describes the day it was written. shelf_open_rows is 2 rather than the 1 this
# scan first read, because booking %338 -- the red about a ledger that cannot accept a row -- put a
# second live red on a shelf. Raising a ceiling to admit your own row is worth saying out loud: the
# alternative was marking %338 closed while the deadlock still stands, and a count that flatters the
# lap taking it is worth less than a blank.
UNRECORDED_SHELVES_CEILING=${UNRECORDED_SHELVES_CEILING:-62}
SHELF_OPEN_ROWS_CEILING=${SHELF_OPEN_ROWS_CEILING:-0}

PIN=${REDS_PIN:-construction/REDS.md}
ARCHIVE_GLOB=${REDS_ARCHIVE_GLOB:-"construction/archive/REDS-*rows-*.md"}
RECITAL=${REDS_RECITAL:-construction/archive/REDS-fold-recital.md}

[ -f "$PIN" ] || { echo "verdict=misuse detail=no_pin pin=$PIN" >&2; exit 2; }

# The bound is CITED, never copied -- one reading of the law, the discipline
# tools/fixtures/l/living_pin_max_bytes.sh exists to hold (REDS %197, %199). A caller overrides it
# only for a pen, where the real law's number would make every reading meaningless.
if [ -n "${REDS_PIN_BOUND:-}" ]; then
  BOUND=$REDS_PIN_BOUND
else
  BOUND=$(sh tools/fixtures/l/living_pin_max_bytes.sh "$PIN")
fi

PIN_BYTES=$(wc -c < "$PIN" | tr -d ' ')
HEADROOM=$((BOUND - PIN_BYTES))

# The row reading lives in one file, called twice, so the pin and the shelves can never drift apart.
ROWREAD=tools/fixtures/r/reds_pin_capacity_rows.awk
[ -f "$ROWREAD" ] || { echo "verdict=misuse detail=no_row_reader reader=$ROWREAD" >&2; exit 2; }

eval "$(awk -f "$ROWREAD" -v mode=pin "$PIN")"
PIN_FOLDABLE=$((PIN_ROWS - PIN_REFUSED))

if [ "$MEDIAN" -gt 0 ] && [ "$HEADROOM" -gt 0 ]; then
  ROWS_THAT_FIT=$((HEADROOM / MEDIAN))
else
  ROWS_THAT_FIT=0
fi

# A deadlock is both halves at once: no room for a new row, and no lawful fold to make room. Either
# alone is ordinary -- a full pin with a foldable row is one reds_fold.sh away from healthy, and an
# all-open pin with headroom is simply a busy ledger.
if [ "$ROWS_THAT_FIT" -eq 0 ] && [ "$PIN_FOLDABLE" -eq 0 ]; then
  DEADLOCKED=1
else
  DEADLOCKED=0
fi

# --- live reds exiled to shelves, read by DECLARED STATUS ---------------------------------------
SHELF_OPEN=0
for f in $ARCHIVE_GLOB; do
  [ -f "$f" ] || continue
  for row in $(awk -f "$ROWREAD" -v mode=open_rows "$f"); do
    echo "detail: shelf_open %$row -- a live red on a shelf, where reds_fold.sh refuses to put one ($f)"
    SHELF_OPEN=$((SHELF_OPEN + 1))
  done
done

# --- the recital's trail ------------------------------------------------------------------------
UNRECORDED=0
PHANTOM=0
if [ -f "$RECITAL" ]; then
  work=$(mktemp -d)
  trap 'rm -rf "$work"' EXIT INT TERM
  grep -o 'REDS-[A-Za-z0-9-]*rows-[0-9-]*\.md' "$RECITAL" | sort -u > "$work/recital.txt" || true
  for f in $ARCHIVE_GLOB; do
    [ -f "$f" ] || continue
    basename "$f"
  done | sort -u > "$work/disk.txt"
  UNRECORDED=$(comm -13 "$work/recital.txt" "$work/disk.txt" | wc -l | tr -d ' ')
  PHANTOM=$(comm -23 "$work/recital.txt" "$work/disk.txt" | wc -l | tr -d ' ')
  comm -23 "$work/recital.txt" "$work/disk.txt" | while read -r m; do
    [ -n "$m" ] && echo "detail: phantom_recital -- the recital names $m, which is not on disk"
  done
else
  echo "detail: no_recital -- $RECITAL is absent, so the trail cannot be read"
fi

if [ "$DEADLOCKED" -eq 1 ]; then
  echo "detail: pin_deadlocked -- $ROWS_THAT_FIT rows fit in ${HEADROOM}B of headroom and $PIN_FOLDABLE of $PIN_ROWS rows are foldable; a new red has nowhere in the pin to go"
fi

echo "pin_bytes=$PIN_BYTES"
echo "pin_bound=$BOUND"
echo "pin_headroom=$HEADROOM"
echo "pin_rows=$PIN_ROWS"
echo "pin_open_rows=$PIN_OPEN"
echo "pin_fold_refused_rows=$PIN_REFUSED"
echo "pin_foldable_rows=$PIN_FOLDABLE"
echo "median_row_bytes=$MEDIAN"
echo "rows_that_fit=$ROWS_THAT_FIT"
echo "pin_deadlocked=$DEADLOCKED"
echo "shelf_open_rows=$SHELF_OPEN"
echo "unrecorded_shelves=$UNRECORDED"
echo "phantom_recital_shelves=$PHANTOM"

if [ "$PHANTOM" -gt 0 ]; then
  echo "verdict=recital_trail_broken"
  exit 1
fi
if [ "$UNRECORDED" -gt "$UNRECORDED_SHELVES_CEILING" ]; then
  echo "verdict=unrecorded_shelves_above_ceiling ceiling=$UNRECORDED_SHELVES_CEILING"
  exit 1
fi
if [ "$SHELF_OPEN" -gt "$SHELF_OPEN_ROWS_CEILING" ]; then
  echo "verdict=shelf_open_rows_above_ceiling ceiling=$SHELF_OPEN_ROWS_CEILING"
  exit 1
fi
echo "verdict=ok"
