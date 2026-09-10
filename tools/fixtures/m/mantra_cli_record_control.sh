#!/bin/sh
# tools/fixtures/m/mantra_cli_record_control.sh -- the CLI's record, broken on purpose.
#
# WHAT THIS DOES. tools/fixtures/m/mantra_cli_record_scan.sh drives the built
# Mantra CLI in a pen and reads the blobs it writes. This control copies
# mantra/src into a throwaway pen, changes ONE thing in the copy of main.rye,
# points the scan at that pen, and watches the reading it broke come back
# wrong. Every phase names the exact reading it expects to move, because a
# control that only checks `verdict` cannot tell a writer emitting the wrong
# header from a reader that stopped opening elder stores.
#
# THE PEN IS A DIRECTORY. Zig resolves an import inside the root file's own
# directory, so main.rye's four siblings -- weave.rye, diff.rye, store.rye and
# the parse_int.rye symlink -- are copied beside it.
#
# SEVEN PHASES. One is an innocence leg that must read ok; the other six are
# breaks, and each names the single reading it moves.
#   clean          -- the unmutated copy reads verdict=ok with every reading in
#                     place. This leg is what lets every other phase read as the
#                     break speaking rather than the pen.
#   writes_v1      -- the writer emits the elder header again. `fresh_header`
#                     comes back `mantra-weave-v1`, which is exactly the state
#                     this round left: a merged history with a format and no
#                     writer, since `to_v1` refuses `V1SiteNotConstant`.
#   drops_v1_read  -- the elder dispatch line is deleted, so a store written
#                     before `20260909` stops opening. `elder_opens` reads no.
#                     This is the break that would lose a user's history, and it
#                     is why the frozen store is a real one rather than a forgery.
#   drops_v2_read  -- the wide dispatch line is deleted, so the CLI cannot read
#                     back what it just wrote. `elder_opens` still reads yes and
#                     `mixed_opens` reads no, which is the pair that tells the
#                     two halves of the dispatch apart.
#   no_digest      -- store.rye's `BlobNameMismatch` refusal is deleted, and the
#                     edited blob is STILL refused -- `tampered_blob_refused`
#                     reads yes. This phase is what proves the refusal is two
#                     deep rather than one: the store spends a name as a proof
#                     first, and the header dispatch answers behind it.
#   no_digest_no_header
#                  -- both are deleted in one pen, so the blob finally travels
#                     and `tampered_blob_refused` reads no. Two phases rather
#                     than one because a reading that comes back yes with either
#                     layer alone cannot say which layer earned it, and a guard
#                     that cannot say that lets one of them rot while green.
#   split_counters -- the counters line is written with a space between the two
#                     numbers rather than a tab, so `read_v2_record` finds one
#                     field where it needs two and the record stops reading back.
#                     `mixed_opens` reads no. This phase guards the design
#                     decision that the counters are CARRIED rather than derived:
#                     a reader deriving them off the rows would not notice.
#
# EXPECTED: clean_ok=1, writes_v1_header=mantra-weave-v1,
# drops_v1_read_elder_opens=no, drops_v2_read_elder_opens=yes,
# drops_v2_read_mixed_opens=no, no_digest_tamper_refused=yes,
# no_digest_no_header_tamper_refused=no, split_counters_mixed_opens=no.
#
# Driven by tools/m/mantra_cli_record_witness.rish. Run from the repository root.

set -eu

# The plant law, imported rather than restated: `plant_apply` rewrites a pen file through a sed
# program and refuses by name when the program matched nothing, so a line that moves in main.rye
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
src="$root/mantra/src"
scan="$root/tools/fixtures/m/mantra_cli_record_scan.sh"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

# Build a pen from the real sources, apply an optional sed program to the named
# copy (main.rye unless a third argument says otherwise -- one phase breaks
# store.rye), then run the scan against it. Echoes the scan's readings.
run_pen() {
  name="$1"
  program="$2"
  target="${3:-main.rye}"
  pen="$work/$name"
  mkdir -p "$pen"
  # -L follows the parse_int.rye symlink, so the pen holds a real file rather
  # than a link pointing back out of it.
  cp -L "$src"/main.rye "$src"/weave.rye "$src"/diff.rye "$src"/store.rye "$src"/parse_int.rye "$pen/"
  if [ -n "$program" ]; then
    # A plant that matched nothing leaves the pen byte for byte identical, so the
    # phase reads the UNMUTATED CLI's answers -- indistinguishable from a law that
    # holds (REDS %519).
    if ! plant_apply "$pen/$target" "$program" "$name"; then
      echo "plant_matched_nothing"
      return
    fi
  fi
  sh "$scan" "$pen/main.rye" 2>/dev/null
}

# Read one `key=value` reading out of a phase's output.
reading() { printf '%s\n' "$1" | sed -n "s/^$2=//p" | head -1; }

clean=$(run_pen clean "")
clean_ok=0
if [ "$(reading "$clean" verdict)" = "ok" ] \
  && [ "$(reading "$clean" fresh_header)" = "mantra-weave-v2" ] \
  && [ "$(reading "$clean" elder_opens)" = "yes" ] \
  && [ "$(reading "$clean" mixed_opens)" = "yes" ] \
  && [ "$(reading "$clean" tampered_blob_refused)" = "yes" ]; then
  clean_ok=1
fi
echo "clean_ok=$clean_ok"

v1=$(run_pen writes_v1 's|try out.appendSlice(allocator, "mantra-weave-v2\\n");|try out.appendSlice(allocator, "mantra-weave-v1\\n");|')
echo "writes_v1_header=$(reading "$v1" fresh_header)"

d1=$(run_pen drops_v1_read 's|^.*if (std.mem.eql(u8, header, "mantra-weave-v1")) return read_v1_rows.*$||')
echo "drops_v1_read_elder_opens=$(reading "$d1" elder_opens)"

d2=$(run_pen drops_v2_read 's|^.*if (std.mem.eql(u8, header, "mantra-weave-v2")) return read_v2_record.*$||')
echo "drops_v2_read_elder_opens=$(reading "$d2" elder_opens)"
echo "drops_v2_read_mixed_opens=$(reading "$d2" mixed_opens)"

nd=$(run_pen no_digest 's|if (!std.mem.eql(u8, recomputed, name)) return StoreError.BlobNameMismatch;||' store.rye)
echo "no_digest_tamper_refused=$(reading "$nd" tampered_blob_refused)"

# Both layers, in one pen: the store's proof and the reader's dispatch. Two
# plants, so `plant_apply` is asked twice and either miss reds the phase.
ndh_pen="$work/no_digest_no_header"
mkdir -p "$ndh_pen"
cp -L "$src"/main.rye "$src"/weave.rye "$src"/diff.rye "$src"/store.rye "$src"/parse_int.rye "$ndh_pen/"
ndh=""
if plant_apply "$ndh_pen/store.rye" 's|if (!std.mem.eql(u8, recomputed, name)) return StoreError.BlobNameMismatch;||' no_digest_no_header_store \
  && plant_apply "$ndh_pen/main.rye" 's|if (std.mem.eql(u8, header, "mantra-weave-v2")) return read_v2_record|if (header.len > 0) return read_v2_record|' no_digest_no_header_main; then
  ndh=$(sh "$scan" "$ndh_pen/main.rye" 2>/dev/null)
fi
echo "no_digest_no_header_tamper_refused=$(reading "$ndh" tampered_blob_refused)"

nc=$(run_pen no_counters 's|"{d}\\t{d}\\n", .{ record.next_pos, record.next_run }|"{d} {d}\\n", .{ record.next_pos, record.next_run }|')
echo "split_counters_mixed_opens=$(reading "$nc" mixed_opens)"

echo "control_verdict=ok"
