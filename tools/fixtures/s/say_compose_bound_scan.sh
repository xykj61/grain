#!/bin/sh
# tools/fixtures/s/say_compose_bound_scan.sh -- which Rishi guards compose a captured output into a
# bounded string, and so can fail for having something to say?
#
# WHY THIS EXISTS. Rishi composes an interpolated string into `StrBuf`, a fixed buffer declared in
# `rishi/src/main.rye`, and a composition past that width returns `error.StringTooLong` and stops the
# script. So a witness that writes `say "reading -- ${scan.out}"` is making a silent promise that its
# scan's output will stay under that width forever, and a scan's output grows with the tree it reads.
#
# THE LANTERN HAS FIRED FOUR TIMES, each repaired where it landed and each lesson written into a
# different file's comments, which is how a fault that is really one class reads as four accidents:
#
#   tools/r/reds_spine_derive_witness.rish   the guard passed every assert and died reporting, once
#                                            the ledger reached 42 lawful stamp duplicates and the
#                                            scan printed 4,250 bytes (`20260907.232343`)
#   tools/fixtures/r/readme_metrics_splice.sh   an 18 KB file overran the same bound
#   tools/fixtures/t/tame_style_long_fn.rish    interpolating a scan's blob into a command refused
#   tools/fixtures/t/tame_style_long_fn_scan.sh the same lesson, written a second time
#
# A lantern that fires twice becomes a loom (`.claude/rules/reds-first.md`). This is the loom.
#
# THE TREE ALREADY KNOWS THE ANSWER, which is what makes this a ratchet rather than a design
# question. A bare `say scan.out` writes the captured value straight out and never opens a `StrBuf`
# at all, so it can never refuse however large the reading grows. Measured `20260908.014200`: 1,015
# sites already spell it that way. The repair at every hazard site is that same two-line shape --
# `say "prefix"` on its own line, then `say scan.out` -- and it loses nothing, which is the second
# reason this is a ratchet: no reader is asked to give up a diagnosis to satisfy it.
#
# TWO HAZARD SHAPES, COUNTED APART, because they fail at different moments and a refusal that
# cannot say which is owed leaves a reader with a number and no act (REDS %528):
#
#   eager     a `say "..."` line interpolating a captured `.out` or `.err`. This composes on EVERY
#             run, so it reds a GREEN tree the day its scan's output crosses the width -- the
#             `reds_spine_derive` firing exactly. A guard that reds because it succeeded at
#             reporting is a guard ships learn to read past.
#   deferred  an `assert` whose `else` clause interpolates one. This composes only on FAILURE, which
#             is the worse half of the same fault: the one message that cannot be built is the one
#             describing a real disagreement, so the explanation fails exactly when it is owed.
#
#   safe      a bare `say <name>.out` -- reported as the population that already holds the answer,
#             never gated, so a reader can see the repair is ordinary rather than novel.
#
# WHAT THIS DOES NOT REACH, said plainly. Whether any particular site's value is ANYWHERE NEAR the
# width today. Answering that means running every guard and measuring its output, which is a
# different instrument and a much more expensive one; this reads shapes. So the two counts are a
# hazard census rather than a list of imminent failures, and they are ratchets for that reason --
# gating them at zero would refuse a tree for a backlog nobody created today.
#
# It also does not reach interpolation into a `run` command, which composes through the same buffer.
# That shape is real -- `tame_style_long_fn.rish` is one -- and it wants its own reading, since a
# command's parts are usually short by construction and a blanket count would drown these two.
#
#   sh tools/fixtures/s/say_compose_bound_scan.sh          # the readings
#   sh tools/fixtures/s/say_compose_bound_scan.sh list     # every hazard site, file:line, one per line
#
# Exit 0 when both counts sit at or under their ceilings, 1 when either is past, 2 on misuse or when
# an instrument this scan depends on cannot answer. No network, no key, no funds, no device.

set -u

# One collation for the whole script, so a sort here and a comparison anywhere else agree about the
# alphabet -- the fault that read ten phantom desks one room over.
LC_ALL=C
export LC_ALL

# Root by upward walk (seated 20260828): the letter fold moves this script's depth, so fixed ../..
# arithmetic breaks. Git-free where it can be, so a pen copy still resolves.
ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_sc_steps=0
while [ ! -d "$ROOT/tools/fixtures" ] || [ ! -d "$ROOT/rishi" ]; do
  _sc_steps=$((_sc_steps + 1))
  if [ "$_sc_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "say_compose_bound: no tree root within 8 steps (needs tools/fixtures and rishi)" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done
cd "$ROOT" || exit 2

mode=readings
if [ "$#" -gt 0 ]; then
  case "$1" in
    list) mode=list; shift ;;
    *) echo "verdict=misuse_unknown_arg ($1)" >&2; exit 2 ;;
  esac
fi
[ "$#" -eq 0 ] || { echo "verdict=misuse_extra_args" >&2; exit 2; }

# THE WIDTH IS READ, NEVER SPELLED. `StrBuf` is Rishi's own declaration, and a number copied into a
# meter goes stale the lap somebody widens the buffer -- with the meter still reciting the old one
# and reading perfectly. So the door above quotes no figure that this line does not derive.
RISHI_SRC=${SAY_COMPOSE_RISHI_SRC:-rishi/src/main.rye}
strbuf_bytes=absent
if [ -f "$RISHI_SRC" ]; then
  strbuf_bytes=$(awk '
    /const StrBuf = struct/ { inbuf = 1 }
    inbuf && match($0, /bytes: \[[0-9]+\]/) {
      s = substr($0, RSTART, RLENGTH); gsub(/[^0-9]/, "", s); print s; exit
    }
  ' "$RISHI_SRC")
  [ -n "$strbuf_bytes" ] || strbuf_bytes=unreadable
fi
# A width nobody could read is reported rather than guessed at. The counts below stand on their own
# -- they read shapes, not sizes -- so an unreadable declaration weakens the door's explanation
# without weakening the reading, and saying so is what keeps the two apart.

# The population: every tracked Rishi script. Tracked rather than found, because an untracked
# scratch file is not something this tree promises anybody, and a guard that counts scratch reds on
# work nobody shipped.
WORK=$(mktemp -d 2>/dev/null) || { echo "say_compose_bound: no temporary directory" >&2; exit 2; }
trap 'rm -rf "$WORK"' EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

if ! git ls-files '*.rish' > "$WORK/files" 2>/dev/null; then
  echo "say_compose_bound: git could not list the tracked Rishi scripts" >&2
  exit 2
fi
files=$(grep -c . "$WORK/files" || true)

# Bound: the tree held 2,415 tracked .rish files on `20260908.014200` and grows by a few a round.
# 16384 is a power of two well above that -- high enough never to refuse honest growth, low enough
# that a generator writing scripts in a loop is named rather than scanned forever.
MAX_FILES=16384
if [ "$files" -gt "$MAX_FILES" ]; then
  echo "say_compose_bound: $files tracked scripts past the bound of $MAX_FILES" >&2
  exit 2
fi
if [ "$files" -eq 0 ]; then
  echo "verdict=no_scripts"
  exit 2
fi

# THE INTERPOLATION, matched as Rishi actually spells it: `${name.out}` or `${name.err}`. A comment
# line is read past, since a `#` line is prose about the shape rather than the shape itself -- the
# same discrimination the sample-permission reading makes one room over, and for the same reason: a
# door teaching against a fault must not be counted as committing it.
: > "$WORK/eager"
: > "$WORK/deferred"
: > "$WORK/safe"
while IFS= read -r f; do
  [ -f "$f" ] || continue
  awk -v path="$f" '
    /^[[:space:]]*#/ { next }
    {
      captured = ($0 ~ /\$\{[A-Za-z_][A-Za-z_0-9]*\.(out|err)\}/)
      if (captured && $0 ~ /^[[:space:]]*say[[:space:]]+"/) { print "eager\t" path ":" FNR "\t" $0; next }
      if (captured && $0 ~ /^[[:space:]]*assert[[:space:]]/)  { print "deferred\t" path ":" FNR "\t" $0; next }
      if ($0 ~ /^[[:space:]]*say[[:space:]]+[A-Za-z_][A-Za-z_0-9]*\.(out|err)[[:space:]]*$/) { print "safe\t" path ":" FNR "\t" $0 }
    }
  ' "$f" >> "$WORK/all"
done < "$WORK/files"
[ -f "$WORK/all" ] || : > "$WORK/all"

awk -F'\t' '$1 == "eager"    { print $2 "\t" $3 }' "$WORK/all" > "$WORK/eager"
awk -F'\t' '$1 == "deferred" { print $2 "\t" $3 }' "$WORK/all" > "$WORK/deferred"
awk -F'\t' '$1 == "safe"     { print $2 "\t" $3 }' "$WORK/all" > "$WORK/safe"

eager=$(grep -c . "$WORK/eager" || true)
deferred=$(grep -c . "$WORK/deferred" || true)
safe=$(grep -c . "$WORK/safe" || true)

# THE CEILINGS ARE SHARES, NOT COUNTS, AND THAT WAS LEARNED THE HARD WAY INSIDE ONE ROUND.
# The first draft held raw ceilings at exactly what stood when it was written -- 502 and 1,741 --
# on the ordinary ratchet argument. Eight ships write into this tree, every one of them landing new
# witnesses, and the rebase at the end of that same round brought two peers' guards in and carried
# `deferred` to 1,744. The ratchet refused, over work nobody did wrong: writing a new guard is the
# most ordinary act on this pier, and a ratchet that reds on ordinary work is a ratchet somebody
# turns off (the shape `%330`'s family booked one room over, met here within the hour).
#
# The population itself grows, so a count is the wrong measure of it. What the readings are actually
# about is a HABIT -- of the sites that could reach for the safe shape, how many do -- and a share
# says that where a count cannot. A guard written the safe way lowers the share; one written the
# hazardous way raises it; a hundred guards written either way leave a tree that has not changed its
# habit reading exactly where it stood.
#
# Per mille rather than percent, in integers, because a shell has no floats and a percent rounds
# 3,262 sites into steps of 33 -- coarse enough to hide a whole lap's worth of drift.
#
# THE SLACK IS NAMED AND SMALL. Measured `20260908.030000`: eager 153, deferred 534 per mille of the
# 3,262 sites carrying any of the three shapes. The ceilings sit two and three per mille above, which
# is room for the two or three sites an ordinary lap adds and no room at all for twenty -- a lap
# landing twenty deferred sites at once reads 690 and refuses. Slack chosen from the measured rate
# of ordinary growth rather than from comfort, and it only falls.
EAGER_PER_MILLE_CEILING=${SAY_COMPOSE_EAGER_CEILING:-155}
DEFERRED_PER_MILLE_CEILING=${SAY_COMPOSE_DEFERRED_CEILING:-537}

# The denominator is every site carrying any of the three shapes, so it moves with the tree exactly
# as the numerators do. A tree with none of them answers zero rather than dividing by nothing.
shaped=$((eager + deferred + safe))
if [ "$shaped" -eq 0 ]; then
  eager_per_mille=0
  deferred_per_mille=0
else
  eager_per_mille=$((eager * 1000 / shaped))
  deferred_per_mille=$((deferred * 1000 / shaped))
fi

if [ "$mode" = list ]; then
  awk -F'\t' '{ print "eager    " $1 }' "$WORK/eager"
  awk -F'\t' '{ print "deferred " $1 }' "$WORK/deferred"
  exit 0
fi

# NAMED, NEVER MERELY COUNTED (REDS %592). A count with no paths tells a reader a quantity and
# leaves them to find the sites, which is the second half of a guard nobody runs. Ten of each, then
# the remainder, and `list` prints them all -- the diagnosis is bounded where the count is not,
# which is the very lesson the reds_spine_derive firing taught this same week.
NAMED=10
head -"$NAMED" "$WORK/eager" | while IFS="$(printf '\t')" read -r site _; do
  [ -n "$site" ] && echo "detail: eager $site -- composes every run; split into a bare \`say <name>.out\` on its own line"
done
if [ "$eager" -gt "$NAMED" ]; then
  echo "detail: and $((eager - NAMED)) further eager sites -- \`sh $0 list\` prints them all"
fi
head -"$NAMED" "$WORK/deferred" | while IFS="$(printf '\t')" read -r site _; do
  [ -n "$site" ] && echo "detail: deferred $site -- composes on failure, when the explanation is owed"
done
if [ "$deferred" -gt "$NAMED" ]; then
  echo "detail: and $((deferred - NAMED)) further deferred sites -- \`sh $0 list\` prints them all"
fi

echo "scripts=$files"
echo "strbuf_bytes=$strbuf_bytes"
echo "eager=$eager"
echo "eager_per_mille=$eager_per_mille"
echo "eager_per_mille_ceiling=$EAGER_PER_MILLE_CEILING"
echo "deferred=$deferred"
echo "deferred_per_mille=$deferred_per_mille"
echo "deferred_per_mille_ceiling=$DEFERRED_PER_MILLE_CEILING"
echo "safe=$safe"
echo "shaped=$shaped"

if [ "$eager_per_mille" -gt "$EAGER_PER_MILLE_CEILING" ]; then
  echo "verdict=over_eager_ceiling"
  echo "refused: a larger share of sites compose a captured output eagerly -- each will refuse the day its scan grows" >&2
  exit 1
fi
if [ "$deferred_per_mille" -gt "$DEFERRED_PER_MILLE_CEILING" ]; then
  echo "verdict=over_deferred_ceiling"
  echo "refused: a larger share of asserts compose a captured output in their else clause -- each fails when the explanation is owed" >&2
  exit 1
fi
echo "verdict=ok"
exit 0
