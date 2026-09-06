#!/bin/sh
# tools/fixtures/r/rye_witness_walker_control.sh -- does the walker census actually bite?
#
#   sh tools/fixtures/r/rye_witness_walker_control.sh
#
# A guard nobody has watched fail is a guard nobody has tested. This builds real git repositories
# in a throwaway pen and drives `rye_witness_walker_scan.sh` through every reading it publishes and
# every refusal it names -- each refusal planted AND then lifted, because a refusal proven only in
# the failing direction cannot be told from a scan that refuses everything.
#
# THE PHASES, and what each one is actually asking.
#
#   clean               a witness walking its subject: walked=1, unwalked=0, exit 0.
#   no_walker           the SAME pen with the comptime block deleted: walked falls to 0 and
#                       unwalked rises to 1. This is the census's whole subject, shown both ways.
#   ceiling             the ratchet from both sides, by planting rather than by an override the
#                       scan does not offer: ceiling+1 unwalked pairs refuse, one removed passes.
#   comment_walker      the walker present but commented out. It must NOT be credited. A teaching
#                       header showing the shape is the likeliest place it appears, and crediting
#                       one would hand a green to the file least entitled to it.
#   loop_no_field       a `@typeInfo(m).decls` loop whose body reads no field -- a walker in shape
#                       only, forcing nothing. Not credited.
#   field_no_loop       a bare `@field(m, "x")` with no decls loop: one declaration, not every one.
#                       Not credited.
#   stem_subject        `X_witness.rye` importing `X.rye` and a second module: exactly ONE subject,
#                       so the dependency is not accused of breaking a promise it never made.
#   single_fallback     a witness whose stem names nothing, importing exactly one sibling. That one
#                       is unambiguously its subject -- `weave_merge_witness.rye`'s own shape, and
#                       the case the first draft of the stem rule read as no subject at all.
#   ambiguous_pair      a witness whose stem names nothing, importing two siblings: counted as
#                       `ambiguous`, listed, and gated on by neither side.
#   symlink_one_pair    the subject reached through a symlink. A second name for one file is not a
#                       second claim, so the pair count stays 1.
#   dangling_import     an import naming a file this tree does not track: no pair at all.
#   unreached_unknown   the compile-reach resolver absent, so the walker's own condition cannot be
#                       checked. `unreached` must read -1, and the run must still complete: an
#                       unknown published as unknown rather than as zero.
#   empty_corpus        a repository with no tracked `.rye`: exit 2, `verdict=empty_corpus`. A
#                       census that reads nothing must never answer *nothing is wrong*.
#   no_witnesses        tracked Rye and not one `*_witness.rye`: exit 2, `verdict=no_witnesses`.
#   no_checkout         a directory that is not a git repository: exit 2, `verdict=no_checkout`.
#   bad_argument        an unknown flag: exit 2, `verdict=bad_argument`.
#   bad_set             `--list` naming a set that does not exist: exit 2, `verdict=bad_set`.
#
# WHAT THIS CONTROL DOES NOT PROVE, said plainly rather than left for a reader to notice. Two
# refusals go unexercised here. `corpus_over_bound` needs 4,097 tracked Rye files, and a pen built
# to trip a bound is slower than the guard it proves. `walker_unreached` -- a walker in a witness no
# build compiles -- needs the compile-reach census answering inside the pen, and that scan refuses
# unless the harness roster scan answers too, so proving it means standing up two more instruments
# whose own controls already prove them. The `unreached_unknown` phase covers the seam this scan
# actually owns: what it does when the answer is unavailable. The gate above it stays argued rather
# than run, and this sentence is where that is admitted.

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

scan="$_fd_root/tools/fixtures/r/rye_witness_walker_scan.sh"
[ -f "$scan" ] || { echo "detail: the scan under test is missing"; echo "control_verdict=no_scan"; exit 2; }

pen=$(mktemp -d) || { echo "detail: mktemp refused a pen"; echo "control_verdict=no_pen"; exit 2; }
# The handler EXITS. A trap that cleans up and returns lets POSIX resume the script where the signal
# landed, so every phase below would then run against a pen that is gone -- REDS %487.
trap 'rm -rf "$pen"; exit 130' INT
trap 'rm -rf "$pen"; exit 143' TERM
trap 'rm -rf "$pen"' EXIT

# A pen is a real git repository, because the scan reads `git ls-files` and `git cat-file` rather
# than the filesystem. A pen built from directories alone would prove nothing about the scan's
# actual corpus.
new_pen() {
  d="$pen/$1"
  rm -rf "$d"; mkdir -p "$d/rishi/bin" "$d/tools/fixtures/s"
  cp "$scan" "$d/tools/fixtures/r_scan.sh" 2>/dev/null || mkdir -p "$d/tools/fixtures/r"
  mkdir -p "$d/tools/fixtures/r"
  cp "$scan" "$d/tools/fixtures/r/rye_witness_walker_scan.sh"
  rm -f "$d/tools/fixtures/r_scan.sh"
  # The scan sources this; a pen carrying an empty one keeps the pen honest about what it exercises.
  if [ -f "$_fd_root/tools/fixtures/s/shell_portable.sh" ]; then
    cp "$_fd_root/tools/fixtures/s/shell_portable.sh" "$d/tools/fixtures/s/shell_portable.sh"
  else
    : > "$d/tools/fixtures/s/shell_portable.sh"
  fi
  : > "$d/rishi/bin/.keep"
  ( cd "$d" && git init -q . \
      && git config user.email pen@example.invalid \
      && git config user.name pen \
      && git config commit.gpgsign false ) || return 1
  echo "$d"
}

seal_pen() { ( cd "$1" && git add -A >/dev/null 2>&1 && git commit -qm pen >/dev/null 2>&1 ); }

# Run the scan inside a pen and echo "exit<TAB>output".
run_pen() {
  d=$1; shift
  out=$( cd "$d" && sh tools/fixtures/r/rye_witness_walker_scan.sh "$@" 2>&1 )
  printf '%s\n' "$?"
  printf '%s\n' "$out"
}
read_field() { printf '%s\n' "$2" | sed -n "s/^$1=//p" | tail -1; }

module_body='pub const max_thing: u32 = 8;

pub fn thing(n: u32) u32 {
    return n + 1;
}
'

witness_head='const std = @import("std");
const m = @import("thing.rye");
'
walker_block='
comptime {
    for (@typeInfo(m).@"struct".decls) |decl| {
        _ = &@field(m, decl.name);
    }
}
'
witness_tail='
pub fn main() void {
    _ = m.thing(1);
}
'

failures=0
note() { echo "$1"; }
expect() { # name expected actual
  if [ "$2" = "$3" ]; then echo "$1=$3"; else echo "$1=$3 EXPECTED=$2"; failures=$((failures + 1)); fi
}

# ---- clean: a witness that walks its subject --------------------------------------------------
d=$(new_pen clean) || { echo "control_verdict=pen_failed"; exit 2; }
mkdir -p "$d/mod"
printf '%s' "$module_body" > "$d/mod/thing.rye"
printf '%s%s%s' "$witness_head" "$walker_block" "$witness_tail" > "$d/mod/thing_witness.rye"
seal_pen "$d"
r=$(run_pen "$d"); clean_exit=$(printf '%s\n' "$r" | head -1); clean_out=$(printf '%s\n' "$r" | tail -n +2)
expect clean_exit 0 "$clean_exit"
expect clean_walked 1 "$(read_field walked "$clean_out")"
expect clean_unwalked 0 "$(read_field unwalked "$clean_out")"
expect clean_subjects 1 "$(read_field subjects "$clean_out")"
expect clean_verdict ok "$(read_field verdict "$clean_out")"

# ---- no_walker: the same pen with the comptime block gone --------------------------------------
d=$(new_pen no_walker) || { echo "control_verdict=pen_failed"; exit 2; }
mkdir -p "$d/mod"
printf '%s' "$module_body" > "$d/mod/thing.rye"
printf '%s%s' "$witness_head" "$witness_tail" > "$d/mod/thing_witness.rye"
seal_pen "$d"
r=$(run_pen "$d"); nw_out=$(printf '%s\n' "$r" | tail -n +2)
expect no_walker_walked 0 "$(read_field walked "$nw_out")"
expect no_walker_unwalked 1 "$(read_field unwalked "$nw_out")"

# ---- the ceiling, proven from both sides by planting rather than overriding ---------------------
# The scan carries the tree's own ceiling and offers no flag to move it, which is the point: a
# ceiling with a door beside it is a habit again. So the pen plants ceiling+1 unwalked pairs and
# watches it refuse, then removes exactly one and watches it pass. Nothing about the scan changes
# between the two runs -- only the tree it reads.
ceiling=$( ( cd "$d" && sed -n 's/^ceiling=//p' tools/fixtures/r/rye_witness_walker_scan.sh | head -1 ) )
case "$ceiling" in
  ''|*[!0-9]*) echo "ceiling_read=$ceiling EXPECTED=a number"; failures=$((failures + 1)); ceiling=0 ;;
  *) echo "ceiling_read=$ceiling" ;;
esac

d=$(new_pen ceiling) || { echo "control_verdict=pen_failed"; exit 2; }
mkdir -p "$d/mod"
i=0
while [ "$i" -le "$ceiling" ]; do
  printf '%s' "$module_body" > "$d/mod/t$i.rye"
  printf 'const std = @import("std");\nconst m = @import("t%s.rye");\n%s' "$i" "$witness_tail" \
    > "$d/mod/t${i}_witness.rye"
  i=$((i + 1))
done
seal_pen "$d"
r=$(run_pen "$d"); over_exit=$(printf '%s\n' "$r" | head -1); over_out=$(printf '%s\n' "$r" | tail -n +2)
expect ceiling_over_unwalked $((ceiling + 1)) "$(read_field unwalked "$over_out")"
expect ceiling_over_exit 1 "$over_exit"
expect ceiling_over_verdict unwalked_over_ceiling "$(read_field verdict "$over_out")"

# One pair removed, and the same scan on the same pen walks free.
rm -f "$d/mod/t0_witness.rye" "$d/mod/t0.rye"
seal_pen "$d"
r=$(run_pen "$d"); at_exit=$(printf '%s\n' "$r" | head -1); at_out=$(printf '%s\n' "$r" | tail -n +2)
expect ceiling_at_unwalked "$ceiling" "$(read_field unwalked "$at_out")"
expect ceiling_at_exit 0 "$at_exit"
expect ceiling_at_verdict ok "$(read_field verdict "$at_out")"

# ---- comment_walker: the shape present, inside a comment ---------------------------------------
d=$(new_pen comment_walker) || { echo "control_verdict=pen_failed"; exit 2; }
mkdir -p "$d/mod"
printf '%s' "$module_body" > "$d/mod/thing.rye"
{
  printf '%s' "$witness_head"
  printf '%s' "$walker_block" | sed 's|^|// |'
  printf '%s' "$witness_tail"
} > "$d/mod/thing_witness.rye"
seal_pen "$d"
r=$(run_pen "$d"); cw_out=$(printf '%s\n' "$r" | tail -n +2)
expect comment_walker_walked 0 "$(read_field walked "$cw_out")"
expect comment_walker_unwalked 1 "$(read_field unwalked "$cw_out")"

# ---- loop_no_field: a decls loop whose body forces nothing -------------------------------------
d=$(new_pen loop_no_field) || { echo "control_verdict=pen_failed"; exit 2; }
mkdir -p "$d/mod"
printf '%s' "$module_body" > "$d/mod/thing.rye"
printf '%s\ncomptime {\n    for (@typeInfo(m).@"struct".decls) |decl| {\n        _ = decl.name;\n    }\n}\n%s' \
  "$witness_head" "$witness_tail" > "$d/mod/thing_witness.rye"
seal_pen "$d"
r=$(run_pen "$d"); lnf_out=$(printf '%s\n' "$r" | tail -n +2)
expect loop_no_field_walked 0 "$(read_field walked "$lnf_out")"
expect loop_no_field_unwalked 1 "$(read_field unwalked "$lnf_out")"

# ---- field_no_loop: one declaration read, not every one ----------------------------------------
d=$(new_pen field_no_loop) || { echo "control_verdict=pen_failed"; exit 2; }
mkdir -p "$d/mod"
printf '%s' "$module_body" > "$d/mod/thing.rye"
printf '%s\ncomptime {\n    _ = &@field(m, "thing");\n}\n%s' \
  "$witness_head" "$witness_tail" > "$d/mod/thing_witness.rye"
seal_pen "$d"
r=$(run_pen "$d"); fnl_out=$(printf '%s\n' "$r" | tail -n +2)
expect field_no_loop_walked 0 "$(read_field walked "$fnl_out")"
expect field_no_loop_unwalked 1 "$(read_field unwalked "$fnl_out")"

# ---- stem_subject: the dependency is not a second claim ----------------------------------------
d=$(new_pen stem_subject) || { echo "control_verdict=pen_failed"; exit 2; }
mkdir -p "$d/mod"
printf '%s' "$module_body" > "$d/mod/thing.rye"
printf '%s' "$module_body" > "$d/mod/helper.rye"
printf 'const std = @import("std");\nconst m = @import("thing.rye");\nconst h = @import("helper.rye");\n%s%s' \
  "$walker_block" "$witness_tail" > "$d/mod/thing_witness.rye"
seal_pen "$d"
r=$(run_pen "$d"); ss_out=$(printf '%s\n' "$r" | tail -n +2)
expect stem_subject_pairs 2 "$(read_field pairs "$ss_out")"
expect stem_subject_subjects 1 "$(read_field subjects "$ss_out")"
expect stem_subject_walked 1 "$(read_field walked "$ss_out")"
expect stem_subject_ambiguous 0 "$(read_field ambiguous "$ss_out")"

# ---- single_fallback: a stem naming nothing, one sibling import --------------------------------
d=$(new_pen single_fallback) || { echo "control_verdict=pen_failed"; exit 2; }
mkdir -p "$d/mod"
printf '%s' "$module_body" > "$d/mod/thing.rye"
printf '%s%s%s' "$witness_head" "$walker_block" "$witness_tail" > "$d/mod/thing_merge_witness.rye"
seal_pen "$d"
r=$(run_pen "$d"); sf_out=$(printf '%s\n' "$r" | tail -n +2)
expect single_fallback_subjects 1 "$(read_field subjects "$sf_out")"
expect single_fallback_walked 1 "$(read_field walked "$sf_out")"
expect single_fallback_ambiguous 0 "$(read_field ambiguous "$sf_out")"

# ---- ambiguous_pair: a stem naming nothing, two siblings ---------------------------------------
d=$(new_pen ambiguous_pair) || { echo "control_verdict=pen_failed"; exit 2; }
mkdir -p "$d/mod"
printf '%s' "$module_body" > "$d/mod/thing.rye"
printf '%s' "$module_body" > "$d/mod/helper.rye"
printf 'const std = @import("std");\nconst m = @import("thing.rye");\nconst h = @import("helper.rye");\n%s' \
  "$witness_tail" > "$d/mod/thing_merge_witness.rye"
seal_pen "$d"
r=$(run_pen "$d"); ap_exit=$(printf '%s\n' "$r" | head -1); ap_out=$(printf '%s\n' "$r" | tail -n +2)
expect ambiguous_pair_ambiguous 1 "$(read_field ambiguous "$ap_out")"
expect ambiguous_pair_subjects 0 "$(read_field subjects "$ap_out")"
expect ambiguous_pair_exit 2 "$ap_exit"
expect ambiguous_pair_verdict no_subjects "$(read_field verdict "$ap_out")"

# ---- symlink_one_pair: a second name is not a second claim -------------------------------------
d=$(new_pen symlink_one_pair) || { echo "control_verdict=pen_failed"; exit 2; }
mkdir -p "$d/mod"
printf '%s' "$module_body" > "$d/mod/thing.rye"
( cd "$d/mod" && ln -s thing.rye alias.rye )
printf 'const std = @import("std");\nconst m = @import("alias.rye");\n%s%s' \
  "$walker_block" "$witness_tail" > "$d/mod/thing_witness.rye"
seal_pen "$d"
r=$(run_pen "$d"); sl_out=$(printf '%s\n' "$r" | tail -n +2)
expect symlink_symlinks 1 "$(read_field symlinks "$sl_out")"
expect symlink_pairs 1 "$(read_field pairs "$sl_out")"
expect symlink_walked 1 "$(read_field walked "$sl_out")"

# ---- dangling_import: an import naming nothing tracked -----------------------------------------
d=$(new_pen dangling_import) || { echo "control_verdict=pen_failed"; exit 2; }
mkdir -p "$d/mod"
printf '%s' "$module_body" > "$d/mod/thing.rye"
printf 'const std = @import("std");\nconst g = @import("ghost.rye");\n%s' \
  "$witness_tail" > "$d/mod/thing_witness.rye"
seal_pen "$d"
r=$(run_pen "$d"); di_exit=$(printf '%s\n' "$r" | head -1); di_out=$(printf '%s\n' "$r" | tail -n +2)
expect dangling_pairs 0 "$(read_field pairs "$di_out")"
expect dangling_exit 2 "$di_exit"
expect dangling_verdict no_pairs "$(read_field verdict "$di_out")"

# ---- unreached_unknown: the resolver absent, so the answer is unknown --------------------------
# The clean pen carries no `rye_compile_reach_scan.sh`, so the walker's own condition cannot be
# checked there. `unreached` must read -1 and the run must still complete.
expect unreached_unknown -1 "$(read_field unreached "$clean_out")"

# ---- empty_corpus: a census that reads nothing must refuse -------------------------------------
d=$(new_pen empty_corpus) || { echo "control_verdict=pen_failed"; exit 2; }
echo hello > "$d/README.md"
seal_pen "$d"
r=$(run_pen "$d"); ec_exit=$(printf '%s\n' "$r" | head -1); ec_out=$(printf '%s\n' "$r" | tail -n +2)
expect empty_corpus_exit 2 "$ec_exit"
expect empty_corpus_verdict empty_corpus "$(read_field verdict "$ec_out")"

# ---- no_witnesses: tracked Rye, no witness -----------------------------------------------------
d=$(new_pen no_witnesses) || { echo "control_verdict=pen_failed"; exit 2; }
mkdir -p "$d/mod"
printf '%s' "$module_body" > "$d/mod/thing.rye"
seal_pen "$d"
r=$(run_pen "$d"); nowit_exit=$(printf '%s\n' "$r" | head -1); nowit_out=$(printf '%s\n' "$r" | tail -n +2)
expect no_witnesses_exit 2 "$nowit_exit"
expect no_witnesses_verdict no_witnesses "$(read_field verdict "$nowit_out")"

# ---- no_checkout: a directory that is not a repository -----------------------------------------
d=$(new_pen no_checkout) || { echo "control_verdict=pen_failed"; exit 2; }
rm -rf "$d/.git"
mkdir -p "$d/mod"; printf '%s' "$module_body" > "$d/mod/thing.rye"
r=$(run_pen "$d"); nc_exit=$(printf '%s\n' "$r" | head -1); nc_out=$(printf '%s\n' "$r" | tail -n +2)
expect no_checkout_exit 2 "$nc_exit"
expect no_checkout_verdict no_checkout "$(read_field verdict "$nc_out")"

# ---- bad_argument and bad_set ------------------------------------------------------------------
d=$(new_pen args) || { echo "control_verdict=pen_failed"; exit 2; }
mkdir -p "$d/mod"
printf '%s' "$module_body" > "$d/mod/thing.rye"
printf '%s%s%s' "$witness_head" "$walker_block" "$witness_tail" > "$d/mod/thing_witness.rye"
seal_pen "$d"
r=$(run_pen "$d" --nonsense); ba_exit=$(printf '%s\n' "$r" | head -1); ba_out=$(printf '%s\n' "$r" | tail -n +2)
expect bad_argument_exit 2 "$ba_exit"
expect bad_argument_verdict bad_argument "$(read_field verdict "$ba_out")"
r=$(run_pen "$d" --list nowhere); bs_exit=$(printf '%s\n' "$r" | head -1); bs_out=$(printf '%s\n' "$r" | tail -n +2)
expect bad_set_exit 2 "$bs_exit"
expect bad_set_verdict bad_set "$(read_field verdict "$bs_out")"
r=$(run_pen "$d" --list walked); lw_out=$(printf '%s\n' "$r" | tail -n +2)
expect list_walked_row 1 "$(printf '%s\n' "$lw_out" | grep -c 'mod/thing_witness.rye')"

echo "behaviors=37"
if [ "$failures" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "detail: $failures readings differed from what the scan promises"
  echo "control_verdict=broken"
  exit 1
fi
