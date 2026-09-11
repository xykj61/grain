#!/bin/sh
# tools/fixtures/g/glow_desk_arity_scan.sh -- do the three statements of a desk's arity agree?
#
# WHY THIS EXISTS. How many sample arguments a Glow desk takes is written down three times, in
# three files, by three different hands:
#
#   the desk      a `::  Sample: 3 5` line in its own head band -- the values that prove it
#   the worker    tools/g/glow_run_worker.sh, which accepts a set of counts per stem
#   the lowering  glow/glow_run.rye --sample-argv, whose emitted Rye reads argv[1..N]
#
# REDS %532 named the worker's copy as the third hand-written enumeration of this corpus and
# repaired the other two -- runnability, read from two markers, and coverage, derived from the
# room. Arity stayed underived, and its own row predicted the fourth: a sampled desk needs "a
# sample value somebody must choose, and then a fourth hand-written enumeration to hold the
# answers." That fourth arrived as the `Sample:` line. So the count now stands in three places
# and, until this meter, in no check.
#
# Measured 20260910: all three agree, across 46 sampled desks, exactly. That agreement is real
# and it is the same agreement %532 found among its three enumerations -- perfect, complete, and
# stored in nobody's instrument. This is the instrument.
#
# WHAT MADE IT ASKABLE. The worker stated its arity only as the shape of what it refused: a nest
# of `test "$NARGS" -eq N` branches, which a meter could read only by parsing shell or by probing
# with wrong counts. `arity_accepts()` states the counts once and `--arity` prints that statement,
# so this scan asks the worker its own question rather than keeping a fourth copy of the answer.
#
# WHAT IT READS. Every *.glow under glow/gen. Four readings are gated at zero and three report.
#
#   desks             every *.glow in the room
#   permitted         desks whose stem the worker accepts a sample for
#   declared          permitted desks carrying a `::  Sample:` line
#   arity_unanswered  permitted desks the worker answers with no counts   -- GATED AT ZERO
#   contract_split    declared count outside the worker's accepted set    -- GATED AT ZERO
#   sample_unpermitted  a desk declaring a Sample the worker would refuse -- GATED AT ZERO
#   lowering_split    declared count against the lowering's own argv gate -- GATED AT ZERO
#   lowering_read     permitted desks whose argv-sample lowering answered
#   lowering_unread   permitted desks whose lowering emits no argv gate   -- reported
#
# WHY THE LOWERING READING TAKES THE MAXIMUM ARGV GATE. A tag desk's emitted program checks
# `argv.len < 2` for the tag, branches on its value, and checks `argv.len < 3` inside the mint
# arm -- so its FIRST gate is a floor of one argument and its arity is neither that floor nor a
# single number. Reading the first gate called four desks split when nothing was wrong;
# the maximum is the count the declared sample actually has to satisfy. Two shapes of check meet
# here and only one is exact: the worker demands a count, the emitted program demands a floor and
# ignores anything past it.
#
# WHY contract_split AND lowering_split ARE SEPARATE GATES. Each answers one question, per the
# single-stranded discipline. A desk disagreeing with the worker fails loudly at the run, with a
# named refusal a reader can act on. A desk disagreeing with the LOWERING passes the worker and
# then returns 2 from a program that read fewer arguments than the desk believed it had, which
# reads as a failing gate rather than as a miscount. A reader repairing one must not have to
# reason about the other.
#
# WHY sample_unpermitted IS GATED RATHER THAN REPORTED. A `Sample:` line the worker would refuse
# is a promise the tree cannot keep: the desk says how to run it and the one runner declines the
# argument by name. It costs one line in the worker's list to fix and it is invisible from either
# file alone.
#
# Usage:
#   sh tools/fixtures/g/glow_desk_arity_scan.sh            # the readings
#   sh tools/fixtures/g/glow_desk_arity_scan.sh --explain  # every split named, desk by desk
#
# Overrides, for the control's pen only:
#   GLOW_DESK_DIR     the desk room to read
#   GLOW_DESK_WORKER  the worker to ask
#   GLOW_ARITY_LOWER  a stub standing in for `glow/bin/glow_run --sample-argv`

set -eu

_fd_root=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
cd "$_fd_root"

DESK_DIR=${GLOW_DESK_DIR:-glow/gen}
WORKER=${GLOW_DESK_WORKER:-tools/g/glow_run_worker.sh}
LOWER=${GLOW_ARITY_LOWER:-glow/bin/glow_run}

explain=no
while [ $# -gt 0 ]; do
  case "$1" in
    --explain) explain=yes; shift ;;
    *) echo "refused: unknown argument '$1' -- takes --explain" >&2; exit 2 ;;
  esac
done

test -d "$DESK_DIR" || {
  echo "refused: no desk room at $DESK_DIR" >&2
  exit 2
}
test -f "$WORKER" || {
  echo "refused: no worker at $WORKER" >&2
  exit 2
}

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT INT TERM

# LC_ALL=C so every sort and comparison here reads one alphabet. A meter that sorts and a meter
# that compares must agree about collation, which cost the sibling scan ten phantom desks
# (REDS %532).
export LC_ALL=C

find "$DESK_DIR" -name '*.glow' | sort > "$WORK/desks"
desks=$(wc -l < "$WORK/desks" | tr -d ' ')

# The worker answers which stems it permits a sample for, read from its `case` PATTERN lines
# rather than by grepping the file for stem-shaped words, so a stem named in a comment is never
# mistaken for a permission. Same reading as glow_desk_reach_scan.sh, on purpose: two meters
# asking one file a different way is how the two come to disagree.
awk '
  /^[[:space:]]*#/ { next }
  /^[[:space:]]*[A-Za-z0-9_*|-]+\)[[:space:]]*$/ ||
  /^[[:space:]]*[A-Za-z0-9_*|-]+\)[[:space:]]+/ {
    line=$0
    sub(/\).*$/, "", line)
    gsub(/^[[:space:]]+/, "", line)
    n=split(line, parts, "|")
    for (i=1; i<=n; i++) if (parts[i] != "*" && parts[i] != "") print parts[i]
  }
' "$WORKER" | sort -u > "$WORK/permit"

permitted=0
declared=0
arity_unanswered=0
contract_split=0
sample_unpermitted=0
lowering_split=0
lowering_read=0
lowering_unread=0
: > "$WORK/splits"

while IFS= read -r desk; do
  stem=$(basename "$desk" .glow)
  # The head band is where a desk states its own sample, and six lines is the band the runner
  # reads. One `Sample:` line wins: a desk saying it twice has said one thing twice.
  args=$(head -6 "$desk" | sed -n 's/^::[[:space:]]*Sample:[[:space:]]*//p' | head -1)
  if grep -qxF "$stem" "$WORK/permit"; then
    permitted=$((permitted + 1))
  else
    if [ -n "$args" ]; then
      sample_unpermitted=$((sample_unpermitted + 1))
      printf 'sample_unpermitted %s -- head declares "%s", the worker permits no argument\n' \
        "$desk" "$args" >> "$WORK/splits"
    fi
    continue
  fi

  accepts=$(sh "$WORKER" --arity "$desk" 2>/dev/null | sed -n 's/^accepts=//p' | head -1)
  if [ -z "$accepts" ]; then
    arity_unanswered=$((arity_unanswered + 1))
    printf 'arity_unanswered %s -- the worker named no accepted count\n' "$desk" >> "$WORK/splits"
    continue
  fi

  [ -n "$args" ] || continue
  declared=$((declared + 1))
  count=$(printf '%s\n' $args | grep -c . || true)

  ok=no
  for k in $accepts; do
    if [ "$count" -eq "$k" ]; then ok=yes; fi
  done
  if [ "$ok" = no ]; then
    contract_split=$((contract_split + 1))
    printf 'contract_split %s -- head declares %s argument(s), worker accepts [%s]\n' \
      "$desk" "$count" "$accepts" >> "$WORK/splits"
  fi

  # The lowering is the only one of the three that is DERIVED, so it is the anchor rather than a
  # peer. It answers only where the argv-sample road accepts the desk at all.
  if [ -x "$LOWER" ]; then
    rye=$("$LOWER" --sample-argv "$desk" 2>/dev/null || true)
    if [ -n "$rye" ] && [ -f "$rye" ]; then
      gate=$(grep -o 'argv\.len < [0-9]*' "$rye" | grep -o '[0-9]*$' | sort -n | tail -1)
      if [ -n "$gate" ]; then
        lowering_read=$((lowering_read + 1))
        want=$((gate - 1))
        if [ "$count" -ne "$want" ]; then
          lowering_split=$((lowering_split + 1))
          printf 'lowering_split %s -- head declares %s argument(s), the emitted program reads %s\n' \
            "$desk" "$count" "$want" >> "$WORK/splits"
        fi
      else
        lowering_unread=$((lowering_unread + 1))
      fi
    else
      lowering_unread=$((lowering_unread + 1))
    fi
  fi
done < "$WORK/desks"

lowering_built=no
if [ -x "$LOWER" ]; then lowering_built=yes; fi

echo "desk_dir=$DESK_DIR"
echo "worker=$WORKER"
echo "desks=$desks"
echo "permitted=$permitted"
echo "declared=$declared"
echo "arity_unanswered=$arity_unanswered"
echo "contract_split=$contract_split"
echo "sample_unpermitted=$sample_unpermitted"
echo "lowering_built=$lowering_built"
echo "lowering_read=$lowering_read"
echo "lowering_unread=$lowering_unread"
echo "lowering_split=$lowering_split"

if [ "$explain" = yes ]; then
  if [ -s "$WORK/splits" ]; then
    sed 's/^/detail: /' "$WORK/splits"
  else
    echo "detail: the three statements agree on every sampled desk in $DESK_DIR"
  fi
fi

faults=$((arity_unanswered + contract_split + sample_unpermitted + lowering_split))
echo "faults=$faults"
if [ "$faults" -eq 0 ]; then
  echo "verdict=agree"
else
  echo "verdict=split"
fi
