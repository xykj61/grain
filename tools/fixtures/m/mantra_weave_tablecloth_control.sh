#!/bin/sh
# tools/fixtures/m/mantra_weave_tablecloth_control.sh -- the wiring, broken on purpose.
#
# WHAT THIS DOES. mantra/src/weave_tablecloth.rye wires Weave.current() to the catalogue's
# append_leaf in one call, and mantra/src/weave_tablecloth_witness.rye proves the wire carries
# bytes through untouched, grows the catalogue by exactly one leaf per call, and lets a refused
# revision cross by name rather than being swallowed. This control copies the module and its
# dependencies into a throwaway pen, changes ONE thing in the copy, and watches the witness
# answer with a non-zero exit. Each break is shown from both sides, so a real refusal stays
# tellable from a bypass.
#
# THE PEN IS A DIRECTORY. Zig resolves an import inside the root file's own directory, so
# weave.rye, recall_lap1.rye, tally_copy.rye, and weave_tablecloth.rye sit side by side here --
# the same shape mantra/src/ itself uses, minus the symlinks: a pen copies real bytes.
#
# FOUR PHASES. One innocence leg that must exit 0, and three breaks that must not.
#   clean          -- the unmutated copy reaches GREEN, exit 0. This leg is what lets the other
#                     phases read as the break speaking rather than the pen.
#   separator      -- render_current joins lines with a space rather than `\n`, so the rendered
#                     document stops being the exact inverse of how it was planted. Claims 1
#                     and 2 answer: the rendered bytes no longer equal the planted document, and
#                     the leaf's digest no longer equals the independently computed one.
#   swallow_error  -- render_to_leaf's `try catalog.append_leaf(...)` becomes
#                     `catalog.append_leaf(...) catch {}`, so a refused revision stops crossing
#                     the wiring and the call returns success instead. render_to_leaf's own
#                     postcondition assert is what catches this one: the catalogue never grew,
#                     so `leaf_count == before + 1` fails and the pen panics.
#   swallow_quiet  -- the same swallow, with render_to_leaf's postcondition assert ALSO deleted.
#                     Nothing in the module notices; the witness's own claim 4 assert is what
#                     catches this one instead, proving the module's postcondition is not the
#                     only thing standing between a swallowed error and a caller believing it.
#
# EXPECTED: clean_exit=0, every other phase non-zero, and legs_ran equal to legs_expected.
#
# Driven by tools/m/mantra_weave_tablecloth_witness.rish. Run from the repository root.

set -eu

_fd_root=$(CDPATH= cd -- "$(dirname "$0")" && git rev-parse --show-toplevel) || {
  echo "$0: not inside a git tree" >&2
  exit 2
}
. "$_fd_root/tools/fixtures/p/plant.sh"

root="$(pwd)"
zig="$root/vendor/zig-toolchain/zig"
rye="$root/rye/bin/rye"
weave_src="$root/mantra/src/weave.rye"
recall_src="$root/mantra/recall_lap1.rye"
copy_src="$root/tally/copy.rye"
module="$root/mantra/src/weave_tablecloth.rye"
witness="$root/mantra/src/weave_tablecloth_witness.rye"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

# Build a pen from the real sources, apply an optional sed program to the module copy
# (weave_tablecloth.rye), then build and run. Echoes the exit code and nothing else.
run_pen() {
  name="$1"
  program="$2"
  pen="$work/$name"
  mkdir -p "$pen"
  cp "$weave_src" "$pen/weave.rye"
  cp "$recall_src" "$pen/recall_lap1.rye"
  cp "$copy_src" "$pen/tally_copy.rye"
  cp "$module" "$pen/weave_tablecloth.rye"
  cp "$witness" "$pen/weave_tablecloth_witness.rye"
  if [ -n "$program" ]; then
    # A plant that matched nothing leaves the pen byte for byte identical, so the phase
    # reads the UNMUTATED module's exit code -- 0, indistinguishable from a law that holds
    # (REDS %519).
    if ! plant_apply "$pen/weave_tablecloth.rye" "$program" "$name"; then
      echo "plant_matched_nothing"
      return
    fi
  fi
  code=0
  ( cd "$pen" && env RYE_ZIG="$zig" "$rye" build weave_tablecloth_witness.rye \
      -femit-bin="$pen/run" >/dev/null 2>&1 ) || code=$?
  if [ "$code" -eq 0 ]; then
    "$pen/run" >/dev/null 2>&1 || code=$?
  fi
  echo "$code"
}

clean_exit="$(run_pen clean '')"
separator_exit="$(run_pen separator 's/"\\n", texts/" ", texts/')"
swallow_error_exit="$(run_pen swallow_error 's/try catalog\.append_leaf(peer, bolt, revision, path, rendered, tilak);/catalog.append_leaf(peer, bolt, revision, path, rendered, tilak) catch {};/')"
swallow_quiet_exit="$(run_pen swallow_quiet 's/try catalog\.append_leaf(peer, bolt, revision, path, rendered, tilak);/catalog.append_leaf(peer, bolt, revision, path, rendered, tilak) catch {};/; /assert(catalog\.leaf_count == before + 1);/d')"

report="$(
echo "phase=clean"
echo "clean_exit=$clean_exit"
echo "phase=separator"
echo "separator_exit=$separator_exit"
echo "phase=swallow_error"
echo "swallow_error_exit=$swallow_error_exit"
echo "phase=swallow_quiet"
echo "swallow_quiet_exit=$swallow_quiet_exit"
)"
printf '%s\n' "$report"

# THE PEN COUNTS ITS OWN LEGS OUT LOUD. `fail=0` is what an empty pen prints too, so a control
# that merely finishes proves nothing about how much of it ran.
legs_expected=4
legs_ran="$(printf '%s\n' "$report" | grep -c '_exit=')"
echo "legs_expected=$legs_expected"
echo "legs_ran=$legs_ran"

verdict=ok
for reading in "$clean_exit" "$separator_exit" "$swallow_error_exit" "$swallow_quiet_exit"; do
  [ "$reading" != plant_matched_nothing ] || verdict=plant_matched_nothing
done
if [ "$verdict" = ok ]; then
  [ "$legs_ran" -eq "$legs_expected" ] || verdict=leg_count_disagrees
  [ "$clean_exit" -eq 0 ] || verdict=clean_failed
  for broken in "$separator_exit" "$swallow_error_exit" "$swallow_quiet_exit"; do
    [ "$broken" -ne 0 ] || verdict=break_not_caught
  done
fi
echo "control_verdict=$verdict"
[ "$verdict" = ok ]
