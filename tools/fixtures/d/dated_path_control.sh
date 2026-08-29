#!/bin/sh
# tools/fixtures/d/dated_path_control.sh -- a throwaway corpus whose right answer is known.
#
# WHY. tools/fixtures/d/dated_path_scan.sh reports how many dated references across the field
# still land. A walker like that is easy to believe and hard to check, because the tree's own
# answer is exactly what the walker is for. So the walker is run here on a corpus built to have
# one obvious answer: two dated references cited from one file, one naming a file that is there
# and one naming a file that is not. A walker that cannot tell those apart cannot be believed
# on nineteen thousand.
#
# EXPECTED OUTPUT: refs_total=2, refs_home=1, refs_broken=1, broken_gone=1, verdict=ok.
#
# THE SECOND CASE, added 20260829: A CHECKOUT OF THIS SAME REPOSITORY IS NOT THE FIELD. The pen
# grows a real `git worktree add` INSIDE itself, carrying its own copy of the citing file, and the
# census must read exactly what it read before. Proven from both sides without an override, since
# a wall with a door beside it is a habit again:
#
#   the walk SEES it    -- a plain recursive grep over the pen finds the worktree's copy, so the
#                          corpus genuinely reaches those bytes and the exclusion is what removes
#                          them rather than the walker never having arrived
#   the census does NOT -- refs_total stays 2, and the added copy moves no reading at all
#   the roster is exact -- dp_worktree_dirs names the added worktree, root-relative, and never
#                          names the pen root itself, which is the field and would prune everything
#
# WHY IT IS PROVEN ON A REAL WORKTREE rather than a lookalike directory: the roster is DERIVED from
# `git worktree list`, so a copied directory would prove the copying and not the derivation.
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
