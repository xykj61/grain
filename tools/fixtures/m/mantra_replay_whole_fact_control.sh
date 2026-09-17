#!/bin/sh
# tools/fixtures/m/mantra_replay_whole_fact_control.sh -- the whole-fact replay comparison, broken on purpose.
#
# WHAT THIS DOES. `mantra/src/receipt_offer.rye` publishes `fact_eql`, which compares an offer
# fact field by field, and `mantra/src/receipt_offer_witness.rye` proves replay determinism with
# it. This control builds a pen, changes ONE thing in it, and watches the build or the run answer
# with a non-zero exit. Every break is shown from both sides, so a real refusal stays tellable
# from a bypass.
#
# WHY THE WHOLE FACT. The elder witness compared `receipt_id` alone -- one field of the fifteen
# the fact publishes -- so a replay that dropped `purpose`, `value_amount`, `expires_at` or
# `signature` passed, and its passing was evidence about one string. The same lesson stands one
# file over in `mantra/src/receipt_refusal_witness.rye`, whose own comment says rendering the
# WHOLE line rather than one field is deliberate. It never crossed to this sibling.
#
# FIVE PHASES.
#   clean              -- the unmutated pen builds and reaches GREEN, exit 0. This leg is what
#                         lets every other phase read as the break speaking rather than the pen.
#   elder_walks_free   -- `replay` is mutated to drop one field, and a witness carrying the ELDER
#                         one-field comparison is run against it. It must exit 0. This is the
#                         measurement that says the repair matters rather than the claim that it
#                         does: a mutation is evidence only where the truth it replaces differs.
#   whole_fact_refuses -- the SAME mutated `replay`, read by the landed whole-fact comparison.
#                         It must exit non-zero.
#   count_drifted      -- `offer_fact_fields` is moved off the struct's own field count while
#                         nothing else changes, so the comptime assert must refuse the build.
#   unstated_type      -- a field of a type the comparison states no reading for is published,
#                         with the count moved to match so ONLY the type branch can speak. The
#                         build must refuse, naming the field.
#
# THE PEN IS A DIRECTORY WITH ONE REAL ROOM. Every module the witness imports lives in
# `mantra/src/`, so the pen carries a real copy of that room and symlinks the rooms the Rye build
# reads (tools, vendor, rye). Copying the toolchain would make the pen a second tree.
#
# THE PLANTS READ THE TREE RATHER THAN SPELLING IT. The field count is read from
# `offer_fact_fields` on disk, so a plant follows the constant wherever it goes -- the fault
# `%519` named, where a sed aimed at a stale literal matches nothing, the module stays correct,
# and the phase reports a refusal it never produced. Each plant is checked for having landed
# before the phase it feeds runs.
#
# EXPECTED: clean_exit=0, elder_walks_free_exit=0, and the other three non-zero. The exit codes
# are printed rather than asserted here; tools/t/tally_receipt_offer_bounds_witness.rish holds
# them, so the numbers live in one place and this file stays the thing that produces them.
#
# Driven by tools/t/tally_receipt_offer_bounds_witness.rish. Run from the repository root.

set -eu

root="$(pwd)"
module="$root/mantra/src/receipt_offer.rye"
witness="$root/mantra/src/receipt_offer_witness.rye"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

legs=0
failed=0
leg() {
  legs=$(( legs + 1 ))
  if [ "$2" = "$3" ]; then
    echo "$1=$2"
  else
    failed=$(( failed + 1 ))
    echo "$1=$2 wanted=$3 FAILED"
  fi
}

# The published count is READ, never spelled, so the drift plant below follows it.
declared="$( grep -o 'pub const offer_fact_fields = [0-9][0-9]*;' "$module" \
  | head -1 | grep -o '[0-9][0-9]*' )"
if [ -z "$declared" ]; then
  echo "control_verdict=broken"
  echo "detail: receipt_offer.rye declares no offer_fact_fields constant, so no plant below has a subject"
  exit 1
fi
drifted=$(( declared - 1 ))
grown=$(( declared + 1 ))

make_pen() {
  _pen="$1"
  mkdir -p "$_pen/mantra/src"
  cp "$root"/mantra/src/*.rye "$_pen/mantra/src/"
  for _room in tools vendor rye; do
    ln -s "$root/$_room" "$_pen/$_room"
  done
}

# Build the witness inside a pen. Echoes the build's exit code.
build_in() {
  _pen="$1"
  _code=0
  ( cd "$_pen" && env RYE_ZIG="$root/vendor/zig-toolchain/zig" \
      sh tools/fixtures/r/rye_build.sh mantra/src/receipt_offer_witness.rye \
      -femit-bin="$_pen/witness" ) >"$_pen/build.out" 2>&1 || _code=$?
  echo "$_code"
}

# Rewrite a file in place through its own inode, so a mode never travels from a temporary.
edit() {
  sed "$2" "$1" > "$1.tmp" && cat "$1.tmp" > "$1" && rm -f "$1.tmp"
}

# THE DROPPED FIELD. `replay` hands back a fact with one text field emptied. Nothing else moves,
# so the two comparisons below read exactly one difference.
drop_program='s|const state: ReceiptState = .{ .offer = fact, .status =|var dropped = fact; dropped.purpose = ""; const state: ReceiptState = .{ .offer = dropped, .status =|'

# clean
clean_pen="$work/clean"
make_pen "$clean_pen"
clean_build="$( build_in "$clean_pen" )"
if [ "$clean_build" -ne 0 ]; then
  echo "control_verdict=broken"
  echo "detail: the unmutated pen did not build, so no phase below reads as a plant speaking"
  sed -n '1,20p' "$clean_pen/build.out"
  exit 1
fi
clean_code=0
"$clean_pen/witness" >"$work/clean.run" 2>&1 || clean_code=$?
leg clean_exit "$clean_code" 0
if ! grep -q 'GREEN: receipt offer' "$work/clean.run"; then
  failed=$(( failed + 1 ))
  echo "clean_green=no wanted=yes FAILED"
else
  echo "clean_green=yes"
fi
legs=$(( legs + 1 ))

# elder_walks_free -- the mutated replay, read by the one-field comparison this repair left behind.
elder_pen="$work/elder"
make_pen "$elder_pen"
edit "$elder_pen/mantra/src/receipt_offer.rye" "$drop_program"
if ! grep -q 'dropped.purpose' "$elder_pen/mantra/src/receipt_offer.rye"; then
  echo "control_verdict=plant_matched_nothing"
  echo "detail: replay no longer builds its state the way the drop plant edits, so the two phases below prove nothing"
  exit 1
fi
# THE ELDER COMPARISON IS RESTORED BY CLASS rather than call by call. Every line naming
# `fact_eql` leaves, and the one-field reading this repair replaced is written back in its place.
# Editing each call by its exact text goes quiet the day a call is added, which is the `%519`
# fault this control already guards against for the field count.
_elder_witness="$elder_pen/mantra/src/receipt_offer_witness.rye"
if ! grep -q 'fact_eql' "$_elder_witness"; then
  echo "control_verdict=plant_matched_nothing"
  echo "detail: the witness names fact_eql nowhere, so the elder comparison below replaces nothing"
  exit 1
fi
grep -v 'fact_eql' "$_elder_witness" > "$_elder_witness.tmp"
cat "$_elder_witness.tmp" > "$_elder_witness"
rm -f "$_elder_witness.tmp"
edit "$_elder_witness" \
  's|    assert(second.status == .offered);|    assert(second.status == .offered);\n    assert(std.mem.eql(u8, first.offer.receipt_id, second.offer.receipt_id));\n    assert(std.mem.eql(u8, first.offer.receipt_id, fact.receipt_id));|'
if grep -q 'fact_eql' "$_elder_witness" \
   || ! grep -q 'first.offer.receipt_id, fact.receipt_id' "$_elder_witness"; then
  echo "control_verdict=plant_matched_nothing"
  echo "detail: the elder one-field comparison could not be written back, so its exit code below says nothing"
  exit 1
fi
elder_build="$( build_in "$elder_pen" )"
if [ "$elder_build" -ne 0 ]; then
  echo "control_verdict=broken"
  echo "detail: the elder-comparison pen did not build, so its exit code below says nothing about the comparison"
  exit 1
fi
elder_code=0
"$elder_pen/witness" >/dev/null 2>&1 || elder_code=$?
leg elder_walks_free_exit "$elder_code" 0

# whole_fact_refuses -- the same mutated replay, read by the landed comparison.
whole_pen="$work/whole"
make_pen "$whole_pen"
edit "$whole_pen/mantra/src/receipt_offer.rye" "$drop_program"
whole_build="$( build_in "$whole_pen" )"
if [ "$whole_build" -ne 0 ]; then
  echo "control_verdict=broken"
  echo "detail: the whole-fact pen did not build, so its exit code below says nothing about the comparison"
  exit 1
fi
# Run through a child shell, so the abort a failing assert raises is reported as an exit code
# rather than as the calling shell's own job-control notice on this control's stderr.
whole_code=0
sh -c '"$1" >/dev/null 2>&1' sh "$whole_pen/witness" || whole_code=$?
if [ "$whole_code" -ne 0 ]; then
  echo "whole_fact_refuses_exit=$whole_code"
else
  failed=$(( failed + 1 ))
  echo "whole_fact_refuses_exit=0 wanted=non-zero FAILED"
fi
legs=$(( legs + 1 ))

# count_drifted -- the stated count leaves the struct's own field count; nothing else moves.
count_pen="$work/count"
make_pen "$count_pen"
edit "$count_pen/mantra/src/receipt_offer.rye" \
  "s|pub const offer_fact_fields = ${declared};|pub const offer_fact_fields = ${drifted};|"
if ! grep -q "offer_fact_fields = ${drifted};" "$count_pen/mantra/src/receipt_offer.rye"; then
  echo "control_verdict=plant_matched_nothing"
  echo "detail: the declared count could not be moved, so the phase below proves nothing"
  exit 1
fi
count_build="$( build_in "$count_pen" )"
if [ "$count_build" -ne 0 ]; then
  echo "count_drifted_exit=$count_build"
else
  failed=$(( failed + 1 ))
  echo "count_drifted_exit=0 wanted=non-zero FAILED"
fi
legs=$(( legs + 1 ))

# unstated_type -- a field whose type the comparison states no reading for, with the count moved
# to match so the count assert stays quiet and ONLY the type branch can speak.
type_pen="$work/type"
make_pen "$type_pen"
edit "$type_pen/mantra/src/receipt_offer.rye" \
  "s|pub const offer_fact_fields = ${declared};|pub const offer_fact_fields = ${grown};|"
edit "$type_pen/mantra/src/receipt_offer.rye" \
  's|signer_id: \[\]const u8, signature: \[\]const u8,|signer_id: []const u8, signature: []const u8, planted_flag: bool,|'
edit "$type_pen/mantra/src/receipt_offer_witness.rye" \
  's|.signature = "fixture-signature-v1",|.signature = "fixture-signature-v1", .planted_flag = true,|'
if ! grep -q 'planted_flag: bool' "$type_pen/mantra/src/receipt_offer.rye" \
   || ! grep -q '.planted_flag = true' "$type_pen/mantra/src/receipt_offer_witness.rye"; then
  echo "control_verdict=plant_matched_nothing"
  echo "detail: the unstated-type field could not be published, so the phase below proves nothing"
  exit 1
fi
type_build="$( build_in "$type_pen" )"
if [ "$type_build" -ne 0 ]; then
  echo "unstated_type_exit=$type_build"
else
  failed=$(( failed + 1 ))
  echo "unstated_type_exit=0 wanted=non-zero FAILED"
fi
legs=$(( legs + 1 ))
if grep -q "planted_flag' publishes no stated comparison" "$type_pen/build.out"; then
  echo "unstated_type_named=yes"
else
  failed=$(( failed + 1 ))
  echo "unstated_type_named=no wanted=yes FAILED"
fi
legs=$(( legs + 1 ))

echo "control_legs=${legs}"
echo "control_failed=${failed}"
echo "control_verdict=ok"
