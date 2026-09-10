#!/bin/sh
# tools/fixtures/m/mantra_idempotent_add_control.sh -- the idempotent add, broken on purpose.
#
# WHAT THIS DOES. tools/fixtures/m/mantra_idempotent_add_scan.sh drives the built
# Mantra CLI over one file three times with no edit between the runs and asks
# whether `.mantra/` came back byte for byte. This control copies mantra/src into
# a throwaway pen, changes ONE thing in the copy of main.rye, points the scan at
# that pen, and watches the reading it broke come back wrong.
#
# THE PEN IS A DIRECTORY. Zig resolves an import inside the root file's own
# directory, so main.rye's four siblings -- weave.rye, diff.rye, store.rye and
# the parse_int.rye symlink -- are copied beside it.
#
# FOUR PHASES: one innocence leg and three breaks, and every break moves a
# reading no other break moves. That pairing is the whole point of the shape:
# a skip can be wrong by never firing OR by firing too eagerly, and a guard
# reading one number cannot say which.
#   clean       -- the unmutated copy reads verdict=ok with every reading in
#                  place. This leg is what lets the others read as the break
#                  speaking rather than the pen.
#   no_skip     -- the skip's condition is made one that never holds, so every
#                  add writes a commit again. `store_stable` reads no and
#                  `commits_after_three` reads 3. This is the red restored.
#   path_only   -- `files_agree` stops comparing the weave name, so an EDIT to a
#                  tracked path reads as agreeing and is never recorded.
#                  `edit_commits` reads no while `second_file_commits` still
#                  reads yes, because a new path still changes the list length.
#   len_blind   -- `files_agree` answers yes when the lengths differ, so adding a
#                  SECOND file is skipped. `second_file_commits` reads no while
#                  `edit_commits` still reads yes. The pair with `path_only` is
#                  what tells a comparison that lost the weave from one that lost
#                  the length.
#
# EXPECTED: clean_ok=1, no_skip_store_stable=no, no_skip_commits=3,
# path_only_edit_commits=no, path_only_second_file_commits=yes,
# len_blind_second_file_commits=no, len_blind_edit_commits=yes.
#
# Driven by tools/m/mantra_idempotent_add_witness.rish. Run from the repository root.

set -eu

# The plant law, imported rather than restated: `plant_apply` rewrites a pen file
# through a sed program and refuses by name when the program matched nothing, so
# a line that moves in main.rye reds this control instead of quietly handing a
# phase an unmutated file (REDS %519). Root by upward walk (seated 20260828).
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
scan="$root/tools/fixtures/m/mantra_idempotent_add_scan.sh"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

run_pen() {
  name="$1"
  program="$2"
  pen="$work/$name"
  mkdir -p "$pen"
  # -L follows the parse_int.rye symlink, so the pen holds a real file rather
  # than a link pointing back out of it.
  cp -L "$src"/main.rye "$src"/weave.rye "$src"/diff.rye "$src"/store.rye "$src"/parse_int.rye "$pen/"
  if [ -n "$program" ]; then
    if ! plant_apply "$pen/main.rye" "$program" "$name"; then
      echo "plant_matched_nothing"
      return
    fi
  fi
  sh "$scan" "$pen/main.rye" 2>/dev/null
}

reading() { printf '%s\n' "$1" | sed -n "s/^$2=//p" | head -1; }

clean=$(run_pen clean "")
clean_ok=0
if [ "$(reading "$clean" verdict)" = "ok" ] \
  && [ "$(reading "$clean" store_stable)" = "yes" ] \
  && [ "$(reading "$clean" store_stable_third)" = "yes" ] \
  && [ "$(reading "$clean" head_stable)" = "yes" ] \
  && [ "$(reading "$clean" commits_after_three)" = "1" ] \
  && [ "$(reading "$clean" edit_commits)" = "yes" ] \
  && [ "$(reading "$clean" second_file_commits)" = "yes" ] \
  && [ "$(reading "$clean" brix_stable)" = "yes" ]; then
  clean_ok=1
fi
echo "clean_ok=$clean_ok"

# `files.len` is at least one by construction, so this condition never holds and
# the commit is written on every run -- the red exactly as it stood.
ns=$(run_pen no_skip 's|if (files_agree(prior_files, files)) {|if (files.len == 0) {|')
echo "no_skip_store_stable=$(reading "$ns" store_stable)"
echo "no_skip_commits=$(reading "$ns" commits_after_three)"

po=$(run_pen path_only 's|^.*if (!std.mem.eql(u8, held.weave_name, fresh.weave_name)) return false;.*$||')
echo "path_only_edit_commits=$(reading "$po" edit_commits)"
echo "path_only_second_file_commits=$(reading "$po" second_file_commits)"

lb=$(run_pen len_blind 's|if (prior.len != next.len) return false;|if (prior.len != next.len) return prior.len >= 1;|')
echo "len_blind_second_file_commits=$(reading "$lb" second_file_commits)"
echo "len_blind_edit_commits=$(reading "$lb" edit_commits)"

echo "control_verdict=ok"
