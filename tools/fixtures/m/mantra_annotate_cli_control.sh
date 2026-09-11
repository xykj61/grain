#!/bin/sh
# tools/fixtures/m/mantra_annotate_cli_control.sh -- the reading, broken on purpose.
#
# WHAT THIS DOES. tools/fixtures/m/mantra_annotate_cli_scan.sh drives the built
# Mantra CLI over one file in a pen and reads the story `mantra annotate`
# prints. This control copies mantra/src into a throwaway pen, changes ONE
# thing in the copy of main.rye, points the scan at that pen, and watches the
# reading it broke come back wrong.
#
# THE PEN IS A DIRECTORY. Zig resolves an import inside the root file's own
# directory, so main.rye's four siblings -- weave.rye, diff.rye, store.rye and
# the parse_int.rye symlink -- are copied beside it.
#
# FOUR PHASES: one innocence leg and three breaks, each break moving a reading
# no other break moves.
#   clean       -- the unmutated copy reads verdict=ok with every reading in
#                  place. This leg is what lets the others read as the break
#                  speaking rather than the pen.
#   sides_swap  -- the two weaves change places, so the working file's added
#                  line reads as one the store removed. `edit_added` reads 0
#                  and `edit_removed` reads 1, which is the story told
#                  backwards.
#   mark_blind  -- the `+` mark becomes two spaces, so an added line is shown
#                  beside the unchanged ones. `edit_shows_plus` reads no while
#                  `edit_added` still reads 1 -- the pair that tells a lost
#                  MARK from a lost COUNT.
#   tomb_shown  -- the both-absent branch stops skipping, so a line deleted in a
#                  past commit is counted and shown again. `tombstone_hidden`
#                  reads no.
#
# EXPECTED: clean_ok=1, sides_swap_added=0, sides_swap_removed=1,
# mark_blind_shows_plus=no, mark_blind_added=1, tomb_shown_hidden=no.
#
# Driven by tools/m/mantra_annotate_cli_witness.rish. Run from the repository root.

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
scan="$root/tools/fixtures/m/mantra_annotate_cli_scan.sh"
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
  && [ "$(reading "$clean" clean_unchanged)" = "3" ] \
  && [ "$(reading "$clean" clean_shows_text)" = "yes" ] \
  && [ "$(reading "$clean" edit_added)" = "1" ] \
  && [ "$(reading "$clean" edit_removed)" = "0" ] \
  && [ "$(reading "$clean" edit_shows_plus)" = "yes" ] \
  && [ "$(reading "$clean" drop_removed)" = "1" ] \
  && [ "$(reading "$clean" drop_shows_minus)" = "yes" ] \
  && [ "$(reading "$clean" tombstone_hidden)" = "yes" ] \
  && [ "$(reading "$clean" repeat_identical)" = "yes" ] \
  && [ "$(reading "$clean" store_untouched)" = "yes" ]; then
  clean_ok=1
fi
echo "clean_ok=$clean_ok"

sw=$(run_pen sides_swap 's|const notes = try base.annotate(allocator, &work);|const notes = try work.annotate(allocator, \&base);|')
echo "sides_swap_added=$(reading "$sw" edit_added)"
echo "sides_swap_removed=$(reading "$sw" edit_removed)"

mb=$(run_pen mark_blind 's|if (note.present_right()) return "+ ";|if (note.present_right()) return "  ";|')
echo "mark_blind_shows_plus=$(reading "$mb" edit_shows_plus)"
echo "mark_blind_added=$(reading "$mb" edit_added)"

# The skip becomes a statement that does nothing, rather than being deleted:
# Zig refuses a pointless discard, and a phase that fails to COMPILE proves
# the compiler rather than the reading.
ts=$(run_pen tomb_shown 's|^            continue;$|            gone += 0;|')
echo "tomb_shown_hidden=$(reading "$ts" tombstone_hidden)"

echo "control_verdict=ok"
