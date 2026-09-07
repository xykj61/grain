#!/bin/sh
# tools/fixtures/d/dated_path_control.sh -- a throwaway corpus whose right answer is known.
#
# WHY. tools/fixtures/d/dated_path_scan.sh reports how many dated references across the field
# still land. A walker like that is easy to believe and hard to check. The tree's own answer is
# exactly what the walker is for, so the tree cannot grade it. Here the walker runs on a corpus
# built to have one obvious answer. One file cites two dated references. One names a file that is
# there; the other names a file that is not. A walker that cannot tell those two apart cannot be
# believed on nineteen thousand.
#
# EXPECTED OUTPUT: refs_total=2, refs_home=1, refs_broken=1, broken_gone=1, verdict=ok.
#
# THE SECOND CASE, added 20260829: A CHECKOUT OF THIS SAME REPOSITORY IS NOT THE FIELD. The pen
# grows a real `git worktree add` INSIDE itself. That checkout carries its own copy of the citing
# file. The census must read exactly what it read before. It is proven from both sides, with no
# override, since a wall with a door beside it is a habit again:
#
#   the walk SEES it    -- a plain recursive grep over the pen finds the worktree's copy, so the
#                          corpus genuinely reaches those bytes and the exclusion is what removes
#                          them rather than the walker never having arrived
#   the census does NOT -- refs_total stays 2, and the added copy moves no reading at all
#   the roster is exact -- dp_worktree_dirs names the added worktree, root-relative, and never
#                          names the pen root itself, which is the field and would prune everything
#
# WHY IT IS PROVEN ON A REAL WORKTREE rather than a lookalike directory. The roster is DERIVED
# from `git worktree list`. A copied directory would prove the copying, and not the derivation.
#
# Driven by tools/d/dated_path_witness.rish. Run from the repository root.

set -eu

root="$(pwd)"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

mkdir -p "$work/room"
: > "$work/room/20260101-000000_real.md"
printf 'cites room/20260101-000000_real.md and room/20260101-000000_ghost.md\n' \
  > "$work/room/citer.md"

cd "$work"
git init -q
git config user.email pen@example.invalid
git config user.name Pen
git config commit.gpgsign false
git add -A

echo "=== case one: the field alone"
sh "$root/tools/fixtures/d/dated_path_scan.sh"

# CASE TWO. A real worktree of this pen, inside the pen, carrying its own copy of the citer.
git commit -q -m "pen: the field"
git worktree add -q -b pen-hand hand HEAD 2>/dev/null || git worktree add -q hand HEAD

# The worktree checkout carries room/citer.md already; name what the walk can find, so the two
# claims below are read against a corpus that demonstrably holds the copy.
walk_hits=$(grep -rIoE '20260101-000000_(real|ghost)\.md' hand 2>/dev/null | wc -l | tr -d ' ')
echo "walk_sees_worktree_refs=$walk_hits"

. "$root/tools/fixtures/d/dated_path_exclusions.sh"
echo "worktree_roster=$(dp_worktree_dirs | tr '\n' ' ')"
# The root is the field. A roster naming it -- as an empty line, a bare dot, or the pen's own
# absolute path -- would prune everything, so each spelling is refused by name rather than assumed
# absent.
echo "roster_names_pen_root=$(dp_worktree_dirs | awk -v r="$(pwd)" '$0=="" || $0=="." || $0==r {n++} END {print n+0}')"

echo "=== case two: the same field, with a worktree of it inside"
sh "$root/tools/fixtures/d/dated_path_scan.sh"

# CASE THREE, the direction that keeps case two honest. An ORDINARY copied directory is not a
# worktree and is not pruned, so the census counts it. Without this the reading of case two could
# not be told from a walker that never descends into any subdirectory at all.
cp -R room plain
echo "=== case three: an ordinary copy, which the census must count"
sh "$root/tools/fixtures/d/dated_path_scan.sh"

# CASE FOUR, added 20260907: A DECLARED ABSENCE IS NOT BREAKAGE, AND THE TWO BOUNDS THAT KEEP THAT
# FROM BECOMING AN ESCAPE HATCH. A row naming a log and saying on the same line that it never
# landed is testimony about a gap rather than a reference that broke -- the session-log shelves
# write exactly that row, 88 of them, and the census counted every one as lost. The narrowing is
# only safe if the two bounds hold, so both are planted here and read from both sides.
#
# Four ghosts in one pen, whose right answer is known before the walker runs:
#
#   plain     -- named, nothing said about it            -> gone      (the control on the control)
#   declared  -- named, "never landed" on the same line  -> declared  (the narrowing itself)
#   linked    -- named, "never landed", AND linked       -> gone      (a link is a promise still)
#   header    -- named; the declaration is a LINE ABOVE  -> gone      (same-line, not same-page)
#
# The last two are the load-bearing legs. Drop the link test and any page may withdraw a promise
# it is still making by writing a sentence beside it; drop the same-line test and one header
# sentence silences every row beneath it.
work4="$(mktemp -d)"
mkdir -p "$work4/room"
: > "$work4/room/20260101-000000_real.md"
{
  printf 'Some rows below name a log that never landed anywhere in this pen.\n'
  printf 'cites room/20260101-000000_real.md plainly\n'
  printf 'cites room/20260101-000000_ghost-plain.md plainly\n'
  printf 'row room/20260101-000000_ghost-declared.md *(log never landed)*\n'
  printf 'row [t](room/20260101-000000_ghost-linked.md) *(log never landed)*\n'
  printf 'cites room/20260101-000000_ghost-header.md\n'
  # THE LABEL AND THE TARGET ARE TWO REFERENCES. Only the target is a promise. A day shelf writes
  # its row this way: the basename in backticks as the link label, the target carrying the room.
  # The extractor records both strings, because they are two strings. A promise test that reads
  # the BASENAME then finds the target's link and charges it to the label. On this field that one
  # false reading was the whole of `lost_promised_living`. Booked `20260907.121623`; the exact
  # test lives in tools/fixtures/d/dated_path_scan.sh.
  printf 'row [`20260101-000000_ghost-label.md`](sub/20260101-000000_ghost-label.md)\n'
} > "$work4/room/citer.md"

# THE SAME PEN ANSWERS THE SPLIT READINGS. A reading proven only where it is zero cannot be told
# from one that is always zero. `citer.md` carries no stamp, so it is LIVING, and one of its
# ghosts is LINKED. That pair is the repairable cell. This second citer's basename opens with a
# one-clock stamp, so the mark law reads it as TESTIMONY -- see .claude/rules/stamp-and-name.md --
# and accrete-never-break forbids repairing what it promises. Its broken link raises
# `lost_promised` and `lost_testimony`, and leaves the repairable cell where it was. That is the
# distinction the two readings exist to draw.
printf 'testimony promises too: [t](room/20260101-000000_ghost-testimony.md)\n' \
  > "$work4/room/20260101-000000_witness.md"

cd "$work4"
git init -q
git config user.email pen@example.invalid
git config user.name Pen
git config commit.gpgsign false
git add -A
echo "=== case four: a declared absence, and the two bounds on it"
sh "$root/tools/fixtures/d/dated_path_scan.sh"
cd "$work"
rm -rf "$work4"
