#!/bin/sh
# tools/fixtures/c/chapter_allocator_scan.sh -- a reflex stated three times as an absolute, and checked nowhere.
#
# WHY. `context/TAME_CORE.md` line 28 carries the chapter-allocator reflex in the imperative:
# "reach the arena via `const garden = init.arena.allocator()`; never construct `ArenaAllocator` in
# authored `.rye`." `context/TAME_GUIDANCE.md` says it again under its own heading, and
# `context/specs/inherited-names.md` gives it the layered form a reader can act on -- "`init.arena`
# yes at the std seam; `ArenaAllocator` no as a name in authored code; `garden` yes as a local
# variable or Tally-owned type when we build it."
#
# Three pages, one absolute, and on `20260908.074000` a grep for the word across every file under
# `tools/` returned ZERO. `tame_style_scan_bans.rish` carries eleven bans and this is not among
# them; `tame_style_scan_advise.rish` carries nine ratchets, including the two siblings this same
# reflex list names -- `parseInt(` and `Ed25519` -- and not this one. `tame-check.rish` reads three
# textual rules and none is this. The reflex was held by habit alone across 1,958 tracked `.rye`
# sources, which is the air row's own finding: a boundary a hand passes through was a wish.
#
# AND THE HABIT HELD, WHICH IS WHY THIS IS A WALL RATHER THAN A RATCHET. Measured the same moment:
# zero authored `.rye` files name `ArenaAllocator`, and zero name `GardenAllocator`. A population
# standing at zero is the cheapest possible moment to seat a gate, because the ceiling and the wall
# are the same number and no lap is asked to pay off a backlog somebody else ran up. The next
# arrival reds on the lap it enters rather than months later.
#
# WHAT IS COUNTED, in two readings that are gated separately because they fail differently.
#   `arena_direct` -- a line of authored Rye naming `ArenaAllocator`. This is reaching past the
#     process season allocator for the inherited type, which the spec forbids because a program
#     that constructs its own arena has left the one bounded region the chapter clears whole.
#   `garden_alias` -- a line naming `GardenAllocator`. A different fault with a different cure:
#     `inherited-names.md` reserves `garden` for Tally's own owned region type, and a thin rename
#     of the inherited allocator "steals the name reserved for Tally and confuses inherited std
#     with owned vocabulary." One is reaching for the wrong thing; the other is renaming a borrowed
#     thing. Two counters rather than one, so a refusal names which.
#
# WHAT PASSES FREE, by named rule.
#   `init.arena.allocator()` -- the std seam itself, which the spec says YES to. The reading below
#     never matches it, since it carries neither banned word; it is counted separately as
#     diagnosis so a reader sees the affirmative half of the reflex beside the refusal.
#   A comment line, whose first non-whitespace is `//`. A comment constructs no allocator; it
#     teaches, and the three law pages this guard serves would each red on their own text if
#     quoted into a source. Proven in both directions, so the rule cannot become a door.
#   Dated testimony under any `date/` shelf, which keeps every word it wrote (accrete-never-break).
#   Inherited std, which `inherited-names.md` explicitly permits to keep the name internally.
#     On this tree that exemption costs nothing to honor: `rye/lib/std` is a SYMLINK into
#     `vendor/zig-toolchain/lib/std`, so `git ls-files` lists not one byte inside it -- the same
#     shape as `vendor/` and `gratitude/`, which are gitlinks. The path rule is carried anyway and
#     proven in the pen, so a later lap that vendors std into the index does not red this wall for
#     obeying the spec.
#
# WHAT IS NOT PROVEN. Whether a file that reaches no arena at all SHOULD -- `TAME_GUIDANCE.md`
# names a freestanding case with no `Init` at all, where a `FixedBufferAllocator` or a Tally region
# is the right answer, so a count of files not reaching `init.arena` measures the tree's shape
# rather than its debt. And whether an arena reached correctly is then USED within its bound, which
# is the width and assert surface other guards already read.
#
# USAGE
#   sh tools/fixtures/c/chapter_allocator_scan.sh
#   sh tools/fixtures/c/chapter_allocator_scan.sh --list          # every site, file and word
#   CHAPTER_ALLOCATOR_ROOT=<dir> sh tools/fixtures/c/chapter_allocator_scan.sh   # a pen's own tree
#
# Driven by tools/c/chapter_allocator_witness.rish. Run from the repository root.

set -u

mode=${1:-count}
root=${CHAPTER_ALLOCATOR_ROOT:-.}

# BOTH WALLS STAND AT ZERO, and they are walls rather than ratchets because the tree stood at zero
# on the day they were seated. A ceiling above a population of zero would be slack nobody earned.
arena_max=${CHAPTER_ALLOCATOR_ARENA_MAX:-0}
alias_max=${CHAPTER_ALLOCATOR_ALIAS_MAX:-0}

cd "$root" 2>/dev/null || { echo "verdict=no_root"; echo "refused: $root is not a directory" >&2; exit 1; }
git rev-parse --git-dir >/dev/null 2>&1 || { echo "verdict=no_git"; echo "refused: this scan reads git ls-files" >&2; exit 1; }

sources=$(git ls-files 2>/dev/null | grep -E '\.rye$' | grep -v '/date/' | grep -v '^rye/lib/std/')
sources_n=$(printf '%s\n' "$sources" | grep -c . || true)
if [ "$sources_n" -eq 0 ]; then
  echo "verdict=no_sources"
  echo "refused: no tracked Rye sources under this root -- a zero here would read as clean" >&2
  exit 1
fi

hits=$(printf '%s\n' "$sources" | while read -r f; do
  [ -n "$f" ] && [ -f "$f" ] || continue
  awk -v F="$f" '
    # A COMMENT CONSTRUCTS NOTHING. Its first non-whitespace being `//` covers `//`, `///` and
    # `//!`, the three comment marks this tree writes in Rye -- the same three the ASCII comment
    # meter reads. A source quoting the ban in order to teach it is doing the reflex a service.
    { line = $0 }
    line ~ /^[ \t]*\/\// { next }
    /GardenAllocator/ { print F "\t" "garden_alias"; next }
    /ArenaAllocator/  { print F "\t" "arena_direct" }
  ' "$f"
done)

arena=$(printf '%s\n' "$hits" | grep -c 'arena_direct$' || true)
alias_n=$(printf '%s\n' "$hits" | grep -c 'garden_alias$' || true)
arena_files=$(printf '%s\n' "$hits" | grep 'arena_direct$' | cut -f1 | sort -u | grep -c . || true)
alias_files=$(printf '%s\n' "$hits" | grep 'garden_alias$' | cut -f1 | sort -u | grep -c . || true)

# THE AFFIRMATIVE HALF, reported and never gated. The spec says YES to `init.arena.allocator()`,
# so a reader deserves to see how far that reflex actually reaches beside the two refusals -- and
# a file that reaches no arena may be entirely correct, per the freestanding clause named above.
seam_files=$(printf '%s\n' "$sources" | while read -r f; do
  [ -n "$f" ] && [ -f "$f" ] || continue
  grep -qF 'init.arena.allocator()' "$f" 2>/dev/null && echo "$f"
done | grep -c . || true)

if [ "$mode" = "--list" ]; then
  printf '%s\n' "$hits" | grep . | sort -u | sed 's/^/site: /'
fi

echo "sources_read=$sources_n"
echo "arena_direct_sites=$arena"
echo "arena_direct_files=$arena_files"
echo "arena_max=$arena_max"
echo "garden_alias_sites=$alias_n"
echo "garden_alias_files=$alias_files"
echo "alias_max=$alias_max"
echo "seam_reach_files=$seam_files"

verdict=ok
if [ "$arena" -gt "$arena_max" ]; then
  echo "over: arena_direct_sites=$arena past its wall of $arena_max -- reach the season arena with init.arena.allocator() and name the local garden"
  verdict=over_wall
fi
if [ "$alias_n" -gt "$alias_max" ]; then
  echo "over: garden_alias_sites=$alias_n past its wall of $alias_max -- garden is Tally's own name, never a rename of the inherited allocator"
  verdict=over_wall
fi
echo "verdict=$verdict"
[ "$verdict" = ok ] || exit 1
exit 0
