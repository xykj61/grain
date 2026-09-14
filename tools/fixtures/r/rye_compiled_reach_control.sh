#!/bin/sh
# tools/fixtures/r/rye_compiled_reach_control.sh -- prove the compiled-reach reading by doing, on
# real repositories.
#
# WHY. A guard that cannot red guards nothing. This control builds git repositories in a temporary
# pen, plants one condition in each, runs tools/fixtures/r/rye_compiled_reach_scan.sh inside them,
# and checks that the refusals bite AND that the honest readings stay free. A refusal proven only
# in the passing direction cannot be told from a bypass, so every gate below is shown from both
# sides, and every leg is written so that `yes` is the right answer. Nothing here touches the tree
# it is run from.
#
# THE CASE THIS EXISTS FOR is the first pair: REDS %449's own shape, planted. A guard that reads a
# module with `grep -q` and never builds it leaves that module outside every compiler's reach, and
# the repair is one build verb. Both directions are asserted, so the reading is proven to tell a
# grep-reader from a builder rather than merely to count files.
#
# THE PEN'S BASE TREE, which every case starts from, mirrors the real one in miniature: `built.rye`
# is named by a builder, `dep.rye` is reached only through `built.rye`'s import, and `weave.rye` is
# read by a guard that never builds it. So a correct reading is `reached=2, uncompiled=1` before a
# single case plants anything, and each case moves exactly one of those numbers.
#
# USAGE
#   sh tools/fixtures/r/rye_compiled_reach_control.sh
#
# Driven by tools/r/rye_compiled_reach_witness.rish. Run from the repository root.

set -u

scan=$(pwd)/tools/fixtures/r/rye_compiled_reach_scan.sh
[ -f "$scan" ] || { echo "control_verdict=scan_missing" >&2; exit 1; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM

checks=0
failures=0
say() { checks=$((checks + 1)); echo "$1"; case "$1" in *=no) failures=$((failures + 1)) ;; esac; }
ask() { if echo "$2" | grep -q "$3"; then say "$1=yes"; else say "$1=no"; fi; }

# The base pen. `reader` is the whole body of tools/g/reader.rish -- a SEPARATE file from the
# builder, because that is the real shape: %449's four guards each held zero build verbs while
# `mantra_weave_merge_witness.rish`, one file over, held one. A path named inside a builder is
# credited on purpose (see the scan's generosity note), so a plant that mixes the two would be
# testing the wrong thing.
build() {
  name=$1; reader=$2
  d=$pen/$name
  mkdir -p "$d/mod" "$d/tools/g"
  ( cd "$d" \
    && git init -q . \
    && git config user.email pen@example.invalid \
    && git config user.name Pen \
    && printf 'const std = @import("std");\nconst dep = @import("dep.rye");\npub const main = dep.n;\n' > mod/built.rye \
    && printf 'const std = @import("std");\npub const n = 1;\n' > mod/dep.rye \
    && printf 'const std = @import("std");\npub const Weave = struct { lines: u32 };\n' > mod/weave.rye \
    && printf 'let b = run ["sh" "-c" "rye build mod/built.rye -femit-bin=/tmp/x"]\n' > tools/g/builder.rish \
    && printf '%s\n' "$reader" > tools/g/reader.rish \
    && git add -A \
    && git commit -qm 'pen: one built module, one dependency, one module only read' ) >/dev/null 2>&1
  echo "$d"
}

read_of() { ( cd "$1" && sh "$scan" "${2:-measure}" 2>/dev/null; ) }

# 1. THE %449 SHAPE. A guard that only greps the module leaves it outside every compiler's reach,
# while the module the same guard BUILDS, and the dependency that one imports, both read reached.
d=$(build grep_only 'let seen = run ["sh" "-c" "grep -q Weave mod/weave.rye"]')
out=$(read_of "$d" list)
ask grep_read_module_uncompiled "$out" 'uncompiled mod/weave.rye'
ask grep_read_module_counted    "$out" 'uncompiled=1'
ask built_module_reached        "$out" 'reached=2'
ask grep_alone_is_not_a_root    "$out" 'roots_literal=1'

# 2. THE REPAIR, one build verb. The same tree with the module named by a builder reads zero.
d=$(build builder 'let w = run ["sh" "-c" "rye build mod/weave.rye -femit-bin=/tmp/y"]')
out=$(read_of "$d" list)
ask build_verb_clears_it     "$out" 'uncompiled=0'
ask build_verb_adds_a_root   "$out" 'roots_literal=2'
ask repaired_tree_free       "$out" 'verdict=ok'

# 3. TRANSITIVE REACH, one hop further. A module the dependency imports is compiled too.
d=$(build imported '# this file reads nothing at all')
printf 'const std = @import("std");\npub const deeper = 2;\n' > "$d/mod/deeper.rye"
printf 'const x = @import("deeper.rye");\n' >> "$d/mod/dep.rye"
( cd "$d" && git add -A && git commit -qm 'pen: a second hop' ) >/dev/null 2>&1
out=$(read_of "$d" list)
ask second_hop_reached "$out" 'reached=3'
ask second_hop_hops    "$out" 'hops=2'

# 4. THE SYMLINK CREDITS ITS TARGET. A build through a link compiles the target's bytes, so
# counting paths would report a live module dead -- eleven links point at tally/parse_int.rye in
# the real tree, and one of them is enough to make the point here.
d=$(build symlink 'let b = run ["sh" "-c" "rye build app/weave.rye -femit-bin=/tmp/x"]')
mkdir -p "$d/app"
( cd "$d/app" && ln -s ../mod/weave.rye weave.rye )
( cd "$d" && git add -A && git commit -qm 'pen: a link into the module' ) >/dev/null 2>&1
out=$(read_of "$d" list)
ask symlink_seen           "$out" 'symlinks=1'
ask symlink_one_body       "$out" 'bodies=3'
# Leg 1 proved mod/weave.rye reads uncompiled when nothing builds it, so a zero here is the LINK
# crediting its target rather than the base builder reaching it another way.
ask symlink_credits_target "$out" 'uncompiled=0'

# 5. THE COMPOSED PATH CREDITS ITS DIRECTORY. A builder joining a directory and stem has no literal
# to read, and refusing its whole directory would call 116 live tests dead in the real tree.
composed_source=$(printf '%s' 'bGV0IGRpciA9ICJtb2QiCmxldCBydW5zID0gbWFwIG5hbWVzIGFzIHM6IHJ1biBbInNoIiAiLWMiICJyeWUgcnVuICR7ZGlyfS8ke3N9LnJ5ZSJd' | base64 -d)
d=$(build composed "$composed_source")
out=$(read_of "$d" list)
ask composed_dir_seen      "$out" 'composed_dirs=1'
ask composed_clears_room   "$out" 'uncompiled=0'

# 6. A FIXTURE PLANT IS COUNTED AND HELD OUT OF THE GATE. A .rye under a fixtures/ pen exists to be
# read by a scan rather than built, so gating it would refuse a file doing its job.
d=$(build plant 'let w = run ["sh" "-c" "rye build mod/weave.rye -femit-bin=/tmp/y"]')
mkdir -p "$d/tools/fixtures/t"
printf 'const std = @import("std");\n// a planted violation, never built\n' > "$d/tools/fixtures/t/ban.rye"
( cd "$d" && git add -A && git commit -qm 'pen: a planted fixture' ) >/dev/null 2>&1
out=$(read_of "$d" plants)
ask plant_counted    "$out" 'plants=1'
ask plant_named      "$out" 'plant tools/fixtures/t/ban.rye'
ask plant_not_gated  "$out" 'uncompiled=0'
ask plant_tree_free  "$out" 'verdict=ok'

# 7. THE CEILING, FROM BOTH SIDES. One body over refuses and names it; the same tree at the
# ceiling walks free. A ceiling proven only downward cannot be told from an override.
d=$(build ceiling 'let seen = run ["sh" "-c" "grep -q Weave mod/weave.rye"]')
out=$( cd "$d" && RYE_UNCOMPILED_CEILING=0 sh "$scan" 2>/dev/null )
ask over_ceiling_refuses   "$out" 'verdict=over_ceiling'
ask over_ceiling_names_it  "$out" 'uncompiled mod/weave.rye'
if ( cd "$d" && RYE_UNCOMPILED_CEILING=0 sh "$scan" >/dev/null 2>&1 ); then
  say over_ceiling_exits_nonzero=no
else
  say over_ceiling_exits_nonzero=yes
fi
out=$( cd "$d" && RYE_UNCOMPILED_CEILING=1 sh "$scan" 2>/dev/null )
ask at_ceiling_free "$out" 'verdict=ok'

# 8. AN EMPTY CORPUS REFUSES RATHER THAN REPORTING A CLEAN TREE. REDS %240's confident wrong zero.
d=$pen/no_rye
mkdir -p "$d"
( cd "$d" && git init -q . && git config user.email pen@example.invalid && git config user.name Pen \
  && printf 'nothing here\n' > README.md && git add -A && git commit -qm 'pen: no rye' ) >/dev/null 2>&1
out=$(read_of "$d")
ask empty_corpus_refuses "$out" 'verdict=no_rye_found'

# 9. NO BUILDER REFUSES. Without one, every body would read uncompiled for the wrong reason -- a
# number that is arithmetically right and diagnostically worthless.
d=$pen/no_builder
mkdir -p "$d/mod" "$d/tools/g"
( cd "$d" && git init -q . && git config user.email pen@example.invalid && git config user.name Pen \
  && printf 'const std = @import("std");\nconst dep = @import("dep.rye");\n' > mod/built.rye \
  && printf 'pub const n = 1;\n' > mod/dep.rye \
  && printf '# this guard names no build verb at all\nlet seen = run ["sh" "-c" "grep -q dep mod/built.rye"]\n' > tools/g/reader.rish \
  && git add -A && git commit -qm 'pen: nothing builds' ) >/dev/null 2>&1
out=$(read_of "$d")
ask no_builder_refuses "$out" 'verdict=no_builders_found'

# 10. A BUILDER NAMING NO TRACKED PATH REFUSES. The closure would start from nothing.
d=$pen/no_root
mkdir -p "$d/mod" "$d/tools/g"
( cd "$d" && git init -q . && git config user.email pen@example.invalid && git config user.name Pen \
  && printf 'const std = @import("std");\nconst dep = @import("dep.rye");\n' > mod/built.rye \
  && printf 'pub const n = 1;\n' > mod/dep.rye \
  && printf 'let b = run ["sh" "-c" "rye build absent/gone.rye -femit-bin=/tmp/x"]\n' > tools/g/builder.rish \
  && git add -A && git commit -qm 'pen: a builder naming nothing tracked' ) >/dev/null 2>&1
out=$(read_of "$d")
ask no_root_refuses "$out" 'verdict=no_roots_found'

# 11. A CORPUS WITH NO IMPORT AT ALL REFUSES. The closure would stop at its roots, so a tree whose
# import grep silently broke reads the same as one genuinely flat -- exactly REDS %447's class.
d=$pen/no_import
mkdir -p "$d/mod" "$d/tools/g"
( cd "$d" && git init -q . && git config user.email pen@example.invalid && git config user.name Pen \
  && printf 'pub const x = 1;\n' > mod/weave.rye \
  && printf 'let b = run ["sh" "-c" "rye build mod/weave.rye -femit-bin=/tmp/x"]\n' > tools/g/guard.rish \
  && git add -A && git commit -qm 'pen: no import anywhere' ) >/dev/null 2>&1
out=$(read_of "$d")
ask no_import_refuses "$out" 'verdict=no_imports_found'

# 12. AN IMPORT CYCLE SETTLES RATHER THAN SPINNING. The bound exists so a pathological corpus
# cannot hang a lap; a cycle must still finish and read every member reached.
d=$(build cycle '# this file reads nothing at all')
printf 'const b = @import("built.rye");\n' >> "$d/mod/dep.rye"
( cd "$d" && git add -A && git commit -qm 'pen: a cycle' ) >/dev/null 2>&1
out=$(read_of "$d")
ask cycle_settles "$out" 'reached=2'
ask cycle_free    "$out" 'verdict=ok'

# 13. THE PEN IS INNOCENT. With the grep-read module built too, the base tree reads zero -- so
# every `yes` above is the plant speaking rather than the pen.
d=$(build clean 'let w = run ["sh" "-c" "rye build mod/weave.rye -femit-bin=/tmp/y"]')
out=$(read_of "$d")
ask clean_reads_zero "$out" 'uncompiled=0'
ask clean_reads_all  "$out" 'reached=3'
ask clean_free       "$out" 'verdict=ok'

echo "control_checks=$checks"
echo "control_failures=$failures"
if [ "$failures" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=broken"
  exit 1
fi
