#!/bin/sh
# tools/fixtures/m/mantra_spool_dedup_ratio_scan.sh -- the spool-scale dedup ratio the
# fourth angle named and left untouched.
#
# WHAT THIS READS. mantra/beading_dedup_ratio.rye measured a single 400-byte resin and
# found content-defined beading winning on shift edits (insert/delete), losing on
# same-length substitutes. mantra/spool.rye's own header names a different scale -- 64
# resins, two fixed-size beads each -- and spool_content never calls
# beading.bead_content_defined at all (spool.rye:143): it always chunks at
# beading.max_resin_bytes-wide ABSOLUTE offsets, then beads each resin with the
# fixed-size beading.bead alone. So this scan does not ask whether content-defined
# beading helps at spool scale -- it is never invoked there. It asks the sharper
# question a fixed-offset split raises on its own: what does an insert or delete cost
# when the SPLIT ITSELF, not only the beading inside each resin, sits at a constant
# byte offset that cannot resync after a shift?
#
# WHAT THE SCAN FOUND, so a reader comparing this guard against a later run knows what
# to expect. Same-length SUBSTITUTE edits dedup at 750-875 permille regardless of
# position (early, mid, or late in a 4-resin, 2048-byte artifact) or size (40 or 200
# bytes) -- every resin boundary at or past the edit stays at the same absolute offset,
# so only the touched resin's own beads cost anything. INSERT and DELETE collapse to
# ZERO permille when planted EARLY (almost the whole artifact lies downstream of the
# edit, and every downstream resin boundary now falls on different bytes), recover
# partially at MID (111-125 permille, roughly half the artifact downstream), and climb
# back near the substitute floor at LATE (777-875 permille, almost nothing downstream).
# The cost of a shift at spool scale is proportional to how much of the artifact lies
# after the edit, not to the edit's own size -- the 40-byte and 200-byte substitutes
# read within a few points of each other, while the same edit_size's insert/delete
# reading swings from 0 to 875 purely on WHERE it lands.
#
# WHAT THIS READING IS NOT. A claim about Mantra's real callers, or a claim that
# content-defined beading would do better at this scale -- that is a different,
# unbuilt question (spool_content would need to call bead_content_defined, or spool's
# own resin split would need to become content-defined, neither of which this scan
# touches). This scan proves the SHAPE of the cost a fixed-offset split already pays.
#
# WHAT IT READS
#   built=yes|no                      the spool-dedup-ratio binary compiled
#   configs=<n>                       total planted configs the binary read
#   substitute_mean_ratio_pm=<n>      mean dedup ratio across the 6 substitute configs
#   shifting_near_zero=<a> of <b>     insert/delete configs reading <=50 permille
#   verdict=ok|red
#
# USAGE
#   sh tools/fixtures/m/mantra_spool_dedup_ratio_scan.sh
#
# Driven by tools/m/mantra_spool_dedup_ratio_witness.rish. Run from the repository root.

set -eu

_sp_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_sp_steps=0
while [ ! -d "$_sp_root/rishi/bin" ] || [ ! -d "$_sp_root/tools/fixtures" ]; do
  _sp_steps=$((_sp_steps + 1))
  if [ "$_sp_steps" -gt 8 ] || [ "$_sp_root" = "/" ] || [ -z "$_sp_root" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  _sp_root=$(dirname "$_sp_root")
done
. "$_sp_root/tools/fixtures/s/shell_portable.sh"

root="$(pwd)"
zig="$root/vendor/zig-toolchain/zig"
rye="$root/rye/bin/rye"
src="$root/mantra/spool_dedup_ratio.rye"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

bin="$work/spool-dedup-ratio"
if env RYE_ZIG="$zig" "$rye" build "$src" -femit-bin="$bin" >/dev/null 2>&1; then
  echo "built=yes"
else
  echo "built=no"
  echo "verdict=red"
  exit 0
fi

verdict=ok
note_red() { verdict=red; }

out=$("$bin" selftest 2>&1) || { note_red; }

configs=$(printf '%s\n' "$out" | grep -c '^config ')
echo "configs=$configs"

substitute_line=$(printf '%s\n' "$out" | grep '^substitute_mean_ratio_pm=' || true)
shifting_line=$(printf '%s\n' "$out" | grep '^shifting_near_zero=' || true)
echo "$substitute_line"
echo "$shifting_line"

if [ -z "$substitute_line" ] || [ -z "$shifting_line" ]; then
  echo "detail: the binary's output carried neither reading"
  note_red
fi

if ! printf '%s\n' "$out" | grep -q '^GREEN: spool_dedup_ratio read'; then
  echo "detail: the binary did not reach its own closing GREEN line"
  note_red
fi

echo "verdict=$verdict"
