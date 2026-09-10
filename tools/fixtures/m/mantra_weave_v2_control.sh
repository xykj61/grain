#!/bin/sh
# tools/fixtures/m/mantra_weave_v2_control.sh -- the wide record, broken on purpose.
#
# WHAT THIS DOES. mantra/src/weave_v2_witness.rye asserts that `Weave.to_v2` and
# `Weave.from_v2` carry a merged history out to a `mantra-weave-v2` record and back without
# moving a field: five fields per line and both counters return as they went, the elder record
# refuses the same weave by name, and four shapes a record read off disk can wear are refused
# at the edge. This control copies the module and its witness into a throwaway pen, changes ONE
# thing in the copy, and watches the witness answer with a non-zero exit. Every refusal is shown
# from BOTH sides -- deleted, and left standing under the wrong error name -- because a refusal
# proven only by deletion cannot be told from one a caller can never match on.
#
# THE PEN IS A DIRECTORY. Zig resolves an import inside the root file's own directory, so
# weave.rye and its witness sit side by side here.
#
# FIFTEEN PHASES -- thirteen over the Rye witness, two over the head scan. Two are innocence
# legs that must exit 0 (clean, head_clean); the other thirteen are breaks that must not.
#   clean            -- the unmutated copy reaches GREEN, exit 0. This leg is what lets every
#                       other phase read as the break speaking rather than the pen.
#   gen_check        -- the reserved-generation refusal is deleted, so a row claiming to
#                       predate its own weave is restored. The module's own postcondition
#                       answers, which is the point: the read proves its output rather than
#                       trusting its input.
#   gen_misnamed     -- that refusal stands under the wrong error name. Claim 7 answers.
#   order_check      -- the place-order refusal is deleted, so a record whose document order is
#                       already broken is restored anyway. This is the one break that would
#                       silently reorder a reader's file.
#   order_misnamed   -- the same refusal, misnamed. Claim 8 answers.
#   identity_check   -- the repeated-identity refusal is deleted, so a record naming one line
#                       twice is restored. Claim 9 answers, and this is the refusal the elder
#                       record never needed: rising positions under one constant site ruled it
#                       out for free, and place order stopped being position order the moment a
#                       second site could hold a line.
#   identity_misnamed-- the same refusal, misnamed.
#   counter_pos_check-- the position-counter bound is deleted, so a record holding a line at
#                       its own counter is restored and the next edit would reissue that name.
#   counter_run_check-- the run-counter bound is deleted. Read as its own phase because a
#                       record may honor one counter and break the other.
#   counter_misnamed -- the position bound stands under the wrong error name. Claim 10 answers.
#   site_field       -- `to_v2` writes site 0 rather than the line's, so the second hand is
#                       erased and two lines collapse onto one place. Claim 1 answers, and the
#                       write's own place-order postcondition answers first.
#   run_field        -- `to_v2` writes run 0 rather than the line's, so the record still rises
#                       and still reads back the wrong weave. Claim 1 answers.
#   pos_derived      -- `from_v2` supplies its own position counter rather than the record's.
#                       This is the phase that guards the design decision: the counters are
#                       CARRIED because the weave's declared invariant is an upper bound rather
#                       than an equality, and claim 4 is what a deriving reader breaks.
#   run_derived      -- the same substitution on the run counter.
#   head_clean       -- the unmutated copy reads ok, exit 0. The head scan's own innocence leg.
#   head_missing     -- the head's `to_v2` line is deleted, so an operation stands unnamed and
#                       tools/fixtures/m/mantra_weave_head_scan.sh reds.
#
# EXPECTED: clean_exit=0, head_clean_exit=0, and every other phase non-zero.
#
# Driven by tools/m/mantra_weave_v2_witness.rish. Run from the repository root.

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
witness="$root/mantra/src/weave_v2_witness.rye"
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
  cp "$witness" "$pen/weave_v2_witness.rye"
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
  ( cd "$pen" && env RYE_ZIG="$zig" "$rye" build weave_v2_witness.rye \
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

# The two field plants are ADDRESSED to `to_v2` rather than matched on their own text, because
# `.site = line.site,` and `.run = line.run,` each stand three times in this module -- in the
# write, in `merge`, and in `annotate`. A plant that rewrote all three would be testing three
# functions at once and reporting one number.
to_v2_range='/pub fn to_v2(/,/^    }$/'

clean_exit="$(run_pen clean '')"
gen_check_exit="$(run_pen gen_check '/if (row\.gen == 0) return WeaveError\.V2GenerationBelowOne;/d')"
gen_misnamed_exit="$(run_pen gen_misnamed 's/if (row\.gen == 0) return WeaveError\.V2GenerationBelowOne;/if (row.gen == 0) return WeaveError.V2PlaceOrderNotRising;/')"
order_check_exit="$(run_pen order_check '/return WeaveError\.V2PlaceOrderNotRising;/d')"
order_misnamed_exit="$(run_pen order_misnamed 's/return WeaveError\.V2PlaceOrderNotRising;/return WeaveError.V2GenerationBelowOne;/')"
identity_check_exit="$(run_pen identity_check '/return WeaveError\.V2IdentityRepeated;/d')"
identity_misnamed_exit="$(run_pen identity_misnamed 's/return WeaveError\.V2IdentityRepeated;/return WeaveError.V2GenerationBelowOne;/')"
counter_pos_check_exit="$(run_pen counter_pos_check '/if (row\.pos >= record\.next_pos) return WeaveError\.V2CounterBelowLine;/d')"
counter_run_check_exit="$(run_pen counter_run_check '/if (row\.run >= record\.next_run) return WeaveError\.V2CounterBelowLine;/d')"
counter_misnamed_exit="$(run_pen counter_misnamed 's/if (row\.pos >= record\.next_pos) return WeaveError\.V2CounterBelowLine;/if (row.pos >= record.next_pos) return WeaveError.V2GenerationBelowOne;/')"
site_field_exit="$(run_pen site_field "${to_v2_range} s/\.site = line\.site,/.site = 0,/")"
run_field_exit="$(run_pen run_field "${to_v2_range} s/\.run = line\.run,/.run = 0,/")"
pos_derived_exit="$(run_pen pos_derived 's/\.next_pos = record\.next_pos,/.next_pos = 1,/')"
run_derived_exit="$(run_pen run_derived 's/\.next_run = record\.next_run,/.next_run = 1,/')"

head_clean_exit="$(run_head_pen clean '')"
head_missing_exit="$(run_head_pen missing '/^\/\/!   weave\.to_v2(/d')"

echo "phase=clean";             echo "clean_exit=$clean_exit"
echo "phase=gen_check";         echo "gen_check_exit=$gen_check_exit"
echo "phase=gen_misnamed";      echo "gen_misnamed_exit=$gen_misnamed_exit"
echo "phase=order_check";       echo "order_check_exit=$order_check_exit"
echo "phase=order_misnamed";    echo "order_misnamed_exit=$order_misnamed_exit"
echo "phase=identity_check";    echo "identity_check_exit=$identity_check_exit"
echo "phase=identity_misnamed"; echo "identity_misnamed_exit=$identity_misnamed_exit"
echo "phase=counter_pos_check"; echo "counter_pos_check_exit=$counter_pos_check_exit"
echo "phase=counter_run_check"; echo "counter_run_check_exit=$counter_run_check_exit"
echo "phase=counter_misnamed";  echo "counter_misnamed_exit=$counter_misnamed_exit"
echo "phase=site_field";        echo "site_field_exit=$site_field_exit"
echo "phase=run_field";         echo "run_field_exit=$run_field_exit"
echo "phase=pos_derived";       echo "pos_derived_exit=$pos_derived_exit"
echo "phase=run_derived";       echo "run_derived_exit=$run_derived_exit"
echo "phase=head_clean";        echo "head_clean_exit=$head_clean_exit"
echo "phase=head_missing";      echo "head_missing_exit=$head_missing_exit"

verdict=ok
# A plant that matched nothing is read FIRST and by its own name, because every
# other reading below is a number and this one is a word.
for reading in "$clean_exit" "$gen_check_exit" "$gen_misnamed_exit" "$order_check_exit" \
               "$order_misnamed_exit" "$identity_check_exit" "$identity_misnamed_exit" \
               "$counter_pos_check_exit" "$counter_run_check_exit" "$counter_misnamed_exit" \
               "$site_field_exit" "$run_field_exit" "$pos_derived_exit" "$run_derived_exit" \
               "$head_clean_exit" "$head_missing_exit"; do
  [ "$reading" != plant_matched_nothing ] || verdict=plant_matched_nothing
done
if [ "$verdict" = ok ]; then
  [ "$clean_exit" -eq 0 ] || verdict=clean_failed
  [ "$head_clean_exit" -eq 0 ] || verdict=head_clean_failed
  for broken in "$gen_check_exit" "$gen_misnamed_exit" "$order_check_exit" \
                "$order_misnamed_exit" "$identity_check_exit" "$identity_misnamed_exit" \
                "$counter_pos_check_exit" "$counter_run_check_exit" "$counter_misnamed_exit" \
                "$site_field_exit" "$run_field_exit" "$pos_derived_exit" \
                "$run_derived_exit" "$head_missing_exit"; do
    [ "$broken" -ne 0 ] || verdict=break_not_caught
  done
fi
echo "control_verdict=$verdict"
[ "$verdict" = ok ]
