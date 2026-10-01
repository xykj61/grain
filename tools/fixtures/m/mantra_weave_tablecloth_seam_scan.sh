#!/bin/sh
# tools/fixtures/m/mantra_weave_tablecloth_seam_scan.sh -- the seam's own falsifier, pressed.
#
# WHAT THIS READS. `active-designing/date/20260921/20260921-071008_the-weave-meets-tablecloth-by-content.md`
# charts a seam between the weave (mantra/src/weave.rye, every line a document ever held) and
# Tablecloth (content-addressed storage, a resin is the SHA3-256 of bytes). Its falsifier is one
# command: render a stored weave's `current()` output, hash the document, and ask whether that
# resin already matches a blob the store holds for the same document. If it does, the seam is
# already half-built and the work is naming it rather than building it.
#
# WHAT THIS BUILDS AND DRIVES. The tree's own Mantra CLI (`mantra/src/main.rye`), in a throwaway
# pen: `mantra init`, `mantra add a.txt` once with no prior history, so `current()`'s rendered
# document equals `a.txt`'s own bytes exactly -- no diff, no prior generation to render around.
# That lets this scan read the document's resin straight off the file on disk rather than adding a
# second binary that walks a weave and renders it, which the charted first step asks for as a
# reading rather than a new module.
#
# THE TWO RESINS COMPARED. `doc_resin` is the SHA3-256 hex digest of `a.txt`'s bytes -- the resin
# `current()`'s output would carry, since `current()` equals this content at this point in the
# document's history. `store_blob_names` is the full list of blob names under `.mantra/blobs/`
# after the add -- each one already a SHA3-256 hex digest, by `mantra/src/store.rye`'s own
# construction. `resin_matches_blob_name=yes` would mean the seam already stands; `=no` measures
# the gap plainly, with the mechanism named rather than only the number.
#
# THE MECHANISM, READ FROM THE SOURCE RATHER THAN GUESSED. `mantra/src/main.rye`'s `cmd_add` calls
# `serialize_weave`, which writes a header line, a counters line, and one row per weave line
# carrying `gen\tpos\tsite\trun\tord\ttext\n` -- the `mantra-weave-20260916.101910` record format.
# That is what `store.write_blob` hashes and names, not the plain concatenated document text
# `current()` would render. So the two resins are expected to differ, and this scan presses that
# expectation on metal rather than reading it off the source alone.
#
# READINGS PRINTED, one per line, each a fact rather than a verdict:
#   built=yes|no                  the CLI compiled
#   doc_resin=<hex>                SHA3-256 of a.txt's bytes (current()'s resin, by construction)
#   blob_count=<n>                 blobs under .mantra/blobs/ after one add
#   resin_matches_blob_name=yes|no whether doc_resin names an existing blob
#   resin_matches_blob_content=yes|no  the same question asked by content rather than by name,
#                                       since a store bug could name a blob wrongly while still
#                                       holding the matching bytes under a different name
#   verdict=ok|red
#
# Run from the repository root. Driven by tools/m/mantra_weave_tablecloth_seam_witness.rish.

set -eu

# The portable-dialect helpers, imported rather than restated. Root by upward
# walk (seated 20260828), so the letter fold's depth is never spelled here.
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
main_src="${1:-$root/mantra/src/main.rye}"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

bin="$work/mantra"
if env RYE_ZIG="$zig" "$rye" build "$main_src" -femit-bin="$bin" >/dev/null 2>&1; then
  echo "built=yes"
else
  echo "built=no"
  echo "verdict=red"
  exit 0
fi

verdict=ok
note_red() { verdict=red; }

pen="$work/pen"
mkdir -p "$pen"
printf 'alpha\nbeta\ngamma\n' > "$pen/a.txt"
( cd "$pen" && "$bin" init >/dev/null 2>&1 && "$bin" add a.txt >/dev/null 2>&1 ) || note_red

# current()'s rendered document, at this point in the history, is exactly
# a.txt's own bytes: one add, no prior generation, nothing to diff around.
# SHA3-256 specifically, matching mantra/src/store.rye's Sha3_256 -- SHA-256
# (sha256sum) is a different algorithm and would never agree with the store
# by construction, so this reaches for a real NIST SHA3-256 implementation
# rather than the readily-available-but-wrong one.
doc_resin=""
if command -v sha3sum >/dev/null 2>&1; then
  doc_resin=$(sha3sum -a 256 "$pen/a.txt" 2>/dev/null | cut -d' ' -f1)
elif command -v openssl >/dev/null 2>&1 && openssl dgst -sha3-256 /dev/null >/dev/null 2>&1; then
  doc_resin=$(openssl dgst -sha3-256 "$pen/a.txt" 2>/dev/null | awk '{print $NF}')
elif command -v python3 >/dev/null 2>&1; then
  doc_resin=$(python3 -c "import hashlib,sys; print(hashlib.sha3_256(open(sys.argv[1],'rb').read()).hexdigest())" "$pen/a.txt")
else
  echo "doc_resin=unavailable-no-sha3-tool"
  echo "verdict=red"
  exit 0
fi
echo "doc_resin=$doc_resin"

blob_dir="$pen/.mantra/blobs"
blob_count=0
resin_matches_blob_name=no
resin_matches_blob_content=no
if [ -d "$blob_dir" ]; then
  blob_count=$(find "$blob_dir" -type f | wc -l | tr -d ' ')
  for b in "$blob_dir"/*; do
    [ -f "$b" ] || continue
    bname=$(basename "$b")
    if [ "$bname" = "$doc_resin" ]; then
      resin_matches_blob_name=yes
    fi
    if cmp -s "$b" "$pen/a.txt"; then
      resin_matches_blob_content=yes
    fi
  done
fi
echo "blob_count=$blob_count"
echo "resin_matches_blob_name=$resin_matches_blob_name"
echo "resin_matches_blob_content=$resin_matches_blob_content"

echo "verdict=$verdict"
