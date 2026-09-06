#!/bin/sh
# tools/fixtures/u/unheard_guard_scan.sh -- a guard that is never run guards nothing.
#
# WHAT THIS IS FOR. This tree proves its work with witnesses, and it has 1,756 of them. The
# standing roster names 115. Everything else is heard only if something on that roster reaches it
# -- a choir that sings a family, a witness that runs a sibling -- and whatever nothing reaches is
# a guard that runs on no lap at all. It still passes review, still reads like proof, and still
# sits in the tree looking exactly like coverage.
#
# WHAT IT COSTS WHEN IT IS MISSED. REDS %357 found three witnesses of one family red at HEAD, each
# failing since the day a document they pinned was edited. None sat on the roster, so a 96-guard
# cold pass read 95 green while three guards outside it had been failing for days. REDS %219 was
# the same shape one layer up -- a whole choir standing off the roster, which the ledger named as
# a refusal nobody receives. The roster's own header already writes the law this reading measures:
# a guard that cannot red guards nothing, AND a guard that is never run guards nothing either. The
# first half has a meter. This is the second half's.
#
#   sh tools/fixtures/u/unheard_guard_scan.sh            # measure and gate
#   sh tools/fixtures/u/unheard_guard_scan.sh list       # print every unheard guard
#   sh tools/fixtures/u/unheard_guard_scan.sh choirs     # print the unheard guards that sing others
#
# WHAT HEARD MEANS, exactly. A guard is heard when the standing roster names its path, or when
# some already-heard guard names its path on a line that is not a comment. Applied to fixpoint,
# that is every guard a roster pass can reach. Everything else is unheard.
#
# WHY THE READING IS DELIBERATELY GENEROUS. A path named on any non-comment line counts as heard,
# even where that line only mentions it. So `heard` is an over-count and `unheard` is a LOWER
# bound: this guard can under-report the problem and can never invent one. A ratchet wants that
# direction -- the number it prints is a floor under the real one, so a fall is always real.
#
# WHAT IT DOES NOT REACH, named rather than implied.
#   - Whether a hand can run a guard. A witness invoked from a README, a launcher, or a seat
#     prompt is runnable and still unheard, because this measures what the STANDING ROSTER hears
#     on a lap nobody is watching. That is the population REDS %357 was drawn from.
#   - A guard discovered by a glob rather than named. Measured on this tree 20260830: four such
#     discovery patterns stand, all in the Caravan and Lotus choirs, and both families are named
#     literally by their roster fixtures as well -- so the glob adds nothing today. A family
#     discovered ONLY by glob would read unheard here, which is the safe direction.
#   - Whether a heard guard asserts anything worth asserting. This counts who is listening.
#
# WHY THE ROSTER IS THE WHOLE SEED, checked rather than assumed. A second standing runner would
# make this reading over-report, so the other candidate was measured: tools/hooks/pre-commit,
# commit-msg, and post-commit run on every commit in this tree and name NO witness at all --
# each does its checking inline. Measured 20260830. So the standing roster is the only thing
# that runs a guard on a lap nobody is watching, and it is the only seed here.
#   - Witnesses under tools/fixtures/, which are pen material a control plants and runs rather
#     than standing equipment. Measured 20260830: three such files, all elder copies inside
#     caravan ladder fixtures.
#
# WHY A ZERO REFUSES RATHER THAN REPORTS. If the population glob matched nothing, `unheard` would
# read zero and this guard would print a green tree it had never looked at -- REDS %240's confident
# wrong zero, and the same vacuum REDS %357's loom grew a leg for one lap earlier. An empty
# population refuses, and so does an empty roster.
set -eu

# THE CEILINGS ONLY FALL. 1,116 and 37 measured 20260831, after `acme_dx` and `drey` joined the
# roster: 28 guards moved from unheard to heard on two rows, and three choirs with them --
# the two rostered plus `operations_conformance`, which `acme_dx` sings. A guard that arrives
# unrostered raises the reading and is refused, and the refusal names the answer: put it on a
# clock rather than raise the number.
#
# 1,116 -> 1,108 on 20260905, when Amphora's eight witnesses took roster rows: `heard` 714 -> 722,
# `unheard` 1,102 -> 1,094, `unheard_choirs` unchanged at 37 because none of the eight sings another.
# THE CEILING FALLS BY EXACTLY WHAT THOSE ROWS MOVED, and the gap that leaves is deliberate rather
# than overlooked: the reading stood 14 UNDER the published ceiling before this round began, which
# is slack other rounds' rosterings left behind, and absorbing it here would tighten a fleet-wide
# lap-tier gate to zero headroom inside a round about vessels. A no-slack ceiling published from a
# tree that then rebases reds every ship the moment one unrostered witness lands upstream -- REDS
# %360 already recorded a fall cancelled that exact way. The 14 is named on the operator card so
# the next hand can take it deliberately, which is the only way a ratchet should ever tighten.
CEILING="${UNHEARD_GUARD_CEILING:-1108}"
CHOIR_CEILING="${UNHEARD_CHOIR_CEILING:-37}"
ROSTER="${UNHEARD_GUARD_ROSTER:-construction/standing-equipment.kyri}"
mode="${1:-measure}"

root=$(git rev-parse --show-toplevel 2>/dev/null) || {
  echo "refused: not a git repository -- this guard reads tracked living sources" >&2
  exit 1
}
cd "$root"
# One shell dialect for the guards, on both piers: this reading reaches its sources through
# xargs_lines_batched, whose GNU-only spellings live in one place (REDS %240, %250).
. "$root/tools/fixtures/s/shell_portable.sh"

# BOUNDS, named at construction. The closure is a fixpoint over a finite tracked set, so it
# terminates on its own; max_hops exists so a pathological cycle cannot spin, and it sits far
# above the three hops this tree converges in. A guard naming more than max_names paths is read
# up to the bound, so a generated file cannot make this reading's memory grow with its input.
max_hops=16
max_names=512

work=$(mktemp -d) || { echo "refused: no temporary directory" >&2; exit 1; }
trap 'rm -rf "$work"' EXIT

# ONE PASS OVER MANY SOURCES, rather than two greps per file. A source names a guard on any line
# that is not a comment; a `# Kin:` line names a sibling it never runs, so comment lines are read
# past here and nowhere else. Written once and used for both readings below, so the closure and
# the choir count can never come to disagree about what naming means.
cat > "$work/names.awk" <<'AWK'
/^[ \t]*#/ { next }
{
  line = $0
  while (match(line, "tools/[A-Za-z0-9_/.-]*(witness|suite)[A-Za-z0-9_.-]*\\.(rish|rye)")) {
    print FILENAME "\t" substr(line, RSTART, RLENGTH)
    line = substr(line, RSTART + RLENGTH)
  }
}
AWK

# THE POPULATION: tracked witnesses and choirs outside the fixture pens. A `_witness` or `_suite`
# in the basename is the tree's own naming convention for a guard, and REDS %297 already taught
# that where a guard finds its subjects by name, the naming convention IS the guard -- so a runner
# that wears neither word is invisible here exactly as it was invisible to the Caravan choir.
git ls-files 'tools/*' 2>/dev/null \
  | grep -E '(witness|suite)[A-Za-z0-9_.-]*\.(rish|rye)$' \
  | grep -v '^tools/fixtures/' \
  | sort -u > "$work/pop.txt"
population=$(grep -c . "$work/pop.txt" || true)

# THE SEED: every path the standing roster names. Three of them are not witnesses by name
# (living_docs_lint, tame_style_check, width-check) and they still seed the closure, because what
# a rostered guard reaches is heard whatever its own basename says.
if [ -f "$ROSTER" ]; then
  sed -n 's/^path //p' "$ROSTER" | sort -u > "$work/roster.txt"
else
  : > "$work/roster.txt"
fi
rostered=$(grep -c . "$work/roster.txt" || true)

cp "$work/roster.txt" "$work/heard.txt"
hops=0
while [ "$hops" -lt "$max_hops" ]; do
  before=$(grep -c . "$work/heard.txt" || true)
  : > "$work/present.txt"
  while IFS= read -r g; do
    [ -n "$g" ] || continue
    [ -f "$g" ] && printf '%s\n' "$g" >> "$work/present.txt"
  done < "$work/heard.txt"
  # A GUARD THAT CANNOT RUN ITS INSTRUMENT REFUSES, AND NAMES IT (REDS %416). This pass used to
  # end `2>/dev/null || true`, discarding both awk's words and its exit. Of the two swallowed
  # passes in this file that one fails LOUDLY -- an empty result stops the transitive closure
  # early, so `unheard` reads high and the ceiling reds -- while its sibling below fails silently.
  # Neither is acceptable and only one would ever have been noticed.
  if ! xargs_lines_batched 200 "$work/present.txt" awk -f "$work/names.awk" \
       > "$work/named.txt" 2>"$work/names.err"; then
    echo "instrument=failed"
    echo "detail=name_pass_refused"
    sed -n '1,5p' "$work/names.err" | sed 's/^/detail_awk=/'
    echo "verdict=misread"
    exit 1
  fi
  cut -f2 "$work/named.txt" | sort -u > "$work/found.txt"
  sort -u "$work/heard.txt" "$work/found.txt" > "$work/heard2.txt"
  mv "$work/heard2.txt" "$work/heard.txt"
  after=$(grep -c . "$work/heard.txt" || true)
  hops=$((hops + 1))
  [ "$before" -eq "$after" ] && break
done

comm -12 "$work/heard.txt" "$work/pop.txt" > "$work/heard_pop.txt"
comm -23 "$work/pop.txt" "$work/heard_pop.txt" > "$work/unheard.txt"
heard=$(grep -c . "$work/heard_pop.txt" || true)
unheard=$(grep -c . "$work/unheard.txt" || true)

# THE SHARPER READING: an unheard guard that itself names three or more others is a CHOIR, and a
# silent choir takes its whole family down with it -- which is REDS %219 exactly. Three is the
# floor because two named siblings is a witness borrowing a helper; three is a roster.
# AND THIS IS THE ONE THAT WOULD NEVER HAVE BEEN NOTICED. An empty result here reads `choirs=0`
# against a ceiling of 37 -- a ratchet passes on a low number, so a broken instrument and a tree
# with no silent choirs at all report the same green (REDS %416).
if ! xargs_lines_batched 200 "$work/unheard.txt" awk -f "$work/names.awk" \
     > "$work/unamed.txt" 2>"$work/unamed.err"; then
  echo "instrument=failed"
  echo "detail=choir_pass_refused"
  sed -n '1,5p' "$work/unamed.err" | sed 's/^/detail_awk=/'
  echo "verdict=misread"
  exit 1
fi
sort -u "$work/unamed.txt" | cut -f1 | uniq -c \
  | awk -v floor=3 '$1 >= floor { print $2 " sings " $1 }' | sort > "$work/choirs.txt"
choirs=$(grep -c . "$work/choirs.txt" || true)

echo "unheard_guard: a guard that is never run guards nothing."
echo "population=$population"
echo "rostered=$rostered"
echo "heard=$heard"
echo "unheard=$unheard"
echo "unheard_ceiling=$CEILING"
echo "unheard_choirs=$choirs"
echo "unheard_choir_ceiling=$CHOIR_CEILING"
echo "hops=$hops"

if [ "$mode" = list ] || [ "$unheard" -gt "$CEILING" ]; then
  while IFS= read -r w; do
    [ -n "$w" ] || continue
    echo "unheard $w"
  done < "$work/unheard.txt"
fi

if [ "$mode" = choirs ] || [ "$choirs" -gt "$CHOIR_CEILING" ]; then
  while IFS= read -r line; do
    [ -n "$line" ] || continue
    echo "choir $line"
  done < "$work/choirs.txt"
fi

if [ "$population" -eq 0 ]; then
  echo "verdict=no_population"
  echo "refused: no tracked guards reached the reading -- a zero nobody planted is not a heard tree." >&2
  exit 1
fi

if [ "$rostered" -eq 0 ]; then
  echo "verdict=no_roster"
  echo "refused: the standing roster named no path -- every guard would read unheard for the wrong reason." >&2
  exit 1
fi

if [ "$hops" -ge "$max_hops" ]; then
  echo "verdict=no_fixpoint"
  echo "refused: the closure did not settle within max_hops=$max_hops -- the reading is incomplete." >&2
  exit 1
fi

if [ "$unheard" -gt "$CEILING" ]; then
  echo "verdict=over_ceiling"
  echo "refused: $unheard guards stand unheard against a ceiling of $CEILING. Roster the new guard in $ROSTER, or register it with a choir something already hears." >&2
  exit 1
fi

if [ "$choirs" -gt "$CHOIR_CEILING" ]; then
  echo "verdict=over_choir_ceiling"
  echo "refused: $choirs unheard choirs against a ceiling of $CHOIR_CEILING -- a silent choir takes its whole family with it." >&2
  exit 1
fi

echo "verdict=ok"
