#!/bin/sh
# tools/fixtures/r/rye_build_lock_reach_control.sh -- the cross-scope reading, shown from both sides.
#
# WHAT THIS PROVES. `rye_build_lock_reach_scan.sh` gates one number at zero: a `.zig` shadow path
# claimed by build roots standing under two different working directories, where two different
# `.rye-build.lock` directories guard one shadow namespace and neither waits for the other. A gate
# proven only in the passing direction cannot be told from a bypass, so every leg below is planted
# and then lifted, and the innocent shape is asserted as hard as the guilty one.
#
# THE PEN IS A REAL GIT REPOSITORY, because the scan's population comes from `git ls-files`. Each
# leg writes tracked caller scripts and `.rye` sources into a throwaway tree, runs the scan there,
# and reads the verdict and the counted numbers off its output.
#
# Run from the repository root:
#   sh tools/fixtures/r/rye_build_lock_reach_control.sh
set -u

root=$(pwd)
scan="$root/tools/fixtures/r/rye_build_lock_reach_scan.sh"
pen=$(mktemp -d 2>/dev/null || echo "$root/.lap/lock-reach-pen-$$")
trap 'rm -rf "$pen"' EXIT

legs=0
fails=0

leg() {
  legs=$((legs + 1))
  name=$1
  want=$2
  got=$3
  if [ "$want" = "$got" ]; then
    echo "leg=$name want=$want got=$got ok"
  else
    fails=$((fails + 1))
    echo "leg=$name want=$want got=$got FAILED"
  fi
}

new_pen() {
  rm -rf "$pen/tree"
  mkdir -p "$pen/tree/tools" "$pen/tree/shared" "$pen/tree/lab"
  cd "$pen/tree" || exit 1
  git init -q . 2>/dev/null
  git config user.email pen@example.invalid
  git config user.name pen
  git config commit.gpgsign false
  printf 'const std = @import("std");\n' > shared/leaf.rye
  printf 'const std = @import("std");\nconst leaf = @import("leaf.rye");\n' > shared/trunk.rye
  printf 'const std = @import("std");\nconst leaf = @import("leaf.rye");\n' > shared/branch.rye
  printf 'const std = @import("std");\n' > lab/solo.rye
}

track() {
  git add -A >/dev/null 2>&1
  git -c commit.gpgsign=false commit -qm pen >/dev/null 2>&1 || true
}

read_field() { sed -n "s/^$2=//p" "$1" | head -1; }

# --- clean: every caller stands at the repository root ---------------------------------------
new_pen
printf 'rye build shared/trunk.rye -femit-bin=bin/trunk\n' > tools/a.sh
printf 'rye build shared/branch.rye -femit-bin=bin/branch\n' > tools/b.sh
track
sh "$scan" > "$pen/out" 2>&1
leg clean_verdict ok "$(read_field "$pen/out" verdict)"
leg clean_one_scope 1 "$(sed -n 's/.*lock_scopes=\([0-9]*\).*/\1/p' "$pen/out" | head -1)"
leg clean_shared_seen 1 "$(read_field "$pen/out" shared_paths)"
leg clean_no_cross 0 "$(read_field "$pen/out" cross_scope_collisions)"

# --- disjoint_scope: a second working directory whose closure touches nothing the root's does --
new_pen
printf 'rye build shared/trunk.rye -femit-bin=bin/trunk\n' > tools/a.sh
printf 'cd lab && rye build solo.rye -femit-bin=../bin/solo\n' > tools/b.sh
track
sh "$scan" > "$pen/out" 2>&1
leg disjoint_verdict ok "$(read_field "$pen/out" verdict)"
leg disjoint_two_scopes 2 "$(sed -n 's/.*lock_scopes=\([0-9]*\).*/\1/p' "$pen/out" | head -1)"
leg disjoint_no_cross 0 "$(read_field "$pen/out" cross_scope_collisions)"

# --- cross_scope: two working directories reaching one shadow -- the gate's own subject --------
new_pen
printf 'rye build shared/trunk.rye -femit-bin=bin/trunk\n' > tools/a.sh
printf 'cd shared && rye build branch.rye -femit-bin=../bin/branch\n' > tools/b.sh
track
sh "$scan" > "$pen/out" 2>&1
leg cross_verdict cross_scope_shadow "$(read_field "$pen/out" verdict)"
leg cross_counted 1 "$(read_field "$pen/out" cross_scope_collisions)"
sh "$scan" --explain > "$pen/out2" 2>&1
leg cross_named yes "$(grep -c 'shared/leaf.zig' "$pen/out2" >/dev/null && echo yes || echo no)"

# --- lifted: the same pen with the second caller brought back to the root ----------------------
printf 'rye build shared/branch.rye -femit-bin=bin/branch\n' > tools/b.sh
track
sh "$scan" > "$pen/out" 2>&1
leg lifted_verdict ok "$(read_field "$pen/out" verdict)"
leg lifted_no_cross 0 "$(read_field "$pen/out" cross_scope_collisions)"

# --- pen_scope: a `cd "$var"` names a throwaway pen and is left out of the reading -------------
new_pen
printf 'rye build shared/trunk.rye -femit-bin=bin/trunk\n' > tools/a.sh
printf 'cd "$d" && rye build shared/branch.rye -femit-bin=bin/branch\n' > tools/b.sh
track
sh "$scan" > "$pen/out" 2>&1
leg pen_verdict ok "$(read_field "$pen/out" verdict)"
leg pen_counted 1 "$(sed -n 's/.*pen_scopes=\([0-9]*\).*/\1/p' "$pen/out" | head -1)"
leg pen_one_tree_scope 1 "$(sed -n 's/.*lock_scopes=\([0-9]*\).*/\1/p' "$pen/out" | head -1)"

# --- escaping_import: an import may reach ABOVE its root file's directory, and one in this tree
# does (`tools/rye/enrich/blocks_audit.rye` imports `../tame_usize_audit.rye`). The walk normalizes
# `..` before claiming a shadow, so a root in one directory and a root above it meet on the shadow
# they share. Without that normalization the path would be claimed under two spellings and the
# collision would go unseen -- which is the whole reading refusing to work on the one shape that
# makes "lock the root file's own directory" an insufficient repair. ---------------------------
new_pen
mkdir -p lab/deep
printf 'const std = @import("std");\n' > lab/above.rye
printf 'const std = @import("std");\nconst up = @import("../above.rye");\n' > lab/deep/climber.rye
printf 'rye build lab/above.rye -femit-bin=bin/above\n' > tools/a.sh
printf 'cd lab/deep && rye build climber.rye -femit-bin=../../bin/climber\n' > tools/b.sh
track
sh "$scan" --explain > "$pen/out" 2>&1
leg escaping_verdict cross_scope_shadow "$(read_field "$pen/out" verdict)"
leg escaping_named yes "$(grep -q 'lab/above.zig' "$pen/out" && echo yes || echo no)"

# --- run_verb: `rye run` bridges the same shadows, so it is read the same way ------------------
new_pen
printf 'rye run shared/trunk.rye\n' > tools/a.sh
printf 'cd shared && rye run branch.rye\n' > tools/b.sh
track
sh "$scan" > "$pen/out" 2>&1
leg run_verb_verdict cross_scope_shadow "$(read_field "$pen/out" verdict)"

# --- self_control: the scan must not read the file whose whole content is planted material -----
# In a pen this is proven the way every other leg is: a control-shaped file carrying a literal
# cross-scope plant is named as the scan's own control and must be read past, and the SAME pen with
# the naming removed must red -- so the exclusion is shown to be load-bearing rather than decorative.
new_pen
mkdir -p tools/fixtures/r
printf 'const std = @import("std");\n' > solo.rye
printf "printf 'cd pen%s && rye build solo.rye -femit-bin=../bin/solo\\n'\n" "" > tools/fixtures/r/rye_build_lock_reach_control.sh
printf 'rye build solo.rye -femit-bin=bin/solo\n' > tools/a.sh
track
sh "$scan" > "$pen/out" 2>&1
leg self_control_excluded_verdict ok "$(read_field "$pen/out" verdict)"
leg self_control_named yes "$(grep -q 'self_control_excluded=tools/fixtures/r/rye_build_lock_reach_control.sh' "$pen/out" && echo yes || echo no)"
leg self_control_one_scope 1 "$(read_field "$pen/out" lock_scopes | awk '{print $1}')"
RYE_LOCK_SELF_CONTROL= sh "$scan" > "$pen/out2" 2>&1
leg self_control_exclusion_load_bearing 1 "$(read_field "$pen/out2" lock_scopes | awk '{print ($1 > 1) ? 1 : 0}')"

cd "$root" || exit 1
echo "control_legs=$legs control_fail=$fails"
if [ "$fails" -eq 0 ]; then echo "verdict=ok"; else echo "verdict=control_failed"; fi
