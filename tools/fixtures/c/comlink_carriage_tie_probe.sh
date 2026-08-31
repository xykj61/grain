#!/bin/sh
# tools/fixtures/c/comlink_carriage_tie_probe.sh -- the carriage ties, proven on metal both ways.
#
# WHY THIS EXISTS SEPARATELY FROM THE SCAN. The scan reads text, so it proves a tie is WRITTEN and
# can never prove it HOLDS. A comptime block that is never evaluated -- inside dead code, or
# behind a constant the compiler folds away -- reads identically to one the language checks on
# every build. Only the compiler can tell those apart, so the question is handed to it here.
#
# WHAT IS ASKED, TWICE OVER
#
#   HOLDS     each tied module compiles as it stands, so the carriage relation is true against
#             the real constants rather than against a remembered arithmetic.
#   REFUSES   the same tie inverted stops the build at comptime. A refusal proven only in the
#             passing direction cannot be told from a bypass.
#
# AND THEN A THIRD ASKING, which is the one that matters most. The four inverted cases prove the
# blocks are live; the three cases below them plant the PLAUSIBLE REAL EDITS -- the ones a
# routine lap would actually make -- and require the build to stop:
#
#   cdc_min_bead 64 -> 32     a chunker tuning change, filed beside a hash mask
#   max_resin_bytes 512 -> 576   a capacity a growing tree naturally raises
#   max_batch_chunks 16 -> 8     a carriage bound halved
#
# Each of those three was measured to produce a real refusal before this probe was written: at
# 576, 9 of 3,999 pseudorandom wholes come back TooManyBeads from a module that accepted them.
#
# The pen is a copy, so the tree is never edited to prove any of this.
#
# WHAT IT READS
#   tied_modules   how many modules carry a carriage tie
#   tie_holds      how many of those compile as they stand
#   tie_refuses    how many refuse at comptime once inverted
#   edit_refuses   how many plausible real edits the compiler stops
#   verdict        proven, or the first failure found
#
# USAGE
#   sh tools/fixtures/c/comlink_carriage_tie_probe.sh
#
# Driven by tools/co/comlink_carriage_witness.rish. Run from the repository root.

set -eu

root="$(pwd)"
zig="$root/vendor/zig-toolchain/zig"
rye="$root/rye/bin/rye"

for f in "$zig" "$rye"; do
  [ -x "$f" ] || { echo "verdict=toolchain_missing"; echo "detail: $f"; exit 1; }
done

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

# The pen dereferences symlinks on purpose: both tied rooms live in mantra/ and are reached
# through a comlink/ face, and a pen holding dangling links would prove nothing.
cp -RL "$root/comlink" "$work/comlink"

tied_modules=0
tie_holds=0
tie_refuses=0
edit_refuses=0
verdict=proven

builds() {
  env RYE_ZIG="$zig" "$rye" build-lib "$work/comlink/$1.rye" -lc -femit-bin="$work/$1.$2.o" \
    >"$work/$1.$2.log" 2>&1
}

# $1 module  $2 tag  $3 sed expression  -- returns 0 when the compiler REFUSED at comptime
stopped_by_comptime() {
  cp "$work/comlink/$1.rye" "$work/keep-$1-$2.rye"
  sed "$3" "$work/comlink/$1.rye" > "$work/e.tmp" && cat "$work/e.tmp" > "$work/comlink/$1.rye"
  ok=0   # 0 refused at comptime, 1 built anyway, 2 refused for another reason
  if builds "$1" "$2"; then
    ok=1
  else
    grep -q 'called at comptime here' "$work/$1.$2.log" || ok=2
  fi
  cat "$work/keep-$1-$2.rye" > "$work/comlink/$1.rye"
  return "$ok"
}

# -- the ties as they stand ------------------------------------------------------------------
for m in beading recall_batch_wire; do
  src="$work/comlink/$m.rye"
  [ -f "$src" ] || { verdict=module_missing; echo "detail: $m is not in the pen"; continue; }
  grep -q '^comptime {' "$src" || { verdict=tie_absent; echo "detail: $m carries no comptime block"; continue; }
  tied_modules=$((tied_modules + 1))
  if builds "$m" hold; then
    tie_holds=$((tie_holds + 1))
  else
    verdict=tie_does_not_hold
    echo "detail: $m does not compile with its ties as written"
  fi
done

# -- each tie inverted, one at a time ---------------------------------------------------------
invert_case() {
  if stopped_by_comptime "$1" "$2" "$3"; then
    tie_refuses=$((tie_refuses + 1))
  else
    rc=$?
    verdict=inverted_tie_built
    [ "$rc" -eq 2 ] && verdict=refused_elsewhere
    echo "detail: $2 did not stop the build at comptime"
  fi
}

invert_case beading cdc \
  's/assert(max_resin_bytes <= max_beads \* cdc_min_bead);/assert(max_resin_bytes > max_beads * cdc_min_bead);/'
invert_case beading fixed \
  's/assert(max_resin_bytes <= max_beads \* max_bead_bytes);/assert(max_resin_bytes > max_beads * max_bead_bytes);/'
invert_case beading index \
  's/assert(index_header_len + max_beads \* digest_raw_len <= max_resin_bytes);/assert(index_header_len + max_beads * digest_raw_len > max_resin_bytes);/'
invert_case recall_batch_wire chunks \
  's/assert(rb.max_batch_bytes <= @as(u32, max_batch_chunks) \* max_chunk_body);/assert(rb.max_batch_bytes > @as(u32, max_batch_chunks) * max_chunk_body);/'

# -- the plausible real edits, which are the point ---------------------------------------------
edit_case() {
  if stopped_by_comptime "$1" "$2" "$3"; then
    edit_refuses=$((edit_refuses + 1))
  else
    rc=$?
    verdict=real_edit_built
    [ "$rc" -eq 2 ] && verdict=refused_elsewhere
    echo "detail: $2 was accepted by the compiler, so the tie does not reach it"
  fi
}

edit_case beading mincut 's/^const cdc_min_bead: u32 = 64;/const cdc_min_bead: u32 = 32;/'
edit_case beading whole 's/^pub const max_resin_bytes: u32 = 512;/pub const max_resin_bytes: u32 = 576;/'
edit_case recall_batch_wire halved 's/^pub const max_batch_chunks: u16 = 16;/pub const max_batch_chunks: u16 = 8;/'

echo "tied_modules=$tied_modules"
echo "tie_holds=$tie_holds"
echo "tie_refuses=$tie_refuses"
echo "edit_refuses=$edit_refuses"

if [ "$verdict" = proven ]; then
  if [ "$tied_modules" -ne 2 ] || [ "$tie_holds" -ne 2 ] \
    || [ "$tie_refuses" -ne 4 ] || [ "$edit_refuses" -ne 3 ]; then
    verdict=counts_disagree
  fi
fi

echo "verdict=$verdict"
[ "$verdict" = proven ] || exit 1
