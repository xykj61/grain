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

echo "control_verdict=$verdict"
[ "$verdict" = ok ]
