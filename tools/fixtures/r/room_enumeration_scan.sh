#!/bin/sh
# tools/fixtures/r/room_enumeration_scan.sh -- a page that lists the rooms beside it is checked
# against the rooms on disk.
#
# WHY. A door often names its neighbors, so a reader learns the shelf without walking it. That
# sentence is a claim about a POPULATION, and a population grows. `docs-geode/etc/README.md` is the
# room held open for a genre that does not exist yet, and it named "the eleven rooms standing beside
# this one" and listed all eleven by name. Twelve stood. `docs-geode/lessons/` landed `20260910` in
# commit `e40799aba` and the waiting room never heard, so the page whose whole job is to notice a
# new genre was the one page that missed one. Its closing sentence -- "the day a twelfth genre
# arrives, this shelf is already here to take it" -- had already come true.
#
# WHAT NOTHING ELSE READ, and this is the sharp half. `tools/cr/crushed_index_witness.rish` exists
# for exactly this fault: its own header records three typed counts wrong at once on `20260906`,
# including the shelf front door saying "ten rooms" over a table of twelve. The repair it built
# reads MEMBERSHIP -- every member of a declared room has a row on that room's index -- so the shelf
# front door's `lessons/` row was there the day the room landed. A count or a list a page types in
# PROSE is read by nothing, on any page, including the four that guard declares. So the fault the
# guard was built for survives beside it in the half the guard does not reach.
#
# WHAT MAKES IT CHECKABLE: the enumeration is DECLARED on one line rather than inferred from prose.
# A page opts in by carrying a `**Neighbors:**` key holding a Markdown link to the parent room and
# the neighbor names in backticks, the way a page declares its `**Style:**`, `**Room:**`, and
# `**Front door:**`. Opting in is the whole population filter, so no reading here guesses which
# sentence meant to be a list, and no reading walks a page's body for a stray backticked word.
#
# TWO SENSES, TWO KEYS, ONE COMPARISON. A page standing INSIDE a room lists the rooms beside it and
# says `**Neighbors:**`; a room's own FRONT DOOR lists the rooms under it and says `**Members:**`,
# with its link naming its own directory. The mechanism is identical -- resolve the link, walk the
# directories, compare -- and only the word differs, because `api/` is a neighbor of
# `docs-geode/etc/README.md` and a member of `docs-geode/README.md`. Calling both neighbors would
# save a line of shell and tell a reader something untrue, which is the trade this tree declines.
#
# WHY THE SECOND KEY EARNED ITS OWN LAP. Read `20260911.092737`, the day after the first key landed:
# ONE page in the tree declared, and it was the page whose own fault built the guard. Meanwhile the
# three prose rooms this tree names -- `manual/`, `docs/`, `docs-geode/` -- each typed a member list
# in prose, and TWO of the three were already wrong. `manual/README.md` holds a section literally
# titled "What Lives Here" and never named `video-scripts/`, three newcomer video scripts; and
# `docs/README.md`, the compression shelf, never named `docs/redacted/`. Both rooms were named only
# from OTHER rooms -- the Bhakta register law, and `docs-geode/edu/README.md` one lane over -- so the
# claim stood in a distant room while the room that owned it was silent. A front door is the most
# Lindy-exposed page a project owns (`foundations/20260811-211431_the-lindy-effect-and-the-long-return.md`),
# so a list typed there and read by nothing goes quietly wrong the first time a room lands.
#
# THE SAME SAFETY TEST, RUN RATHER THAN ASSUMED. `**Members:**` was grepped against every reader in
# `tools/` before a byte landed: no scan matches it, no living page carried it, and it does not match
# `two_rooms_doorway_scan_one.sh`'s `\*\*Room[^:]*:\*\*` -- proven by feeding that regex the literal
# line rather than by reading it. The two memberships are PRINTED APART, `pages_neighbors` beside
# `pages_members`, so a page that falls out of one by an edit made elsewhere is legible in the census
# rather than silent.
#
# WHY THE FIRST KEY IS SPELLED `Neighbors` AND NOT `Rooms beside`. The Comlink tendency asks three things
# of a new name -- clear, fun, and SAFE, where safe means it collides with nothing seated. The first
# draft read `**Rooms beside:**` and failed the third test by grep: `two_rooms_doorway_scan_one.sh`
# reads a page's door with `\*\*Room[^:]*:\*\*`, which `**Rooms beside:**` matches. Nothing breaks
# on the page below, since its Status line already carries the room token and that scan greps both
# lines together -- yet a page whose Status named no room, listing a neighbor literally called
# `vision` or `mixed`, would have read as a room declaration it never made. The test is cheap and it
# earned its place here before a byte landed.
#
# WHAT IS GATED, hard, at zero:
#   missing  -- a directory under the parent room, other than the page's own, absent from the list
#   phantom  -- a listed name with no directory under the parent room
#   no_target -- a `**Neighbors:**` key carrying no Markdown link at all
#   absent   -- the linked parent room is not a directory in this tree
#   unreadable -- a room name under the parent outside `^[a-z][a-z0-9-]*$`, which this reading
#                 cannot compare without splitting on it; named rather than dropped in silence
#
# WHAT IS READ PAST. The page's OWN room, since the seated sentence is "beside this one"; the
# `date/`, `archive/` and `yonder/` shelves under the parent, which are closed stacks holding
# testimony rather than genres; and any name not matching `^[a-z][a-z0-9-]*$`, which is what keeps
# the link's own backticked text (`../`) out of the claimed set.
#
# WHAT IT DOES NOT REACH. Whether a page that OUGHT to enumerate its neighbors has declined to --
# opting in is the filter, so an undeclared door is invisible here, exactly as `front_door_claim`
# says of its own population. And whether the prose around the key says anything true.
#
# Driven by tools/r/room_enumeration_witness.rish. Run from the repository root.
# Run: sh tools/fixtures/r/room_enumeration_scan.sh [--explain]
set -u

EXPLAIN=no
[ "${1:-}" = "--explain" ] && EXPLAIN=yes

# The reading is of a tracked tree. Outside a repository it refuses rather than walking the disk.
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || {
    echo "verdict=no_repository"
    exit 2
}

missing=0
phantom=0
no_target=0
absent=0
unreadable=0
pages=0
neighbors=0
members=0

# THE POPULATION, in ONE process rather than one per page. A `grep -q` per tracked Markdown file
# spawns a process for each of several thousand pages to find the handful that declare the key;
# `git grep -l` asks the same question once and answers in a fraction of the time. Closed stacks --
# the date, archive and yonder shelves -- hold testimony and are read past.
# AND IT IS READ THROUGH A REDIRECT rather than a pipe or a word split. A `for page in $LIST` splits
# a path on a space, and a pipe into `while read` runs the loop in a subshell where every count
# below would be discarded at the end. A file read on the loop's own stdin keeps both the paths and
# the counts whole.
DECLARING=$(mktemp) || { echo "verdict=no_pen"; exit 2; }
trap 'rm -f "$DECLARING"' EXIT
git grep -lE '^\*\*(Neighbors|Members):\*\*' -- '*.md' 2>/dev/null \
    | grep -vE '(^|/)(date|archive|yonder)/' > "$DECLARING"

while IFS= read -r page; do
    [ -n "$page" ] || continue
    pages=$((pages + 1))
    line=$(grep -m1 -E '^\*\*(Neighbors|Members):\*\*' "$page")
    # The two memberships are counted apart, so a page leaving one is visible rather than silent.
    case "$line" in
        '**Members:**'*) members=$((members + 1)) ;;
        *)               neighbors=$((neighbors + 1)) ;;
    esac
    dir=$(dirname "$page")

    # The link names the parent room, resolved against the page's own directory.
    # THE FIRST LINK ON THE LINE, never the last. The key's grammar is "the rooms under <link> --
    # `name`, `name`", so the parent is always the first link, and a `.*](` is GREEDY: it walks to
    # the LAST link on the line. A key that closes with a pointer to the law behind the room -- which
    # is ordinary, useful prose -- then had its parent read as that pointer, and `docs/README.md`
    # refused with `absent` naming a rule page. Taking the first link lets a key carry a trailing
    # link and costs nothing where there is only one, which is every key written before this lap.
    rel=$(printf '%s\n' "$line" | sed -n 's/^[^]]*](\([^)]*\)).*/\1/p' | head -1)
    if [ -z "$rel" ]; then
        no_target=$((no_target + 1))
        [ "$EXPLAIN" = yes ] && echo "detail: $page -- no_target, the key carries no Markdown link"
        continue
    fi
    parent=$(cd "$dir" 2>/dev/null && cd "$rel" 2>/dev/null && pwd)
    if [ -z "$parent" ] || [ ! -d "$parent" ]; then
        absent=$((absent + 1))
        [ "$EXPLAIN" = yes ] && echo "detail: $page -- absent, '$rel' is no directory"
        continue
    fi

    self=$(basename "$dir")

    # Claimed: backticked bare names on the key line. The name rule is what excludes the link text.
    claimed=$(printf '%s\n' "$line" | grep -oE '`[a-z][a-z0-9-]*`' | tr -d '`' | sort -u)

    # Actual: immediate subdirectories of the parent, minus this page's own room and the shelves.
    # THE SAME NAME RULE AS THE CLAIMED SET, and it is load-bearing rather than tidy: this loop
    # splits on whitespace, so a directory carrying a space would arrive as two words and read as
    # two rooms the list never names -- a false refusal, which is the costliest kind. A name
    # outside the rule is counted under `unreadable` and named, never silently dropped.
    actual=$(cd "$parent" && ls -d */ 2>/dev/null | sed 's|/$||' \
        | grep -xE '[a-z][a-z0-9-]*' | grep -vxE "$self|date|archive|yonder" | sort -u)
    odd=$(cd "$parent" && ls -d */ 2>/dev/null | sed 's|/$||' \
        | grep -vxE '[a-z][a-z0-9-]*' | grep -vxE "$self|date|archive|yonder" | wc -l)
    if [ "$odd" -gt 0 ]; then
        unreadable=$((unreadable + odd))
        [ "$EXPLAIN" = yes ] && echo "detail: $page -- $odd room name(s) under $rel outside [a-z][a-z0-9-]*"
    fi

    for a in $actual; do
        printf '%s\n' "$claimed" | grep -qx "$a" || {
            missing=$((missing + 1))
            [ "$EXPLAIN" = yes ] && echo "detail: $page -- missing '$a', a room under $rel the list never names"
        }
    done
    for c in $claimed; do
        printf '%s\n' "$actual" | grep -qx "$c" || {
            phantom=$((phantom + 1))
            [ "$EXPLAIN" = yes ] && echo "detail: $page -- phantom '$c', named in the list and no room on disk"
        }
    done
done < "$DECLARING"

echo "pages_declaring=$pages"
echo "pages_neighbors=$neighbors"
echo "pages_members=$members"
echo "missing=$missing"
echo "phantom=$phantom"
echo "no_target=$no_target"
echo "absent=$absent"
echo "unreadable=$unreadable"

# A POPULATION THAT CAME BACK EMPTY prints four zeros and reads exactly like a tree whose every
# enumeration is true. That is the confident wrong zero, so it refuses by name instead.
if [ "$pages" -eq 0 ]; then
    echo "verdict=no_enumerations"
    exit 1
fi
if [ "$missing" -eq 0 ] && [ "$phantom" -eq 0 ] && [ "$no_target" -eq 0 ] && [ "$absent" -eq 0 ] \
   && [ "$unreadable" -eq 0 ]; then
    echo "verdict=ok"
    exit 0
fi
echo "verdict=enumeration_drift"
exit 1
