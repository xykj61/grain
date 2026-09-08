#!/bin/sh
# tools/fixtures/s/store_shape_control.sh -- proves tools/fixtures/s/store_shape_census.sh reads
# what it claims to read, by building record sets of a KNOWN shape in a throwaway pen and watching
# the census answer them, then moving one line and watching the answer move with it.
#
# WHY A DATA PEN RATHER THAN ONLY SCAN PLANTS. This census's whole output is a claim about a shape,
# and a shape is a property of DATA. Planting a fault into a copy of the scan proves the code is
# load-bearing; building records whose shape is known before the census reads them proves the code
# is RIGHT. Both are here, and the second is the one that would catch a census that always answers
# `two_shapes` because that is what its author expected to see.
#
# WHY BOTH DIRECTIONS, EVERY TIME. A refusal proven only in the direction that fires cannot be told
# from a bypass. Each plant below is applied, read, and lifted, and the lifted reading must return
# to the unplanted one.
#
# THE PLANTS THAT EARN THEIR PLACE:
#
#   THE VERDICT FLIPS ON DATA, because a verdict that never moves is a printed constant. A journal
#   whose records carry no repeated field must read `one_shape`, and a registry given one repeated
#   field in one row must read `one_shape` too -- the second is the sharper half, since it is the
#   claim the paper leans on hardest.
#
#   THE ANCHORED FIELD PATTERN, because a looser one inverts the finding. Counting every line as a
#   column makes a row carrying two `#` notes read as multi-valued; over the real
#   `standing-equipment.kyri` that is 108 of 235 rows, which would report the registries as
#   document-shaped and turn the paper's conclusion upside down. This plant also RETIRED A LINE:
#   the census opened with a `grep -v '^#'` strip ahead of the pattern, the plant that removed the
#   strip changed no number, and the strip left rather than the check.
#
#   THE CEILING, from both sides, because a census that walks a growing room and truncates in
#   silence reads exactly like a small room.
#
#   THE UNREAD COUNT, because it is the census's own printed blind spot. A line this reading passes
#   over must be counted rather than ignored, or the blind spot is a claim instead of a number.
#
#   sh tools/fixtures/s/store_shape_control.sh

set -u

_fd_root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
_fd_steps=0
while [ ! -d "$_fd_root/rishi/bin" ] || [ ! -d "$_fd_root/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$_fd_root" = "/" ] || [ -z "$_fd_root" ]; then
    echo "$0: no tree root within 8 steps" >&2; exit 2
  fi
  _fd_root=$(dirname "$_fd_root")
done
. "$_fd_root/tools/fixtures/p/plant.sh"

SCAN=tools/fixtures/s/store_shape_census.sh
PEN="${TMPDIR:-/tmp}/store_shape_control.$$"
trap 'rm -rf "$PEN"' EXIT INT TERM
mkdir -p "$PEN" || exit 1
cd "$_fd_root" || exit 2
pass=0; fail=0
note() { printf '%s %s\n' "$1" "$2"; if [ "$1" = "ok" ]; then pass=$((pass+1)); else fail=$((fail+1)); fi }

# ---- a record set whose shape is known before the census reads it -------------------------------
#
# Six journal records: five carrying a repeated `think` (multi-valued), one carrying none. Five of
# six is 83%, over the 50% the verdict wants. One registry of four rows, three columns, no row
# carrying a field twice. So the pen is a small, deliberate copy of what the tree reads.
build_pen() {
  rm -rf "$PEN/d"; mkdir -p "$PEN/d/journal" "$PEN/d/registry"
  i=1
  while [ "$i" -le 5 ]; do
    printf 'format pen\nstamp 2026\nthink one\nthink two\nfile a\n' > "$PEN/d/journal/r$i.kyri"
    i=$((i + 1))
  done
  printf 'format pen\nstamp 2026\nthink alone\n' > "$PEN/d/journal/r6.kyri"
  printf '# a comment inside the table, which is prose about a row and never a column\n' > "$PEN/d/registry/t.kyri"
  printf 'row a\ncol 1\n# a note about this row\nseat x\n# and a second note, so an unstripped comment would repeat\nrow b\ncol 2\nseat y\nrow c\ncol 3\nseat z\nrow d\ncol 4\nseat w\n' >> "$PEN/d/registry/t.kyri"
}
census() { STORE_SHAPE_PEN="$PEN/d" sh "$1" "${2:-}" 2>&1; }

build_pen
BASE=$(census "$SCAN")

expect_line() {
  if printf '%s\n' "$3" | grep -q "^$2\$"; then note ok "$1"
  else note RED "$1 -- absent: $2"; fi
}

# ---- the pen reads exactly the shape it was built with -----------------------------------------
expect_line "six journal records counted" "journal_records=6" "$BASE"
expect_line "five of six carry a repeated field" "journal_multivalued_records=5" "$BASE"
expect_line "the widest field is the one repeated" "journal_widest_field=think" "$BASE"
expect_line "four registry rows, none multi-valued" "registry_multivalued_rows=0" "$BASE"
expect_line "the share is computed, not assumed" "journal_multivalued_share_pct=83" "$BASE"
expect_line "a known two-shape set reads two_shapes" "verdict=two_shapes" "$BASE"

# ---- determinism, because a census read twice must answer twice the same ------------------------
A=$(census "$SCAN"); B=$(census "$SCAN")
if [ "$A" = "$B" ]; then note ok "two runs over one pen agree line for line"
else note RED "two runs disagree"; fi

# ---- the verdict flips when the JOURNAL loses its repeats ---------------------------------------
build_pen
i=1
while [ "$i" -le 5 ]; do
  printf 'format pen\nstamp 2026\nthink one\nfile a\n' > "$PEN/d/journal/r$i.kyri"
  i=$((i + 1))
done
FLAT=$(census "$SCAN")
expect_line "a journal with no repeats reads one_shape" "verdict=one_shape" "$FLAT"
expect_line "and says so with a zero share" "journal_multivalued_share_pct=0" "$FLAT"
build_pen
LIFT=$(census "$SCAN")
if [ "$LIFT" = "$BASE" ]; then note ok "lifting the journal plant returns the original reading"
else note RED "the journal plant did not lift cleanly"; fi

# ---- the verdict flips when ONE REGISTRY ROW gains a repeated field ------------------------------
#
# This is the half the paper leans on: the claim is not that journals repeat, it is that registry
# rows do NOT. One repeated field in one row of four must be enough to move the answer.
build_pen
printf 'row e\ncol 5\ncol 6\nseat v\n' >> "$PEN/d/registry/t.kyri"
RAGGED=$(census "$SCAN")
expect_line "one repeated field in one registry row reads one_shape" "verdict=one_shape" "$RAGGED"
expect_line "and the row is counted rather than merely noticed" "registry_multivalued_rows=1" "$RAGGED"
build_pen
LIFT=$(census "$SCAN")
if [ "$LIFT" = "$BASE" ]; then note ok "lifting the registry plant returns the original reading"
else note RED "the registry plant did not lift cleanly"; fi

# ---- the anchored field pattern is load-bearing, proven by loosening it --------------------------
#
# The pen's registry carries two `#` notes inside one row block. Loosened to accept any line, that
# row reads two columns named `#` and the registry population turns document-shaped -- the finding
# inverted by one regular expression.
cp "$SCAN" "$PEN/loose.sh"
if plant_apply "$PEN/loose.sh" 's|n \&\& /\^\[a-z_\]\[a-z0-9_\]\* / { buf = buf " " \$1 }|n \&\& /^./ { buf = buf " " $1 }|' field_anchor
then note ok "plant field_anchor landed"
else note RED "plant field_anchor matched nothing -- the line it names has moved"; fi
build_pen
LOOSE=$(census "$PEN/loose.sh")
if printf '%s\n' "$LOOSE" | grep -q '^registry_multivalued_rows=0$'
then note RED "loosening the field pattern changed nothing -- the anchor is not load-bearing"
else note ok "loosening the field pattern makes a comment read as a column"; fi
LIFT=$(census "$SCAN")
if [ "$LIFT" = "$BASE" ]; then note ok "the tree scan is untouched by the pen plant"
else note RED "the tree scan moved"; fi

# ---- the ceiling refuses rather than truncating, and does so only past the bound -----------------
OVER=$(STORE_SHAPE_PEN="$PEN/d" STORE_SHAPE_MAX=3 sh "$SCAN" 2>&1 || :)
if printf '%s\n' "$OVER" | grep -q 'refused: journal holds 6 records above the named ceiling of 3'
then note ok "a record set past the ceiling refuses and names both numbers"
else note RED "the ceiling did not refuse"; fi
AT=$(STORE_SHAPE_PEN="$PEN/d" STORE_SHAPE_MAX=6 sh "$SCAN" 2>&1 || :)
if printf '%s\n' "$AT" | grep -q '^verdict=two_shapes$'
then note ok "a record set standing exactly at the ceiling walks free"
else note RED "the ceiling bites one record early"; fi

# ---- the unread count is a number rather than a promise ------------------------------------------
build_pen
printf 'A line starting with a capital carries no field name, so this reading passes over it\n' >> "$PEN/d/journal/r6.kyri"
UNREAD=$(census "$SCAN")
expect_line "a line this reading passes over is counted" "journal_unread_lines=1" "$UNREAD"
build_pen

# ---- an unknown leg refuses rather than silently running everything -------------------------------
BAD=$(STORE_SHAPE_PEN="$PEN/d" sh "$SCAN" schema 2>&1 || :)
if printf '%s\n' "$BAD" | grep -q 'refused: unknown leg'
then note ok "an unknown leg refuses by name"
else note RED "an unknown leg did not refuse"; fi

# ---- the shape leg alone says so rather than guessing ---------------------------------------------
SOLO=$(census "$SCAN" shape)
if printf '%s\n' "$SOLO" | grep -q 'verdict=partial'
then note ok "the shape leg alone reports partial rather than inventing a verdict"
else note RED "the shape leg alone invented a verdict"; fi

# ---- an absent pen refuses ------------------------------------------------------------------------
GONE=$(STORE_SHAPE_PEN="$PEN/absent" sh "$SCAN" 2>&1 || :)
if printf '%s\n' "$GONE" | grep -q 'refused: STORE_SHAPE_PEN names no directory'
then note ok "a pen that is not there refuses by name"
else note RED "an absent pen did not refuse"; fi

printf '\nbehaviors=%d\nfaults=%d\n' "$((pass + fail))" "$fail"
if [ "$fail" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=faulted"; exit 1; fi
