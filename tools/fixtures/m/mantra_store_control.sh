#!/bin/sh
# tools/fixtures/m/mantra_store_control.sh -- the verified read, broken on purpose.
#
# WHAT THIS DOES. mantra/src/store_witness.rye asserts that a content-addressed blob comes
# back whole or refuses by name: the digest is recomputed on every read, a blob altered or
# truncated on disk is refused, and `max_blob_bytes` is read at both edges. This control copies
# the module and its witness into a throwaway pen, changes ONE thing in the copy, and watches
# the witness answer with a non-zero exit. Every break is shown from both sides, so a real
# refusal stays tellable from a bypass.
#
# THE PEN IS A DIRECTORY. Zig resolves an import inside the root file's own directory, so
# store.rye, weave.rye and the witness sit side by side here.
#
# SEVEN PHASES. One is the innocence leg that must exit 0; the other six are breaks that must
# not.
#   clean          -- the unmutated copy reaches GREEN, exit 0. This leg is what lets every
#                     other phase read as the break speaking rather than the pen.
#   no_verify      -- the digest comparison is deleted, so the name is a proof computed once
#                     and never spent. This is the elder store exactly. Claims 3 and 4 answer.
#   verify_misnamed-- the comparison stands and refuses under the wrong error name, which is
#                     the half a deletion cannot show: a refusal a caller cannot match on is a
#                     refusal only in appearance.
#   elder_read     -- the bounded `readFileAlloc` is replaced by the elder `readFile` into a
#                     fixed buffer, which fills and calls that the answer. Claim 6 answers,
#                     since a file past the ceiling now returns a prefix rather than refusing.
#   write_ceiling  -- the write-edge refusal is deleted, so a blob nothing could read back
#                     whole may be stored. Claim 5 answers.
#   ceiling_number -- `max_blob_bytes` is moved to 64 MiB, so it no longer stands in the
#                     stated relation to `weave.max_weave_lines`. Claim 8 answers.
#   head_length    -- the HEAD length check is deleted, so a mis-sized HEAD names a blob that
#                     was never written. Claim 7 answers.
#
# THE ONE BREAK THIS CANNOT CATCH, named rather than left for a reader to find. Moving the read
# limit from `max_blob_bytes + 1` to `max_blob_bytes` would refuse a blob standing exactly on
# the ceiling, and every phase here would still pass -- because proving that boundary costs two
# SHA3-256 passes over 128 MiB on every lap. The witness header says the same thing from its
# own side. What both readings hold is the REFUSING direction at the real number.
#
# EXPECTED: clean_exit=0, and every other phase non-zero.
#
# Driven by tools/m/mantra_store_witness.rish. Run from the repository root.

set -eu

# The plant law, imported rather than restated: `plant_apply` rewrites a pen file through a sed
# program and refuses by name when the program matched nothing, so a line that moves in the module
# reds this control instead of quietly handing a phase an unmutated file (REDS %519). Root by
# upward walk (seated 20260828), so the letter fold's depth is never spelled here.
_fd_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$_fd_root/rishi/bin" ] || [ ! -d "$_fd_root/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$_fd_root" = "/" ] || [ -z "$_fd_root" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  _fd_root=$(dirname "$_fd_root")
done
. "$_fd_root/tools/fixtures/p/plant.sh"

root="$(pwd)"
zig="$root/vendor/zig-toolchain/zig"
rye="$root/rye/bin/rye"
module="$root/mantra/src/store.rye"
model="$root/mantra/src/weave.rye"
witness="$root/mantra/src/store_witness.rye"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

# Build a pen from the real sources, apply an optional sed program to the module copy,
# then build and run. Echoes the exit code and nothing else.
run_pen() {
  name="$1"
  program="$2"
  pen="$work/$name"
  mkdir -p "$pen/blobpen"
  cp "$module" "$pen/store.rye"
  cp "$model" "$pen/weave.rye"
  cp "$witness" "$pen/store_witness.rye"
  if [ -n "$program" ]; then
    # A plant that matched nothing leaves the pen byte for byte identical, so the
    # phase reads the UNMUTATED module's exit code -- 0, indistinguishable from a
    # law that holds (REDS %519).
    if ! plant_apply "$pen/store.rye" "$program" "$name"; then
      echo "plant_matched_nothing"
      return
    fi
  fi
  code=0
  ( cd "$pen" && env RYE_ZIG="$zig" "$rye" build store_witness.rye \
      -femit-bin="$pen/run" >/dev/null 2>&1 ) || code=$?
  if [ "$code" -eq 0 ]; then
    ( cd "$pen" && "$pen/run" blobpen >/dev/null 2>&1 ) || code=$?
  fi
  echo "$code"
}

clean_exit="$(run_pen clean '')"
no_verify_exit="$(run_pen no_verify '/if (!std\.mem\.eql(u8, recomputed, name)) return StoreError\.BlobNameMismatch;/d')"
verify_misnamed_exit="$(run_pen verify_misnamed 's/if (!std\.mem\.eql(u8, recomputed, name)) return StoreError\.BlobNameMismatch;/if (!std.mem.eql(u8, recomputed, name)) return StoreError.BlobTooLarge;/')"
elder_read_exit="$(run_pen elder_read '/const limit = std\.Io\.Limit\.limited64(max_blob_bytes + 1);/,/^        };$/c\
        const elder_buf = try allocator.alloc(u8, 1024 * 1024);\
        const content = try self.blobs_dir.readFile(io, name, elder_buf);')"
write_ceiling_exit="$(run_pen write_ceiling '/if (data\.len > max_blob_bytes) return StoreError\.BlobTooLarge;/d')"
ceiling_number_exit="$(run_pen ceiling_number 's/^pub const max_blob_bytes: u64 = 1 << 27;$/pub const max_blob_bytes: u64 = 1 << 26;/')"
head_length_exit="$(run_pen head_length '/if (name\.len != Sha3\.digest_length \* 2) return null; \/\/ corrupt HEAD/d')"

echo "phase=clean"
echo "clean_exit=$clean_exit"
echo "phase=no_verify"
echo "no_verify_exit=$no_verify_exit"
echo "phase=verify_misnamed"
echo "verify_misnamed_exit=$verify_misnamed_exit"
echo "phase=elder_read"
echo "elder_read_exit=$elder_read_exit"
echo "phase=write_ceiling"
echo "write_ceiling_exit=$write_ceiling_exit"
echo "phase=ceiling_number"
echo "ceiling_number_exit=$ceiling_number_exit"
echo "phase=head_length"
echo "head_length_exit=$head_length_exit"

verdict=ok
# A plant that matched nothing is read FIRST and by its own name, because every
# other reading below is a number and this one is a word.
for reading in "$clean_exit" "$no_verify_exit" "$verify_misnamed_exit" "$elder_read_exit" \
               "$write_ceiling_exit" "$ceiling_number_exit" "$head_length_exit"; do
  [ "$reading" != plant_matched_nothing ] || verdict=plant_matched_nothing
done
if [ "$verdict" = ok ]; then
  [ "$clean_exit" -eq 0 ] || verdict=clean_failed
  for broken in "$no_verify_exit" "$verify_misnamed_exit" "$elder_read_exit" \
                "$write_ceiling_exit" "$ceiling_number_exit" "$head_length_exit"; do
    [ "$broken" -ne 0 ] || verdict=break_not_caught
  done
fi
echo "control_verdict=$verdict"
[ "$verdict" = ok ]
