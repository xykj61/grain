#!/bin/sh
# tools/fixtures/l/law_tool_citation_scan.sh -- a tool path the law room prints is a path the
# repository carries.
#
# WHY. `.claude/rules/` holds 54 pages every ship reads at its cold open, and those pages name
# their instruments constantly: a witness that walls a count, a scan that prices a room, a
# launcher a hand runs. Measured `20260910.170340`, the room prints **99 distinct `tools/` file
# paths**, and **50 of them appear nowhere in the room as a Markdown link** -- a bare backticked
# name, or a path typed inside a sentence.
#
# NOTHING READ THOSE FIFTY. `tools/t/tracked_link_witness.rish` reads Markdown LINKS, so a
# backticked name is invisible to it. `tools/d/docs_command_path_witness.rish` reads a path a
# page tells a reader to RUN, and it passes an absent path FREE on purpose -- its own header
# says why: tree-wide, a printed path the tree does not carry is usually a path the reader is
# being asked to create. That reasoning is right for a tutorial and wrong here, because a law
# page naming a guard is making a promise about a file that already exists.
#
# The scope is what makes the gate honest. Tree-wide the class is ambiguous; inside the law room
# it is not, so this scan reads exactly that room and gates at zero.
#
# WHAT IS GATED, hard, at zero. Every `tools/` FILE path printed anywhere in a tracked
# `.claude/rules/*.md` page is a path `git ls-files` carries.
#
# WHAT IS REPORTED, never gated.
#   `cited_bare` -- how many of those paths the room never writes as a link. This is the reason
#   the gate exists rather than a fault, and it will move with ordinary editing.
#   `runners_unrostered` -- a cited witness, check, suite, choir or sweep with no `path` row in
#   `construction/standing-equipment.kyri`. The GATE for that class is
#   `tools/w/witness_reach_witness.rish`, which traces reachability tree-wide and holds
#   `unreached` under a ceiling; a second gate here would be one question with two answers.
#   Today's one is `tools/b/bat_fleet_witness.rish`, named in `.claude/rules/ascii-first.md` as a
#   file whose own `say` line was swept -- a mention rather than a promise.
#   The `.cursor/rules/*.mdc` twin room, read the same way. Its own guard `rule_twin` is gated
#   behind custody gate %7, and a second gate over that room would push a lane into the merge
#   that gate reserves.
#
# WHAT IS READ PAST, each for its own reason. A bare room name (`tools/ca`, `tools/rye`) promises
# no file. `tools/.build` is gitignored on purpose -- `.claude/rules/gratitude-licenses.md` names
# it as the place an LGPL CLI builds to, so its absence from the tracked tree is the point.
# Dated shelves hold no rule page, so accrete-never-break needs no clause here.
#
# USAGE
#   sh tools/fixtures/l/law_tool_citation_scan.sh [law_room] [twin_room] [roster]
#
# Driven by tools/l/law_tool_citation_witness.rish. Run from the repository root.

set -eu

command -v git >/dev/null 2>&1 || { echo "verdict=no_git"; echo "refused: this scan reads the tracked tree, so it wants git" >&2; exit 1; }
git rev-parse --git-dir >/dev/null 2>&1 || { echo "verdict=no_repo"; echo "refused: not inside a git repository" >&2; exit 1; }

law_room=${1:-.claude/rules}
twin_room=${2:-.cursor/rules}
roster=${3:-construction/standing-equipment.kyri}

# Bound named at the door: a room of law pages is a hand-written room, and ten times today's
# reading is far past any honest growth. Past it the scan refuses rather than reading on.
max_cited=4096

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

git ls-files > "$work/tracked.txt"

# A cited path: a `tools/` token, its sentence punctuation stripped, keeping the file shapes this
# tree writes plus the extensionless hooks. Everything else is a room name and promises no file.
cite() {
  room=$1; ext=$2
  git ls-files "$room/*$ext" > "$work/pages.txt" 2>/dev/null || : > "$work/pages.txt"
  if [ ! -s "$work/pages.txt" ]; then
    : > "$work/cited.txt"
    return 0
  fi
  # shellcheck disable=SC2046
  grep -ohE 'tools(/[A-Za-z0-9_.-]+)+' $(cat "$work/pages.txt") 2>/dev/null \
    | sed 's/[.,;:)]*$//' \
    | grep -E '\.(rish|sh|rye|txt|kyri|bron)$|^tools/hooks/[A-Za-z0-9_-]+$' \
    | sort -u > "$work/cited.txt" || : > "$work/cited.txt"
}

untracked_of() {
  : > "$work/untracked.txt"
  while read -r p; do
    [ -n "$p" ] || continue
    grep -qxF "$p" "$work/tracked.txt" || echo "$p" >> "$work/untracked.txt"
  done < "$work/cited.txt"
}

cite "$law_room" .md
law_pages=$(wc -l < "$work/pages.txt" | tr -d ' ')
cp "$work/cited.txt" "$work/law_cited.txt"
cited=$(wc -l < "$work/law_cited.txt" | tr -d ' ')

echo "law_room=$law_room"
echo "law_pages=$law_pages"
echo "cited_paths=$cited"

if [ "$law_pages" -eq 0 ]; then
  echo "verdict=law_room_empty"
  echo "refused: the room whose citations this reads holds no tracked page" >&2
  exit 1
fi
if [ "$cited" -eq 0 ]; then
  echo "verdict=no_citations"
  echo "refused: a room naming no tool would read clean while measuring nothing" >&2
  exit 1
fi
if [ "$cited" -gt "$max_cited" ]; then
  echo "verdict=over_bound"
  echo "refused: $cited cited paths is past max_cited=$max_cited" >&2
  exit 1
fi

untracked_of
cp "$work/untracked.txt" "$work/law_untracked.txt"
untracked=$(wc -l < "$work/law_untracked.txt" | tr -d ' ')

# Bare: never written as a Markdown link anywhere in the room, so no link guard can see it.
bare=0
while read -r p; do
  bn=${p##*/}
  # shellcheck disable=SC2046
  grep -qE "\]\([^)]*$bn\)" $(cat "$work/pages.txt") 2>/dev/null || bare=$((bare + 1))
done < "$work/law_cited.txt"

grep -E '_(witness|check|suite|choir|sweep)\.rish$|/[a-z][a-z-]*-check\.rish$' "$work/law_cited.txt" > "$work/runners.txt" || : > "$work/runners.txt"
runners=$(wc -l < "$work/runners.txt" | tr -d ' ')
: > "$work/unrostered.txt"
if [ -f "$roster" ]; then
  while read -r p; do
    [ -n "$p" ] || continue
    grep -qx "path $p" "$roster" || echo "$p" >> "$work/unrostered.txt"
  done < "$work/runners.txt"
  unrostered=$(wc -l < "$work/unrostered.txt" | tr -d ' ')
else
  # An absent roster cannot answer the question, and `0` would read as an answer.
  unrostered=unread
fi

cite "$twin_room" .mdc
twin_pages=$(wc -l < "$work/pages.txt" | tr -d ' ')
twin_cited=$(wc -l < "$work/cited.txt" | tr -d ' ')
untracked_of
twin_untracked=$(wc -l < "$work/untracked.txt" | tr -d ' ')

echo "cited_untracked=$untracked"
echo "cited_bare=$bare"
echo "cited_runners=$runners"
echo "roster=$roster"
echo "runners_unrostered=$unrostered"
echo "twin_room=$twin_room"
echo "twin_pages=$twin_pages"
echo "twin_cited_paths=$twin_cited"
echo "twin_cited_untracked=$twin_untracked"

[ ! -s "$work/unrostered.txt" ] || sed 's/^/unrostered: /' "$work/unrostered.txt"
if [ "$untracked" -eq 0 ]; then
  echo "verdict=ok"
  exit 0
fi
sed 's/^/untracked: /' "$work/law_untracked.txt"
echo "verdict=citation_absent"
echo "refused: a law page names a tool path the repository does not carry" >&2
exit 1
