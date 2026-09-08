#!/bin/sh
# tools/fixtures/m/mantra_weave_v1_write_control.sh -- the write, broken on purpose.
#
# WHAT THIS DOES. mantra/src/weave_v1_write_witness.rye asserts that `Weave.to_v1` writes a
# wide weave back out as an elder `mantra-weave-v1` record without moving the document: rows
# come back text for text, an edit lands last, the round trip returns the same document while
# collapsing the runs, a deletion keeps its even generation, and two shapes the format cannot
# hold are refused by name. This control copies the module and its witness into a throwaway
# pen, changes ONE thing in the copy, and watches the witness answer with a non-zero exit.
# Each break is shown from both sides, so a real refusal stays tellable from a bypass.
#
# THE PEN IS A DIRECTORY. Zig resolves an import inside the root file's own directory, so
# weave.rye and its witness sit side by side here.
#
# NINE PHASES -- seven over the Rye witness, two over the head scan. Two are innocence legs
# that must exit 0 (clean, head_clean); the other seven are breaks that must not.
#   clean          -- the unmutated copy reaches GREEN, exit 0. This leg is what lets every
#                     other phase read as the break speaking rather than the pen.
#   site_check     -- the second-site refusal is deleted, so a weave two hands have written is
#                     flattened into a record that cannot tell them apart. Claim 6 answers.
#   site_misnamed  -- the check stands and refuses under the wrong error name, which is the
#                     half a deletion cannot show: a refusal a caller cannot match on is a
#                     refusal only in appearance.
#   order_check    -- the rise check is deleted, so a merged weave whose document order has
#                     parted from its position order is written anyway. Claim 7 answers, and
#                     this is the one break that would silently reorder a reader's file.
#   gen            -- the write stamps generation 1 rather than the line's own, so a deleted
#                     line comes back present and the record stops being a history. Claims 1
#                     and 5 answer.
#   text           -- the write carries a fixed text rather than the line's, so the record
#                     stops being the document. Claim 1 answers.
#   pos            -- the write stamps position 0 rather than the line's, so the rows no
#                     longer rise. The module's own postcondition assert answers first, which
#                     is the point: the write proves its own output rather than trusting it.
#   head_clean     -- the unmutated copy reads ok, exit 0. The head scan's own innocence leg.
#   head_missing   -- the head's `to_v1` line is deleted, so an operation stands unnamed and
#                     tools/fixtures/m/mantra_weave_head_scan.sh reds.
#
# EXPECTED: clean_exit=0, head_clean_exit=0, and every other phase non-zero.
#
# Driven by tools/m/mantra_weave_v1_write_witness.rish. Run from the repository root.

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
module="$root/mantra/src/weave.rye"
witness="$root/mantra/src/weave_v1_write_witness.rye"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

# Build a pen from the real sources, apply an optional sed program to the module copy,
# then build and run. Echoes the exit code and nothing else.
run_pen() {
  name="$1"
  program="$2"
  pen="$work/$name"
  mkdir -p "$pen"
  cp "$module" "$pen/weave.rye"
  cp "$witness" "$pen/weave_v1_write_witness.rye"
  if [ -n "$program" ]; then
    # A plant that matched nothing leaves the pen byte for byte identical, so the
    # phase reads the UNMUTATED module's exit code -- 0, indistinguishable from a
    # law that holds (REDS %519).
    if ! plant_apply "$pen/weave.rye" "$program" "$name"; then
      echo "plant_matched_nothing"
      return
    fi
  fi
  code=0
  ( cd "$pen" && env RYE_ZIG="$zig" "$rye" build weave_v1_write_witness.rye \
      -femit-bin="$pen/run" >/dev/null 2>&1 ) || code=$?
  if [ "$code" -eq 0 ]; then
    "$pen/run" >/dev/null 2>&1 || code=$?
  fi
  echo "$code"
}

# The head scan reads a file rather than building one, so its pens skip the compiler.
run_head_pen() {
  name="$1"
  program="$2"
  pen="$work/head_$name"
  mkdir -p "$pen"
  cp "$module" "$pen/weave.rye"
  if [ -n "$program" ]; then
    if ! plant_apply "$pen/weave.rye" "$program" "$name"; then
      echo "plant_matched_nothing"
      return
    fi
  fi
  code=0
  sh "$root/tools/fixtures/m/mantra_weave_head_scan.sh" "$pen/weave.rye" >/dev/null 2>&1 || code=$?
  echo "$code"
}

clean_exit="$(run_pen clean '')"
site_check_exit="$(run_pen site_check '/if (line\.site != v1_site) return WeaveError\.V1SiteNotConstant;/d')"
site_misnamed_exit="$(run_pen site_misnamed 's/if (line\.site != v1_site) return WeaveError\.V1SiteNotConstant;/if (line.site != v1_site) return WeaveError.V1PositionsDoNotRise;/')"
order_check_exit="$(run_pen order_check '/if (seen_any and line\.pos <= previous_pos) return WeaveError\.V1PositionsDoNotRise;/d')"
gen_exit="$(run_pen gen 's/rows\.appendAssumeCapacity(\.{ \.text = line\.text, \.gen = line\.gen, \.pos = line\.pos });/rows.appendAssumeCapacity(.{ .text = line.text, .gen = 1, .pos = line.pos });/')"
text_exit="$(run_pen text 's/rows\.appendAssumeCapacity(\.{ \.text = line\.text, \.gen = line\.gen, \.pos = line\.pos });/rows.appendAssumeCapacity(.{ .text = "x", .gen = line.gen, .pos = line.pos });/')"
pos_exit="$(run_pen pos 's/rows\.appendAssumeCapacity(\.{ \.text = line\.text, \.gen = line\.gen, \.pos = line\.pos });/rows.appendAssumeCapacity(.{ .text = line.text, .gen = line.gen, .pos = 0 });/')"

head_clean_exit="$(run_head_pen clean '')"
head_missing_exit="$(run_head_pen missing '/^\/\/!   weave\.to_v1(/d')"

echo "phase=clean"
echo "clean_exit=$clean_exit"
echo "phase=site_check"
echo "site_check_exit=$site_check_exit"
echo "phase=site_misnamed"
echo "site_misnamed_exit=$site_misnamed_exit"
echo "phase=order_check"
echo "order_check_exit=$order_check_exit"
echo "phase=gen"
echo "gen_exit=$gen_exit"
echo "phase=text"
echo "text_exit=$text_exit"
echo "phase=pos"
echo "pos_exit=$pos_exit"
echo "phase=head_clean"
echo "head_clean_exit=$head_clean_exit"
echo "phase=head_missing"
echo "head_missing_exit=$head_missing_exit"

verdict=ok
# A plant that matched nothing is read FIRST and by its own name, because every
# other reading below is a number and this one is a word.
for reading in "$clean_exit" "$site_check_exit" "$site_misnamed_exit" "$order_check_exit" \
               "$gen_exit" "$text_exit" "$pos_exit" "$head_clean_exit" "$head_missing_exit"; do
  [ "$reading" != plant_matched_nothing ] || verdict=plant_matched_nothing
done
if [ "$verdict" = ok ]; then
  [ "$clean_exit" -eq 0 ] || verdict=clean_failed
  [ "$head_clean_exit" -eq 0 ] || verdict=head_clean_failed
  for broken in "$site_check_exit" "$site_misnamed_exit" "$order_check_exit" \
                "$gen_exit" "$text_exit" "$pos_exit" "$head_missing_exit"; do
    [ "$broken" -ne 0 ] || verdict=break_not_caught
  done
fi
echo "control_verdict=$verdict"
[ "$verdict" = ok ]
