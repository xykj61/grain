#!/bin/sh
# glow_rune_shop_core_control.sh -- the core-road guard proven able to red, on a throwaway checkout.
#
#   sh tools/fixtures/g/glow_rune_shop_core_control.sh
#
# WHY THIS FIXTURE EXISTS. `tools/g/glow_rune_shop_core_witness.rish` watches the predicate that
# decides which road a `|%` source takes -- the welcome road for a thin core, the shop road for one
# whose every arm carries a body. It arrived asserting on a delegate's selftest with no refusal of
# its own on disk, which is the population `standing_equipment_redleg` reads and holds at a falling
# ceiling. The aether row states the standard this answers: a witness must be proven able to make a
# sound before its silence means anything.
#
# THE SUBJECT NEEDS A COMPILER, so the pen is a checkout plus three links. `git worktree add
# --detach` carries every tracked file in about a second; `rye/bin`, `rishi/bin` and
# `vendor/zig-toolchain` are build outputs this tree ignores, so the pen links them back to the
# live root rather than rebuilding a toolchain per plant. THE THREE FILES UNDER TEST ARE THE ONES
# ON DISK -- runner, module and selftest are copied in over HEAD's copies, so a repair being made
# is proven in its new form rather than its elder one (`tools/c/convergence_tree_prove.sh`,
# `20260909.170804`).
#
# FIVE PLANTS, AND THE LAST TWO ARE WHY THE FIRST THREE ARE NOT ENOUGH. Plants 1 to 3 move the
# module, so the selftest exits non-zero and the runner refuses at its `selftest.ok` leg -- which
# proves the DELEGATE can sound and says nothing about the runner's own seventeen legs. Plants 4
# and 5 leave a selftest that exits 0, and only the runner's own text legs can catch them:
#
#   any_arm          -- the elder fault (REDS `20260906.195208`): the predicate claims every `|%`
#                       source, so the six thin desks read as the shop's. `ThinShapeClaimedByShop`.
#   armless_declines -- a core with no `++` at all declines, which is the single source on which
#                       "any arm carries a body" and "every arm carries a body" part.
#                       `ShopShapeNotClaimedByShop`, after the two shop legs before it pass.
#   empty_core       -- the shop's own `EmptyCore` refusal collapses into `MalformedCore`, so the
#                       armless core stops being refused by its own name.
#   claim_reworded   -- the selftest passes and renames one claim line. The runner refuses at line
#                       37, its own leg, rather than at the delegate's exit code.
#   summary_renamed  -- the selftest's closing summary line is renamed and everything else stands.
#                       Every one of the seventeen leg lines ends in `-- GREEN`, so the elder
#                       `contains "GREEN"` matched a first leg and could not tell a finished run
#                       from an abandoned one. Sharpened to the summary's own words on
#                       `20260909.211500`; this plant is what proves the sharpened leg sounds.
#
# EVERY PLANT IS LIFTED AND READ BACK. A refusal shown only in the failing direction cannot be told
# from a tool that refuses everything, so each case ends by restoring the file and requiring a pass.
#
# Prints `pass=N fail=N`. Bounded: one pen, five plants, at most eleven runner runs at ~2.1s each.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
runner_real="$root/tools/g/glow_rune_shop_core_witness.rish"
[ -f "$runner_real" ] || { echo "refused: no runner at $runner_real" >&2; exit 2; }

pen=$(mktemp -d "${TMPDIR:-/tmp}/shopcore-pen.XXXXXX")
rmdir "$pen"
cleanup() { git -C "$root" worktree remove --force "$pen" >/dev/null 2>&1 || rm -rf "$pen"; }
trap cleanup EXIT INT TERM

git -C "$root" worktree add --detach "$pen" HEAD >/dev/null 2>&1 \
  || { echo "refused: could not make a pen checkout" >&2; exit 2; }

# The three build outputs the tree ignores, linked rather than copied: the zig toolchain alone is
# 165 MB and every plant would pay for it again.
for d in rye/bin rishi/bin vendor/zig-toolchain; do
  [ -e "$root/$d" ] || { echo "refused: this root holds no $d -- build it first" >&2; exit 2; }
  mkdir -p "$pen/$(dirname -- "$d")"
  ln -s "$root/$d" "$pen/$d"
done

# `cat >` writes through the checkout's own inode, so the mode git tracks survives the copy
# (`.claude/rules/exec-bit.md`).
for f in tools/g/glow_rune_shop_core_witness.rish glow/rune_shop_core.rye glow/rune_shop_core_witness.rye; do
  [ -f "$pen/$f" ] || { echo "refused: the pen holds no $f -- nothing to plant in" >&2; exit 2; }
  cat "$root/$f" > "$pen/$f"
done

# THE PEN'S RUNNER LOSES ITS OWN CONTROL LEG, and this is the one place the pen copy departs from
# disk. The runner ends by invoking THIS fixture; a pen whose runner did that would make a pen of
# its own, forever. Everything below the runner's `# CONTROL LEG` marker is dropped, so the pen
# proves the seventeen legs above it and this fixture proves the leg below.
runner="$pen/tools/g/glow_rune_shop_core_witness.rish"
grep -q '^# CONTROL LEG' "$runner" \
  || { echo "refused: the runner names no CONTROL LEG marker -- the pen cannot tell where to cut" >&2; exit 2; }
sed '/^# CONTROL LEG/,$d' "$runner" > "$runner.cut" && cat "$runner.cut" > "$runner" && rm -f "$runner.cut"

for f in tools/g/glow_rune_shop_core_witness.rish glow/rune_shop_core.rye glow/rune_shop_core_witness.rye; do
  cat "$pen/$f" > "$pen/$f.pristine"
done

pass=0; fail=0
check() { if [ "$3" = "$2" ]; then pass=$((pass+1)); else fail=$((fail+1)); printf 'FAIL %s -- wanted %s, got %s\n' "$1" "$2" "$3" >&2; fi; }
has() { case "$1" in *"$2"*) echo yes ;; *) echo no ;; esac; }

run_guard() { ( cd "$pen" && rishi/bin/rishi run tools/g/glow_rune_shop_core_witness.rish 2>&1 ); }
lift() { cat "$pen/$1.pristine" > "$pen/$1"; }
# The portable in-place form this tree prescribes: write a temporary, cat it back (`shell_dialect`
# gates `sed -i` at zero, since GNU and BSD spell it differently).
plant() { sed "$2" "$pen/$1" > "$pen/$1.tmp" && cat "$pen/$1.tmp" > "$pen/$1" && rm -f "$pen/$1.tmp"; }

# THE BASELINE. A pen that cannot pass proves nothing about the plants that follow, and the summary
# line is the one the sharpened leg now reads.
base=$(run_guard) && base_ok=yes || base_ok=no
check "clean pen passes" yes "$base_ok"
check "clean pen speaks the summary" yes "$(has "$base" "GREEN: the \`|%\` road is picked")"
# The runner CAPTURES the selftest's own lines rather than echoing them, so a baseline reading has
# only the runner's own words to read -- which is the same limit the two text plants below exploit.
check "clean pen names its lens" yes "$(has "$base" "the declines are proven as hard as the claims")"

# Each case: plant, require a refusal naming its own fault, lift, require the pass back.
case_run() {
  label=$1; rel=$2; expr=$3; want=$4
  lift "$rel"
  plant "$rel" "$expr"
  out=$(run_guard) && refused=no || refused=yes
  check "$label refuses" yes "$refused"
  check "$label names its fault" yes "$(has "$out" "$want")"
  lift "$rel"
  back=$(run_guard) && back_ok=yes || back_ok=no
  check "$label lifted passes" yes "$back_ok"
}

mod=glow/rune_shop_core.rye
sel=glow/rune_shop_core_witness.rye

case_run "any_arm" "$mod" \
  's/if (prev_opens_arm and (opens_arm or closes)) return false;/if (false and prev_opens_arm and (opens_arm or closes)) return false;/' \
  "ThinShapeClaimedByShop"

case_run "armless_declines" "$mod" \
  's/    var live: u32 = 0;/    var live: u32 = 0;\n    if (std.mem.indexOf(u8, src, "++") == null) return false;/' \
  "ShopShapeNotClaimedByShop"

case_run "empty_core" "$mod" \
  's/if (spec.arm_count == 0) return error.EmptyCore;/if (spec.arm_count == 0) return error.MalformedCore;/' \
  "MalformedCore"

case_run "claim_reworded" "$sel" \
  "s/is the shop's own -- GREEN/belongs to the shop -- GREEN/" \
  "missing the standing shop-desk claim"

case_run "summary_renamed" "$sel" \
  's/GREEN: looks_like_shop_core separates/SUMMARY: looks_like_shop_core separates/' \
  "missing the summary claim"

echo "coverage: a clean pen speaking its summary and one decline; three plants in the module the selftest catches -- the elder any-arm routing, the armless core that decides the every-arm law, and the shop's own EmptyCore refusal collapsed; and two in a selftest that still exits 0, which only the runner's own text legs can catch"
echo "pass=$pass fail=$fail"
[ "$fail" -eq 0 ]
