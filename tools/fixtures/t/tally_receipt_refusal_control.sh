#!/bin/sh
# tools/fixtures/t/tally_receipt_refusal_control.sh -- prove the refusal witness bites.
#
# The witness claims that every admission that stops names its own field and
# renders one stable line. A witness green on a broken module teaches a reader
# very little, so this control plants each way the reading could go wrong,
# rebuilds, and requires the witness to catch it -- then lifts the plant and
# requires the green claim back.
#
# Every leg runs in its own pen, assembled from real copies rather than the tree's
# symlinks, so each plant stays inside the pen and every tracked file stays put.
set -u

ROOT=$(cd "$(dirname "$0")/../../.." && pwd)
# One shell dialect on both piers: `sed -i` takes a mandatory suffix on BSD and
# refuses it on GNU, so the plant below calls the tree's own portable helper.
. "$ROOT/tools/fixtures/s/shell_portable.sh"
ZIG="$ROOT/vendor/zig-toolchain/zig"
RYE="$ROOT/rye/bin/rye"
PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT

legs_expected=11
legs=0
failed=0

leg() {
  legs=$((legs + 1))
  if [ "$1" = yes ]; then
    printf 'leg %s=yes -- %s\n' "$2" "$3"
  else
    failed=$((failed + 1))
    printf 'leg %s=NO -- %s\n' "$2" "$3"
  fi
}

# Assemble one build pen. Imports are by bare name, so the four sources sit flat.
assemble() {
  dir="$1"
  mkdir -p "$dir"
  cp "$ROOT/mantra/src/receipt_offer.rye" "$dir/receipt_offer.rye"
  cp "$ROOT/mantra/src/receipt_refusal_witness.rye" "$dir/receipt_refusal_witness.rye"
  cp "$ROOT/tally/receipt_offer_bounds.rye" "$dir/tally_receipt_offer_bounds.rye"
  cp "$ROOT/tally/receipt_refusal.rye" "$dir/tally_receipt_refusal.rye"
}

# Build and run one pen. Prints ok when the witness reaches its GREEN claim.
verdict() {
  dir="$1"
  if ! env RYE_ZIG="$ZIG" "$RYE" build "$dir/receipt_refusal_witness.rye" -femit-bin="$dir/w" >"$dir/build.log" 2>&1; then
    echo "build-failed"
    return
  fi
  if "$dir/w" >"$dir/run.log" 2>&1 && grep -q 'GREEN: receipt refusal' "$dir/run.log"; then
    echo "ok"
  else
    echo "refused"
  fi
}

clean="$PEN/clean"
assemble "$clean"
clean_verdict=$(verdict "$clean")
leg "$([ "$clean_verdict" = ok ] && echo yes || echo no)" clean_passes \
  "the unmutated witness reaches its GREEN claim (read $clean_verdict)"

# Each plant names the file it edits, the sed program, and a word proving the edit landed.
plant() {
  name="$1"; file="$2"; program="$3"; proof="$4"; story="$5"
  dir="$PEN/$name"
  assemble "$dir"
  sed_inplace "$program" "$dir/$file"
  if grep -q "$proof" "$dir/$file"; then
    leg yes "${name}_applied" "the plant landed in $file"
  else
    leg no "${name}_applied" "the plant did NOT land in $file -- the leg below proves nothing"
  fi
  v=$(verdict "$dir")
  leg "$([ "$v" != ok ] && echo yes || echo no)" "${name}_bites" "$story (read $v)"
}

# A refusal that names the wrong field still carries the right reason, so a test
# reading the reason alone would pass. The witness reads the whole line.
plant wrong_field receipt_offer.rye \
  's/"holder_id", .value = f.holder_id/"receipt_id", .value = f.holder_id/' \
  '.name = "receipt_id", .value = f.holder_id' \
  'a refusal naming the wrong field refuses the witness'

# The two faces of one reading -- the record and the elder named error -- must agree.
plant crossed_error receipt_offer.rye \
  's/.empty => AdmissionError.Empty,/.empty => AdmissionError.NonAscii,/' \
  'empty => AdmissionError.NonAscii' \
  'a reason mapped to the wrong named error refuses the witness'

# A unit is what makes the number readable, so a drifted unit is a wrong answer
# that still compiles -- the shape a bare named error could never have exposed.
plant crossed_unit tally_receipt_refusal.rye \
  's/.unit = .ascii_byte }/.unit = .byte }/' \
  'unit = .byte }' \
  'a text ceiling reported in the wrong unit refuses the witness'

# The rendered key order is the contract a reader relies on.
plant reordered_line tally_receipt_refusal.rye \
  's/"field={s} value={d} ceiling={d} unit={s} reason={s}"/"field={s} ceiling={d} value={d} unit={s} reason={s}"/' \
  'field={s} ceiling={d} value={d}' \
  'a rendered line with its keys reordered refuses the witness'

# The record refuses a field name past its published ceiling.
plant unbounded_field tally_receipt_refusal.rye \
  's/if (self.field.len > max_field_name_bytes) return RenderError.FieldNameTooLong;//' \
  'pub fn render' \
  'a record that stops bounding its field name refuses the witness'

printf 'legs=%s legs_expected=%s control_failed=%s\n' "$legs" "$legs_expected" "$failed"
if [ "$legs" -ne "$legs_expected" ]; then
  printf 'detail: leg count moved -- a leg written today is heard only when this number moves with it\n'
  failed=$((failed + 1))
fi
if [ "$failed" -eq 0 ]; then
  printf 'control_verdict=ok\n'
else
  printf 'control_verdict=refused\n'
fi
