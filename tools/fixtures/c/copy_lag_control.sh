#!/bin/sh
# tools/fixtures/c/copy_lag_control.sh -- prove the copy-lag reading by doing, on real repositories.
#
# WHY. A guard that cannot red guards nothing. This control builds git repositories in a temporary
# pen, plants one condition in each, runs tools/fixtures/c/copy_lag_scan.sh inside them, and checks
# that the refusals bite and the honest readings stay free. Nothing here touches the tree it runs
# from.
#
# THE CEILING IS ASKED FOR, NEVER SPELLED. The pen reads `behind_ceiling` out of the scan's own
# output and plants one past it, so this control tests the law rather than a snapshot of the law --
# a pen holding the constant `2` would quietly stop proving anything the day the ratchet fell.
#
# USAGE
#   sh tools/fixtures/c/copy_lag_control.sh
# Driven by tools/co/copy_lag_witness.rish. Run from the repository root.

set -u

root=$(pwd -P)
scan=$root/tools/fixtures/c/copy_lag_scan.sh
[ -f "$scan" ] || { echo "control_verdict=scan_missing" >&2; exit 1; }

pen=$(mktemp -d) || { echo "control_verdict=no_pen" >&2; exit 1; }
trap 'rm -rf "$pen"' EXIT INT TERM

# A repository holding one canon in `alpha/`, one symlinking room in `beta/`, and whatever the
# caller plants beside them. The canon publishes two items so a copy can lack one.
build() {
  d=$pen/$1
  mkdir -p "$d/alpha" "$d/beta"
  printf 'pub const Widget = struct {};\npub fn take() void {}\npub fn give() void {}\n' > "$d/alpha/thing.rye"
  ( cd "$d/beta" && ln -s ../alpha/thing.rye thing.rye )
  ( cd "$d" && git init -q . && git config user.email pen@example.invalid && git config user.name Pen ) >/dev/null 2>&1
  echo "$d"
}

seal() { ( cd "$1" && git add -A && git commit -qm 'pen: one canon and its rooms' ) >/dev/null 2>&1; }

read_scan() { ( cd "$1" && sh "$scan" 2>/dev/null; ) }
# The elder reader keeps only the output, which is what nine of the twelve legs ask about.
# A refusal is an exit code as much as a verdict line, so the two new legs read it directly.
scan_status() { ( cd "$1" && sh "$scan" >/dev/null 2>&1; echo $?; ) }

has() { printf '%s\n' "$1" | grep -q "$2"; }

# 1. A canon and a symlink, nothing else. No copy exists, and the canon is never counted as one.
d=$(build clean); seal "$d"
out=$(read_scan "$d")
has "$out" 'verdict=ok'   && echo "clean_free=yes"          || echo "clean_free=no"
has "$out" 'copies=0'     && echo "canon_not_a_copy=yes"    || echo "canon_not_a_copy=no"
has "$out" 'basenames_both_ways=1' && echo "population_seen=yes" || echo "population_seen=no"

# 2. A byte-identical copy is a copy, and it agrees. Counted, and free.
d=$(build identical)
mkdir -p "$d/gamma"; cp "$d/alpha/thing.rye" "$d/gamma/thing.rye"; seal "$d"
out=$(read_scan "$d")
has "$out" 'copies=1'     && echo "identical_counted=yes"   || echo "identical_counted=no"
has "$out" 'identical=1'  && echo "identical_agrees=yes"    || echo "identical_agrees=no"
has "$out" 'verdict=ok'   && echo "identical_free=yes"      || echo "identical_free=no"

# 3. The lag itself -- a copy publishing nothing of its own and lacking one. Counted and named,
#    and free under the ceiling, because the ratchet reports before it refuses.
d=$(build behind)
mkdir -p "$d/gamma"
printf 'pub const Widget = struct {};\npub fn take() void {}\n' > "$d/gamma/thing.rye"
seal "$d"
out=$(read_scan "$d")
has "$out" 'behind=1'                  && echo "behind_counted=yes" || echo "behind_counted=no"
has "$out" 'detail: behind gamma/thing.rye' && echo "behind_named=yes" || echo "behind_named=no"
has "$out" 'lacking 1'                 && echo "behind_priced=yes" || echo "behind_priced=no"
has "$out" 'verdict=ok'                && echo "behind_under_ceiling_free=yes" || echo "behind_under_ceiling_free=no"

# 4. A different module sharing a word. It publishes its own, so it is a sibling rather than a lag.
d=$(build sibling)
mkdir -p "$d/gamma"
printf 'pub const Other = struct {};\npub fn spin() void {}\n' > "$d/gamma/thing.rye"
seal "$d"
out=$(read_scan "$d")
has "$out" 'sibling=1' && echo "sibling_counted=yes" || echo "sibling_counted=no"
has "$out" 'behind=0'  && echo "sibling_not_behind=yes" || echo "sibling_not_behind=no"
has "$out" 'verdict=ok' && echo "sibling_free=yes" || echo "sibling_free=no"

# 5. The parse_int shape -- one published surface, different bytes. Behind, because a copy that
#    publishes nothing of its own has nothing of its own to be.
d=$(build byteonly)
mkdir -p "$d/gamma"
printf '// a comment the canon does not carry\npub const Widget = struct {};\npub fn take() void {}\npub fn give() void {}\n' > "$d/gamma/thing.rye"
seal "$d"
out=$(read_scan "$d")
has "$out" 'differ=1' && echo "byte_only_differs=yes" || echo "byte_only_differs=no"
has "$out" 'behind=1' && echo "byte_only_is_behind=yes" || echo "byte_only_is_behind=no"

# 6. A symlink naming a symlink. One canon, resolved through the chain -- the blindness that made
#    this control's own tree read as four-way split before the resolver was bounded and walked.
d=$(build chain)
mkdir -p "$d/delta"
( cd "$d/delta" && ln -s ../beta/thing.rye thing.rye )
seal "$d"
out=$(read_scan "$d")
has "$out" 'split_canon=0' && echo "chain_resolved=yes" || echo "chain_resolved=no"
has "$out" 'verdict=ok'    && echo "chain_free=yes"     || echo "chain_free=no"

# 7. Two symlinks genuinely naming two different files. No one canon exists, and picking one
#    silently is the fault this reading refuses.
d=$(build split)
mkdir -p "$d/gamma" "$d/delta"
printf 'pub fn other() void {}\n' > "$d/gamma/thing.rye"
( cd "$d/delta" && ln -s ../gamma/thing.rye thing.rye )
seal "$d"
out=$(read_scan "$d")
has "$out" 'split_canon=1'      && echo "split_counted=yes" || echo "split_counted=no"
has "$out" 'verdict=canon_split' && echo "split_refused=yes" || echo "split_refused=no"

# 8. The ceiling, proven from both sides, with the ceiling ASKED FOR rather than spelled.
d=$(build ceiling); seal "$d"
ceiling=$(read_scan "$d" | sed -n 's/^behind_ceiling=//p')
case "${ceiling:-}" in ''|*[!0-9]*) echo "ceiling_read=no"; ceiling=0 ;; *) echo "ceiling_read=yes" ;; esac

plant_behind() {
  # $1 pen dir, $2 how many rooms each holding a copy that lacks one published item
  i=0
  while [ "$i" -lt "$2" ]; do
    r=$1/room$i
    mkdir -p "$r"
    printf 'pub const Widget = struct {};\npub fn take() void {}\n' > "$r/thing.rye"
    i=$((i + 1))
  done
}

d=$(build at_ceiling); plant_behind "$d" "$ceiling"; seal "$d"
out=$(read_scan "$d")
has "$out" "behind=$ceiling" && echo "at_ceiling_counted=yes" || echo "at_ceiling_counted=no"
has "$out" 'verdict=ok'      && echo "at_ceiling_free=yes"    || echo "at_ceiling_free=no"

over=$((ceiling + 1))
d=$(build over_ceiling); plant_behind "$d" "$over"; seal "$d"
out=$(read_scan "$d")
has "$out" "behind=$over"                 && echo "over_ceiling_counted=yes" || echo "over_ceiling_counted=no"
has "$out" 'verdict=behind_over_ceiling'  && echo "over_ceiling_refused=yes" || echo "over_ceiling_refused=no"

# 9. A tree holding no Rye at all says so, rather than answering `nothing is wrong` over nothing.
d=$pen/empty; mkdir -p "$d"
( cd "$d" && git init -q . && git config user.email pen@example.invalid && git config user.name Pen \
  && printf 'no rye here\n' > README.md && git add -A && git commit -qm 'pen: no rye' ) >/dev/null 2>&1
out=$(read_scan "$d")
has "$out" 'verdict=no_rye' && echo "empty_says_so=yes" || echo "empty_says_so=no"
[ "$(scan_status "$d")" -ne 0 ] && echo "empty_refuses=yes" || echo "empty_refuses=no"

# 10. An untracked copy is not the tree's, and the population is what git tracks.
d=$(build untracked); seal "$d"
mkdir -p "$d/gamma"
printf 'pub const Widget = struct {};\n' > "$d/gamma/thing.rye"
out=$(read_scan "$d")
has "$out" 'copies=0'   && echo "untracked_unread=yes" || echo "untracked_unread=no"
has "$out" 'verdict=ok' && echo "untracked_free=yes"   || echo "untracked_free=no"

# 11. A root that is not a checkout cannot be read, and the reading says which instrument refused
#     rather than reporting a clean tree. This is the leg REDS %473 was booked for: the first draft
#     piped `git ls-files` into `awk` under `|| true`, so a refused index landed on the same
#     `no_rye` answer an honest empty tree gives, at exit 0.
d=$pen/no_checkout; mkdir -p "$d/alpha"
printf 'pub fn take() void {}\n' > "$d/alpha/thing.rye"
out=$(read_scan "$d")
has "$out" 'verdict=no_checkout'  && echo "no_checkout_says_so=yes" || echo "no_checkout_says_so=no"
has "$out" 'git ls-files refused' && echo "no_checkout_named=yes"   || echo "no_checkout_named=no"
[ "$(scan_status "$d")" -ne 0 ]   && echo "no_checkout_refuses=yes" || echo "no_checkout_refuses=no"

echo "control_verdict=ok"
