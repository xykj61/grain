#!/bin/sh
# tools/fixtures/b/build_target_control.sh -- prove the build-target scan from both sides.
#
#   sh tools/fixtures/b/build_target_control.sh
#
# Every refusal is planted and then lifted, and every welcome is asserted as hard as every refusal:
# a refusal proven only in the passing direction cannot be told from a bypass. The pen is a real git
# repository, because two of the scan's readings are `git ls-files` and `git check-ignore` and a
# pen without git would prove them against nothing.
#
# IT COUNTS ITS OWN LEGS OUT LOUD. `fail=0` is what an empty pen prints too, so the control publishes
# `legs_expected` and `legs_run`, and `tools/b/build_target_witness.rish` asserts both meet the
# number it carries. Delete a leg and the witness reds.
set -u

SCAN=${BUILD_TARGET_SCAN:-tools/fixtures/b/build_target_scan.sh}
scan_abs=$(cd "$(dirname "$SCAN")" && pwd)/$(basename "$SCAN")
[ -f "$scan_abs" ] || { echo "detail: no scan at $SCAN" >&2; echo "control_verdict=no_scan"; exit 2; }

pen=$(mktemp -d) || { echo "control_verdict=no_pen"; exit 2; }
trap 'rm -rf "$pen"' EXIT INT TERM

legs=0
fail=0
leg() {
  # leg <name> <expected> <got>
  legs=$((legs + 1))
  if [ "$2" = "$3" ]; then
    echo "leg $1 ok"
  else
    echo "leg $1 FAILED want=$2 got=$3"
    fail=$((fail + 1))
  fi
}

# ONE PEN TREE PER SHAPE, each a real git repository with its own roster and its own witness
# sources, so a reading is about the bytes the pen holds rather than about this tree.
make_tree() {
  t="$pen/$1"
  mkdir -p "$t/construction" "$t/tools/x"
  ( cd "$t" && git init -q . && git config user.email pen@example.invalid && git config user.name pen )
  printf 'bin/\n' > "$t/.gitignore"
  : > "$t/construction/roster.kyri"
}

seat() {
  # seat <tree> <guard> <source-basename>
  printf 'guard %s\npath tools/x/%s\ntier lap\n\n' "$2" "$3" >> "$pen/$1/construction/roster.kyri"
}

read_scan() {
  # read_scan <tree> [extra args...]; prints the scan's key=value lines
  t="$pen/$1"; shift
  ( cd "$t" && BUILD_TARGET_ROSTER=construction/roster.kyri sh "$scan_abs" "$@" 2>/dev/null )
}

field() { printf '%s\n' "$1" | sed -n "s/^$2=//p" | head -1; }

# --- 1. the four kinds a target can be -------------------------------------------------------
make_tree kinds
cat > "$pen/kinds/tools/x/fixed_witness.rish" <<'EOF'
let out = run ["sh" "-c" "rye build a.rye -femit-bin=bin/fixed_one"]
EOF
cat > "$pen/kinds/tools/x/inline_witness.rish" <<'EOF'
let out = run ["sh" "-c" "d=$(mktemp -d); rye build a.rye -femit-bin=$d/thing; rm -rf $d"]
EOF
cat > "$pen/kinds/tools/x/chain_witness.rish" <<'EOF'
let made = run ["sh" "-c" "mktemp -d /tmp/chain.XXXXXX"]
let home = trim made.out
let out = run ["sh" "-c" "rye build a.rye -femit-bin=${home}/thing"]
EOF
cat > "$pen/kinds/tools/x/nested_witness.rish" <<'EOF'
let made = run ["sh" "-c" "mktemp -d /tmp/nested.XXXXXX"]
let home = trim made.out
let elder_dir = "${home}/elder"
let out = run ["sh" "-c" "rye build a.rye -femit-bin=${elder_dir}/thing"]
EOF
cat > "$pen/kinds/tools/x/unknown_witness.rish" <<'EOF'
let out = run ["sh" "-c" "rye build a.rye -femit-bin=${whatever}/thing"]
EOF
seat kinds fixed fixed_witness.rish
seat kinds inline inline_witness.rish
seat kinds chain chain_witness.rish
seat kinds nested nested_witness.rish
seat kinds unknown unknown_witness.rish
k=$(read_scan kinds)
leg kinds_sites 5 "$(field "$k" emit_sites)"
leg kinds_fixed 1 "$(field "$k" emit_fixed)"
leg kinds_pen 3 "$(field "$k" emit_pen)"
leg kinds_unresolved 1 "$(field "$k" emit_unresolved)"
leg kinds_guards_emitting 5 "$(field "$k" guards_emitting)"
leg kinds_verdict ok "$(field "$k" verdict)"

# THE NESTED LEG IS THIS LAP'S OWN FAULT, PLANTED. A literal that itself holds a variable read as a
# fixed tree path on the scan's first pass, and ten real amphora sites reaching a real pen were
# counted as tree writes. The list names the resolved path, so the leg reads the answer rather
# than the tally.
nested_line=$(read_scan kinds --list | grep ' nested ' | head -1)
case "$nested_line" in
  'site pen nested '*) leg nested_resolves_to_pen yes yes ;;
  *) leg nested_resolves_to_pen yes "no:$nested_line" ;;
esac

# --- 2. shared is about DISTINCT guards, never about sites ------------------------------------
make_tree shared
cat > "$pen/shared/tools/x/one_witness.rish" <<'EOF'
let a = run ["sh" "-c" "rye build a.rye -femit-bin=bin/together"]
EOF
cat > "$pen/shared/tools/x/two_witness.rish" <<'EOF'
let a = run ["sh" "-c" "rye build b.rye -femit-bin=bin/together"]
EOF
seat shared one one_witness.rish
seat shared two two_witness.rish
s=$(read_scan shared)
leg shared_two_guards 1 "$(field "$s" shared_paths)"
leg shared_max_writers 2 "$(field "$s" max_writers)"
leg shared_fixed_paths 1 "$(field "$s" fixed_paths)"

make_tree twice
cat > "$pen/twice/tools/x/twice_witness.rish" <<'EOF'
let a = run ["sh" "-c" "rye build a.rye -femit-bin=bin/together"]
let b = run ["sh" "-c" "rye build b.rye -femit-bin=bin/together"]
EOF
seat twice twice twice_witness.rish
w=$(read_scan twice)
leg twice_sites 2 "$(field "$w" emit_sites)"
leg twice_not_shared 0 "$(field "$w" shared_paths)"
leg twice_max_writers 1 "$(field "$w" max_writers)"

# --- 3. the two walls, each planted and then lifted -------------------------------------------
make_tree tracked
cat > "$pen/tracked/tools/x/t_witness.rish" <<'EOF'
let a = run ["sh" "-c" "rye build a.rye -femit-bin=bin/carried"]
EOF
seat tracked t t_witness.rish
mkdir -p "$pen/tracked/bin"
printf 'binary\n' > "$pen/tracked/bin/carried"
( cd "$pen/tracked" && git add -f bin/carried >/dev/null 2>&1 )
t=$(read_scan tracked)
leg wall_tracked_bites 1 "$(field "$t" emit_tracked)"
leg wall_tracked_verdict tracked_output "$(field "$t" verdict)"
# A TRACKED OUTPUT IS NECESSARILY AN UNIGNORED ONE -- both readings fire, and the verdict names the
# worse. Asserted here so the precedence is proven rather than assumed from one word.
leg wall_tracked_also_unignored 1 "$(field "$t" emit_unignored)"
( cd "$pen/tracked" && git rm -q --cached bin/carried >/dev/null 2>&1 )
t2=$(read_scan tracked)
leg wall_tracked_lifts 0 "$(field "$t2" emit_tracked)"
leg wall_tracked_lifts_verdict ok "$(field "$t2" verdict)"

make_tree unignored
cat > "$pen/unignored/tools/x/u_witness.rish" <<'EOF'
let a = run ["sh" "-c" "rye build a.rye -femit-bin=out/visible"]
EOF
seat unignored u u_witness.rish
u=$(read_scan unignored)
leg wall_unignored_bites 1 "$(field "$u" emit_unignored)"
leg wall_unignored_verdict unignored_output "$(field "$u" verdict)"
printf 'bin/\nout/\n' > "$pen/unignored/.gitignore"
u2=$(read_scan unignored)
leg wall_unignored_lifts 0 "$(field "$u2" emit_unignored)"
leg wall_unignored_lifts_verdict ok "$(field "$u2" verdict)"

# --- 4. the two ratchets, proven from both sides at a pen ceiling -----------------------------
make_tree ceil
i=1
while [ $i -le 3 ]; do
  cat > "$pen/ceil/tools/x/c${i}_witness.rish" <<EOF
let a = run ["sh" "-c" "rye build a.rye -femit-bin=bin/c${i}"]
EOF
  seat ceil "c$i" "c${i}_witness.rish"
  i=$((i + 1))
done
c_at=$( cd "$pen/ceil" && BUILD_TARGET_ROSTER=construction/roster.kyri BUILD_TARGET_CEILING_FIXED=3 sh "$scan_abs" 2>/dev/null )
leg ratchet_at_ceiling_passes ok "$(field "$c_at" verdict)"
leg ratchet_at_ceiling_source env "$(field "$c_at" ceiling_source)"
c_over=$( cd "$pen/ceil" && BUILD_TARGET_ROSTER=construction/roster.kyri BUILD_TARGET_CEILING_FIXED=2 sh "$scan_abs" 2>/dev/null )
leg ratchet_over_ceiling_bites fixed_over_ceiling "$(field "$c_over" verdict)"
c_shared=$( cd "$pen/shared" && BUILD_TARGET_ROSTER=construction/roster.kyri BUILD_TARGET_CEILING_SHARED=0 sh "$scan_abs" 2>/dev/null )
leg ratchet_shared_bites shared_over_ceiling "$(field "$c_shared" verdict)"
leg ceiling_source_seated seated "$(field "$(read_scan shared)" ceiling_source)"

# --- 5. the scan's own refusals ---------------------------------------------------------------
r=$( cd "$pen/shared" && BUILD_TARGET_ROSTER=construction/absent.kyri sh "$scan_abs" 2>/dev/null )
leg refuse_no_roster no_roster "$(field "$r" verdict)"
b=$( cd "$pen/shared" && BUILD_TARGET_ROSTER=construction/roster.kyri sh "$scan_abs" --nonsense 2>/dev/null )
leg refuse_bad_argument bad_argument "$(field "$b" verdict)"

# A ROSTERED GUARD WHOSE SOURCE IS ABSENT IS SKIPPED RATHER THAN COUNTED, because a roster row
# pointing at nothing is a different fault with a different guard, and counting it here would make
# this reading answer two questions at once.
make_tree ghost
seat ghost ghost ghost_witness.rish
g=$(read_scan ghost)
leg ghost_source_skipped 0 "$(field "$g" emit_sites)"
leg ghost_still_rostered 1 "$(field "$g" guards_rostered)"

# --- 6. mutations, each asserted to bite ------------------------------------------------------
mutate() {
  # mutate <name> <sed-expression> <tree> <field> <expected-under-mutation>
  # A THROUGH-WRITE RATHER THAN `sed -i`: the in-place flag takes an argument on BSD and none on
  # GNU, so the one spelling is two commands. `shell_dialect` gates that, and it bit a peer's pen
  # the day before this one was written.
  sed "$2" "$scan_abs" > "$pen/mutant.sh"
  if cmp -s "$scan_abs" "$pen/mutant.sh"; then
    legs=$((legs + 1)); fail=$((fail + 1))
    echo "leg $1 FAILED plant_matched_nothing"
    return
  fi
  got=$( cd "$pen/$3" && BUILD_TARGET_ROSTER=construction/roster.kyri sh "$pen/mutant.sh" 2>/dev/null | sed -n "s/^$4=//p" | head -1 )
  leg "$1" "$5" "$got"
}

# Drop the uniqueness of (path, guard) and one guard writing twice reads as two writers.
mutate mutation_sort_u 's|sort -u > "$pen/path_guard"|sort > "$pen/path_guard"|' twice max_writers 2

# Drop the hop bound to one and the nested literal reads as a fixed tree path.
# One hop resolves `${elder_dir}` to the string `${home}/elder` and stops, so the site falls out of
# `emit_fixed` into `emit_unresolved` rather than being miscounted as a tree path. The mutation is
# read where it lands.
mutate mutation_one_hop 's|-lt 4 \]; do|-lt 1 ]; do|' kinds emit_unresolved 2

# THE SEATED COUNT, AND THE COUNT THIS RUN REACHED. Two independent copies of one number: delete a
# leg and `legs_run` falls away from `LEGS_EXPECTED` here, and away from the number
# `tools/b/build_target_witness.rish` carries. `fail=0` is what an empty pen prints too.
LEGS_EXPECTED=33
echo "legs_expected=$LEGS_EXPECTED"
echo "legs_run=$legs"
[ "$legs" -eq "$LEGS_EXPECTED" ] || { echo "detail: legs_run $legs against seated $LEGS_EXPECTED" >&2; fail=$((fail + 1)); }
echo "fail=$fail"
if [ "$fail" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=failed"; exit 1; fi
