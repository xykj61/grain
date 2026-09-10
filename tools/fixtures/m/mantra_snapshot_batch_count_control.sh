#!/bin/sh
# tools/fixtures/m/mantra_snapshot_batch_count_control.sh -- can this guard red?
#
# WHAT THIS PROVES. The scan beside it reads a repair in
# `mantra/snapshot_export.rye`: the import compares the offset it stopped at
# against the length of the blob it was handed, and refuses bytes standing past
# the last declared batch by the name the module's error set already held. A
# guard nobody has watched fail is a guard nobody has tested, so this control
# copies the module into a throwaway pen, breaks ONE thing in the copy, and
# watches the reading it broke come back wrong -- then shows the unmutated pen
# reading ok, so a refusal cannot be told apart from a broken build.
#
# THE FIVE PHASES, and the one reading each is aimed at:
#   clean         nothing changed -- every reading yes, verdict ok
#   no_edge       the edge refusal deleted -- tail and prefix both accepted again
#   no_leg        the selftest's own tail line deleted, the check left in place
#                 -- `tail_refused=no` while `edge_check_present=yes`, which is
#                 what keeps the behavioral reading from being a grep in disguise
#   wrong_name    the refusal returns `LeafCountMismatch` -- a caller cannot tell
#                 a padded snapshot from a miscounted one, and the leg refuses
#   lawful_break  the comparison bites one byte early -- an HONEST snapshot is
#                 refused, which is the direction a repair fails in when it
#                 reaches past its target
#
# BUILT IS READ IN EVERY PHASE. A mutation that fails to compile would move every
# reading at once and look like a finding, so each phase asserts `built=yes`
# beside the reading it is aimed at.
#
# LEGS ARE TALLIED. `control_failed` counts every leg that did not answer as this
# header says it must, so a leg written tomorrow is heard the day it lands rather
# than only when a witness happens to name it.
#
# Driven by tools/m/mantra_snapshot_batch_count_witness.rish. Run from the root.

set -eu

# The plant law, imported rather than restated: `plant_apply` rewrites a pen file
# through a sed program and refuses by name when the program matched nothing, so
# a line that moves in the module reds this control instead of quietly handing a
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
scan="$root/tools/fixtures/m/mantra_snapshot_batch_count_scan.sh"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

failed=0
leg() {
  name="$1"; got="$2"; want="$3"
  if [ "$got" = "$want" ]; then
    echo "$name=$got"
  else
    echo "$name=$got"
    echo "leg_failed=$name wanted=$want"
    failed=$((failed + 1))
  fi
}

run_pen() {
  name="$1"
  program="$2"
  pen="$work/$name"
  mkdir -p "$pen"
  # -L follows the kumara.rye, parse_int.rye and tally_copy.rye symlinks, so the
  # pen holds real files rather than links pointing back out of it.
  cp -L "$root"/mantra/*.rye "$pen/"
  if [ -n "$program" ]; then
    if ! plant_apply "$pen/snapshot_export.rye" "$program" "$name"; then
      echo "plant_matched_nothing"
      return
    fi
  fi
  sh "$scan" "$pen/snapshot_export.rye" 2>/dev/null
}

reading() { printf '%s\n' "$1" | sed -n "s/^$2=//p" | head -1; }

clean=$(run_pen clean "")
clean_ok=0
if [ "$(reading "$clean" verdict)" = "ok" ] \
  && [ "$(reading "$clean" built)" = "yes" ] \
  && [ "$(reading "$clean" edge_check_present)" = "yes" ] \
  && [ "$(reading "$clean" honest_import)" = "yes" ] \
  && [ "$(reading "$clean" tail_refused)" = "yes" ] \
  && [ "$(reading "$clean" prefix_refused)" = "yes" ]; then
  clean_ok=1
fi
leg clean_ok "$clean_ok" 1

ne=$(run_pen no_edge 's|^    if (off != cap_u32(snapshot)) return error.BatchCountMismatch;$||')
leg no_edge_built "$(reading "$ne" built)" yes
leg no_edge_tail_refused "$(reading "$ne" tail_refused)" no
leg no_edge_prefix_refused "$(reading "$ne" prefix_refused)" no
leg no_edge_verdict "$(reading "$ne" verdict)" red

nl=$(run_pen no_leg 's|^    print("snapshot: bytes past the last declared batch.*$||')
leg no_leg_built "$(reading "$nl" built)" yes
leg no_leg_edge_check_present "$(reading "$nl" edge_check_present)" yes
leg no_leg_tail_refused "$(reading "$nl" tail_refused)" no

wn=$(run_pen wrong_name 's|^    if (off != cap_u32(snapshot)) return error.BatchCountMismatch;$|    if (off != cap_u32(snapshot)) return error.LeafCountMismatch;|')
leg wrong_name_built "$(reading "$wn" built)" yes
leg wrong_name_tail_refused "$(reading "$wn" tail_refused)" no

lb=$(run_pen lawful_break 's|^    if (off != cap_u32(snapshot)) return error.BatchCountMismatch;$|    if (off + 1 != cap_u32(snapshot)) return error.BatchCountMismatch;|')
leg lawful_break_built "$(reading "$lb" built)" yes
leg lawful_break_honest_import "$(reading "$lb" honest_import)" no

echo "control_failed=$failed"
if [ "$failed" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=red"
fi
