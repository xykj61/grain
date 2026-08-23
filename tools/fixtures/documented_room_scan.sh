#!/bin/sh
# tools/fixtures/documented_room_scan.sh -- a room this tree documents must be a room a reader gets.
#
# WHY. `.gitignore` here is an ALLOW-LIST: line 8 is `/*`, ignoring everything at the repository
# root, and each project room is then let back in by name. Its own comment says so -- "When we add
# a new top-level project directory, we list it here too." Miss that line and the room is invisible
# to every clone, while `git add -A` reports success on the other files in the same commit and the
# whole thing looks shipped.
#
# That is exactly what happened to `active-development/` (REDS %120). It was opened as an arc's
# deliverable, announced in ORGANIZING, CLAUDE.md, the Lexicon, and a commit message -- and no
# reader ever received it. Nothing caught it, because nothing was broken: the commit was green, the
# links resolved locally, and the room existed on the one machine that never needed it.
#
# So the check is the reader's question, asked mechanically: every room the filing guide names, does
# a clone actually carry it?
#
# TWO HONEST EXEMPTIONS
#   a symlink to a tracked room -- `work-in-progress -> crux` is deliberate; the target is tracked.
#   a room named as DEPARTED -- ORGANIZING names `old/` and `vere/` to explain where they went, and
#   a filing guide that cannot say "this is gone" would have to lie or forget.
#
# USAGE
#   sh tools/fixtures/documented_room_scan.sh
#
# Driven by tools/d/documented_room_witness.rish. Run from the repository root.

set -eu

named=0
invisible=0
: > /tmp/drs_bad.txt

for room in $(grep -oE '^\*\*`[a-z][a-z0-9-]*/`\*\*' ORGANIZING.md | tr -d '*`/' | sort -u); do
  named=$((named + 1))

  # Named as departed? The entry says so in its own first sentence.
  if grep -qE "^\*\*\`${room}/\`\*\* -- \*\*gone" ORGANIZING.md; then
    continue
  fi

  # A symlink whose target is tracked is a room a reader receives, by another name.
  if [ -L "$room" ]; then
    target=$(readlink "$room")
    if [ -n "$(git ls-files "$target" 2>/dev/null | head -1)" ]; then continue; fi
  fi

  if [ -z "$(git ls-files "$room" 2>/dev/null | head -1)" ]; then
    echo "$room" >> /tmp/drs_bad.txt
    invisible=$((invisible + 1))
  fi
done

echo "rooms_named=$named"
echo "rooms_invisible=$invisible"
if [ "$invisible" -gt 0 ]; then sed 's/^/invisible: /' /tmp/drs_bad.txt; fi
rm -f /tmp/drs_bad.txt

if [ "$invisible" -eq 0 ]; then echo "verdict=ok"; exit 0; fi
echo "verdict=invisible_room"
echo "refused: a room this tree documents is absent from every clone -- add it to the .gitignore allow-list" >&2
exit 1
