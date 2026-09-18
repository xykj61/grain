#!/bin/sh
# tools/fixtures/m/mantra_head_door_cost_scan.sh -- both sides of one falsifier, counted in one unit.
#
# WHAT THIS READS, and the page it reads for. REDS %807 says a line inserted at the HEAD of a
# stored document leaves the document. The design page at
# active-designing/date/20260916/20260916-105110_no-anchor-names-the-head.md names three doors out of that, and
# recommends Door C -- a document-start sentinel -- with its own falsifier written in plain words:
#
#   "a count of the places that would have to learn about the sentinel. If that count exceeds the
#    12 place constructions Door B touches, Door B is the cheaper accretion and this
#    recommendation is wrong."
#
# Nobody ran it. This scan does, and it answers in a way the page did not anticipate: the
# falsifier FIRES under its own literal reading and DOES NOT fire once both sides are counted in
# one unit. Both readings are printed; neither is collapsed into the other.
#
# WHY THE TWO READINGS PART. The falsifier compares "places that would have to learn about the
# sentinel" against "place constructions". Those are two different units. A place construction is
# a four-field literal; a place that must learn is any site whose arithmetic changes when the line
# list carries one more entry than the document holds. Counting Door C in the first unit and Door
# B in the second is what makes the comparison answerable only by whoever chooses the unit.
#
# THE THRESHOLD IS READ OFF THE PAGE rather than spelled here, so the day the page moves its own
# number, this guard moves with it. The page's 12 is also checked against the module: it does not
# reproduce, and the reading that does is printed beside it.
#
# THE THREE READINGS PER DOOR.
#
#   DOOR B -- a fourth place field. Its cost is every site that names the order key, since a
#   sibling flag goes exactly where `ord` goes: the four-field literals that construct a place,
#   the struct fields that store one, and every other site naming `.ord`. Comment text is read
#   past, because a doc comment describing the field needs no edit to keep compiling.
#
#   DOOR C -- a document-start sentinel. Its cost is every site reading `lines.items.len`, since
#   the sentinel is an extra entry in that list and every count taken off it moves by one. The
#   sites are CLASSIFIED rather than totalled, in this order:
#
#     free      -- an adjacency walk (`i + 1 < len`) or an insertion index seeded from the length.
#                  Both compare the list against itself, so a sentinel carried by both sides of
#                  the comparison travels free.
#     external  -- the length compared against a ceiling, a record's row count, or a diff's insert
#                  count. The sentinel is in the length and in none of the others, so each of
#                  these must learn.
#     alloc     -- the length cast into a count that sizes an allocation, or asserted equal to a
#                  result's length. A row array sized to include the sentinel writes a row the
#                  record must not carry, so each of these must learn.
#
#   FREE IS TESTED FIRST, and the order is load-bearing: `var at: u32 = @intCast(lines.items.len)`
#   matches both the free rule and the alloc rule, and it is an insertion index rather than an
#   allocation. Testing alloc first would move that one site across the gate.
#
# THE SUBJECT IS MODULE SOURCE, and one file is excluded BY NAME. mantra/src/diff.rye carries two
# `lines.items.len` sites, and its `lines` is the diff's own output list rather than a weave's --
# a different subject wearing the same spelling. It is counted and reported apart, so the
# exclusion is visible rather than silent. Witnesses are counted apart for the same reason: a
# witness that must learn about the sentinel is a real lap, and it is not the cost either door's
# argument is about.
#
# WHAT THIS DOES NOT REACH. Which door the weave walks through. That is a ruling about how places
# are ASSIGNED, and REDS %807 returns it to Keaton exactly as %680 did. This scan puts a number
# beside each door and stops.
#
# Run from the repository root:
#   sh tools/fixtures/m/mantra_head_door_cost_scan.sh [<design page>] [<module source room>]

set -eu

_sp_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_sp_steps=0
while [ ! -d "$_sp_root/rishi/src" ] || [ ! -d "$_sp_root/tools/fixtures" ]; do
  _sp_steps=$((_sp_steps + 1))
  if [ "$_sp_steps" -gt 8 ] || [ "$_sp_root" = "/" ] || [ -z "$_sp_root" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/src and tools/fixtures)" >&2
    exit 2
  fi
  _sp_root=$(dirname "$_sp_root")
done
. "$_sp_root/tools/fixtures/s/shell_portable.sh"

root="$(pwd)"
paper="${1:-$root/active-designing/date/20260916/20260916-105110_no-anchor-names-the-head.md}"
# The module room, so a control may plant into a copy rather than into the tree it is measuring.
src="${2:-$root/mantra/src}"
weave="$src/weave.rye"
main="$src/main.rye"
other="$src/diff.rye"

verdict=ok
note_red() { verdict=red; }

# --- the page, and the number it states about Door B ---
if [ -r "$paper" ]; then
  echo "paper=$(printf '%s' "$paper" | sed "s|^$root/||")"
  echo "paper_readable=yes"
else
  echo "paper_readable=no"
  echo "verdict=red"
  exit 0
fi

paper_threshold=$(grep -oE 'the [0-9]+ place constructions' "$paper" | head -1 | grep -oE '[0-9]+' || true)
if [ -z "${paper_threshold:-}" ]; then
  echo "paper_threshold=absent"
  echo "detail: the page no longer states a falsifier threshold in the form 'the N place constructions'"
  note_red
  paper_threshold=0
else
  echo "paper_threshold=$paper_threshold"
fi

for f in "$weave" "$main" "$other"; do
  [ -r "$f" ] || { echo "subject_absent=$f"; echo "verdict=red"; exit 0; }
done
echo "subjects=2"
echo "subject_1=mantra/src/weave.rye"
echo "subject_2=mantra/src/main.rye"

# --- Door B: every site a sibling of the order key would have to reach ---
#
# A four-field place literal, counted whole: a literal naming three of the four is a row
# construction rather than a place, and would be counted by a looser pattern.
doorb_constructions=$(grep -hE '\.run = .*\.site = .*\.pos = .*\.ord = ' "$weave" "$main" | wc -l | tr -d ' ')
doorb_fields=$(grep -hcE '^    ord: u32,' "$weave" | tr -d ' ')
doorb_ord_all=$(grep -hoE '\.ord\b' "$weave" "$main" | wc -l | tr -d ' ')
doorb_ord_code=$(grep -hE '\.ord\b' "$weave" "$main" | grep -vE '^[[:space:]]*//' | grep -oE '\.ord\b' | wc -l | tr -d ' ')
doorb_same_unit=$((doorb_ord_code + doorb_fields))

echo "doorb_place_constructions=$doorb_constructions"
echo "doorb_place_field_decls=$doorb_fields"
echo "doorb_ord_sites_all=$doorb_ord_all"
echo "doorb_ord_sites_code=$doorb_ord_code"
echo "doorb_same_unit=$doorb_same_unit"

if [ "$doorb_constructions" -eq "$paper_threshold" ]; then
  echo "paper_unit_reproduces=yes"
else
  echo "paper_unit_reproduces=no"
  echo "detail: the page counts $paper_threshold place constructions and the module holds $doorb_constructions"
fi

# --- Door C: every site whose arithmetic moves when the list carries one more entry ---
#
# Free is tested first on purpose; see the header. Every site lands in exactly one class, and the
# unclassified count is printed so a new shape cannot be absorbed in silence.
doorc=$(grep -hE 'lines\.items\.len' "$weave" "$main" | grep -v '///' | awk '
  /i \+ 1 </ || /var at: u32/                                  { free++;     next }
  /max_weave_lines|record\.rows\.len|diff\.inserts\.len/        { external++; next }
  /@intCast|result\.len ==/                                     { alloc++;    next }
                                                                { unread++ }
  END { print (free+0) " " (external+0) " " (alloc+0) " " (unread+0) }')
doorc_free=$(echo "$doorc" | cut -d' ' -f1)
doorc_external=$(echo "$doorc" | cut -d' ' -f2)
doorc_alloc=$(echo "$doorc" | cut -d' ' -f3)
doorc_unread=$(echo "$doorc" | cut -d' ' -f4)
doorc_sites=$((doorc_free + doorc_external + doorc_alloc + doorc_unread))
doorc_must_learn=$((doorc_external + doorc_alloc))

echo "doorc_sites=$doorc_sites"
echo "doorc_free=$doorc_free"
echo "doorc_external=$doorc_external"
echo "doorc_alloc=$doorc_alloc"
echo "doorc_unclassified=$doorc_unread"
echo "doorc_must_learn=$doorc_must_learn"

if [ "$doorc_unread" -ne 0 ]; then
  echo "detail: a count site fell into no class, so this reading is a reading of less than it names"
  note_red
fi

# --- the subject excluded by name, counted so the exclusion is visible ---
other_sites=$(grep -cE 'lines\.items\.len' "$other" | tr -d ' ')
echo "excluded_subject=mantra/src/diff.rye"
echo "excluded_subject_sites=$other_sites"
echo "excluded_reason=its lines is the diff's own output list rather than a weave's"

# --- the witnesses, counted apart and gated by nothing ---
witness_sites=$(grep -hE 'lines\.items\.len' "$src"/*_witness.rye 2>/dev/null | grep -cv '///' || true)
echo "witness_count_sites=${witness_sites:-0}"

# --- the two answers ---
if [ "$doorc_must_learn" -gt "$paper_threshold" ]; then
  echo "falsifier_fires=yes"
else
  echo "falsifier_fires=no"
fi

if [ "$doorc_must_learn" -lt "$doorb_same_unit" ]; then
  echo "same_unit_cheaper=doorc"
elif [ "$doorc_must_learn" -gt "$doorb_same_unit" ]; then
  echo "same_unit_cheaper=doorb"
else
  echo "same_unit_cheaper=tied"
fi

echo "reading=falsifier $doorc_must_learn against $paper_threshold; same unit $doorc_must_learn against $doorb_same_unit"
echo "verdict=$verdict"
