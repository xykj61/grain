#!/bin/sh
# tools/fixtures/m/mantra_diff_control.sh -- the diff, broken on purpose.
#
# WHAT THIS DOES. mantra/src/diff_witness.rye asserts that the diff compiles, keeps the
# common subsequence, round-trips an append, and appends a middle insert. This control
# copies the module and its witness into a throwaway pen, changes ONE thing in the copy,
# and watches the witness answer with a non-zero exit. Each break is shown from both
# sides, so a real refusal stays tellable from a bypass.
#
# THE PEN IS A DIRECTORY. Zig resolves an import inside the root file's own directory, so
# weave.rye, diff.rye and the witness sit side by side here. Everything reads from the
# filesystem alone, which makes a plain directory the honest pen.
#
# SEVEN PHASES.
#   clean          -- the unmutated copy reaches GREEN, exit 0. This leg is what lets every
#                     other phase read as the break speaking rather than the pen.
#   elder_arraylist -- `var deletes: ... = .empty` returns to the Zig 0.15 form
#                     `std.ArrayListUnmanaged(u32){}`. This is the exact fault this witness
#                     was written for: the module carried it at HEAD, five guards read the
#                     file with grep, and every one stayed green.
#   walker_teeth   -- a public function carrying a type error is appended to the module,
#                     and nothing in the witness calls it. The comptime declaration walker
#                     reaches it, so the build reds.
#   walker_removed -- the SAME planted function, with the walker deleted from the witness
#                     copy. This phase must exit 0. Zig analyses lazily, so an uncalled
#                     declaration is never looked at, and the witness sails past a module
#                     that does not compile. That pass is the whole argument for the walker:
#                     it shows what the toothless form waves through.
#   lcs_equality   -- the line-text comparison inside the LCS table becomes `false`, so no
#                     line is ever common. Identical documents then diff as a whole
#                     replacement, and claim 1 catches it.
#   inverted_inserts -- the insert-collection test is inverted, so the lines held in common
#                     are carried as inserts and the genuinely new ones are dropped. Claim 1
#                     catches it at its first assert: an unchanged document stops being free.
#   trailing_token -- the break that drops the empty token after a file's last newline is
#                     deleted, so "one\ntwo\n" reads as three lines. Claim 7 catches it.
#
# WHY walker_removed IS THE SHARPEST PHASE. Every other phase proves the witness bites.
# This one proves the witness would NOT bite without its walker -- the plant the grain's own
# strand asks for, where the toothed form catches what the vacuous form waves through
# (foundations/20260826-024942_the-grain-and-the-crossing.md, "a guard that cannot red
# guards nothing").
#
# EXPECTED: clean_exit=0, walker_removed_exit=0, and every other phase non-zero.
#
# Driven by tools/m/mantra_diff_witness.rish. Run from the repository root.

set -eu

root="$(pwd)"
zig="$root/vendor/zig-toolchain/zig"
rye="$root/rye/bin/rye"
module="$root/mantra/src/diff.rye"
weave="$root/mantra/src/weave.rye"
witness="$root/mantra/src/diff_witness.rye"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

# A public declaration carrying a type error, reachable only by analysis. Appended to the
# module copy for the two walker phases.
planted_decl='pub fn planted_never_called(value: u32) u32 { return value.no_such_field; }'

# Build a pen from the real sources, apply an optional sed program to the module copy and an
# optional one to the witness copy, then build and run. Echoes the exit code and nothing else.
run_pen() {
  name="$1"
  module_program="$2"
  witness_program="$3"
  append_decl="$4"
  pen="$work/$name"
  mkdir -p "$pen"
  cp "$weave" "$pen/weave.rye"
  cp "$module" "$pen/diff.rye"
  cp "$witness" "$pen/diff_witness.rye"
  if [ -n "$module_program" ]; then
    sed "$module_program" "$pen/diff.rye" > "$pen/diff.tmp"
    cat "$pen/diff.tmp" > "$pen/diff.rye"
    rm -f "$pen/diff.tmp"
  fi
  if [ -n "$append_decl" ]; then
    printf '\n%s\n' "$planted_decl" >> "$pen/diff.rye"
  fi
  if [ -n "$witness_program" ]; then
    sed "$witness_program" "$pen/diff_witness.rye" > "$pen/witness.tmp"
    cat "$pen/witness.tmp" > "$pen/diff_witness.rye"
    rm -f "$pen/witness.tmp"
  fi
  code=0
  ( cd "$pen" && env RYE_ZIG="$zig" "$rye" build diff_witness.rye \
      -femit-bin="$pen/run" >/dev/null 2>&1 ) || code=$?
  if [ "$code" -eq 0 ]; then
    "$pen/run" >/dev/null 2>&1 || code=$?
  fi
  echo "$code"
}

# The walker is four lines; deleting it is what walker_removed measures.
drop_walker='/^comptime {$/,/^}$/d'

clean_exit="$(run_pen clean '' '' '')"
elder_exit="$(run_pen elder_arraylist \
  's/    var deletes: std.ArrayListUnmanaged(u32) = .empty;/    var deletes = std.ArrayListUnmanaged(u32){};/' '' '')"
walker_teeth_exit="$(run_pen walker_teeth '' '' 'yes')"
walker_removed_exit="$(run_pen walker_removed '' "$drop_walker" 'yes')"
lcs_exit="$(run_pen lcs_equality \
  's/            if (std.mem.eql(u8, old_lines\[i - 1\].text, new_text\[j - 1\])) {/            if (false) {/' '' '')"
inverted_inserts_exit="$(run_pen inverted_inserts \
  's/        if (!kept_new\[idx\]) {/        if (kept_new[idx]) {/' '' '')"
trailing_exit="$(run_pen trailing_token \
  '/        if (line.len == 0 and it.rest().len == 0) break;/d' '' '')"

echo "phase=clean"
echo "clean_exit=$clean_exit"
echo "phase=elder_arraylist"
echo "elder_arraylist_exit=$elder_exit"
echo "phase=walker_teeth"
echo "walker_teeth_exit=$walker_teeth_exit"
echo "phase=walker_removed"
echo "walker_removed_exit=$walker_removed_exit"
echo "phase=lcs_equality"
echo "lcs_equality_exit=$lcs_exit"
echo "phase=inverted_inserts"
echo "inverted_inserts_exit=$inverted_inserts_exit"
echo "phase=trailing_token"
echo "trailing_token_exit=$trailing_exit"

verdict=ok
[ "$clean_exit" -eq 0 ] || verdict=clean_failed
[ "$walker_removed_exit" -eq 0 ] || verdict=walker_removed_not_innocent
for broken in "$elder_exit" "$walker_teeth_exit" "$lcs_exit" "$inverted_inserts_exit" "$trailing_exit"; do
  [ "$broken" -ne 0 ] || verdict=break_not_caught
done
echo "control_verdict=$verdict"
[ "$verdict" = ok ]
