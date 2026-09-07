#!/usr/bin/env sh
# tools/fixtures/l/retired_word_control.sh -- prove the retired-word reading on real git history.
#
# WHY A CONTROL FOR AN ADVISORY. Duty 1 prints and never refuses, and for its whole life it read
# 60 of the tree's 767 living markdown pages -- so its silence covered a fourteenth of the room it
# rules, and nobody had seen it name a violation. That is the shape the grain's fusion strand
# names: a guard that cannot red guards nothing. This builds a throwaway repository, plants one
# page of each shape the reading must judge, and asserts BOTH directions -- the violation caught
# and every lawful shape walked free -- since a refusal proven only in the passing direction
# cannot be told from a bypass.
#
# Nine behaviors, each a decision the reading makes:
#   1  a plain living page using a retired word          CAUGHT
#   2  the same word backticked as a token               free -- a mention, never a use
#   3  the same word inside a fenced block               free -- what a page shows
#   4  a stamped basename (testimony)                    free -- the mark law's own test
#   5  a page under date/                                free -- a dated shelf
#   6  a page under counsel/                             free -- a closed room keeping its words
#   7  a page under tools/fixtures/                      free -- planted corpora
#   8  a keeps.txt path plus regex                       free -- one lawful line at a time
#   9  a stamped basename declaring itself Living        CAUGHT -- the page's own word overrides
#                                                        the mark law's test (20260907.144000)
#  10  a stamped basename declaring another Status       free -- a lifecycle word is not Living
#  11  an empty roster                                    REFUSED -- roster_empty, exit 2
#  12  a roster whose every path has moved                REFUSED -- roster_all_absent, exit 2
#  13  one page present, one moved                        read -- retired_word_absent=1, exit 0
#  14  the refusal stripped out of the scan               exit 0 on an empty roster, so the
#                                                         refusal is told apart from a bypass
#
#   sh tools/fixtures/l/retired_word_control.sh
set -eu

ROOT=$(pwd)
SCAN="$ROOT/tools/fixtures/l/retired_word_scan.sh"
ROSTER="$ROOT/tools/fixtures/l/living_prose_roster.sh"
PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT

cd "$PEN"
git init -q .
git config user.email pen@example.invalid
git config user.name pen

mkdir -p date counsel tools/fixtures .claude/rules
printf '# plain\n\nThis page still says footgun in ordinary prose.\n' > plain.md
printf '# token\n\nThe banned word is `footgun`, named as a token.\n' > token.md
printf '# fenced\n\n```\nfootgun\n```\n\nNothing outside the fence.\n' > fenced.md
printf '# testimony\n\nfootgun stood here on the day this was written.\n' > 20260101-010101_testimony.md
printf '# shelf\n\nfootgun on a dated shelf.\n' > date/shelf.md
printf '# counsel\n\nfootgun in a closed room.\n' > counsel/20260101-010101_note.md
printf '# counsel door\n\nfootgun on a front door that carries no stamp.\n' > counsel/README.md
printf '# fixture\n\nfootgun is planted input here.\n' > tools/fixtures/planted.md
printf '# kept\n\nfootgun on a line the keeps file rules lawful.\n' > kept.md
printf '# declared\n\n**Status:** Living -- a page that calls itself living\n\nfootgun in living prose.\n' > 20260101-010101_declared_living.md
printf '# retired page\n\n**Status:** Retired -- a lifecycle word that is not Living\n\nfootgun here.\n' > 20260101-010101_declared_retired.md
printf 'kept.md\ta line the keeps file rules lawful\n' > keeps.txt

git add -A >/dev/null
git commit -qm "pen: plant every shape the reading must judge"

out=$(sh "$ROSTER" | KEEPS="$PEN/keeps.txt" ROOT="$PEN" sh "$SCAN")
printf '%s\n' "$out"

caught=$(printf '%s\n' "$out" | grep -c '^RETIRED ' || :)
echo "control_caught=$caught"

verdict=ok
if [ "$caught" -ne 3 ]; then
  echo "MISSED want exactly three caught -- the plain living page, the unstamped front door, and the stamped page declaring itself Living"
  verdict=MISSED
fi
for bite in 'plain\.md' 'counsel/README\.md' '20260101-010101_declared_living\.md'; do
  if ! printf '%s\n' "$out" | grep -q "^RETIRED ${bite}:"; then
    echo "MISSED ${bite} walked free -- the reading cannot bite"
    verdict=MISSED
  fi
done
for free in token.md fenced.md 20260101-010101_testimony.md 20260101-010101_declared_retired.md date/shelf.md counsel/20260101-010101_note.md tools/fixtures/planted.md kept.md; do
  if printf '%s\n' "$out" | grep -q "^RETIRED ${free}:"; then
    echo "MISSED ${free} was named, and it is lawful -- the reading refuses honest prose"
    verdict=MISSED
  fi
done

# A READING OF NOTHING IS NOT A CLEAN TREE (11-14). Every leg above feeds the scan a real roster,
# so none of them could tell a swept tree from a scan that read no file at all -- and until
# `20260907.153705` those two answers were the same bytes and the same exit code. The four legs
# below are that distinction, each shown from both sides.

expect_refusal() {
  _er_label=$1
  _er_want=$2
  _er_input=$3
  _er_rc=0
  _er_err=$(printf '%s' "$_er_input" | KEEPS="$PEN/keeps.txt" ROOT="$PEN" sh "$SCAN" 2>&1 >/dev/null) || _er_rc=$?
  if [ "$_er_rc" -ne 2 ]; then
    echo "MISSED ${_er_label} answered exit ${_er_rc}, wanted 2 -- a reading with no subject reads as a pass"
    verdict=MISSED
  fi
  case "$_er_err" in
    *"$_er_want"*) ;;
    *)
      echo "MISSED ${_er_label} refused without naming ${_er_want} -- got: ${_er_err}"
      verdict=MISSED
      ;;
  esac
}

# 11 -- an empty roster. The producer died, or matched nothing; either way there is no subject.
expect_refusal empty roster_empty ''

# 12 -- every path moved. A roster of real lines, none of them a readable file today.
expect_refusal all_absent roster_all_absent 'gone/one.md
gone/two.md
'

# 13 -- one present, one moved. Ordinary during a move, so it READS and reports the absence
# beside the count rather than refusing; gating here would red on honest work.
mixed_rc=0
mixed=$(printf 'plain.md\ngone/two.md\n' | KEEPS="$PEN/keeps.txt" ROOT="$PEN" sh "$SCAN") || mixed_rc=$?
if [ "$mixed_rc" -ne 0 ]; then
  echo "MISSED a roster holding one readable page refused (exit ${mixed_rc}) -- a partial move is not a dead reading"
  verdict=MISSED
fi
for want in 'retired_word_files=1' 'retired_word_absent=1'; do
  if ! printf '%s\n' "$mixed" | grep -q "^${want}$"; then
    echo "MISSED the mixed roster did not report ${want} -- got: $(printf '%s' "$mixed" | tr '\n' ' ')"
    verdict=MISSED
  fi
done

# 14 -- THE LOAD-BEARING LEG. A refusal proven only in the refusing direction cannot be told from a
# bypass, so strip the guard out of a copy and watch the same empty roster walk free. This is the
# exact reading the scan gave before this repair: exit 0, hits zero, indistinguishable from clean.
sed '/^if \[ "$files" -eq 0 \]; then$/,/^fi$/d' "$SCAN" > "$PEN/scan_unguarded.sh"
if cmp -s "$SCAN" "$PEN/scan_unguarded.sh"; then
  echo "MISSED the refusal block was not found in the scan -- this leg tests nothing"
  verdict=MISSED
else
  unguarded_rc=0
  : | KEEPS="$PEN/keeps.txt" ROOT="$PEN" sh "$PEN/scan_unguarded.sh" >/dev/null 2>&1 || unguarded_rc=$?
  if [ "$unguarded_rc" -ne 0 ]; then
    echo "MISSED the unguarded scan refused anyway (exit ${unguarded_rc}) -- leg 11 may be passing for another reason"
    verdict=MISSED
  fi
fi

echo "control_verdict=$verdict"
[ "$verdict" = ok ]
