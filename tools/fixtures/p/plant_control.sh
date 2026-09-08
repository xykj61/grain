#!/bin/sh
# tools/fixtures/p/plant_control.sh -- the plant helper, proven on real files in a throwaway pen.
#
# WHY A CONTROL RATHER THAN A READING. `tools/fixtures/p/plant.sh` exists so that a control which
# breaks a module on purpose can prove the break landed. That makes it the instrument every other
# control's honesty rests on, and an instrument nobody has tried to fool is a claim. So each of the
# three functions is shown from BOTH sides here -- a plant that lands answered 0, and a plant that
# matches nothing answered 1 by name -- on files this control writes and then reads back.
#
# THE LOAD-BEARING PHASE IS `stripped`. A helper that answered "landed" about every plant would
# pass every welcome leg above and catch nothing. So one phase copies plant.sh, removes the byte
# comparison from `plant_apply`, and asserts the copy reads a no-op plant as LANDED. That failing
# reading standing green beside the real one is what distinguishes a working check from a check
# that has merely started saying yes.
#
# THE MODE PHASE IS NOT DECORATION. A plant aimed at a fixture or a launcher is aimed at a file
# whose exec bit is tracked content (.claude/rules/exec-bit.md, where `mv` over an original dropped
# 100755 on thirty-nine files in one commit). `plant_apply` writes through the original inode; this
# control plants into a 755 file and reads the mode back.
#
# EXPECTED: every behavior below satisfied, faults=0, exit 0.
#
# Driven by tools/p/plant_witness.rish. Run from anywhere -- the root is found by upward walk.

set -eu

# Root by upward walk (seated 20260828): the letter fold moved fixtures one directory deeper, so
# fixed ../.. arithmetic breaks. The walk finds the first ancestor holding rishi/bin and
# tools/fixtures -- git-free, so a pen copy outside a repository still resolves.
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

HELPER="$_fd_root/tools/fixtures/p/plant.sh"
PEN="$(mktemp -d)"
trap 'rm -rf "$PEN"' EXIT

behaviors=0
faults=0

# A behavior is named, its measured answer printed beside the answer it owes, so a reader watching
# the stream sees what was asked as well as whether it passed.
note() {
  _label=$1; _got=$2; _want=$3
  behaviors=$((behaviors + 1))
  if [ "$_got" = "$_want" ]; then
    echo "OK   $_label ($_got)"
  else
    echo "FAULT $_label -- got '$_got', owed '$_want'"
    faults=$((faults + 1))
  fi
}

subject() {
  printf 'const std = @import("std");\nvar deletes: u32 = 0;\npub fn go() void {}\n' > "$1"
}

echo "plant-control: three functions, each shown from both sides, in $PEN"
echo

# --- plant_landed, the reading alone -----------------------------------------------------------
echo "== 1. plant_landed reads a difference and reads its absence =="
subject "$PEN/a.rye"
subject "$PEN/b.rye"
printf 'extra\n' >> "$PEN/b.rye"
note "landed_on_difference" "$(plant_landed "$PEN/a.rye" "$PEN/b.rye" one 2>/dev/null && echo landed || echo nothing)" "landed"

subject "$PEN/c.rye"
subject "$PEN/d.rye"
note "landed_on_identical" "$(plant_landed "$PEN/c.rye" "$PEN/d.rye" two 2>/dev/null && echo landed || echo nothing)" "nothing"
note "identical_names_the_word" \
  "$(plant_landed "$PEN/c.rye" "$PEN/d.rye" two 2>&1 >/dev/null | grep -c 'plant_matched_nothing:two')" "1"
note "landed_on_absent_before" \
  "$(plant_landed "$PEN/nowhere.rye" "$PEN/d.rye" three 2>/dev/null && echo landed || echo nothing)" "nothing"
note "absent_names_its_own_word" \
  "$(plant_landed "$PEN/nowhere.rye" "$PEN/d.rye" three 2>&1 >/dev/null | grep -c 'plant_source_absent:three')" "1"

echo
# --- plant_write, source to destination --------------------------------------------------------
echo "== 2. plant_write mutates into a new file, or refuses and writes none =="
subject "$PEN/src.rye"
note "write_lands" \
  "$(plant_write "$PEN/src.rye" "$PEN/out.rye" 's/u32/LineId/' widen 2>/dev/null && echo landed || echo nothing)" "landed"
note "write_actually_changed_the_bytes" "$(grep -c 'LineId' "$PEN/out.rye")" "1"
note "write_left_the_source_alone" \
  "$(cmp -s "$PEN/src.rye" "$PEN/out.rye" && echo same || echo differs)" "differs"

note "write_refuses_a_stale_line" \
  "$(plant_write "$PEN/src.rye" "$PEN/stale.rye" 's/no_such_line_anywhere/x/' stale 2>/dev/null && echo landed || echo nothing)" "nothing"
# The refused destination must not exist. A caller that ignores the return value then cannot build
# an unmutated pen and read its exit code as a break -- which is the exact shape REDS %519 booked.
note "refused_write_leaves_no_destination" \
  "$([ -e "$PEN/stale.rye" ] && echo present || echo absent)" "absent"
note "stale_names_the_word" \
  "$(plant_write "$PEN/src.rye" "$PEN/stale2.rye" 's/no_such_line_anywhere/x/' stale 2>&1 >/dev/null | grep -c 'plant_matched_nothing:stale')" "1"

note "write_refuses_an_empty_program" \
  "$(plant_write "$PEN/src.rye" "$PEN/empty.rye" '' blank 2>/dev/null && echo landed || echo nothing)" "nothing"
note "empty_program_names_its_own_word" \
  "$(plant_write "$PEN/src.rye" "$PEN/empty.rye" '' blank 2>&1 >/dev/null | grep -c 'plant_program_empty:blank')" "1"

note "write_refuses_an_absent_source" \
  "$(plant_write "$PEN/nowhere.rye" "$PEN/x.rye" 's/a/b/' gone 2>/dev/null && echo landed || echo nothing)" "nothing"

# A destination that does not exist yet is seeded with `cp`, which carries the source's mode, and
# then written through that inode. Reading the mode back to re-apply it would want `stat`, whose
# field-format flag differs between GNU and BSD and which `shell_dialect` holds at zero.
printf '#!/bin/sh\necho gamma\n' > "$PEN/src_runnable.sh"
chmod 755 "$PEN/src_runnable.sh"
plant_write "$PEN/src_runnable.sh" "$PEN/new_runnable.sh" 's/gamma/delta/' newmode >/dev/null 2>&1 || true
note "write_to_a_new_destination_keeps_the_exec_bit" \
  "$([ -x "$PEN/new_runnable.sh" ] && echo executable || echo plain)" "executable"
note "write_to_a_new_destination_carries_the_mutation" \
  "$(grep -c delta "$PEN/new_runnable.sh")" "1"

# A sed program sed itself rejects leaves a partial or empty file behind. That file DIFFERS from the
# source, so a bare byte comparison would call the plant landed and hand the phase an empty module.
# Reading sed's exit code is what tells a typo from a break.
note "write_refuses_a_program_sed_rejects" \
  "$(plant_write "$PEN/src.rye" "$PEN/bad.rye" 's/unclosed' broken 2>/dev/null && echo landed || echo nothing)" "nothing"
note "rejected_program_names_its_own_word" \
  "$(plant_write "$PEN/src.rye" "$PEN/bad2.rye" 's/unclosed' broken 2>&1 >/dev/null | grep -c 'plant_program_failed:broken')" "1"
note "rejected_program_leaves_no_destination" \
  "$([ -e "$PEN/bad.rye" ] && echo present || echo absent)" "absent"

echo
# --- plant_apply, in place ---------------------------------------------------------------------
echo "== 3. plant_apply rewrites in place, keeps the mode, and leaves nothing behind =="
subject "$PEN/inplace.rye"
cp "$PEN/inplace.rye" "$PEN/inplace.before"
note "apply_lands" \
  "$(plant_apply "$PEN/inplace.rye" 's/u32/LineId/' widen 2>/dev/null && echo landed || echo nothing)" "landed"
note "apply_actually_changed_the_file" \
  "$(cmp -s "$PEN/inplace.rye" "$PEN/inplace.before" && echo same || echo differs)" "differs"

subject "$PEN/untouched.rye"
cp "$PEN/untouched.rye" "$PEN/untouched.before"
note "apply_refuses_a_stale_line" \
  "$(plant_apply "$PEN/untouched.rye" 's/no_such_line_anywhere/x/' stale 2>/dev/null && echo landed || echo nothing)" "nothing"
note "refused_apply_leaves_the_file_byte_identical" \
  "$(cmp -s "$PEN/untouched.rye" "$PEN/untouched.before" && echo same || echo differs)" "same"

# The exec bit is tracked content, and writing through the original inode is what keeps it.
printf '#!/bin/sh\necho alpha\n' > "$PEN/runnable.sh"
chmod 755 "$PEN/runnable.sh"
plant_apply "$PEN/runnable.sh" 's/alpha/beta/' mode >/dev/null 2>&1 || true
note "apply_keeps_the_exec_bit" "$([ -x "$PEN/runnable.sh" ] && echo executable || echo plain)" "executable"
note "apply_left_no_temporary" \
  "$(find "$PEN" -name '*.plant.*' 2>/dev/null | wc -l | tr -d ' ')" "0"

echo
# --- the load-bearing phase ---------------------------------------------------------------------
echo "== 4. stripped of its comparison, the same helper calls a no-op plant landed =="
# The plant into the helper copy is itself proven to have landed, by the helper under test. A
# control that mutates its own subject without checking is the fault this whole file exists for.
cp "$HELPER" "$PEN/stripped.sh"
plant_apply "$PEN/stripped.sh" '/^  if cmp -s "\$_pa_tmp" "\$_pa_file"; then$/,/^  fi$/d' strip >/dev/null 2>&1 \
  && strip_planted=yes || strip_planted=no
note "the_strip_plant_landed" "$strip_planted" "yes"

subject "$PEN/victim.rye"
cp "$PEN/victim.rye" "$PEN/victim.before"
stripped_says=$(
  # shellcheck disable=SC1090
  . "$PEN/stripped.sh"
  plant_apply "$PEN/victim.rye" 's/no_such_line_anywhere/x/' blind >/dev/null 2>&1 && echo landed || echo nothing
)
note "stripped_helper_reads_a_no_op_as_landed" "$stripped_says" "landed"
note "stripped_helper_left_the_file_unmutated" \
  "$(cmp -s "$PEN/victim.rye" "$PEN/victim.before" && echo same || echo differs)" "same"

echo
# --- the real tree ------------------------------------------------------------------------------
echo "== 5. the helper works on a real tracked source, not only on pen text =="
cp "$_fd_root/mantra/src/diff.rye" "$PEN/diff.rye"
note "real_source_plant_lands" \
  "$(plant_apply "$PEN/diff.rye" 's/^const assert = std.debug.assert;$/const assert = std.debug.assert; \/\/ planted/' real 2>/dev/null && echo landed || echo nothing)" "landed"
note "real_source_stale_plant_refuses" \
  "$(plant_apply "$PEN/diff.rye" 's/^const this_line_never_existed = 1;$/x/' realstale 2>/dev/null && echo landed || echo nothing)" "nothing"

echo
# --- the adoption floor -------------------------------------------------------------------------
# A FLOOR PROVEN FROM BOTH SIDES, on a real git repository, because until `20260907.180000` this
# reading was an equality wearing a floor's name: the witness asserted the literal `sourcing=13`,
# so a lane that ADOPTED the plant law reddened every ship until a hand edited the number. It was
# edited seven times in one day. The three legs below ask the three questions that distinguishes a
# floor from an equality, and the third is the load-bearing one.
#
# THE PEN IS A REAL REPOSITORY because the scan reads `git ls-files` -- the index, never the
# working tree -- so a pen of loose files would read zero controls and every leg would pass for the
# wrong reason. It carries `rishi/bin` and `tools/fixtures` so the scan's upward walk stops here
# rather than climbing back into the field.
#
# THE FLOOR IS MOVED WITH `plant_apply`, which is this control's own subject: the helper that
# refuses to build an unmutated pen is exactly what a leg planting a constant into a copied scan
# needs, and using it here means a stale plant reads `nothing` rather than passing quietly.
echo "== 6. the adoption floor welcomes a rise and refuses a fall =="
FLOORPEN="$PEN/floorpen"
mkdir -p "$FLOORPEN/rishi/bin" "$FLOORPEN/tools/fixtures/p"
cp "$HELPER" "$FLOORPEN/tools/fixtures/p/plant.sh"
cp "$_fd_root/tools/fixtures/p/plant_adoption_scan.sh" "$FLOORPEN/tools/fixtures/p/plant_adoption_scan.sh"
# Two adopters and one abstainer, so the pen's own count is 2 and a floor may be set either side.
for n in one two; do
  printf '#!/bin/sh\n. "$root/tools/fixtures/p/plant.sh"\n' > "$FLOORPEN/tools/fixtures/p/${n}_control.sh"
done
printf '#!/bin/sh\n# names tools/fixtures/p/plant.sh and does not import it\n' > "$FLOORPEN/tools/fixtures/p/three_control.sh"
(
  cd "$FLOORPEN"
  git init -q . 2>/dev/null
  git add -A >/dev/null 2>&1
) || true

floor_read() {
  ( cd "$FLOORPEN" && sh tools/fixtures/p/plant_adoption_scan.sh 2>/dev/null | sed -n "s/^$1=//p" )
}
floor_verdict() {
  ( cd "$FLOORPEN" && sh tools/fixtures/p/plant_adoption_scan.sh >/dev/null 2>&1 && echo ok || echo refused )
}

note "floor_pen_counts_its_own_adopters" "$(floor_read sourcing)" "2"

plant_apply "$FLOORPEN/tools/fixtures/p/plant_adoption_scan.sh" 's/^FLOOR=13$/FLOOR=1/' floorbelow >/dev/null 2>&1   && floor_planted=landed || floor_planted=nothing
note "floor_below_the_count_plants" "$floor_planted" "landed"
note "floor_below_the_count_welcomes_a_rise" "$(floor_verdict)" "ok"
note "floor_below_the_count_says_so" "$(floor_read adoption_floor_held)" "yes"

plant_apply "$FLOORPEN/tools/fixtures/p/plant_adoption_scan.sh" 's/^FLOOR=1$/FLOOR=3/' floorabove >/dev/null 2>&1   && floor_planted=landed || floor_planted=nothing
note "floor_above_the_count_plants" "$floor_planted" "landed"
note "floor_above_the_count_refuses" "$(floor_verdict)" "refused"
note "floor_above_the_count_names_the_fall" "$(floor_read adoption_floor_held)" "no"

# THE LOAD-BEARING LEG. A floor that has merely started saying `yes` passes every welcome leg
# above. Strip the refusal out of a copy and the same below-floor pen walks free, which is what
# tells a working floor from one that has stopped reading.
sed '/^if \[ "\$floor_held" = no \]; then$/,/^fi$/d' \
  "$FLOORPEN/tools/fixtures/p/plant_adoption_scan.sh" > "$FLOORPEN/tools/fixtures/p/stripped.sh"
note "stripped_floor_is_a_different_file" \
  "$(cmp -s "$FLOORPEN/tools/fixtures/p/plant_adoption_scan.sh" "$FLOORPEN/tools/fixtures/p/stripped.sh" && echo same || echo differs)" "differs"
cp "$FLOORPEN/tools/fixtures/p/stripped.sh" "$FLOORPEN/tools/fixtures/p/plant_adoption_scan.sh"
note "stripped_floor_welcomes_the_fall" "$(floor_verdict)" "ok"

echo
echo "behaviors=$behaviors"
echo "faults=$faults"
if [ "$faults" -eq 0 ]; then
  echo "control_verdict=ok"
  exit 0
fi
echo "control_verdict=faults"
exit 1
