#!/bin/sh
# tools/fixtures/l/law_guard_heard_scan.sh -- a law that names its guard promises that guard runs.
#
# WHY. A rule page in this tree does not merely state a boundary; it names the instrument that
# holds the boundary still, and Gauge asks for exactly that -- a figure carries unit, date, source,
# and WHAT HOLDS IT STILL, where "walled" means a guard reds the lap the number moves. A reader
# meeting `held by tools/x/foo_witness.rish` in a rule page reads that sentence as a wall. It is a
# wall only while something runs the guard on a lap nobody is watching, and the roster is what
# does that. Where nothing on the roster reaches it, the law's own citation is a wish.
#
# The wound is already in the ledger one room over. REDS %357 found three witnesses of one family
# red at HEAD, each failing since the day a document they pinned was edited, none of them on the
# standing roster -- so a 96-guard cold endurance run read 95 green beside three guards that had been
# failing for days. That row's repair was a tree-wide census, tools/fixtures/u/unheard_guard_scan.sh,
# which holds 1,063 unheard guards under a ceiling that only falls. This reading asks the same
# question of a far smaller and far louder population: the guards THE LAW ITSELF cites.
#
#   sh tools/fixtures/l/law_guard_heard_scan.sh          # measure and gate
#   sh tools/fixtures/l/law_guard_heard_scan.sh list     # name every unheard law-cited guard
#   sh tools/fixtures/l/law_guard_heard_scan.sh pages    # name each law page and what it cites
#
# WHERE THE LAW LIVES, and why these three rooms rather than a judgment. `.claude/rules/*.md` and
# `.cursor/rules/*.mdc` are the two editors' rule rooms, which every lap loads; `context/*.md` is
# the canon those rules send a reader to first. tools/fixtures/a/ascii_document_scan.sh already
# treats exactly the first two as the room that writes the law and derives its wall from their
# citations, so the seat is the tree's own rather than this scan's invention.
#
# WHAT COUNTS AS A CITATION. A `tools/<room>/<name>.rish` or `.rye` path standing anywhere in a law
# page -- inside a Markdown link, inside backticks, or bare in a sentence. All three forms read to a
# person as the same promise, so all three are read here. Measured on the seating lap: of 100 such
# citations, 37 stand inside a Markdown link and 63 do not, and only the first 37 are within reach
# of tools/fixtures/t/tracked_link_scan.sh. So the `absent` gate below is a wall over the 63 that
# no standing guard could see.
#
# WHAT COUNTS AS A GUARD, narrowed on purpose. A citation joins the heard reading only when its
# basename wears `witness` or `suite` -- the sibling census's own population rule. Two reasons, and
# neither is taste. First, one definition of the population lives in one file: asking the sibling
# about a path it never enumerated would answer from a rule spelled twice. Second, a law page cites
# plenty of tools that are not standing equipment at all -- a resolver a hand runs, a converter, a
# preview -- and calling those unheard would red on nothing wrong. The remainder is counted as
# `outside_population` and judged nowhere.
#
# HOW HEARD IS DECIDED, in one place. This scan runs the sibling census in `list` mode and reads
# its `unheard` lines. It defines nothing about reach itself: transitivity, the roster seed, the
# comment rule, and the fixture-pen exclusion are all the sibling's, proven by the sibling's own
# fifty-two pen legs. A cited guard is unheard here exactly when the sibling names it unheard.
#
# THE READINGS.
#   law_pages           law pages read
#   citations           distinct tool paths those pages name
#   absent              cited and not carried by the repository        GATED, hard, at zero
#   guard_citations     of the citations, the ones wearing witness or suite
#   outside_population  the remainder, reported and judged nowhere
#   unheard             guard citations no roster pass reaches         RATCHET, ceiling only falls
#
# WHY `absent` WALLS AND `unheard` RATCHETS. An absent path is decidable with no judgment and it
# reads zero on this tree, so a wall there refuses nothing anyone does on purpose. `unheard` reads
# 25 of 66, and the lawful repairs are several -- roster the guard, have a rostered choir sing it,
# or find that the citation was never a wall claim at all -- so a hard gate would refuse the law's
# ordinary growth and become a gate someone turns off. It falls when a repair lands.
#
# WHAT IT DOES NOT REACH, named rather than implied.
#   - Whether a cited guard PASSES. This counts who is listening. Four of the twenty-five were run
#     by hand on the seating lap and all four read GREEN.
#   - Whether a guard can be run at all with no arguments. `tools/cl/claim_preserve_witness.rish`
#     refuses a bare invocation by design -- it wants CLAIM_PRESERVE_FILES named -- so it is a
#     parameterized instrument a style pass drives rather than standing equipment, and its place in
#     the unheard count is correct and uninteresting. Sorting the parameterized from the merely
#     unrostered is a reading about what a program needs, and it wants its own instrument.
#   - Whether the sentence doing the citing was making a wall claim. A rule page names a guard to
#     credit it, to teach it, and to lean on it, and this reading cannot tell the three apart.
#     It counts the reach the law's reader is invited to assume.
#
# WHY THIS SCAN NAMES NO GUARD PATH ON A LINE THAT RUNS. The sibling census credits a path named on
# any non-comment line as run, which is deliberate generosity that makes its count a floor -- and it
# is exactly wrong for a file whose job is to name what nothing runs. That is REDS %486, which the
# sibling booked against itself and answered by excluding its own three files from its closure. This
# scan, its control, and its witness stay out of that closure a second way, by construction: they
# spell no real guard path outside a comment. The control plants invented names in a pen and the
# witness asserts on counts and on this scan's own verdict words. Checked by measurement rather than
# by intent, on the seating lap: the sibling read population 1,947 / heard 884 / unheard 1,063 before
# these three files were staged, and 1,948 / 885 / 1,063 after -- the witness joins the population and
# takes a roster row in the same commit, so `heard` rises by one and `unheard` does not move at all.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
set -eu

# THE CEILING ONLY FALLS. 25 measured 20260910 against 66 guard citations, on the tree at
# 2410630a80. Published at exactly what was measured, so the widening reds no ship and the
# twenty-sixth unheard citation reds on the lap it lands. It falls when a guard takes a roster row,
# when a rostered choir gathers one, or when a citation that was never a wall claim leaves the law.
CEILING="${LAW_GUARD_UNHEARD_CEILING:-25}"
SIBLING="${LAW_GUARD_SIBLING:-tools/fixtures/u/unheard_guard_scan.sh}"
mode="${1:-measure}"

root=$(git rev-parse --show-toplevel 2>/dev/null) || {
  echo "refused: not a git repository -- this guard reads tracked living law" >&2
  exit 1
}
cd "$root"

# BOUNDS, named at construction. Each is far above the live reading, so neither shapes an honest
# tree; they exist so a generated page or a runaway roster cannot make this reading's work grow
# without limit.
max_pages=512
max_citations=1024

work=$(mktemp -d) || { echo "refused: no temporary directory" >&2; exit 1; }
trap 'rm -rf "$work"' EXIT

# THE LAW ROOMS, listed once and reached through git rather than through the filesystem. A page
# present on this machine and absent from the repository is not law anybody else receives.
LAW_GLOBS="${LAW_GUARD_ROOMS:-.claude/rules/*.md .cursor/rules/*.mdc context/*.md}"
# shellcheck disable=SC2086
git ls-files -- $LAW_GLOBS 2>/dev/null | head -n "$max_pages" | sort > "$work/pages.txt"
pages=$(wc -l < "$work/pages.txt" | tr -d ' ')

if [ "$pages" -eq 0 ]; then
  echo "law_pages=0"
  echo "verdict=no_law_pages"
  exit 3
fi

# ONE PASS OVER THE PAGES. A citation is a tools path with a room letter, a basename, and one of
# the two authored runner extensions. Comment lines are not read past here: a rule page is prose,
# and a `#` opens a heading rather than a comment.
tr '\n' '\0' < "$work/pages.txt" | xargs -0 grep -ohE 'tools/[a-z]{1,3}/[a-z0-9_-]+\.(rish|rye)' 2>/dev/null \
  | sort -u | head -n "$max_citations" > "$work/cited.txt"
citations=$(wc -l < "$work/cited.txt" | tr -d ' ')

if [ "$citations" -eq 0 ]; then
  echo "law_pages=$pages"
  echo "citations=0"
  echo "verdict=no_citations"
  exit 3
fi

# ABSENT: cited and not carried by the repository. Asked of the tracked tree rather than of this
# filesystem, for the reason tools/fixtures/p/phantom_path_scan.sh writes out at length -- a guard's
# whole worth is that its promise travels to a clone.
# The listing is an INSTRUMENT, so a failure of it refuses rather than reading as an empty tree.
# Piping straight into `sort` would hand this reading git's exit status through a pipeline that
# reports the sort's, and `|| true` would call a broken git an absent citation -- every cited path
# would then read `absent` against a wall at zero, loudly wrong for a reason no line names.
# `tools/fixtures/i/instrument_refusal_scan.sh` holds that swallow at zero across the tree, and it
# caught this line one lap after the file was written.
if ! git ls-files -- $(cat "$work/cited.txt" | tr '\n' ' ') > "$work/tracked_raw.txt"; then
  echo "law_pages=$pages"
  echo "citations=$citations"
  echo "verdict=listing_refused"
  exit 3
fi
sort -u "$work/tracked_raw.txt" > "$work/tracked.txt"
comm -23 "$work/cited.txt" "$work/tracked.txt" > "$work/absent.txt"
absent=$(wc -l < "$work/absent.txt" | tr -d ' ')

# THE GUARD-NAMED SUBSET, by the sibling census's own naming rule.
grep -E '/[a-z0-9_-]*(witness|suite)[a-z0-9_-]*\.(rish|rye)$' "$work/cited.txt" > "$work/guards.txt" || true
guard_citations=$(wc -l < "$work/guards.txt" | tr -d ' ')
outside=$((citations - guard_citations))

# HEARD, DECIDED IN ONE PLACE. The sibling owns every rule about reach; this reads its answer.
if [ ! -f "$SIBLING" ]; then
  echo "law_pages=$pages"
  echo "citations=$citations"
  echo "verdict=no_sibling"
  exit 3
fi
sh "$SIBLING" list > "$work/sib.txt" 2>/dev/null || {
  echo "law_pages=$pages"
  echo "citations=$citations"
  echo "verdict=sibling_refused"
  exit 3
}
awk '$1=="unheard"{print $2}' "$work/sib.txt" | sort -u > "$work/sib_unheard.txt"
# A SIBLING THAT NAMED NOTHING IS A READING THAT BROKE, never a tree where every law-cited guard
# is heard. REDS %240's confident wrong zero: an empty result passes a ceiling and reads as health.
if [ ! -s "$work/sib_unheard.txt" ]; then
  echo "law_pages=$pages"
  echo "citations=$citations"
  echo "verdict=sibling_empty"
  exit 3
fi

comm -12 "$work/guards.txt" "$work/sib_unheard.txt" > "$work/unheard.txt"
unheard=$(wc -l < "$work/unheard.txt" | tr -d ' ')

if [ "$mode" = "list" ]; then
  while IFS= read -r p; do
    echo "unheard_law_guard $p"
  done < "$work/unheard.txt"
fi

if [ "$mode" = "pages" ]; then
  while IFS= read -r page; do
    n=$(grep -ohE 'tools/[a-z]{1,3}/[a-z0-9_-]+\.(rish|rye)' "$page" 2>/dev/null | sort -u | wc -l | tr -d ' ')
    [ "$n" -eq 0 ] || echo "law_page $page cites=$n"
  done < "$work/pages.txt"
fi

echo "law_guard_heard: a law that names its guard promises that guard runs."
echo "law_pages=$pages"
echo "citations=$citations"
echo "absent=$absent"
echo "guard_citations=$guard_citations"
echo "outside_population=$outside"
echo "unheard=$unheard"
echo "unheard_ceiling=$CEILING"

if [ "$absent" -gt 0 ]; then
  while IFS= read -r p; do echo "absent_citation $p"; done < "$work/absent.txt"
  echo "verdict=absent_citation"
  exit 2
fi
if [ "$unheard" -gt "$CEILING" ]; then
  echo "verdict=over_ceiling"
  exit 2
fi
echo "verdict=ok"
