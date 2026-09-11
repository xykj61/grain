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
# pin_fold_refused_rows, pin_foldable_rows, median_row_bytes, rows_that_fit, pin_deadlocked,
# pin_held_rows, pin_unheld_rows.
#
# WHY pin_held_rows, added `20260910.073602`. Door B landed on `20260829` as the one door that
# reaches the cause -- BOOKED split from OPEN, eight booked rows drained, the pin fell 24,828 to
# 5,388 bytes. Twelve days later the pin stands at 40,771 of 40,960 with **16 OPEN rows and none
# foldable**, so the deadlock came back. The population is what changed: door B split a live defect
# from a booked remainder, and never split who can CLOSE a live one. **9 of the 16 name Keaton, a
# custody gate, or a numbered gate**, and 7 of those name `Keaton\'s word` outright. Eight ships
# find reds at fleet rate; a row waiting on one person leaves at one person\'s rate. That is a
# refill mechanism rather than a busy week, and it is reported here so the next reading of the
# deadlock meets the cause rather than the symptom.
#
# WHY pin_unheld_rows AND THE DOORS LINE MOVED, added `20260910.140033`. The reading above landed
# at 07:36 and the doors line beneath it was left saying "no lawful fold exists here. The three
# doors of %338 stand and each is Keaton's word." Those two lines print in one breath and they
# disagree: 9 of 16 rows named a hand outside the loop, so SEVEN did not, and a row nobody outside
# the loop holds is a row the fleet itself may close. Four ships read the elder line that morning
# and each carried "yours, Keaton" onto `construction/ITINERARY.md` -- a wall where a door stood.
#
# The complement is derived rather than counted again, and it is a PROXY twice over: `held()` reads
# a row's prose for Keaton, a custody gate, or a numbered gate, and an unheld row may still be live
# work nobody can finish today. So it is printed row by row and gated at nothing -- which this
# header claimed for six hours before it was true (`20260910.181200`). The count printed; the rows
# did not, and the one sentence naming their number sat inside the DEADLOCK branch, so it went
# quiet exactly when the pin was healthy enough to act on cheaply. `pin_unheld_row` names each one
# now, unconditionally, beside `pin_held`; `pin_unheld_named` counts what was named, so the
# enumeration and the derived `PIN_UNHELD` are two readings a pen holds to each other. What it does
# promise is exact: closing ONE open row -- proving its repair on metal and accreting that row's
# last bold marker to BOOKED -- moves pin_foldable_rows off zero, and by this scan's own table
# that is the deadlock broken.
#
# Walked through on the lap that wrote this. `%697` had been booked at `20260910.064526` asking for
# a byte-floor on a staged `.kyri`; `71a85f8f7` landed exactly that at `07:14:21`, forty-eight
# minutes later, and the row stood OPEN for six hours because nothing in the ledger hears a repair
# land. Its clause accreted, the row folded, and the pin fell 40,771 -> 38,768 bytes with no word
# from anyone.
#
# WHY CAPACITY IS MOSTLY REPORTED AND NOT GATED. A full pin wants a person: raising a page's bound
# is Keaton's word, seated that way once already for `session-logs/README.md`. A gate here would red
# on every ordinary lap until he speaks, and a gate that reds on ordinary work is a gate someone
# turns off. So the deadlock is printed loudly and refuses nothing.
#
# THE ONE CELL THAT DOES GATE, and why it is not an exception to the paragraph above but the state
# that paragraph was never written about (REDS %517). Two readings cross here:
#
#                       | foldable row exists      | no foldable row
#   -------------------|--------------------------|--------------------------
#   headroom >= 0      | ok                       | ok
#   headroom <  0      | over_bound_foldable GATE | pin_deadlocked, reported
#
# The argument above holds exactly in the right-hand column: nothing a lap can do makes room, so
# only Keaton's word helps and a refusal would red on ordinary work. The left-hand column is the
# opposite state, and this scan's own deadlock comment already names it -- "a full pin with a
# foldable row is one reds_fold.sh away from healthy." One fold away from healthy is not healthy.
# It is repairable by whichever lap meets it, with no word from anyone, in one command.
#
# Measured `20260906.212057`, which is why the cell is gated rather than merely printed: the pin
# stood at 41,153 of 40,960 with `pin_foldable_rows=7`, and TWO OTHER rostered guards red on that
# same page in that same cold pass -- `equinox_e123_living_pin_guard` with `detail=pin_over_bound`
# and `declared_ceiling` with `verdict=over_declared_bound`. Neither names a remedy, because
# neither knows this ledger folds. This scan knew, printed `rows_that_fit=0` beside
# `pin_headroom=-193`, and answered `verdict=ok`. Four of 111 commit states that day carried the
# pin over its bound. A verdict that disagrees with its own numbers is worth less than no verdict,
# so the word and the exit status move together here.
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
# WHY IT READS THE ANOINTED PIN TOO (`20260911.064500`). Every reading above is taken from THIS
# CLONE's bytes, and `construction/REDS.md` is one page eight ships write. Measured on the lap this
# was added: **all 200** of the last 200 commits touched the pin, 50 of them inside 16 hours, and
# headroom moved 0 -> 1,993 -> 15 bytes across five of them -- a swing wider than the median row of
# 1,977. So a clone one commit behind does not read a slightly stale ledger; it reads a ledger whose
# deadlock verdict can have flipped. The fault has already fired here: on `20260911.034352` this
# scan's `pin_foldable_rows` named a row a peer had folded, and the lap acted on a door that was
# already walked through. That is REDS %457's class exactly -- an answer about a shared tree drawn
# from local bytes -- and `tools/fixtures/p/path_absence_scan.sh` is the loom already built for it,
# never wired to this second site. A lantern that fires twice becomes a loom.
#
# It reads the REF rather than fetching, which is the sibling `reds_spine_derive_scan.sh`'s own
# idiom and the right one for a lap-tier guard: the round-open pulls at lap START, this runs moments
# later, and 8 ships fetching every lap buys nothing the pull did not. A ref that will not resolve
# reads `unread` and says so, because an allocator that falls back to the local tree in silence is
# the fault this reading names.
#
# Exit 0 clean - 1 a gated reading above zero or a ratchet above its ceiling - 2 misuse.
# It reads markdown, counts bytes, and reads one git ref; it opens no socket.
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

# The complement of PIN_HELD, derived here rather than counted a second time -- two readers
# spelling one rule are two readers that can come to disagree. An OPEN row naming no hand outside
# the loop is one the fleet itself may close, which is the door the deadlock message had no way to
# name: it printed pin_held_rows=9 beside "each is Keaton's word" and the two disagreed.
PIN_UNHELD=$((PIN_OPEN - PIN_HELD))
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

# --- who holds an open row -------------------------------------------------------------------
# A PROXY, printed row by row so a reader checks it rather than trusting it: an OPEN row whose own
# text names Keaton, a custody gate, or a numbered gate. Reported and never gated -- a gate on rows
# only one person may close would red hardest on the laps that found them.
for row in $(awk -f "$ROWREAD" -v mode=held_rows "$PIN"); do
  echo "detail: pin_held %$row -- an open row whose own text names a hand outside the loop"
done

# THE COMPLEMENT, NAMED RATHER THAN MERELY COUNTED (`20260910.181200`). The WHY block above has
# claimed since `20260910.140033` that the unheld reading is "printed row by row"; it was printed
# as a count, and its one sentence naming no row rode inside the DEADLOCK branch, so it vanished
# exactly when the pin was healthy enough for a lap to act on it cheaply. A number tells a lap that
# a door exists; a list tells it which door. `PIN_UNHELD` stays derived as `PIN_OPEN - PIN_HELD`,
# so this enumeration is a SECOND reader of one truth and `pin_unheld_named` is printed beside it
# -- two readings that must agree, checked in the pen rather than assumed, which is the shape the
# elder disagreement between `pin_held_rows` and the doors line already cost one morning.
PIN_UNHELD_NAMED=0
for row in $(awk -f "$ROWREAD" -v mode=unheld_rows "$PIN"); do
  echo "detail: pin_unheld_row %$row -- an open row naming no hand outside the loop; the fleet's own to close, and closing one makes reds_fold.sh lawful here"
  PIN_UNHELD_NAMED=$((PIN_UNHELD_NAMED + 1))
done

# --- the recital's trail ------------------------------------------------------------------------
UNRECORDED=0
PHANTOM=0
if [ -f "$RECITAL" ]; then
  work=$(mktemp -d)
  trap 'rm -rf "$work"' EXIT INT TERM
  grep -o 'REDS-[A-Za-z0-9-]*rows-[0-9-]*\.md' "$RECITAL" | sort -u > "$work/recital.txt" || true
  # One `sed` over the whole list rather than one `basename` fork per file. The glob holds
  # 339 archive shelves today, and the fork loop cost 1,451ms of this scan's 2,723ms --
  # 53% of the wall for 339 of its 708 clones, measured `20260908.092431`. `printf` is a
  # shell builtin, so the existence check keeps its meaning and the loop keeps no fork.
  # Third site of the class REDS %622 named; a comment repairs the file it sits in.
  for f in $ARCHIVE_GLOB; do
    [ -f "$f" ] || continue
    printf '%s\n' "$f"
  done | sed 's|.*/||' | sort -u > "$work/disk.txt"
  UNRECORDED=$(comm -13 "$work/recital.txt" "$work/disk.txt" | wc -l | tr -d ' ')
  PHANTOM=$(comm -23 "$work/recital.txt" "$work/disk.txt" | wc -l | tr -d ' ')
  comm -23 "$work/recital.txt" "$work/disk.txt" | while read -r m; do
    [ -n "$m" ] && echo "detail: phantom_recital -- the recital names $m, which is not on disk"
  done
else
  echo "detail: no_recital -- $RECITAL is absent, so the trail cannot be read"
fi

# --- the ANOINTED pin, beside this clone's ------------------------------------------------------
# Reported, never gated, for the reason `dropped_upstream_stamps` is reported one guard over: being
# behind is ordinary work on an eight-ship fleet, and a gate that reds on ordinary work is a gate
# somebody turns off. What it buys is that a lap reading `pin_foldable_rows` is told, in the same
# breath, whether the page it just measured is the page the fleet holds.
ANOINTED=${REDS_ANOINTED:-xy/main}
UPSTREAM_BYTES=unread
UPSTREAM_STATE=unread
AHEAD_OF_UPSTREAM=0
ONLY_UPSTREAM=0
COMMITS_BEHIND=unknown

up_pin=""
if [ -n "${REDS_UPSTREAM_PIN:-}" ]; then
  # The pen door, and it is a door rather than a second mechanism: a control builds two real pin
  # files without needing a remote, and the reading below is the same reading either way.
  [ -f "$REDS_UPSTREAM_PIN" ] && up_pin=$REDS_UPSTREAM_PIN
elif git rev-parse --verify --quiet "$ANOINTED" >/dev/null 2>&1; then
  upwork=$(mktemp -d)
  if git show "$ANOINTED:$PIN" > "$upwork/REDS.md" 2>/dev/null; then
    up_pin=$upwork/REDS.md
  fi
  COMMITS_BEHIND=$(git rev-list --count "HEAD..$ANOINTED" 2>/dev/null || echo unknown)
fi

if [ -n "$up_pin" ]; then
  UPSTREAM_BYTES=$(wc -c < "$up_pin" | tr -d ' ')
  if [ "$UPSTREAM_BYTES" = "$PIN_BYTES" ]; then
    UPSTREAM_STATE=same
  else
    UPSTREAM_STATE=differs
  fi
  # WHICH ROWS, rather than only how many bytes. A byte difference says the page moved; the row
  # sets say WHAT moved. Both pins are read by the one row reader, so they cannot disagree about
  # what a row is.
  rowwork=$(mktemp -d)
  awk -f "$ROWREAD" -v mode=all_rows "$PIN" | sort -u > "$rowwork/here.txt"
  awk -f "$ROWREAD" -v mode=all_rows "$up_pin" | sort -u > "$rowwork/there.txt"
  for r in $(comm -23 "$rowwork/here.txt" "$rowwork/there.txt"); do
    # OBSERVED, never inferred (`%700`'s own sentence, applied to this reading an hour after it was
    # written). A row here and not upstream has TWO causes that look identical from bytes: a peer has
    # folded it, or this lap has just written it and not yet pushed. The first strands a capacity
    # reading; the second is the ordinary state of every lap that books a row. The line names the
    # observation and both readings of it, because guessing between them is what it came to refuse.
    echo "detail: pin_row_ahead_of_upstream %$r -- this pin carries the row and $ANOINTED's does not, which is either a row this lap has yet to push or one a peer has folded; if it is the second, a capacity reading here counts a row the fleet's pin no longer holds"
    AHEAD_OF_UPSTREAM=$((AHEAD_OF_UPSTREAM + 1))
  done
  for r in $(comm -13 "$rowwork/here.txt" "$rowwork/there.txt"); do
    echo "detail: pin_row_only_upstream %$r -- $ANOINTED's pin carries the row and this one does not; this checkout is behind and every reading above is short by that row"
    ONLY_UPSTREAM=$((ONLY_UPSTREAM + 1))
  done
  rm -rf "$rowwork"
  if [ "$UPSTREAM_STATE" = differs ]; then
    echo "detail: pin_upstream_differs -- this clone reads ${PIN_BYTES}B and $ANOINTED reads ${UPSTREAM_BYTES}B, so pin_headroom, rows_that_fit, pin_foldable_rows and pin_deadlocked above describe THIS checkout rather than the fleet's ledger; rebase before acting on them"
  fi
else
  echo "detail: pin_upstream_unread -- $ANOINTED does not resolve here, or carries no $PIN, so every reading above is this clone's alone and nothing checks it"
fi
[ -n "${upwork:-}" ] && rm -rf "$upwork"

if [ "$DEADLOCKED" -eq 1 ]; then
  echo "detail: pin_deadlocked -- $ROWS_THAT_FIT rows fit in ${HEADROOM}B of headroom and $PIN_FOLDABLE of $PIN_ROWS rows are foldable; a new red has nowhere in the pin to go"
  # The foldable case names the command to type (over_bound_foldable, below). The deadlocked case
  # named none, so a lap that met the wall had to re-derive its options -- and on 20260910 five did,
  # in one morning, each asking for a bound raise and one leaving its red cited in the card and in
  # no row at all. A meter that detects a wall and goes quiet about the doors is half a meter.
  echo "detail: pin_unheld -- $PIN_UNHELD of $PIN_OPEN open rows name no hand outside the loop; each is the fleet's own to close, and one closed row makes reds_fold.sh lawful here"
  echo "detail: pin_deadlock_doors -- no fold is lawful while every open row reads OPEN, and the FIRST door is the fleet's own: $PIN_UNHELD of $PIN_OPEN open rows name no hand outside the loop, so a lap that proves one repair on metal and accretes that row's last bold marker to BOOKED makes a fold lawful in the same lap. Where every open row is held, the three doors of %338 stand and each is Keaton's word: raise this page's bound, split OPEN by WHO HOLDS the row, or sanction the single-row shelf birth in reds_fold.sh's contract. Born-on-a-shelf is recorded PRACTICE rather than law -- see construction/archive/REDS-fold-recital.md -- and its cost is a live red where a lap reading the pin will not see it, which shelf_open_rows counts."
fi

echo "pin_bytes=$PIN_BYTES"
echo "pin_upstream_ref=$ANOINTED"
echo "pin_upstream_bytes=$UPSTREAM_BYTES"
echo "pin_upstream_state=$UPSTREAM_STATE"
echo "pin_rows_ahead_of_upstream=$AHEAD_OF_UPSTREAM"
echo "pin_rows_only_upstream=$ONLY_UPSTREAM"
echo "commits_behind=$COMMITS_BEHIND"
echo "pin_bound=$BOUND"
echo "pin_headroom=$HEADROOM"
echo "pin_rows=$PIN_ROWS"
echo "pin_open_rows=$PIN_OPEN"
echo "pin_held_rows=$PIN_HELD"
echo "pin_unheld_rows=$PIN_UNHELD"
echo "pin_unheld_named=$PIN_UNHELD_NAMED"
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
# The one gated cell -- over the declared bound WITH a lawful fold available. See the header table:
# the deadlocked cell beside it stays reported, since only a bound raise helps there and that is
# Keaton's word. Here a lap repairs it in one command, so the remedy is named in the refusal itself.
if [ "$HEADROOM" -lt 0 ] && [ "$PIN_FOLDABLE" -gt 0 ]; then
  echo "detail: over_bound_foldable -- the pin stands ${HEADROOM#-}B above its bound with $PIN_FOLDABLE of $PIN_ROWS rows foldable; write a shelf head and run sh tools/fixtures/r/reds_fold.sh <shelf> <rows> --why '<what they taught together>'"
  echo "verdict=over_bound_foldable"
  exit 1
fi
echo "verdict=ok"
