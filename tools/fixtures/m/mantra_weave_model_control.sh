#!/bin/sh
# tools/fixtures/m/mantra_weave_model_control.sh -- the model-agreement scan, broken on purpose.
#
# WHAT THIS DOES. tools/fixtures/m/mantra_weave_model_scan.sh claims that every tracked copy of
# Mantra's weave model declares the same fields, in the same order, as the published module.
# This control builds real git repositories in a throwaway pen, plants ONE break in each, and
# watches the scan answer. Every refusal is shown from both sides -- planted, then lifted -- and
# every welcome is asserted as hard as every refusal, since a refusal proven only in the passing
# direction cannot be told from a bypass.
#
# THE PEN IS A GIT REPOSITORY, because discovery reads `git ls-files`. A pen of loose files
# would exercise a code path the real scan never takes.
#
# THIRTEEN BEHAVIORS.
#   clean            -- module plus two agreeing copies: verdict=ok, exit 0. This leg is what
#                       lets every break below read as the break speaking rather than the pen.
#   fourth_field     -- a copy's Line gains a fourth field. This is the exact hazard the scan
#                       was written for: widening the module and forgetting a copy.
#   ceiling_welcomes -- the SAME repository and the same single break, read at a ceiling of one
#                       instead of zero: verdict=ok, exit 0. Only the ceiling moves between the
#                       two legs, so the difference in the answer is the ceiling speaking.
#   reorder          -- a copy's Line fields are reordered, nothing added or removed. REDS %500
#                       is here: a presence check cannot see this and a field READER can.
#   renamed          -- a copy renames one field.
#   diff_widened     -- a copy's Diff gains a field, proving Diff is read rather than assumed.
#   weave_widened    -- a copy's Weave gains a field, proving all three of the triple are read.
#   one_line         -- a copy declares Line on a single line, which the field reader refuses:
#                       counted `unreadable` and gated, because a copy nobody can check is the
#                       door this scan exists to find.
#   not_the_triple   -- a file declares Weave with no Line and no Diff. It is another subject,
#                       so it is `skipped` and the verdict stays ok -- the discovery bound
#                       proven from the PASSING side, where a bound is easiest to get wrong.
#   module_only      -- no copies at all: verdict=ok with copies=0. Deleting a copy is the CURE
#                       for a duplicated model, so the scan must welcome a tree that applied it.
#   no_module        -- the module itself is gone: verdict=no_module rather than a cheerful
#                       zero over an empty set.
#   untracked_copy   -- a disagreeing copy that is not in the index is not judged, because
#                       `git ls-files` reads what a commit ships.
#   lifted           -- the fourth field removed again returns the same repository to ok, which
#                       is the pen proving its own innocence.
#
# EXPECTED: control_verdict=ok. Run from the repository root.

set -eu

root="$(pwd)"
scan="$root/tools/fixtures/m/mantra_weave_model_scan.sh"
fields="$root/tools/fixtures/r/rye_struct_fields_scan.sh"
pen="$(mktemp -d)"
trap 'rm -rf "$pen"' EXIT
trap 'rm -rf "$pen"; exit 130' INT
trap 'rm -rf "$pen"; exit 143' TERM

failures=0
behaviors=0

check() {
  # $1 label, $2 expected, $3 got
  behaviors=$((behaviors + 1))
  if [ "$2" = "$3" ]; then
    printf 'ok    %s -- %s\n' "$1" "$3"
  else
    printf 'BROKE %s -- wanted %s, got %s\n' "$1" "$2" "$3"
    failures=$((failures + 1))
  fi
}

write_model() {
  # $1 path, $2 Line body, $3 Diff body, $4 Weave body
  mkdir -p "$(dirname "$1")"
  {
    printf 'const std = @import("std");\n\n'
    printf '%s\n' "$2"
    printf '%s\n' "$3"
    printf '%s\n' "$4"
  } > "$1"
}

line_three='pub const Line = struct {
    text: []const u8,
    gen: u32,
    pos: u32,
};'
line_four='pub const Line = struct {
    text: []const u8,
    gen: u32,
    pos: u32,
    site: u32,
};'
line_reordered='pub const Line = struct {
    text: []const u8,
    pos: u32,
    gen: u32,
};'
line_renamed='pub const Line = struct {
    text: []const u8,
    gen: u32,
    place: u32,
};'
line_one='pub const Line = struct { text: []const u8, gen: u32, pos: u32 };'
diff_two='pub const Diff = struct {
    inserts: []const []const u8,
    deletes: []const u32,
};'
diff_three='pub const Diff = struct {
    inserts: []const []const u8,
    deletes: []const u32,
    anchors: []const u32,
};'
weave_two='pub const Weave = struct {
    lines: u32,
    next_pos: u32,
};'
weave_three='pub const Weave = struct {
    lines: u32,
    next_pos: u32,
    site: u32,
};'

# Build a fresh repository holding the module and one copy shaped by the arguments, run the
# scan inside it, and echo `verdict|disagreements|unreadable|copies|skipped|exit`.
run_pen() {
  name="$1"; copy_line="$2"; copy_diff="$3"; copy_weave="$4"; stage="${5:-track}"; ceiling="${6:-0}"
  work="$pen/$name"
  rm -rf "$work"
  mkdir -p "$work"
  (
    cd "$work"
    git init -q .
    git config user.email pen@example.invalid
    git config user.name pen
    write_model "mantra/src/weave.rye" "$line_three" "$diff_two" "$weave_two"
    write_model "second/copy.rye" "$copy_line" "$copy_diff" "$copy_weave"
    if [ "$stage" = track ]; then
      git add -A
    else
      git add mantra/src/weave.rye
    fi
  ) >/dev/null 2>&1
  code=0
  out=$( cd "$work" && env FIELDS_SCAN="$fields" MODULE_PATH="mantra/src/weave.rye" \
    DISAGREE_CEILING="$ceiling" sh "$scan" 2>&1 ) || code=$?
  v=$(printf '%s\n' "$out" | sed -n 's/^verdict=//p')
  d=$(printf '%s\n' "$out" | sed -n 's/^disagreements=//p')
  u=$(printf '%s\n' "$out" | sed -n 's/^unreadable=//p')
  c=$(printf '%s\n' "$out" | sed -n 's/^copies=//p')
  s=$(printf '%s\n' "$out" | sed -n 's/^skipped_not_the_triple=//p')
  h=$(printf '%s\n' "$out" | sed -n 's/^disagreement_ceiling_held=//p')
  echo "${v:-none}|${d:-none}|${u:-none}|${c:-none}|${s:-none}|$code|${h:-none}"
}

field() { printf '%s\n' "$1" | cut -d'|' -f"$2"; }

echo "phase=clean"
r=$(run_pen clean "$line_three" "$diff_two" "$weave_two")
check "clean/verdict"       ok "$(field "$r" 1)"
check "clean/disagreements" 0  "$(field "$r" 2)"
check "clean/unreadable"    0  "$(field "$r" 3)"
check "clean/copies"        1  "$(field "$r" 4)"
check "clean/ceiling_held"  yes "$(field "$r" 7)"
check "clean/exit"          0  "$(field "$r" 6)"

echo "phase=fourth_field"
r=$(run_pen fourth "$line_four" "$diff_two" "$weave_two")
check "fourth/verdict"       disagree "$(field "$r" 1)"
check "fourth/disagreements" 1        "$(field "$r" 2)"
check "fourth/ceiling_held"  no       "$(field "$r" 7)"
check "fourth/exit"          1        "$(field "$r" 6)"

# THE CEILING, PROVEN FROM BOTH SIDES ON ONE BREAK. The same repository, the same single
# disagreeing copy, read once at a ceiling of zero (above) and once at a ceiling of one (here).
# Only the ceiling moves, so a difference in the answer can be nothing but the ceiling speaking.
# This is the leg the live tree stands on: `tools/m/mantra_weave_model_witness.rish` passes 2
# for two copies that lag the module by a field the module gained at `bc37657e8`, and a ceiling
# proven only in the refusing direction cannot be told from a gate that never welcomes.
echo "phase=ceiling_welcomes"
r=$(run_pen ceilingone "$line_four" "$diff_two" "$weave_two" track 1)
check "ceiling_welcomes/verdict"       ok "$(field "$r" 1)"
check "ceiling_welcomes/disagreements" 1  "$(field "$r" 2)"
check "ceiling_welcomes/ceiling_held"  yes "$(field "$r" 7)"
check "ceiling_welcomes/exit"          0  "$(field "$r" 6)"

echo "phase=reorder"
r=$(run_pen reorder "$line_reordered" "$diff_two" "$weave_two")
check "reorder/verdict"       disagree "$(field "$r" 1)"
check "reorder/disagreements" 1        "$(field "$r" 2)"

echo "phase=renamed"
r=$(run_pen renamed "$line_renamed" "$diff_two" "$weave_two")
check "renamed/verdict"       disagree "$(field "$r" 1)"
check "renamed/disagreements" 1        "$(field "$r" 2)"

echo "phase=diff_widened"
r=$(run_pen diffwide "$line_three" "$diff_three" "$weave_two")
check "diff_widened/verdict"       disagree "$(field "$r" 1)"
check "diff_widened/disagreements" 1        "$(field "$r" 2)"

echo "phase=weave_widened"
r=$(run_pen weavewide "$line_three" "$diff_two" "$weave_three")
check "weave_widened/verdict"       disagree "$(field "$r" 1)"
check "weave_widened/disagreements" 1        "$(field "$r" 2)"

echo "phase=one_line"
r=$(run_pen oneline "$line_one" "$diff_two" "$weave_two")
check "one_line/verdict"    unreadable "$(field "$r" 1)"
check "one_line/unreadable" 1          "$(field "$r" 3)"
check "one_line/exit"       1          "$(field "$r" 6)"

echo "phase=not_the_triple"
work="$pen/triple"
mkdir -p "$work"
(
  cd "$work"
  git init -q .
  git config user.email pen@example.invalid
  git config user.name pen
  write_model "mantra/src/weave.rye" "$line_three" "$diff_two" "$weave_two"
  mkdir -p other
  printf 'const std = @import("std");\n\npub const Weave = struct {\n    warp: u32,\n    weft: u32,\n};\n' > other/loom.rye
  git add -A
) >/dev/null 2>&1
code=0
out=$( cd "$work" && env FIELDS_SCAN="$fields" MODULE_PATH="mantra/src/weave.rye" sh "$scan" 2>&1 ) || code=$?
check "not_the_triple/verdict" ok "$(printf '%s\n' "$out" | sed -n 's/^verdict=//p')"
check "not_the_triple/skipped" 1  "$(printf '%s\n' "$out" | sed -n 's/^skipped_not_the_triple=//p')"
check "not_the_triple/copies"  0  "$(printf '%s\n' "$out" | sed -n 's/^copies=//p')"
check "not_the_triple/exit"    0  "$code"

echo "phase=module_only"
work="$pen/only"
mkdir -p "$work"
(
  cd "$work"
  git init -q .
  git config user.email pen@example.invalid
  git config user.name pen
  write_model "mantra/src/weave.rye" "$line_three" "$diff_two" "$weave_two"
  git add -A
) >/dev/null 2>&1
code=0
out=$( cd "$work" && env FIELDS_SCAN="$fields" MODULE_PATH="mantra/src/weave.rye" sh "$scan" 2>&1 ) || code=$?
check "module_only/verdict" ok "$(printf '%s\n' "$out" | sed -n 's/^verdict=//p')"
check "module_only/copies"  0  "$(printf '%s\n' "$out" | sed -n 's/^copies=//p')"
check "module_only/exit"    0  "$code"

echo "phase=no_module"
work="$pen/nomodule"
mkdir -p "$work"
(
  cd "$work"
  git init -q .
  git config user.email pen@example.invalid
  git config user.name pen
  write_model "second/copy.rye" "$line_three" "$diff_two" "$weave_two"
  git add -A
) >/dev/null 2>&1
code=0
out=$( cd "$work" && env FIELDS_SCAN="$fields" MODULE_PATH="mantra/src/weave.rye" sh "$scan" 2>&1 ) || code=$?
check "no_module/verdict" no_module "$(printf '%s\n' "$out" | sed -n 's/^verdict=//p')"
check "no_module/exit"    1         "$code"

echo "phase=untracked_copy"
r=$(run_pen untracked "$line_four" "$diff_two" "$weave_two" stage_module_only)
check "untracked_copy/verdict" ok "$(field "$r" 1)"
check "untracked_copy/copies"  0  "$(field "$r" 4)"
check "untracked_copy/exit"    0  "$(field "$r" 6)"

echo "phase=lifted"
work="$pen/fourth"
( cd "$work" && write_model "second/copy.rye" "$line_three" "$diff_two" "$weave_two" && git add -A ) >/dev/null 2>&1
code=0
out=$( cd "$work" && env FIELDS_SCAN="$fields" MODULE_PATH="mantra/src/weave.rye" sh "$scan" 2>&1 ) || code=$?
check "lifted/verdict" ok "$(printf '%s\n' "$out" | sed -n 's/^verdict=//p')"
check "lifted/exit"    0  "$code"

echo "behaviors=$behaviors"
echo "phases=13"
echo "failures=$failures"
if [ "$failures" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=broken"
fi
[ "$failures" -eq 0 ]
