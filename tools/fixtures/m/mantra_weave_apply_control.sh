#!/bin/sh
# tools/fixtures/m/mantra_weave_apply_control.sh -- the apply contract, broken on purpose.
#
# WHAT THIS DOES. mantra/src/weave_apply_witness.rye asserts that `Weave.apply` reads one
# caller's diff to one standard: both halves refuse by name, and every delete refusal is read
# BEFORE a generation moves. This control copies the module and its witness into a throwaway
# pen, changes ONE thing in the copy, and watches the witness answer with a non-zero exit. Each
# break is shown from both sides, so a real refusal stays tellable from a bypass.
#
# THE PEN IS A DIRECTORY. Zig resolves an import inside the root file's own directory, so
# weave.rye and its witness sit side by side here. Everything reads from the filesystem alone,
# which makes a plain directory the honest pen.
#
# THIRTEEN PHASES -- one innocent, ten breaks, and two lifts that name a reader.
#   clean            -- the unmutated copy reaches GREEN, exit 0. This leg is what lets every
#                       other phase read as the break speaking rather than the pen.
#   gone_removed     -- the `DeleteNamesGoneLine` refusal is deleted, which is the module as it
#                       stood before `20260912`: the parity assert below it fires and the phase
#                       exits 134, the original abort naming itself.
#   gone_misnamed    -- the same refusal kept, under the wrong error name. A check present and
#                       answering wrongly is a different fault from a check absent, and a control
#                       that planted only the deletion could not tell them apart.
#   noline_removed   -- the `DeleteNamesNoLine` refusal is deleted. A delete naming no held line
#                       is then WELCOMED, and the witness's `unreachable` says so.
#   noline_misnamed  -- the same refusal, wrong name.
#   twice_removed    -- the `DeleteNamesOneLineTwice` refusal is deleted, so two targets naming
#                       one line reach the walk and the second bump resurrects a deleted line.
#   twice_misnamed   -- the same refusal, wrong name.
#   mutation_early   -- THE ORDERING LEG, and the one this witness exists for. The refusals stay
#                       exactly where they are and every error name is right; only the MOMENT the
#                       generation rises moves, from the mark loop past the last refusal back
#                       into the walk. A block whose first target is good and whose second is not
#                       then refuses by the correct name over a weave it has already half
#                       changed. Nothing but claim 7's before-and-after reading can see this, so
#                       a control without this phase would pass a module whose named errors lie.
#   anchor_ignored     -- CLAIM 9's first half. The anchor lookup is forced never to match, so an
#                       insert carrying an anchor falls through to the counter's answer and lands
#                       at the END instead of just past its anchor. Every refusal stands and every
#                       error name is right; only where a WELCOMED line goes has moved, which is
#                       why no refusal claim can see it.
#   run_order_reversed   -- CLAIM 9's second half, and the only change in this module that can put a
#                       fresh insert in FIRST place: the run comparison inside `Place.less_than`
#                       is turned around, so the newest edit sorts to the top of the document.
#   run_order_reversed_lifted, anchor_ignored_lifted
#                    -- each break above, run a second time with claim 9 REMOVED from the witness
#                       copy, where both must reach exit 0. These two name which LEG is reading:
#                       the breaks prove the law breakable, and these prove claim 9 is the one
#                       claim that catches either. Without them both plants could be caught by
#                       some other claim entirely and nobody would know -- which is the same
#                       question `lifted` asks about the pen, asked about the witness instead.
#   lifted           -- the `mutation_early` program run with an empty plant returns the same pen
#                       to exit 0, which is the pen proving its own innocence.
#
# WHY THE NAME PLANTS MATTER AS MUCH AS THE DELETIONS. A refusal proven only by its absence is a
# refusal proven in one direction. `PositionTextDisagrees` is the wrong name chosen on purpose:
# it is a real member of the same error set, so the module still compiles and the only thing that
# has changed is what a caller is told.
#
# EXPECTED: control_verdict=ok; clean_exit, lifted_exit, run_order_reversed_lifted_exit and
# anchor_ignored_lifted_exit all 0; every other phase non-zero.
#
# Driven by tools/m/mantra_weave_apply_witness.rish. Run from the repository root.

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
witness="$root/mantra/src/weave_apply_witness.rye"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
trap 'rm -rf "$work"; exit 130' INT
trap 'rm -rf "$work"; exit 143' TERM

# Build a pen from the real sources, apply an optional sed program to the module copy and an
# optional second one to the WITNESS copy, then build and run. Echoes the exit code and nothing
# else.
#
# THE WITNESS PROGRAM IS WHAT LETS A PHASE ASK WHICH LEG IS READING. Mutating the module answers
# *does this break*; removing one claim from the witness beside it answers *and is this the claim
# that sees it*. A control that only ever mutates the module can prove a law broken and can never
# say which reading proves it, so a leg deleted tomorrow would leave the mutation caught by
# something else and nobody the wiser.
run_pen() {
  name="$1"
  program="$2"
  witness_program="${3:-}"
  pen="$work/$name"
  mkdir -p "$pen"
  cp "$module" "$pen/weave.rye"
  cp "$witness" "$pen/weave_apply_witness.rye"
  if [ -n "$program" ]; then
    # A plant that matched nothing leaves the pen byte for byte identical, so the
    # phase reads the UNMUTATED module's exit code -- 0, indistinguishable from a
    # law that holds. `plant_apply` refuses by name, imported rather than written
    # here so the next control inherits it.
    if ! plant_apply "$pen/weave.rye" "$program" "$name"; then
      echo "plant_matched_nothing"
      return
    fi
  fi
  if [ -n "$witness_program" ]; then
    # Same law on the witness copy: a plant that matched nothing would leave the leg
    # in place and make this phase read as the leg failing to catch the mutation.
    if ! plant_apply "$pen/weave_apply_witness.rye" "$witness_program" "${name}_witness"; then
      echo "plant_matched_nothing"
      return
    fi
  fi
  code=0
  ( cd "$pen" && env RYE_ZIG="$zig" "$rye" build weave_apply_witness.rye \
      -femit-bin="$pen/run" >/dev/null 2>&1 ) || code=$?
  if [ "$code" -eq 0 ]; then
    "$pen/run" >/dev/null 2>&1 || code=$?
  fi
  echo "$code"
}

# The wrong name every misnaming plant reaches for: a real member of WeaveError, so the module
# still compiles and the only thing that changed is what a caller is told.
wrong='WeaveError.PositionTextDisagrees'

clean_exit="$(run_pen clean '')"
gone_removed_exit="$(run_pen gone_removed \
  '/if (line.gen % 2 == 0) return WeaveError.DeleteNamesGoneLine;/d')"
gone_misnamed_exit="$(run_pen gone_misnamed \
  "s#return WeaveError.DeleteNamesGoneLine;#return ${wrong};#")"
noline_removed_exit="$(run_pen noline_removed \
  '/return WeaveError.DeleteNamesNoLine;/d')"
noline_misnamed_exit="$(run_pen noline_misnamed \
  "s#return WeaveError.DeleteNamesNoLine;#return ${wrong};#")"
twice_removed_exit="$(run_pen twice_removed \
  '/return WeaveError.DeleteNamesOneLineTwice;/d')"
twice_misnamed_exit="$(run_pen twice_misnamed \
  "s#return WeaveError.DeleteNamesOneLineTwice;#return ${wrong};#")"

# The ordering plant, in two substitutions that must land together. The first raises the
# generation inside the walk, the moment a target is matched; the second empties the mark loop
# that used to be the only mutation, by slicing it to nothing rather than deleting it, so the
# module still compiles and `hits` is still read. Neither error name moves.
early='s#if (line.gen % 2 == 0) return WeaveError.DeleteNamesGoneLine;#if (line.gen % 2 == 0) return WeaveError.DeleteNamesGoneLine; self.lines.items[at].gen += 1;#; s#for (marks\[0..hits\]) |at| {#for (marks[0..0]) |at| {#'
mutation_early_exit="$(run_pen mutation_early "$early")"

# CLAIM 9's TWO PLANTS. The ninth claim reads where an insert lands when no line comes before it:
# a null anchor keeps the counter's answer and lands LAST, and anchoring on the first line lands
# SECOND, so first place is unreachable from either spelling. Each half needs its own break.
#
# `anchor_ignored` forces the anchor lookup never to match, so an anchored insert falls through to
# the counter's answer and lands last. The error names are untouched and every refusal still
# stands; only where a welcomed line goes has moved. This is the half claim 1 cannot see, because
# claim 1 inserts without anchors.
anchor_ignored_exit="$(run_pen anchor_ignored \
  's#if (held.id().eq(anchor)) {#if (false and held.id().eq(anchor)) {#')"

# `run_order_reversed` turns the run comparison in `Place.less_than` around, which is the ONLY change
# in this module that can put a fresh insert in FIRST place -- a fresh run stands above every held
# run, so reading runs downward puts the newest edit at the top of the document. Claim 9's null
# anchor reads "beta, gamma, alpha" and would read "alpha, beta, gamma".
reversed='s#if (self.run != other.run) return self.run < other.run;#if (self.run != other.run) return self.run > other.run;#'
run_order_reversed_exit="$(run_pen run_order_reversed "$reversed")"

# AND THE PHASE THAT NAMES WHICH LEG IS READING. The same reversed-run module, with claim 9's call
# removed from the witness copy, must reach exit 0 -- which is the measurement the design paper
# `active-designing/20260916-105110_no-anchor-names-the-head.md` states: claim 9 is the only
# reading in this file that presses the order law's first key. A `break_not_caught` reading here
# would mean some other claim catches it too and the paper's sentence is wrong; a non-zero exit
# for any other reason would mean the plant did something besides what it says.
drop9='s#    try prove_head_insert_lands_last(garden);##'
run_order_reversed_lifted_exit="$(run_pen run_order_reversed_lifted "$reversed" "$drop9")"
anchor_ignored_lifted_exit="$(run_pen anchor_ignored_lifted \
  's#if (held.id().eq(anchor)) {#if (false and held.id().eq(anchor)) {#' "$drop9")"

lifted_exit="$(run_pen lifted '')"

report=$(
  echo "phase=clean"
  echo "clean_exit=$clean_exit"
  echo "phase=gone_removed"
  echo "gone_removed_exit=$gone_removed_exit"
  echo "phase=gone_misnamed"
  echo "gone_misnamed_exit=$gone_misnamed_exit"
  echo "phase=noline_removed"
  echo "noline_removed_exit=$noline_removed_exit"
  echo "phase=noline_misnamed"
  echo "noline_misnamed_exit=$noline_misnamed_exit"
  echo "phase=twice_removed"
  echo "twice_removed_exit=$twice_removed_exit"
  echo "phase=twice_misnamed"
  echo "twice_misnamed_exit=$twice_misnamed_exit"
  echo "phase=mutation_early"
  echo "mutation_early_exit=$mutation_early_exit"
  echo "phase=anchor_ignored"
  echo "anchor_ignored_exit=$anchor_ignored_exit"
  echo "phase=run_order_reversed"
  echo "run_order_reversed_exit=$run_order_reversed_exit"
  echo "phase=run_order_reversed_lifted"
  echo "run_order_reversed_lifted_exit=$run_order_reversed_lifted_exit"
  echo "phase=anchor_ignored_lifted"
  echo "anchor_ignored_lifted_exit=$anchor_ignored_lifted_exit"
  echo "phase=lifted"
  echo "lifted_exit=$lifted_exit"
)
echo "$report"

# THE PEN COUNTS ITS OWN LEGS OUT LOUD. `fail=0` is what an empty pen prints too, so a leg
# deleted with nothing else changed would leave this control cheerful and blind. The witness
# asserts both numbers, so removing a phase reds the guard rather than quietly shrinking it.
legs_ran=$(echo "$report" | grep -c '_exit=')
legs_expected=13
echo "legs_ran=$legs_ran"
echo "legs_expected=$legs_expected"

verdict=ok
# A plant that matched nothing is read FIRST and by its own name, because every other reading
# below is a number and this one is a word.
for reading in "$clean_exit" "$gone_removed_exit" "$gone_misnamed_exit" \
               "$noline_removed_exit" "$noline_misnamed_exit" "$twice_removed_exit" \
               "$twice_misnamed_exit" "$mutation_early_exit" "$anchor_ignored_exit" \
               "$run_order_reversed_exit" "$run_order_reversed_lifted_exit" \
               "$anchor_ignored_lifted_exit" "$lifted_exit"; do
  [ "$reading" != plant_matched_nothing ] || verdict=plant_matched_nothing
done
if [ "$verdict" = ok ]; then
  [ "$legs_ran" -eq "$legs_expected" ] || verdict=leg_count_disagrees
fi
if [ "$verdict" = ok ]; then
  [ "$clean_exit" -eq 0 ] || verdict=clean_failed
  [ "$lifted_exit" -eq 0 ] || verdict=lift_not_innocent
  # The claim-9 lift is read as its own word rather than folded in with `lifted`, because the two
  # prove different things: `lifted` says the PEN is innocent, and this says the LEG is the reader.
  [ "$run_order_reversed_lifted_exit" -eq 0 ] || verdict=claim9_not_sole_reader
  [ "$anchor_ignored_lifted_exit" -eq 0 ] || verdict=claim9_not_sole_reader
  for broken in "$gone_removed_exit" "$gone_misnamed_exit" "$noline_removed_exit" \
                "$noline_misnamed_exit" "$twice_removed_exit" "$twice_misnamed_exit" \
                "$mutation_early_exit" "$anchor_ignored_exit" "$run_order_reversed_exit"; do
    [ "$broken" -ne 0 ] || verdict=break_not_caught
  done
fi
echo "control_verdict=$verdict"
[ "$verdict" = ok ]
