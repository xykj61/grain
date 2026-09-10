#!/bin/sh
# tools/fixtures/m/mantra_multifile_control.sh -- the per-file record, broken on purpose.
#
# WHAT THIS DOES. tools/fixtures/m/mantra_multifile_scan.sh drives the built
# Mantra CLI over two tracked files and asks whether the first one still reads
# clean. This control copies mantra/src into a throwaway pen, changes ONE
# thing in the copy of main.rye, points the scan at that pen, and watches the
# reading it broke come back wrong. Every phase names the exact reading it
# expects to move, because a control that only checks `verdict` cannot tell a
# writer that forgot a path from a reader that stopped honoring one.
#
# THE PEN IS A DIRECTORY. Zig resolves an import inside the root file's own
# directory, so main.rye's four siblings -- weave.rye, diff.rye, store.rye and
# the parse_int.rye symlink -- are copied beside it.
#
# SIX PHASES. One is an innocence leg that must read ok; the other five are
# breaks, and each names the single reading it moves.
#   clean          -- the unmutated copy reads verdict=ok with every reading in
#                     place. This leg is what lets every other phase read as the
#                     break speaking rather than the pen.
#   ignores_path   -- `weave_for` returns the first entry whatever path it was
#                     handed, which is the whole-directory reading the elder
#                     record forced. `first_clean` reads no: file two's diff
#                     deleted file one's lines. This is that red restored.
#   drops_prior    -- a commit names only the file it just wove, so the entry
#                     for every earlier file leaves the record. `first_clean`
#                     reads no again, and the pair matters: one break is the
#                     READER losing the path, the other is the WRITER losing it,
#                     and a guard reading one number cannot say which.
#   no_elder_read  -- the elder `mantra-commit-v1` dispatch is deleted, so a
#                     store written before this change stops opening.
#                     `elder_opens` reads no, and `first_clean` still reads yes
#                     -- which is the pair telling the accretion apart from the
#                     repair.
#   no_elder_fall  -- the empty-path fallback is deleted, so an elder record's
#                     one weave belongs to no path at all. `elder_opens` reads
#                     no while the v1 dispatch is still in place, so the two
#                     halves of elder support are told apart rather than
#                     tested as one.
#   space_rows     -- the file rows are written with a space between path and
#                     name rather than a tab, so `read_commit_v2` finds two
#                     fields where it needs three and the record stops reading
#                     back. `first_clean` reads no. This phase guards the
#                     decision that a v2 row is tab-separated, which is what
#                     lets a tracked path carry a space.
#
# EXPECTED: clean_ok=1, ignores_path_first_clean=no,
# drops_prior_first_clean=no, no_elder_read_elder_opens=no,
# no_elder_read_first_clean=yes, no_elder_fall_elder_opens=no,
# space_rows_first_clean=no.
#
# Driven by tools/m/mantra_multifile_witness.rish. Run from the repository root.

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
scan="$root/tools/fixtures/m/mantra_multifile_scan.sh"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

# Build a pen from the real sources, apply a sed program to the copy of
# main.rye, then run the scan against it. Echoes the scan's readings.
run_pen() {
  name="$1"
  program="$2"
  pen="$work/$name"
  mkdir -p "$pen"
  # -L follows the parse_int.rye symlink, so the pen holds a real file rather
  # than a link pointing back out of it.
  cp -L "$src"/main.rye "$src"/weave.rye "$src"/diff.rye "$src"/store.rye "$src"/parse_int.rye "$pen/"
  if [ -n "$program" ]; then
    # A plant that matched nothing leaves the pen byte for byte identical, so the
    # phase reads the UNMUTATED CLI's answers -- indistinguishable from a law that
    # holds (REDS %519).
    if ! plant_apply "$pen/main.rye" "$program" "$name"; then
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
  && [ "$(reading "$clean" first_clean)" = "yes" ] \
  && [ "$(reading "$clean" last_clean)" = "yes" ] \
  && [ "$(reading "$clean" brix_first_clean)" = "yes" ] \
  && [ "$(reading "$clean" commit_header)" = "mantra-commit-v2" ] \
  && [ "$(reading "$clean" elder_opens)" = "yes" ]; then
  clean_ok=1
fi
echo "clean_ok=$clean_ok"

ip=$(run_pen ignores_path 's|if (std.mem.eql(u8, fw.path, path)) return fw.weave_name;|if (fw.path.len >= path.len * 0) return self.files[self.files.len - 1].weave_name;|')
echo "ignores_path_first_clean=$(reading "$ip" first_clean)"

dp=$(run_pen drops_prior 's#    for (prior) |fw| {#    for (prior[0..0]) |fw| {#')
echo "drops_prior_first_clean=$(reading "$dp" first_clean)"

ne=$(run_pen no_elder_read 's|^.*if (std.mem.eql(u8, header, "mantra-commit-v1")) return read_commit_v1.*$||')
echo "no_elder_read_elder_opens=$(reading "$ne" elder_opens)"
echo "no_elder_read_first_clean=$(reading "$ne" first_clean)"

nf=$(run_pen no_elder_fall 's|if (fw.path.len == 0) return fw.weave_name;|if (fw.path.len == 999) return fw.weave_name;|')
echo "no_elder_fall_elder_opens=$(reading "$nf" elder_opens)"

sr=$(run_pen space_rows 's|"file\\t{s}\\t{s}\\n", .{ fw.path, fw.weave_name }|"file\\t{s} {s}\\n", .{ fw.path, fw.weave_name }|')
echo "space_rows_first_clean=$(reading "$sr" first_clean)"

echo "control_verdict=ok"
