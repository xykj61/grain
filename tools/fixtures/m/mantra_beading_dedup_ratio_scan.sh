#!/bin/sh
# tools/fixtures/m/mantra_beading_dedup_ratio_scan.sh -- the dedup ratio nobody had measured.
#
# WHAT THIS READS. mantra/beading.rye proves fixed-size and content-defined beading both
# correct; every existing test (fourteen pond/apps/ call sites plus one edit case in
# mantra/recall_beaded.rye) asks BeadReport a yes/no question -- did at least one bead
# dedup, did at least one land new. None of them read the RATIO: the fraction of a
# resin's bytes a real revision actually forces back into the store versus recognizes
# from before. mantra/beading_dedup_ratio.rye builds that reading, as a synthetic
# multi-revision edit sequence crossed against distribution, edit kind, size, and count,
# run through both chunkers sharing one store per chunker across the whole sequence.
#
# WHY THE EDIT KIND IS READ APART. beading.rye's own header comment names the reason
# content-defined chunking exists: "an edit shifts only nearby beads and the rest
# re-sync." A same-length SUBSTITUTE never shifts anything -- fixed-size beading's
# boundaries sit at constant byte offsets and need no resync at all for it. INSERT and
# DELETE are the shapes that actually move every downstream byte, which is the case the
# comment is about. Reading substitute and the two shifting kinds as separate buckets is
# what lets this scan say which claim the module's own design argument is actually
# making, rather than averaging two different questions into one number.
#
# WHAT THE SCAN FOUND, so a reader checking this file against a later run knows what to
# expect. Across the 12 planted substitute configs, content-defined beading reads a
# BETTER ratio in 1 of 12 -- it loses to fixed-size on same-length edits far more often
# than it wins, because a byte change can still move a content-defined boundary even
# when nothing downstream has moved, while fixed-size pays no such cost for a
# substitution. Across the 12 planted insert/delete configs, content-defined beading
# wins 11 of 12, often by a wide margin (up to 500 permille on a single front-loaded
# insert) -- the shifting case the module's own comment is actually about.
#
# WHAT THIS READING IS NOT. A claim about Mantra's real callers. pond/apps/ workloads
# may lean toward substitution, toward insert/delete, or toward some mix this synthetic
# generator does not reach at all -- that question is the proposal's own named horizon
# for spool.rye's larger scale, and stays open. This scan proves the SHAPE of the
# tradeoff on a controlled input; it does not measure a real resin history.
#
# WHAT IT READS
#   built=yes|no                   the beading_dedup_ratio binary compiled
#   configs=<n>                    total planted configs the binary read
#   substitute_cdc_wins=<a> of <b> content-defined beats fixed-size on same-length edits
#   shifting_cdc_wins=<a> of <b>   content-defined beats fixed-size on insert/delete
#   verdict=ok|red
#
# USAGE
#   sh tools/fixtures/m/mantra_beading_dedup_ratio_scan.sh
#
# Driven by tools/m/mantra_beading_dedup_ratio_witness.rish. Run from the repository root.

set -eu

_sp_root=$(CDPATH= cd -- "$(dirname "$0")" && git rev-parse --show-toplevel) || {
  echo "$0: not inside a git tree" >&2
  exit 2
}
. "$_sp_root/tools/fixtures/s/shell_portable.sh"

root="$(pwd)"
zig="$root/vendor/zig-toolchain/zig"
rye="$root/rye/bin/rye"
src="$root/mantra/beading_dedup_ratio.rye"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

bin="$work/beading-dedup-ratio"
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

substitute_line=$(printf '%s\n' "$out" | grep '^substitute_cdc_wins=' || true)
shifting_line=$(printf '%s\n' "$out" | grep '^shifting_cdc_wins=' || true)
echo "$substitute_line"
echo "$shifting_line"

if [ -z "$substitute_line" ] || [ -z "$shifting_line" ]; then
  echo "detail: the binary's output carried neither reading"
  note_red
fi

if ! printf '%s\n' "$out" | grep -q '^GREEN: beading_dedup_ratio read'; then
  echo "detail: the binary did not reach its own closing GREEN line"
  note_red
fi

echo "verdict=$verdict"
