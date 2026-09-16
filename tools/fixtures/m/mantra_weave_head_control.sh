#!/bin/sh
# tools/fixtures/m/mantra_weave_head_control.sh -- break the head reader in a throwaway pen.
#
# WHY THIS EXISTS. tools/fixtures/m/mantra_weave_head_scan.sh has read the module head
# against the module since REDS %506, and it shipped with no control: four witnesses assert
# its verdict, so every leg proved the scan PASSES and not one proved it BITES. A refusal
# proven in no direction cannot be told from a bypass. On 20260916 the scan grew two more
# readings over `Diff`'s fields, and a second unproven reading beside a first is how a guard
# becomes decoration.
#
# WHAT THIS PROVES. Each refusal is planted in a pen copy of the real module, read, and then
# LIFTED -- so every bite is shown beside the same file answering ok. A plant that is never
# removed proves the scan dislikes something and never that it disliked the plant.
#
# The partition legs are the sharp ones. An operation line and a field line differ by one
# parenthesis, so a pattern reading either loosely would count `Weave.empty()` as a field of
# `Diff` or `Diff.after` as an operation of `Weave`. Both counts are asserted exactly, in the
# unplanted file and again with a field line carrying a parenthesis in its prose.
#
# EXPECTED: behaviors=17, failed=0, verdict=ok. Run from the repository root.

set -eu

# `sed -i` takes no argument on GNU and REQUIRES a backup suffix on BSD, so the two spellings
# have no overlap and this tree writes neither -- `sed_inplace` is a temporary file copied back
# through the original inode, which every host runs and which keeps the mode the repository
# tracks.
. "$PWD/tools/fixtures/s/shell_portable.sh"

scan="$PWD/tools/fixtures/m/mantra_weave_head_scan.sh"
module="$PWD/mantra/src/weave.rye"

behaviors=0
failed=0

pen="$(mktemp -d "${TMPDIR:-/tmp}/mantra-head-control.XXXXXX")"
# The pen is released on every exit path, refusal included, and it is a directory this
# script made under TMPDIR rather than one a caller named -- so the removal can only ever
# reach what this run created.
trap 'rm -rf "$pen"' EXIT INT TERM HUP

work="$pen/weave.rye"

# check <name> <expected-substring> -- run the scan on the pen file and read one line back.
check() {
  behaviors=$((behaviors + 1))
  out="$(sh "$scan" "$work" 2>&1 || true)"
  case "$out" in
    *"$2"*) echo "leg $1 ok" ;;
    *) echo "leg $1 FAILED -- wanted $2"; failed=$((failed + 1)) ;;
  esac
}

reset() { cp "$module" "$work"; }

# 1-2 -- the unplanted file reads ok, and the two enumerations come out at their real sizes.
reset
check unplanted_ok "verdict=ok"
check partition_counts_exact "diff_declared=5"

# 3-4 -- a field lands and the head stays behind. This is the direction that fired.
reset
grep -v '^//!   Diff\.after' "$work" > "$work.tmp" && cat "$work.tmp" > "$work" && rm -f "$work.tmp"
check diff_missing_bites "diff_missing=1"
check diff_missing_verdict "verdict=diff_head_disagrees"
reset
check diff_missing_lifted "verdict=ok"

# 5-6 -- the mirror: the head names a field the struct no longer declares.
reset
sed_inplace 's|^//!   Diff\.site |//!   Diff.ghost |' "$work"
check diff_stale_bites "diff_stale=1"
reset
check diff_stale_lifted "verdict=ok"

# 7-8 -- the Diff container renamed. A census reading nothing must refuse by name rather
# than answer zero of everything, which is the one verdict a healthy file also prints.
reset
sed_inplace 's|^pub const Diff = struct {|pub const Change = struct {|' "$work"
check diff_container_absent "verdict=diff_container_absent"
reset
check diff_container_lifted "verdict=ok"

# 9 -- the head's whole field list gone, which a tidy-up could do in one stroke.
reset
grep -v '^//!   Diff\.' "$work" > "$work.tmp" && cat "$work.tmp" > "$work" && rm -f "$work.tmp"
check head_lists_no_fields "verdict=head_lists_no_fields"

# 10-11 -- the elder two readings, unproven since %506. An operation lands unnamed.
reset
grep -v '^//!   weave\.merge(' "$work" > "$work.tmp" && cat "$work.tmp" > "$work" && rm -f "$work.tmp"
check head_missing_bites "head_missing=1"
reset
check head_missing_lifted "verdict=ok"

# 12 -- and the head naming an operation the module no longer publishes.
reset
sed_inplace 's|^//!   weave\.merge(alloc, w)|//!   weave.mingle(alloc, w)|' "$work"
check head_stale_bites "head_stale=1"

# 13 -- the Weave container renamed, the elder refusal.
reset
sed_inplace 's|^pub const Weave = struct {|pub const Cloth = struct {|' "$work"
check weave_container_absent "verdict=weave_container_absent"

# 14 -- THE PARTITION, planted. A field line whose PROSE carries a parenthesis must still
# read as a field and never as an operation, so the counts stand exactly where they stood.
reset
sed_inplace 's|^//!   Diff\.after    -- per insert, the kept line it follows, or null|//!   Diff.after -- per insert, the kept line it follows (or null)|' "$work"
check partition_paren_in_prose "diff_missing=1"

# 15 -- the mirror of the partition: the operation count is untouched by that same line, so
# the field line was never counted as an operation on its way to being missed as a field.
check partition_ops_untouched "listed=11"

# 16 -- an absent module refuses rather than reporting zeroes.
work="$pen/gone.rye"
check module_absent "verdict=module_absent"

echo "behaviors=$behaviors"
echo "failed=$failed"
if [ "$failed" -eq 0 ]; then echo "verdict=ok"; else echo "verdict=leg_failed"; fi
[ "$failed" -eq 0 ]
