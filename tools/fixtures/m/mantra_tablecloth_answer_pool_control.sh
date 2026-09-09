#!/bin/sh
# tools/fixtures/m/mantra_tablecloth_answer_pool_control.sh -- the answer budget, broken on purpose.
#
# WHAT THIS DOES. mantra/recall_tablecloth_query_delivery.rye reserves an answer slot before a
# request runs, so a caller that keeps its reply is charged for the bytes it keeps. Its selftest
# fills the pool, reads a refusal while every request slot stands idle, releases one answer, and
# reads the answers nobody released after the slot beside them was reused. This control copies the
# module and its siblings into a throwaway pen, changes ONE thing in the copy, and watches the
# selftest answer with a non-zero exit. Every break is shown from both sides, so a real refusal
# stays tellable from a bypass.
#
# THE PEN IS A DIRECTORY. Zig resolves an import inside the root file's own directory, so every
# module the delivery reaches -- the wire, the query, the catalog, the envelope, Tally's copy, and
# the two the catalog itself imports -- is copied in beside it. `cp -L` follows tally_copy.rye,
# which is a symlink into tally/, since a symlink out of the pen is an import out of the pen.
#
# SIX PHASES. One is the innocence leg that must exit 0; the other five are breaks that must not.
#   clean            -- the unmutated copy reaches GREEN, exit 0. This leg is what lets every other
#                       phase read as the break speaking rather than the pen.
#   active_only      -- the answer-slot half of admission is deleted, so a request is admitted on
#                       the count of requests alone. This is the elder shape the design names: a
#                       full pool of kept answers admits anyway, and the trial's refusal never
#                       comes.
#   shared_frame     -- the trial hands every exchange ONE scratch buffer rather than each slot's
#                       own, which is the caller this pool replaces. The answers are views, so the
#                       second reply overwrites the first and a kept answer reads its successor.
#   no_generation    -- the release stops advancing the slot's generation, so a ticket handed back
#                       still opens the slot -- and reads whatever answer stands there now.
#   release_uncounted-- the release frees the slot without lowering the retained count, so capacity
#                       returned to the caller is never returned to the pool.
#   request_ceiling  -- the request-slot half of admission is deleted, so a pool with two requests
#                       in flight refuses under the answer-slot name or not at all. A refusal a
#                       caller cannot match on is a refusal only in appearance.
#
# THE BREAK THIS CANNOT CATCH, named rather than left for a reader to find. Nothing here proves the
# pool under CONCURRENT holders: every transition in the trial is serial, which is the model's own
# stated assumption. A borrower reading a slot while another thread releases it would pass every
# phase below. The design says the same from its side.
#
# EXPECTED: clean_exit=0, and every other phase non-zero.
#
# Driven by tools/m/mantra_recall_tablecloth_query_wire.rish. Run from the repository root.

set -eu

# The plant law, imported rather than restated: `plant_apply` rewrites a pen file through a sed
# program and refuses by name when the program matched nothing, so a line that moves in the module
# reds this control instead of quietly handing a phase an unmutated file (REDS %519). Root by
# upward walk, so the letter fold's depth is never spelled here.
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
delivery="$root/mantra/recall_tablecloth_query_delivery.rye"
siblings="recall_tablecloth_query_wire.rye recall_tablecloth_query.rye recall_lap1.rye
wire_format.rye tally_copy.rye kumara.rye recall_by_mark.rye"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

# Build a pen from the real sources, apply an optional sed program to the delivery copy, then build
# and run its selftest. Echoes the exit code and nothing else.
run_pen() {
  name="$1"
  program="$2"
  pen="$work/$name"
  mkdir -p "$pen"
  cp -L "$delivery" "$pen/recall_tablecloth_query_delivery.rye"
  for sibling in $siblings; do
    cp -L "$root/mantra/$sibling" "$pen/$sibling"
  done
  if [ -n "$program" ]; then
    # A plant that matched nothing leaves the pen byte for byte identical, so the phase reads the
    # UNMUTATED module's exit code -- 0, indistinguishable from a law that holds (REDS %519).
    if ! plant_apply "$pen/recall_tablecloth_query_delivery.rye" "$program" "$name"; then
      echo "plant_matched_nothing"
      return
    fi
  fi
  code=0
  ( cd "$pen" && env RYE_ZIG="$zig" "$rye" build recall_tablecloth_query_delivery.rye -lc \
      -femit-bin="$pen/run" >/dev/null 2>&1 ) || code=$?
  if [ "$code" -eq 0 ]; then
    ( cd "$pen" && "$pen/run" selftest >/dev/null 2>&1 ) || code=$?
  fi
  echo "$code"
}

clean_exit="$(run_pen clean '')"
active_only_exit="$(run_pen active_only \
  '/if (self\.active + self\.retained >= pool_answer_max) return error\.AnswerSlotsFull;/d')"
shared_frame_exit="$(run_pen shared_frame \
  's/^    var pool: AnswerPool = \.{};$/    var pool: AnswerPool = .{};\
    var shared: [@intCast(wf.max_message)]u8 = undefined;/
s/filling\[i\], \&slot\.frame,/filling[i], \&shared,/')"
no_generation_exit="$(run_pen no_generation \
  '/if (slot\.state != \.retained) return error\.SlotNotRetained;/,/^    }$/{/slot\.generation += 1;/d;}')"
release_uncounted_exit="$(run_pen release_uncounted \
  '/if (slot\.state != \.retained) return error\.SlotNotRetained;/,/^    }$/{/self\.retained -= 1;/d;}')"
request_ceiling_exit="$(run_pen request_ceiling \
  '/if (self\.active >= pool_active_max) return error\.RequestSlotsFull;/d')"

echo "phase=clean"
echo "clean_exit=$clean_exit"
echo "phase=active_only"
echo "active_only_exit=$active_only_exit"
echo "phase=shared_frame"
echo "shared_frame_exit=$shared_frame_exit"
echo "phase=no_generation"
echo "no_generation_exit=$no_generation_exit"
echo "phase=release_uncounted"
echo "release_uncounted_exit=$release_uncounted_exit"
echo "phase=request_ceiling"
echo "request_ceiling_exit=$request_ceiling_exit"

verdict=ok
# A plant that matched nothing is read FIRST and by its own name, because every other reading below
# is a number and this one is a word.
for reading in "$clean_exit" "$active_only_exit" "$shared_frame_exit" "$no_generation_exit" \
               "$release_uncounted_exit" "$request_ceiling_exit"; do
  [ "$reading" != plant_matched_nothing ] || verdict=plant_matched_nothing
done
if [ "$verdict" = ok ]; then
  [ "$clean_exit" -eq 0 ] || verdict=clean_refused
  for reading in "$active_only_exit" "$shared_frame_exit" "$no_generation_exit" \
                 "$release_uncounted_exit" "$request_ceiling_exit"; do
    [ "$reading" -ne 0 ] || verdict=break_passed
  done
fi
echo "verdict=$verdict"
[ "$verdict" = ok ]
