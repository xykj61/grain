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
#   sh tools/fixtures/u/unheard_guard_scan.sh unnamed    # print the unheard runners wearing neither word
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
# THE SECOND READING: THE RUNNERS THIS CONVENTION CANNOT SEE (REDS %465, measured 20260906).
# The population above is drawn by basename, so a runner wearing neither `witness` nor `suite` is
# not counted unheard -- it is ABSENT, and absence looks like health. That limit was disclosed in
# this header from the day it was written and it had no size for 36 days, which is the fault the
# row books: a disclosed limit whose size is unknown cannot be weighed. It has a size now.
#
#   unnamed_population  tracked tools/*.{rish,rye} outside the pens, wearing NEITHER word, and
#                       carrying an `assert` in command position -- a checkable claim is what
#                       makes a runner standing equipment whatever its filename says. 451 here.
#   unnamed_heard       of those, the ones a roster pass reaches. 43 here.
#   unnamed_runners     the unreached remainder. 408 here. REPORTED, never gated -- see below.
#   unnamed_choirs      of the unreached, the ones singing three or more members of the guard
#                       universe. 12 here, and this is the reading that gates.
#
# WHY THE ASSERT PATTERN READS TWO SPELLINGS. Rishi writes `assert x else "..."` and Rye writes
# `assert(x)`, so a pattern requiring the space reads a two-language tree and finds none of the
# second: `^[ \t]*assert ` matched 0 of the 82 unnamed `.rye` files here, where `^[ \t]*assert[ (]`
# matches 63. That is this row's own fault one layer down -- an instrument narrowed by a convention
# it was not built to question -- so it is written out rather than left as a silent floor.
#
# WHY THE SECOND READING USES A WIDER NAMING RULE, and why that does not make the two disagree.
# The elder reading's naming rule recognises a path by the same convention its population uses, so
# for the elder population it is complete: every path wearing the word matches. It is blind by
# construction to a path that does NOT wear the word -- which is exactly the population this second
# reading is about, so reusing it here would repeat REDS %465 one level down. The second closure
# therefore reads any tracked tools/ path on a non-comment line. Measured 20260906: the wide rule
# reaches 43 of the 451 where the narrow rule reaches 4, so a narrow reading here would over-report
# by 39. Each closure agrees with its own choir count, which is the property the shared naming file
# below was written to keep.
#
# AND THE ELDER READING'S OWN LIMIT NOW CARRIES A NUMBER TOO. A guard wearing the word can be run
# THROUGH a runner that does not, and the narrow closure cannot follow that hop. `elder_reach_gap`
# counts the elder-population guards the wide closure reaches and the narrow one calls unheard: 2
# here, both genuinely run. The elder reading stays exactly as it was -- it is a fleet-wide ratchet
# and its over-report is in the safe direction -- and the size of its blind spot is printed rather
# than described.
#
# WHY `unnamed_runners` IS REPORTED AND NEVER GATED, from measurement rather than preference.
# Every arrival into this set over the fourteen days to 20260906 -- ten of ten, with the tools/
# letter-room fold excluded -- was an ACTOR: seven `launch-*-chapter.rish`, `chatgpt-mind.rish`,
# `birth_a_clone.rish` which copies a tree's `.ssh`, and `lap_vocabulary_sweep.rish`. A ceiling
# here would red on the tree's ordinary growth, and the only lawful answer to each red would be
# *never roster this* -- a wall someone turns off within a week. Worse, a meter that reads high
# and says `roster these` points a hand at custody gate 3 through a number.
#
# AND WHY NO NAME-OR-VERDICT TRIAGE IS OFFERED, measured before it was built. This tree's success
# signature is `say "GREEN...`, and it looked like the triage: 326 of the 408 print it. It separates
# nothing -- `birth_a_clone.rish` prints GREEN, `make_key_card.rish` reaches gpg and prints GREEN,
# and seven launchers that start agent loops print GREEN. A classifier built on it would have
# credited the clone-birther as rosterable standing equipment. The honest answer is that this census
# reads REACH and says nothing about EFFECT; which runners may be put on a clock is a reading about
# what a program touches, and it wants its own instrument.
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
# THE SECOND READING'S CEILING, published at exactly what was measured on the round that widened
# the population, so no ship reds on the widening and the thirteenth silent choir reds on the lap
# it arrives. 12 measured 20260906 at 2a3313c06b -- `parity_ch01.rish` singing 281 guards and
# `parity_ch02.rish` 128 are the two largest, and neither is reachable from the roster today.
UNNAMED_CHOIR_CEILING="${UNNAMED_CHOIR_CEILING:-12}"
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

# THIS GUARD DOES NOT READ ITS OWN FINDINGS (REDS %486, found by this reading turning on itself).
# The closures below credit a path named on ANY non-comment line, which is deliberate generosity --
# a mention is treated as a run, so the count is a floor. That generosity is safe for every file in
# the tree except three: this scan, its control, and its witness, whose whole job is to NAME the
# guards nothing runs. The moment the witness asserted `tools/p/parity_ch01.rish` by name, the
# closure read that assert string as a run and marked the largest silent choir heard -- with it,
# the 281 guards it sings. One line moved `unnamed_heard` 42 -> 194, `unnamed_runners` 408 -> 256,
# and `elder_reach_gap` 2 -> 102, measured 20260906 at 2a3313c06b -- a tree one file smaller than
# the readings above, which is why 42 stands here and 43 stands there. That is REDS %463's fault exactly: an
# instrument reading its own reflection and reporting the room empty. Excluded by name, as %463's
# census excludes itself, and proven from the failing side in the control. The three paths are
# written to `$work/self.txt` below, once the work directory exists.

work=$(mktemp -d) || { echo "refused: no temporary directory" >&2; exit 1; }
trap 'rm -rf "$work"' EXIT

printf '%s\n' \
  "tools/fixtures/u/unheard_guard_scan.sh" \
  "tools/fixtures/u/unheard_guard_control.sh" \
  "tools/u/unheard_guard_witness.rish" > "$work/self.txt"

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

# THE WIDE NAMING RULE, for the second reading alone. Any tracked tools/ runner named on a
# non-comment line, whatever its basename says. The narrow rule above cannot match a path that
# wears neither word, and the second reading's whole population is exactly those paths -- so
# reusing it there would be blind by construction. Each closure below is paired with the rule
# that can see its own population, and neither reads the other's file.
cat > "$work/names_wide.awk" <<'AWK'
/^[ \t]*#/ { next }
{
  line = $0
  while (match(line, "tools/[A-Za-z0-9_/.-]*\\.(rish|rye)")) {
    print FILENAME "\t" substr(line, RSTART, RLENGTH)
    line = substr(line, RSTART + RLENGTH)
  }
}
AWK

# THE CLAIM TEST, both spellings. Rishi writes `assert x else "..."`, Rye writes `assert(x)`, and a
# pattern requiring the space finds none of the second. Written as awk rather than `grep -l` so a
# failure is legible in the exit status: batched grep exits nonzero merely because some batch had
# no match, which cannot be told from a broken instrument.
cat > "$work/asserts.awk" <<'AWK'
FNR == 1 { shown = 0 }
shown { next }
/^[ \t]*assert[ (]/ { print FILENAME; shown = 1 }
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

# THE SECOND POPULATION: the runners the convention cannot see. Same rooms, same extensions, same
# pen exclusion -- and the basename test inverted, so this set and the one above never overlap. A
# runner joins it by carrying a checkable claim in command position, since that is what makes a
# program standing equipment whatever it is called.
git ls-files 'tools/*' 2>/dev/null \
  | grep -E '\.(rish|rye)$' \
  | grep -v '^tools/fixtures/' \
  | grep -vE '(witness|suite)[A-Za-z0-9_.-]*\.(rish|rye)$' \
  | sort -u > "$work/unnamed_all.txt"
: > "$work/unnamed_present.txt"
while IFS= read -r u; do
  [ -n "$u" ] || continue
  [ -f "$u" ] && printf '%s\n' "$u" >> "$work/unnamed_present.txt"
done < "$work/unnamed_all.txt"
if ! xargs_lines_batched 200 "$work/unnamed_present.txt" awk -f "$work/asserts.awk" \
     > "$work/unnamed_pop.txt" 2>"$work/asserts.err"; then
  echo "instrument=failed"
  echo "detail=assert_pass_refused"
  sed -n '1,5p' "$work/asserts.err" | sed 's/^/detail_awk=/'
  echo "verdict=misread"
  exit 1
fi
sort -u "$work/unnamed_pop.txt" -o "$work/unnamed_pop.txt"
unnamed_population=$(grep -c . "$work/unnamed_pop.txt" || true)

# THE SEED: every path the standing roster names. Three of them are not witnesses by name
# (living_docs_lint, tame_style_check, width-check) and they still seed the closure, because what
# a rostered guard reaches is heard whatever its own basename says.
if [ -f "$ROSTER" ]; then
  sed -n 's/^path //p' "$ROSTER" | sort -u > "$work/roster.txt"
else
  : > "$work/roster.txt"
fi
rostered=$(grep -c . "$work/roster.txt" || true)

# THE CLOSURE READS EACH SOURCE ONCE. A hop reads only what the previous hop ADDED, since a file
# already read names the same paths however many times it is read again -- so the fixpoint is
# identical and the work is linear in the heard set rather than quadratic in the hop count. That is
# what pays for the second closure: measured 20260906 on this tree, HEAD's single re-reading closure
# ran 0.60s and this file's two incremental ones run 0.88s together.
#
# THE SELF-EXCLUSION IS FILTERED IN ONE PASS, and the first draft was not. Testing each path with
# `grep -Fxq` inside the loop spawns a process per heard file -- ~800 of them per closure -- and read
# 24.7s against the 0.88s below. A per-item shell-out inside a loop over a tracked corpus is the
# whole cost, every time. The filter's `|| true` is deliberate and its failure direction is named:
# grep exits 1 on an empty batch, and a genuine failure leaves the source list short, which
# UNDER-reports reach, OVER-reports unheard, and reds the ceiling rather than passing quietly.
cp "$work/roster.txt" "$work/heard.txt"
: > "$work/scanned.txt"
hops=0
while [ "$hops" -lt "$max_hops" ]; do
  comm -23 "$work/heard.txt" "$work/scanned.txt" > "$work/todo.txt"
  [ -s "$work/todo.txt" ] || break
  : > "$work/present.txt"
  while IFS= read -r g; do
    [ -n "$g" ] || continue
    [ -f "$g" ] && printf '%s\n' "$g" >> "$work/present.txt"
  done < "$work/todo.txt"
  grep -Fxv -f "$work/self.txt" "$work/present.txt" > "$work/present2.txt" || true
  mv "$work/present2.txt" "$work/present.txt"
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
  sort -u "$work/scanned.txt" "$work/todo.txt" > "$work/scanned2.txt"
  mv "$work/scanned2.txt" "$work/scanned.txt"
  sort -u "$work/heard.txt" "$work/found.txt" > "$work/heard2.txt"
  mv "$work/heard2.txt" "$work/heard.txt"
  hops=$((hops + 1))
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

# THE SECOND CLOSURE, over the wide naming rule, seeded from the same roster. It is computed apart
# from the first rather than replacing it: the elder reading is a published fleet-wide ratchet and
# its narrow rule is complete for its own population, so moving it would move eight ships' numbers
# to correct a two-file over-report in the safe direction. What the wide closure buys is a reading
# of the population the narrow rule cannot see at all, and a NUMBER for the elder rule's blind spot.
cp "$work/roster.txt" "$work/wide.txt"
: > "$work/wscanned.txt"
whops=0
while [ "$whops" -lt "$max_hops" ]; do
  comm -23 "$work/wide.txt" "$work/wscanned.txt" > "$work/wtodo.txt"
  [ -s "$work/wtodo.txt" ] || break
  : > "$work/wpresent.txt"
  while IFS= read -r g; do
    [ -n "$g" ] || continue
    [ -f "$g" ] && printf '%s\n' "$g" >> "$work/wpresent.txt"
  done < "$work/wtodo.txt"
  grep -Fxv -f "$work/self.txt" "$work/wpresent.txt" > "$work/wpresent2.txt" || true
  mv "$work/wpresent2.txt" "$work/wpresent.txt"
  if ! xargs_lines_batched 200 "$work/wpresent.txt" awk -f "$work/names_wide.awk" \
       > "$work/wnamed.txt" 2>"$work/wnames.err"; then
    echo "instrument=failed"
    echo "detail=wide_name_pass_refused"
    sed -n '1,5p' "$work/wnames.err" | sed 's/^/detail_awk=/'
    echo "verdict=misread"
    exit 1
  fi
  cut -f2 "$work/wnamed.txt" | sort -u > "$work/wfound.txt"
  sort -u "$work/wscanned.txt" "$work/wtodo.txt" > "$work/wscanned2.txt"
  mv "$work/wscanned2.txt" "$work/wscanned.txt"
  sort -u "$work/wide.txt" "$work/wfound.txt" > "$work/wide2.txt"
  mv "$work/wide2.txt" "$work/wide.txt"
  whops=$((whops + 1))
done

comm -12 "$work/wide.txt" "$work/unnamed_pop.txt" > "$work/unnamed_heard.txt"
comm -23 "$work/unnamed_pop.txt" "$work/unnamed_heard.txt" > "$work/unnamed.txt"
unnamed_heard=$(grep -c . "$work/unnamed_heard.txt" || true)
unnamed_runners=$(grep -c . "$work/unnamed.txt" || true)

# THE ELDER RULE'S BLIND SPOT, given a size. A guard wearing the word can be reached THROUGH a
# runner that does not, and the narrow closure cannot follow that hop. These are elder-population
# guards the wide closure reaches and the narrow one calls unheard -- reported, never gated, since
# every one of them is a guard the elder reading over-counts in the safe direction.
comm -12 "$work/wide.txt" "$work/unheard.txt" > "$work/reach_gap.txt"
elder_reach_gap=$(grep -c . "$work/reach_gap.txt" || true)

# THE SECOND READING'S SHARPEST HALF: a silent choir among the runners nothing names as guards.
# It counts only the members of the GUARD UNIVERSE a runner sings -- both populations together --
# because the wide naming rule matches helper scripts too, and a runner naming three helpers is not
# a choir. Same floor of three, same reason: two named siblings is a witness borrowing a helper.
# AND THE SAME VACUUM AS ITS ELDER: an empty result reads choirs=0 against a ceiling, which a
# ratchet passes, so a broken instrument and a tree with no silent choirs report the same green.
sort -u "$work/pop.txt" "$work/unnamed_pop.txt" > "$work/universe.txt"
if ! xargs_lines_batched 200 "$work/unnamed.txt" awk -f "$work/names_wide.awk" \
     > "$work/unnamed_named.txt" 2>"$work/unnamed_names.err"; then
  echo "instrument=failed"
  echo "detail=unnamed_choir_pass_refused"
  sed -n '1,5p' "$work/unnamed_names.err" | sed 's/^/detail_awk=/'
  echo "verdict=misread"
  exit 1
fi
sort -u "$work/unnamed_named.txt" \
  | awk -v universe="$work/universe.txt" -v floor=3 '
      BEGIN { while ((getline u < universe) > 0) known[u] = 1 }
      known[$2] && $1 != $2 { sung[$1]++ }
      END { for (f in sung) if (sung[f] >= floor) printf "%s sings %d\n", f, sung[f] }' \
  | sort > "$work/unnamed_choirs.txt"
unnamed_choirs=$(grep -c . "$work/unnamed_choirs.txt" || true)

echo "unheard_guard: a guard that is never run guards nothing."
echo "population=$population"
echo "rostered=$rostered"
echo "heard=$heard"
echo "unheard=$unheard"
echo "unheard_ceiling=$CEILING"
echo "unheard_choirs=$choirs"
echo "unheard_choir_ceiling=$CHOIR_CEILING"
echo "unnamed_population=$unnamed_population"
echo "unnamed_heard=$unnamed_heard"
echo "unnamed_runners=$unnamed_runners"
echo "unnamed_choirs=$unnamed_choirs"
echo "unnamed_choir_ceiling=$UNNAMED_CHOIR_CEILING"
echo "elder_reach_gap=$elder_reach_gap"
echo "hops=$hops"
echo "wide_hops=$whops"

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

if [ "$mode" = unnamed ]; then
  while IFS= read -r u; do
    [ -n "$u" ] || continue
    echo "unnamed $u"
  done < "$work/unnamed.txt"
  while IFS= read -r g; do
    [ -n "$g" ] || continue
    echo "reach_gap $g"
  done < "$work/reach_gap.txt"
fi

if [ "$mode" = choirs ] || [ "$mode" = unnamed ] || [ "$unnamed_choirs" -gt "$UNNAMED_CHOIR_CEILING" ]; then
  while IFS= read -r line; do
    [ -n "$line" ] || continue
    echo "unnamed_choir $line"
  done < "$work/unnamed_choirs.txt"
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

if [ "$whops" -ge "$max_hops" ]; then
  echo "verdict=no_wide_fixpoint"
  echo "refused: the wide closure did not settle within max_hops=$max_hops -- the second reading is incomplete." >&2
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

if [ "$unnamed_choirs" -gt "$UNNAMED_CHOIR_CEILING" ]; then
  echo "verdict=over_unnamed_choir_ceiling"
  echo "refused: $unnamed_choirs silent choirs wear neither word, against a ceiling of $UNNAMED_CHOIR_CEILING. Roster it, or let something already heard name its path." >&2
  exit 1
fi

echo "verdict=ok"
