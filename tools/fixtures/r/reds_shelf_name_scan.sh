#!/bin/sh
# tools/fixtures/r/reds_shelf_name_scan.sh -- a fold shelf spells its row number four times, and
# this is where those four spellings are read against one another.
#
# WHY. When a REDS row folds off the living pin onto its own shelf, its number is written into the
# shelf's FILENAME (`...rows-572.md`), into the shelf's H1 TITLE, into a `**Rows:**` header line,
# and into the row HEADLINE itself. Four copies of one fact, edited by one hand in one pass -- and
# `reds_spine_derive_scan.sh`, the only instrument that reads a row's number at all, reads the
# HEADLINE alone. So a renumber sweep that reaches three of the four leaves the shelf disagreeing
# with itself and every standing guard green.
#
# MEASURED `20260907.151832`, which is why this exists. 291 tracked shelves stand in `construction/archive`;
# 63 declare a span in their title and 26 in a `**Rows:**` header. Exactly ONE disagreed:
# `REDS-a-reader-that-walks-past-its-subject-rows-572.md` carried `row %568` in its own H1 while its
# filename, its `**Rows:**` header and its headline all read `%572`. That row had been renumbered
# `%568 -> %566 -> %572` on the anointed spine the lap before, and the sweep reached everything the
# spine guard reads.
#
# WHY THE FILENAME IS THE AUTHORITY here, rather than the headline. The filename is the LINK
# TARGET: 291 living citations open a shelf by path, and a path that moves breaks a promise
# (`reds_citation_scan.sh` guards those citations from the other side). The other three spellings
# are labels a reader reads; the filename is the address a reader arrives at. So the reading asks
# whether each label agrees with the address.
#
# THE THREE READINGS, and why each is shaped narrowly.
#
#   held_outside_span     A headline row whose number falls outside the span the filename declares.
#                         Read with the SAME pattern the spine guard uses -- `**REDS %N (`stamp`)`
#                         -- so a mere mention of another row in prose is never counted as a row
#                         held here. HELD AT ZERO.
#
#   title_disagrees       An H1 ending in a declaration clause -- `, row %N` or `(rows %A-%B)` --
#                         whose span differs from the filename's. Only a TRAILING clause is read.
#                         A title may lawfully name a number as its subject mid-sentence, as
#                         `REDS-one-number-two-rows-364-371.md` does with *the %364 collision*, and
#                         a reading that took every `%N` in the line would call that honest title
#                         wrong. HELD AT ZERO.
#
#   rows_header_disagrees A `**Rows:**` line's declaration -- the backticked `%N` tokens BEFORE the
#                         first ` -- ` -- whose span differs from the filename's. The narration
#                         after the separator is prose and often recites the renumber history, so
#                         `**Rows:** `%545` -- ... the number moved `%540` -> `%542` -> `%545`` is
#                         honest and must pass. HELD AT ZERO.
#
# WHAT PASSES FREE, on purpose. A shelf whose filename names a span WIDER than the rows it holds:
# `REDS-microkernel-arc-rows-80-87.md` holds 82 through 87, because rows 80 and 81 folded elsewhere
# when the archive was reorganised. The span is a range rather than a set, and an endpoint naming a
# row kept somewhere else breaks no link. A shelf holding no readable headline at all -- the elder
# index and recital files -- is counted `unread_shelves` and gated by nothing, since silence makes
# no claim to check.
#
# READINGS
#   shelves_read          -- shelf files examined
#   unread_shelves        -- of those, the ones holding no stamped headline. Reported, never gated.
#   title_declaring       -- shelves whose H1 ends in a declaration clause
#   rows_declaring        -- shelves carrying a `**Rows:**` declaration
#   held_outside_span     -- HELD AT ZERO
#   title_disagrees       -- HELD AT ZERO
#   rows_header_disagrees -- HELD AT ZERO
#   verdict               -- ok, or the first reading that refused
#
# The three counts above the gates are printed because a guard that reports only what it gates
# reads as though it covered the room (REDS %451, %469). `title_declaring` and `rows_declaring` say
# how much of the population actually makes a checkable promise: 63 and 26 of 291 on this tree, so
# the green here means *the shelves that declare, agree* rather than *every shelf is right*.
#
# USAGE
#   sh tools/fixtures/r/reds_shelf_name_scan.sh          # census -- key=value lines
#   sh tools/fixtures/r/reds_shelf_name_scan.sh list     # one line per disagreement, with its file
#   ROOT_DIR=<dir> sh tools/fixtures/r/reds_shelf_name_scan.sh   # read another checkout (the pen)
#
# Exit 0 ok - 1 a gated reading is non-zero - 2 misuse. A misuse exits DIFFERENTLY from a refusal,
# so a caller never reads a broken invocation as a clean archive.
#
# Driven by tools/r/reds_shelf_name_witness.rish. Proven both ways by reds_shelf_name_control.sh.
# Purely local -- no key, no network, no funds, no device.
set -u

SELF_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
ROOT=$SELF_DIR
_steps=0
while [ ! -d "$ROOT/rishi/bin" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
  _steps=$((_steps + 1))
  if [ "$_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done

# The pen hands its own checkout in, so the control plants real files in a real repository and
# reads them the way a lap reads this one.
subject=${ROOT_DIR:-$ROOT}
mode=${1:-census}
case "$mode" in
  census|list) ;;
  *) echo "$0: unknown mode '$mode' -- census or list" >&2; exit 2 ;;
esac

cd "$subject" 2>/dev/null || { echo "$0: cannot enter $subject" >&2; exit 2; }

# Every collection names a maximum (TAME). 4,096 is an order of magnitude above the 291 shelves
# this archive holds and far below anything a shell loop would struggle with.
MAX_SHELVES=4096

# Tracked shelves only. A shelf a clone does not carry is not a promise this tree makes, and an
# untracked file in `construction/archive` is somebody's scratch.
shelf_list=$(git ls-files 'construction/archive/REDS-*rows-*.md' 2>/dev/null || true)

shelves_read=0
unread_shelves=0
title_declaring=0
rows_declaring=0
held_outside_span=0
title_disagrees=0
rows_header_disagrees=0

note() { [ "$mode" = list ] && echo "$1"; }

# The span a name declares: the minimum and maximum of the digit groups after `rows-`.
span_of() {
  printf '%s\n' "$1" | tr -cs '0-9' '\n' | grep -E '^[0-9]+$' | sort -n | sed -n '1p;$p'
}

for f in $shelf_list; do
  [ -f "$f" ] || continue
  shelves_read=$((shelves_read + 1))
  if [ "$shelves_read" -gt "$MAX_SHELVES" ]; then
    echo "detail: shelves exceed the declared maximum of $MAX_SHELVES"
    echo "verdict=too_many_shelves"
    exit 2
  fi

  base=${f##*/}; base=${base%.md}
  tail_part=${base##*rows-}
  set -- $(span_of "$tail_part")
  flo=${1:-}; fhi=${2:-$flo}
  [ -n "$flo" ] || continue

  # 1 -- the rows this shelf actually holds, read with the spine guard's own headline shape.
  held=$(sed -n 's/^\*\*REDS [%#]\([0-9][0-9]*\) *(`[0-9]\{8\}\.[0-9]\{6\}`).*/\1/p' "$f" | sort -n -u)
  if [ -z "$held" ]; then
    unread_shelves=$((unread_shelves + 1))
  else
    outside=$(printf '%s\n' "$held" | awk -v lo="$flo" -v hi="$fhi" '$1 < lo || $1 > hi')
    if [ -n "$outside" ]; then
      held_outside_span=$((held_outside_span + 1))
      note "outside $f names $flo-$fhi and holds $(echo $outside)"
    fi
  fi

  # 2 -- the H1's trailing declaration clause, if it carries one.
  title=$(head -1 "$f")
  decl=$(printf '%s\n' "$title" | sed -n 's/.*[,(] *rows\{0,1\} \(%[0-9]*\(-%\{0,1\}[0-9]*\)*\))\{0,1\} *$/\1/p')
  if [ -n "$decl" ]; then
    title_declaring=$((title_declaring + 1))
    set -- $(span_of "$decl")
    tlo=${1:-}; thi=${2:-$tlo}
    if [ "$tlo" != "$flo" ] || [ "$thi" != "$fhi" ]; then
      title_disagrees=$((title_disagrees + 1))
      note "title $f names $flo-$fhi and its title declares $tlo-$thi"
    fi
  fi

  # 3 -- the `**Rows:**` declaration, taken before the ` -- ` that opens its narration.
  rowsline=$(grep -m1 '^\*\*Rows:' "$f" 2>/dev/null || true)
  if [ -n "$rowsline" ]; then
    head_part=${rowsline%% -- *}
    claim=$(printf '%s\n' "$head_part" | grep -o '`%[0-9][0-9]*`' | tr -d '`%')
    if [ -n "$claim" ]; then
      rows_declaring=$((rows_declaring + 1))
      set -- $(span_of "$(echo $claim)")
      rlo=${1:-}; rhi=${2:-$rlo}
      if [ "$rlo" != "$flo" ] || [ "$rhi" != "$fhi" ]; then
        rows_header_disagrees=$((rows_header_disagrees + 1))
        note "rows $f names $flo-$fhi and its Rows header declares $rlo-$rhi"
      fi
    fi
  fi
done

echo "shelves_read=$shelves_read"
echo "unread_shelves=$unread_shelves"
echo "title_declaring=$title_declaring"
echo "rows_declaring=$rows_declaring"
echo "held_outside_span=$held_outside_span"
echo "title_disagrees=$title_disagrees"
echo "rows_header_disagrees=$rows_header_disagrees"

if [ "$held_outside_span" -ne 0 ]; then echo "verdict=held_outside_span"; exit 1; fi
if [ "$title_disagrees" -ne 0 ]; then echo "verdict=title_disagrees"; exit 1; fi
if [ "$rows_header_disagrees" -ne 0 ]; then echo "verdict=rows_header_disagrees"; exit 1; fi
echo "verdict=ok"
exit 0
