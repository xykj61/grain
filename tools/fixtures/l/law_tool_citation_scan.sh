#!/bin/sh
# tools/fixtures/l/law_tool_citation_scan.sh -- a path the law room prints is a path the repository
# carries.
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
# AND EVERY OTHER ROOM'S PATH, on its own reading and its own gate (widened `20260911.093000`).
# The argument above is about a LAW PAGE rather than about `tools/`: a page naming a foundation,
# a spec, a context guide or a design essay makes the same promise about the same kind of file.
# The first reading was bounded to `tools/` because that was the class the measurement found, and
# the room prints 133 more paths into eleven other rooms. Two of them were stale: the pre-fold
# flat paths of `20260715-163000_radiant-style-self-critique-benediction-vocabulary-ornament.md`
# and `20260717-181715_tame-slc-rye-audit-ledger.md`, both folded to `active-designing/yonder/`,
# cited across three law pages and the twin. One line of `.claude/rules/tame-guidance.md` carried
# a repaired citation and a stale one side by side, which is what an unread class looks like.
#
# TWO READINGS, TWO GATES, rather than one merged number. `cited_bare` and `cited_runners` are
# questions about instruments, so folding room paths into `cited_paths` would move a number those
# two are measured against. The same reasoning the ASCII comment meter took for its trailing
# reading: a merged total can be improved by moving a citation between the classes.
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
# The room reading reads three more classes past, and NONE of them is a typed list of exceptions.
#   An ABSOLUTE path names the host rather than the tree -- `/etc/nixos/configuration.nix` in
#   `.claude/rules/declared-host-config.md` is the machine's copy, and the whole point of that law
#   is that the tree's own file is somewhere else.
#   A PLACEHOLDER is what `.claude/rules/stamp-and-name.md` requires of an illustration, under its
#   own heading *Illustrate with placeholders, cite only what exists*: `YYYY`, `HHMMSS`, `MMDD`,
#   `sprig`, `NNN`. An angle-bracket form -- `docs/<subroom>/<page>.md` -- needs no filter at all,
#   because the token shape carries no `<`, so it is never collected in the first place; a filter
#   for it would read as a working clause while doing nothing, and the control proves the shape is
#   uncounted rather than trusting this sentence. So a page following that law passes free, and a page
#   spelling a plausible-looking path that names no file is exactly what the gate is for. One such
#   illustration stood when this reading was built and took a placeholder instead of an exemption.
#   A GITIGNORED path is one the repository keeps outside itself on purpose, and here the answer
#   is mechanical rather than listed: this tree's `.gitignore` denies the root with `/*` and allows
#   each project room back by name, so `git check-ignore` answers precisely *is this a room the
#   repository keeps*. `.lap/commit-msg.txt`, `.gnupg-rye/gpg.sh` and `20260830/x.kyri` all answer
#   yes, and a missing page under an allowed room -- `foundations/`, `docs/`, `context/` -- answers
#   no and reds. The wall `.claude/rules/read-scope.md` and `.claude/rules/git-signing.md` both
#   describe is what makes this one test enough.
#
# WHAT THE ROOM READING DOES NOT ASK is whether a relative citation climbs the right number of
# levels. A leading `../` run is stripped and the remainder read from the root, because a law page
# sits two deep and the room writes both `../../foundations/x.md` and `../foundations/x.md` for
# the same file. `tools/t/tracked_link_witness.rish` owns the climb for a citation written as a
# link; this one owns existence.
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

# The room reading's own bound, named for the same reason: 133 room paths stood when it was built,
# and ten times that is far past honest growth for a hand-written room.
max_room_cited=4096

# The file shapes this tree authors. A token ending in none of them is prose rather than a path.
room_ext='md|mdc|rye|rish|sh|txt|kyri|bron|brix|glow|myc|brush|nix|json|example'

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

# A cited ROOM path: every other room's file the page prints, normalized to the tree root. The
# three read-past classes are applied here rather than after, so the count reports what is gated.
cite_rooms() {
  room=$1; ext=$2
  git ls-files "$room/*$ext" > "$work/pages.txt" 2>/dev/null || : > "$work/pages.txt"
  if [ ! -s "$work/pages.txt" ]; then
    : > "$work/room_raw.txt"; : > "$work/cited.txt"
    return 0
  fi
  # shellcheck disable=SC2046
  grep -ohE '/?(\.\./)*[A-Za-z0-9_.-]+(/[A-Za-z0-9_.-]+)+' $(cat "$work/pages.txt") 2>/dev/null \
    | sed 's/[.,;:)]*$//' \
    | grep -E "\.($room_ext)\$" \
    | grep -v '^/' \
    | sed 's|^\./||; s|^\(\.\./\)*||' \
    | grep -v '^tools/' \
    | sort -u > "$work/room_raw.txt" || : > "$work/room_raw.txt"
  grep -vE 'YYYY|HHMMSS|MMDD|sprig|NNN' "$work/room_raw.txt" > "$work/room_named.txt" \
    || : > "$work/room_named.txt"
  : > "$work/cited.txt"
  while read -r p; do
    [ -n "$p" ] || continue
    git check-ignore -q -- "$p" 2>/dev/null && continue
    echo "$p" >> "$work/cited.txt"
  done < "$work/room_named.txt"
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

# The room reading, gated here beside the tool reading.
cite_rooms "$law_room" .md
room_raw=$(wc -l < "$work/room_raw.txt" | tr -d ' ')
room_named=$(wc -l < "$work/room_named.txt" | tr -d ' ')
cp "$work/cited.txt" "$work/room_cited.txt"
room_cited=$(wc -l < "$work/room_cited.txt" | tr -d ' ')
room_placeholder=$((room_raw - room_named))
room_ignored=$((room_named - room_cited))
if [ "$room_cited" -gt "$max_room_cited" ]; then
  echo "verdict=room_over_bound"
  echo "refused: $room_cited cited room paths is past max_room_cited=$max_room_cited" >&2
  exit 1
fi
untracked_of
cp "$work/untracked.txt" "$work/room_untracked.txt"
room_untracked=$(wc -l < "$work/room_untracked.txt" | tr -d ' ')

room_bare=0
# shellcheck disable=SC2046
git ls-files "$law_room/*.md" > "$work/pages.txt" 2>/dev/null || : > "$work/pages.txt"
while read -r p; do
  [ -n "$p" ] || continue
  bn=${p##*/}
  # shellcheck disable=SC2046
  grep -qE "\]\([^)]*$bn\)" $(cat "$work/pages.txt") 2>/dev/null || room_bare=$((room_bare + 1))
done < "$work/room_cited.txt"

cite "$twin_room" .mdc
twin_pages=$(wc -l < "$work/pages.txt" | tr -d ' ')
twin_cited=$(wc -l < "$work/cited.txt" | tr -d ' ')
untracked_of
twin_untracked=$(wc -l < "$work/untracked.txt" | tr -d ' ')

cite_rooms "$twin_room" .mdc
twin_room_cited=$(wc -l < "$work/cited.txt" | tr -d ' ')
cp "$work/cited.txt" "$work/twin_room_cited.txt"
untracked_of
cp "$work/untracked.txt" "$work/twin_room_untracked.txt"
twin_room_untracked=$(wc -l < "$work/twin_room_untracked.txt" | tr -d ' ')

echo "cited_untracked=$untracked"
echo "cited_bare=$bare"
echo "cited_runners=$runners"
echo "roster=$roster"
echo "runners_unrostered=$unrostered"
echo "twin_room=$twin_room"
echo "twin_pages=$twin_pages"
echo "twin_cited_paths=$twin_cited"
echo "twin_cited_untracked=$twin_untracked"
echo "room_cited_paths=$room_cited"
echo "room_cited_untracked=$room_untracked"
echo "room_cited_bare=$room_bare"
echo "room_placeholder_read_past=$room_placeholder"
echo "room_ignored_read_past=$room_ignored"
echo "twin_room_cited_paths=$twin_room_cited"
echo "twin_room_cited_untracked=$twin_room_untracked"
# Named rather than counted, because a reader handed a bare number can act on nothing. Today's one
# stands in `.cursor/rules/tame-guidance.mdc` and its sentence marks it `when built` -- a promise
# about the future rather than about the tree. It is printed at runtime rather than spelled here,
# since `tools/g/geode_libraries.rish` counts a witness for a room by the room paths its text
# names, and spelling this one enrolled the reading in that room's census on its first lap.
[ ! -s "$work/twin_room_untracked.txt" ] || sed 's/^/twin_room_untracked: /' "$work/twin_room_untracked.txt"

[ ! -s "$work/unrostered.txt" ] || sed 's/^/unrostered: /' "$work/unrostered.txt"
if [ "$untracked" -eq 0 ] && [ "$room_untracked" -eq 0 ]; then
  echo "verdict=ok"
  exit 0
fi
[ ! -s "$work/law_untracked.txt" ] || sed 's/^/untracked: /' "$work/law_untracked.txt"
[ ! -s "$work/room_untracked.txt" ] || sed 's/^/room_untracked: /' "$work/room_untracked.txt"
echo "verdict=citation_absent"
echo "refused: a law page names a path the repository does not carry" >&2
exit 1
