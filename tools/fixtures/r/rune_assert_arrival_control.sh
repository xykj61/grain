#!/bin/sh
# tools/fixtures/r/rune_assert_arrival_control.sh -- the arrival finder proven on real repositories.
# Orchestrated by tools/r/rune_assert_arrival_witness.rish.
#
#   sh tools/fixtures/r/rune_assert_arrival_control.sh
#
# WHAT THIS PROVES. Every reading the finder publishes is a claim about commits nobody typed, so
# each is planted in a throwaway git repository in a pen, read while it stands, and read back once
# it is lifted. Every refusal is shown from BOTH sides -- planted and then removed -- since a
# refusal proven only in the passing direction cannot be told from a bypass.
#
# THE PEN IS A REAL REPOSITORY, never a directory of files. The finder walks `git rev-list`,
# `git diff-tree` and `git archive`, so a pen without commits would prove the awk and none of the
# walk. REDS %745 is why the pen is released on every exit path rather than on the success one.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md.
set -eu

root=$(pwd)
scan="$root/tools/fixtures/r/rune_assert_arrival.sh"
sweep="$root/tools/fixtures/r/rune_assert_sweep_scan.sh"
pen=$(mktemp -d "${TMPDIR:-/tmp}/rune_assert_arrival_control.XXXXXX")
trap 'rm -rf "$pen"' EXIT INT HUP TERM

legs=0
failed=0
say() {
  legs=$((legs + 1))
  echo "$1=$2"
  if [ "$2" != "yes" ]; then failed=$((failed + 1)); fi
}

repo="$pen/repo"
mkdir -p "$repo/room" "$repo/tools/fixtures/r" "$repo/tools/fixtures/t"
cd "$repo"
git init -q .
git config user.email pen@pen.invalid
git config user.name pen
git config commit.gpgsign false
printf 'room\n' > tools/fixtures/t/tame_style_rooms.txt
cp "$sweep" tools/fixtures/r/rune_assert_sweep_scan.sh
cp "$scan" tools/fixtures/r/rune_assert_arrival.sh

# A NAMED assert: the file counts in the population and contributes zero unnamed.
cat > room/clean.rye <<'EOF'
const std = @import("std");
const assert = std.debug.assert;
pub fn hold(n: u32) void {
    // invariant: the count stays inside the bound this module declares
    assert(n < 8);
}
EOF
git add -A
git commit -q -m "pen: a named assert"
base=$(git rev-parse HEAD)

# A commit touching no .rye at all -- it must never be extracted and never read as an arrival.
printf 'prose\n' > NOTES.md
git add -A
git commit -q -m "pen: prose only"
prose=$(git rev-parse HEAD)

out=$(sh tools/fixtures/r/rune_assert_arrival.sh "$base" "$prose" 2>&1)
case "$out" in *"commits=1 touching_rye=0"*) say prose_commit_not_touching yes ;; *) say prose_commit_not_touching no ;; esac
case "$out" in *"arrivals=0"*) say prose_commit_no_arrival yes ;; *) say prose_commit_no_arrival no ;; esac
case "$out" in *"old_unnamed=0"*) say named_assert_reads_zero yes ;; *) say named_assert_reads_zero no ;; esac

# THE ARRIVAL: one unnamed assert enters an existing file.
cat > room/clean.rye <<'EOF'
const std = @import("std");
const assert = std.debug.assert;
pub fn hold(n: u32) void {
    // invariant: the count stays inside the bound this module declares
    assert(n < 8);
}
pub fn also(n: u32) void {
    assert(n > 0);
}
EOF
git add -A
git commit -q -m "pen: an unnamed assert arrives"
arrival=$(git rev-parse HEAD)

out=$(sh tools/fixtures/r/rune_assert_arrival.sh "$base" "$arrival" 2>&1)
case "$out" in *"arrivals=1"*) say arrival_counted yes ;; *) say arrival_counted no ;; esac
case "$out" in *"0 -> 1"*) say arrival_delta_printed yes ;; *) say arrival_delta_printed no ;; esac
case "$out" in *"room/clean.rye"*) say arrival_names_the_file yes ;; *) say arrival_names_the_file no ;; esac
case "$out" in *"$(git rev-parse --short=10 "$arrival")"*) say arrival_names_the_commit yes ;; *) say arrival_names_the_commit no ;; esac
case "$out" in *"an unnamed assert arrives"*) say arrival_names_the_subject yes ;; *) say arrival_names_the_subject no ;; esac
case "$out" in *"new_unnamed=1"*) say arrival_moves_the_total yes ;; *) say arrival_moves_the_total no ;; esac
# The silent commit sits INSIDE this window and must still be passed over.
case "$out" in *"commits=2 touching_rye=1"*) say silent_commit_skipped_inside_window yes ;; *) say silent_commit_skipped_inside_window no ;; esac

# A NEW FILE arriving with one unnamed assert -- the shape the heaviest-twenty red can never show.
cat > room/fresh.rye <<'EOF'
const std = @import("std");
const assert = std.debug.assert;
pub fn open(n: u32) void {
    assert(n < 4);
}
EOF
git add -A
git commit -q -m "pen: a new file carrying one"
fresh=$(git rev-parse HEAD)
out=$(sh tools/fixtures/r/rune_assert_arrival.sh "$arrival" "$fresh" 2>&1)
case "$out" in *"room/fresh.rye 0 -> 1"*) say new_file_arrival_named yes ;; *) say new_file_arrival_named no ;; esac

# THE REPAIR: naming the assert must read as a FALL rather than be passed over.
cat > room/fresh.rye <<'EOF'
const std = @import("std");
const assert = std.debug.assert;
pub fn open(n: u32) void {
    // invariant: the caller's index stays inside the four seats this holds
    assert(n < 4);
}
EOF
git add -A
git commit -q -m "pen: the repair names it"
repaired=$(git rev-parse HEAD)
out=$(sh tools/fixtures/r/rune_assert_arrival.sh "$fresh" "$repaired" 2>&1)
case "$out" in *"room/fresh.rye 1 -> 0"*) say repair_reads_as_a_fall yes ;; *) say repair_reads_as_a_fall no ;; esac
case "$out" in *"arrivals=1"*) say fall_is_counted_too yes ;; *) say fall_is_counted_too no ;; esac

# A WITNESS file's asserts stay in the proving half and never reach this reading.
cat > room/thing_witness.rye <<'EOF'
const std = @import("std");
const assert = std.debug.assert;
pub fn main() void {
    assert(1 == 1);
}
EOF
git add -A
git commit -q -m "pen: a proving file"
proving=$(git rev-parse HEAD)
out=$(sh tools/fixtures/r/rune_assert_arrival.sh "$repaired" "$proving" 2>&1)
case "$out" in *"arrivals=0"*) say proving_file_is_no_arrival yes ;; *) say proving_file_is_no_arrival no ;; esac
case "$out" in *"touching_rye=1"*) say proving_file_still_extracted yes ;; *) say proving_file_still_extracted no ;; esac

# REFUSALS, each shown from both sides.
out=$(sh tools/fixtures/r/rune_assert_arrival.sh 2>&1 || true)
case "$out" in *"verdict=unread"*) say no_ref_refused yes ;; *) say no_ref_refused no ;; esac
out=$(sh tools/fixtures/r/rune_assert_arrival.sh no-such-ref 2>&1 || true)
case "$out" in *"unresolvable ref"*) say bad_ref_refused yes ;; *) say bad_ref_refused no ;; esac
out=$(sh tools/fixtures/r/rune_assert_arrival.sh "$base" HEAD 2>&1 || true)
case "$out" in *"verdict=read"*) say good_ref_welcomed yes ;; *) say good_ref_welcomed no ;; esac

mv tools/fixtures/t/tame_style_rooms.txt "$pen/rooms.held"
out=$(sh tools/fixtures/r/rune_assert_arrival.sh "$base" HEAD 2>&1 || true)
case "$out" in *"absent instrument"*) say absent_roster_refused yes ;; *) say absent_roster_refused no ;; esac
mv "$pen/rooms.held" tools/fixtures/t/tame_style_rooms.txt
out=$(sh tools/fixtures/r/rune_assert_arrival.sh "$base" HEAD 2>&1 || true)
case "$out" in *"verdict=read"*) say roster_restored_welcomed yes ;; *) say roster_restored_welcomed no ;; esac

# THE BOUND, shown from both sides by moving the ceiling rather than by making 256 commits.
sed 's/^max_commits=256$/max_commits=1/' tools/fixtures/r/rune_assert_arrival.sh > "$pen/bounded.sh"
out=$(sh "$pen/bounded.sh" "$base" HEAD 2>&1 || true)
case "$out" in *"over max_commits=1"*) say window_over_bound_refused yes ;; *) say window_over_bound_refused no ;; esac
out=$(sh "$pen/bounded.sh" "HEAD^" HEAD 2>&1 || true)
case "$out" in *"verdict=read"*) say window_at_bound_welcomed yes ;; *) say window_at_bound_welcomed no ;; esac

# THE PEN IS RELEASED, including on a refusal -- REDS %745's own reading.
before=$(find "${TMPDIR:-/tmp}" -maxdepth 1 -name 'rune_assert_arrival.*' 2>/dev/null | grep -c '' || true)
sh tools/fixtures/r/rune_assert_arrival.sh "$base" HEAD > /dev/null 2>&1 || true
sh tools/fixtures/r/rune_assert_arrival.sh no-such-ref > /dev/null 2>&1 || true
after=$(find "${TMPDIR:-/tmp}" -maxdepth 1 -name 'rune_assert_arrival.*' 2>/dev/null | grep -c '' || true)
if [ "$before" -eq "$after" ]; then say pen_released_both_paths yes; else say pen_released_both_paths no; fi

# THE MUTATION THAT MUST BITE: dropping the .rye filter makes every prose commit an extraction.
sed 's/grep -qE .\\\.rye\$./grep -q ./' tools/fixtures/r/rune_assert_arrival.sh > "$pen/nofilter.sh"
out=$(sh "$pen/nofilter.sh" "$base" HEAD 2>&1 || true)
case "$out" in *"touching_rye=1"*) say filter_mutation_bites no ;; *) say filter_mutation_bites yes ;; esac

cd "$root"
echo "legs=$legs"
echo "control_failed=$failed"
echo "control=done"
