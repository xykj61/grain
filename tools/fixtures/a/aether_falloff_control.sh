#!/bin/sh
# tools/fixtures/a/aether_falloff_control.sh -- can aether_falloff_scan.sh read a gradient that is
# there, and refuse to invent one that is not?
#
# WHY A CONTROL. The scan's whole finding is a NEGATIVE: the standing roster has no gradient to
# fall off. A scan that answered "no gradient" for every input would produce that finding on a
# tree that had a perfect one, and nothing in its own output could tell the two apart. So every
# reading below is proven from BOTH sides -- a pen built to have locality must show it, and a pen
# built to have none must show none -- and the anchor and distance rules are each planted and then
# lifted.
#
# HOW A PEN IS BUILT. Each pen is a real git repository holding `rishi/bin` and `tools/fixtures`,
# so the scan's upward root walk resolves exactly as it does in the tree, plus a roster, a scope
# map fixture, and real commits whose paths the scan reads from git. Nothing is stubbed: the pen
# exercises the same awk, the same git call, and the same bounds.
#
# Run from anywhere:  sh tools/fixtures/a/aether_falloff_control.sh

set -eu

_fd_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$_fd_root/rishi/bin" ] || [ ! -d "$_fd_root/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$_fd_root" = "/" ]; then
    echo "$0: no tree root within 8 steps" >&2; exit 2
  fi
  _fd_root=$(dirname "$_fd_root")
done
scan="$_fd_root/tools/fixtures/a/aether_falloff_scan.sh"
[ -f "$scan" ] || { echo "refused: no scan at $scan" >&2; exit 1; }

legs=0
faults=0
say() { printf '%s\n' "$*"; }
leg() {
  # leg NAME EXPECTED ACTUAL
  legs=$((legs + 1))
  if [ "$2" = "$3" ]; then
    say "leg $1 ok"
  else
    faults=$((faults + 1))
    say "leg $1 FAULT expected=$2 actual=$3"
  fi
}

pen_root="$(mktemp -d)"
trap 'rm -rf "$pen_root"' EXIT

# make_pen NAME -- an empty repository shaped like this tree's root.
make_pen() {
  p="$pen_root/$1"
  mkdir -p "$p/rishi/bin" "$p/tools/fixtures/a" "$p/tools/fixtures/s"
  cp "$scan" "$p/tools/fixtures/a/aether_falloff_scan.sh"
  ( cd "$p" && git init -q . && git config user.email pen@example.invalid \
      && git config user.name pen && git config commit.gpgsign false )
  printf '%s\n' "$p"
}

read_key() { printf '%s\n' "$2" | awk -F= -v k="$1" '$1 == k { print $2; exit }'; }

# ---------------------------------------------------------------------------------------------
# PEN ONE -- a roster with real locality. Four guards, each mapped to its own room, and a commit
# touching one room only. A gradient exists here, so the scan must find it: one guard at radius 0
# and the rest arriving later.
# ---------------------------------------------------------------------------------------------
p1=$(make_pen local)
for room in alpha beta gamma delta; do
  mkdir -p "$p1/$room"
  printf 'x\n' > "$p1/$room/file.rye"
done
mkdir -p "$p1/construction"
cat > "$p1/construction/roster.kyri" <<'ROSTER'
format standing-equipment-v1
guard g_alpha
path tools/a/g_alpha_witness.rish
guard g_beta
path tools/b/g_beta_witness.rish
guard g_gamma
path tools/g/g_gamma_witness.rish
guard g_delta
path tools/d/g_delta_witness.rish
ROSTER
cat > "$p1/tools/fixtures/s/map.sh" <<'MAP'
#!/bin/sh
cat <<'ROWS'
g_alpha alpha/
g_beta beta/
g_gamma gamma/
g_delta delta/
ROWS
MAP
( cd "$p1" && git add -A && git commit -qm 'pen: seed' )
printf 'y\n' > "$p1/alpha/file.rye"
( cd "$p1" && git add -A && git commit -qm 'pen: touch alpha only' )

out1=$( cd "$p1" && STANDING_ROSTER=construction/roster.kyri \
        STANDING_SCOPE_MAP=tools/fixtures/s/map.sh sh tools/fixtures/a/aether_falloff_scan.sh --window 1 --radius 6 2>&1 ) || true

leg local_verdict_ok ok "$(read_key verdict "$out1")"
leg local_guards_4 4 "$(read_key guards_total "$out1")"
leg local_mapped_4 4 "$(read_key mapped "$out1")"
leg local_absent_0 0 "$(read_key absent "$out1")"
leg local_floor_zero 0.000 "$(read_key floor_share "$out1")"
# alpha alone at radius 0; its three siblings are two hops away (up one, down one).
leg local_r0_one 1.00 "$(printf '%s\n' "$out1" | awk '{for(i=1;i<=NF;i++) if($i ~ /^woken_r0_mapped=/){split($i,a,"=");print a[2];exit}}')"
leg local_r1_one 1.00 "$(printf '%s\n' "$out1" | awk '{for(i=1;i<=NF;i++) if($i ~ /^woken_r1_mapped=/){split($i,a,"=");print a[2];exit}}')"
leg local_r2_four 4.00 "$(printf '%s\n' "$out1" | awk '{for(i=1;i<=NF;i++) if($i ~ /^woken_r2_mapped=/){split($i,a,"=");print a[2];exit}}')"
leg local_saturates_at_2 2 "$(read_key mapped_saturation_radius "$out1")"

# ---------------------------------------------------------------------------------------------
# PEN TWO -- the same four rooms and the same commit, with NO map at all. Every guard is absent,
# so every guard wakes at radius 0 and the floor is the whole roster. This is the shape the real
# tree is measured to be in, proven here from the other side.
# ---------------------------------------------------------------------------------------------
cat > "$p1/tools/fixtures/s/empty.sh" <<'MAP'
#!/bin/sh
:
MAP
out2=$( cd "$p1" && STANDING_ROSTER=construction/roster.kyri \
        STANDING_SCOPE_MAP=tools/fixtures/s/empty.sh sh tools/fixtures/a/aether_falloff_scan.sh --window 1 --radius 6 2>&1 ) || true
leg absent_verdict_ok ok "$(read_key verdict "$out2")"
leg absent_mapped_0 0 "$(read_key mapped "$out2")"
leg absent_absent_4 4 "$(read_key absent "$out2")"
leg absent_floor_whole 1.000 "$(read_key floor_share "$out2")"
leg absent_r0_share_whole 1.000 "$(printf '%s\n' "$out2" | awk '{for(i=1;i<=NF;i++) if($i ~ /^woken_r0_share=/){split($i,a,"=");print a[2];exit}}')"
leg absent_no_saturation none_within_bound "$(read_key mapped_saturation_radius "$out2")"

# ---------------------------------------------------------------------------------------------
# PEN THREE -- DISCOVERY is counted apart from ABSENT and lands in the same floor. The two are one
# floor and two different repairs, so a reading that merged them would hide which one a hand owes.
# ---------------------------------------------------------------------------------------------
cat > "$p1/tools/fixtures/s/disc.sh" <<'MAP'
#!/bin/sh
cat <<'ROWS'
g_alpha alpha/
g_beta DISCOVERY
ROWS
MAP
out3=$( cd "$p1" && STANDING_ROSTER=construction/roster.kyri \
        STANDING_SCOPE_MAP=tools/fixtures/s/disc.sh sh tools/fixtures/a/aether_falloff_scan.sh --window 1 --radius 6 2>&1 ) || true
leg disc_mapped_1 1 "$(read_key mapped "$out3")"
leg disc_discovery_1 1 "$(read_key discovery "$out3")"
leg disc_absent_2 2 "$(read_key absent "$out3")"
leg disc_floor_3 3 "$(read_key floor_count "$out3")"

# ---------------------------------------------------------------------------------------------
# PEN FOUR -- the anchor rule, one word shape per leg. A glob component truncates the anchor, a
# bare filename anchors at the root, and a room word anchors to its own room. Each is read through
# the distance it produces against a commit touching `alpha/file.rye`.
# ---------------------------------------------------------------------------------------------
cat > "$p1/tools/fixtures/s/anchors.sh" <<'MAP'
#!/bin/sh
cat <<'ROWS'
g_alpha alpha/
g_beta alpha/*/deep.rye
g_gamma README.md
g_delta beta/inner/leaf.rye
ROWS
MAP
out4=$( cd "$p1" && STANDING_ROSTER=construction/roster.kyri \
        STANDING_SCOPE_MAP=tools/fixtures/s/anchors.sh sh tools/fixtures/a/aether_falloff_scan.sh --window 1 --radius 6 --list 2>&1 ) || true
md() { printf '%s\n' "$out4" | awk -v g="$1" '$1 == "mean_distance" && $2 == g { print $3; exit }'; }
# alpha/ anchors at `alpha`, the touched directory itself.
leg anchor_room_zero 0.00 "$(md g_alpha)"
# alpha/*/deep.rye truncates at the glob, anchoring at `alpha` too.
leg anchor_glob_truncates 0.00 "$(md g_beta)"
# A bare filename anchors at the root, one hop from `alpha`.
leg anchor_bare_root_one 1.00 "$(md g_gamma)"
# beta/inner/leaf.rye anchors at `beta/inner`: up two, down one.
leg anchor_file_dirname_three 3.00 "$(md g_delta)"

# ---------------------------------------------------------------------------------------------
# PEN FIVE -- an orphan map row, naming a guard the roster never seated, is read past rather than
# counted as coverage. standing_equipment_scope_rank.sh is what GATES that fault; this proves only
# that it cannot inflate the mapped count here.
# ---------------------------------------------------------------------------------------------
cat > "$p1/tools/fixtures/s/orphan.sh" <<'MAP'
#!/bin/sh
cat <<'ROWS'
g_alpha alpha/
g_nowhere beta/
ROWS
MAP
out5=$( cd "$p1" && STANDING_ROSTER=construction/roster.kyri \
        STANDING_SCOPE_MAP=tools/fixtures/s/orphan.sh sh tools/fixtures/a/aether_falloff_scan.sh --window 1 --radius 6 2>&1 ) || true
leg orphan_mapped_1 1 "$(read_key mapped "$out5")"
leg orphan_absent_3 3 "$(read_key absent "$out5")"

# ---------------------------------------------------------------------------------------------
# PEN SIX -- the refusals. Each is proven by its exit status and its own message, since a refusal
# that exits zero is a reading nobody receives.
# ---------------------------------------------------------------------------------------------
# WHY THE STATUS IS CAPTURED THIS WAY. Under `set -e` a failing command that is not the last in
# its list ends the shell, so the familiar `cmd; echo $?` would never reach the echo -- and the
# leg would read empty rather than refused, which is the one answer a refusal test must never give.
refuse_code() {
  _rc=0
  ( cd "$p1" && STANDING_ROSTER=construction/roster.kyri \
    STANDING_SCOPE_MAP=tools/fixtures/s/map.sh sh tools/fixtures/a/aether_falloff_scan.sh "$@" \
    >/dev/null 2>&1 ) || _rc=$?
  echo "$_rc"
}
exit_of() {
  # exit_of ROSTER MAP [ARGS...] -- the scan's own exit status, captured set -e safely.
  _er=0
  _r=$1; _m=$2; shift 2
  ( cd "$p1" && STANDING_ROSTER="$_r" STANDING_SCOPE_MAP="$_m" \
    sh tools/fixtures/a/aether_falloff_scan.sh "$@" >/dev/null 2>&1 ) || _er=$?
  echo "$_er"
}
leg refuse_unknown_flag 2 "$(refuse_code --nope)"
leg refuse_window_word 2 "$(refuse_code --window many)"
leg refuse_window_zero 2 "$(refuse_code --window 0)"
leg refuse_window_past_bound 2 "$(refuse_code --window 501)"
leg refuse_radius_past_bound 2 "$(refuse_code --radius 13)"
leg refuse_radius_word 2 "$(refuse_code --radius far)"
leg refuse_missing_roster 1 "$(exit_of construction/absent.kyri tools/fixtures/s/map.sh)"
leg refuse_missing_map 1 "$(exit_of construction/roster.kyri tools/fixtures/s/absent.sh)"
cat > "$p1/tools/fixtures/s/broken.sh" <<'MAP'
#!/bin/sh
exit 3
MAP
leg refuse_failing_map 1 "$(exit_of construction/roster.kyri tools/fixtures/s/broken.sh)"
cat > "$p1/construction/empty-roster.kyri" <<'ROSTER'
format standing-equipment-v1
ROSTER
leg refuse_empty_roster 1 "$(exit_of construction/empty-roster.kyri tools/fixtures/s/map.sh)"

# A radius of zero is lawful and is the reading row 4's falsifier turns on, so it must pass rather
# than refuse.
leg radius_zero_lawful 0 "$(exit_of construction/roster.kyri tools/fixtures/s/map.sh --radius 0)"

# ---------------------------------------------------------------------------------------------
# PEN SEVEN -- the mutation. The anchor rule is the scan's one piece of judgment, so it is broken
# on a copy and the copy must read differently. A mutation that changes no reading is a rule the
# control never tested.
# ---------------------------------------------------------------------------------------------
mut="$p1/tools/fixtures/a/mutant_scan.sh"
sed 's|if (comp ~ /\[\*?\[\]/) break|if (0) break|' "$scan" > "$mut"
if cmp -s "$scan" "$mut"; then
  faults=$((faults + 1)); legs=$((legs + 1))
  say "leg mutation_planted FAULT plant_matched_nothing"
else
  legs=$((legs + 1)); say "leg mutation_planted ok"
  out7=$( cd "$p1" && STANDING_ROSTER=construction/roster.kyri \
          STANDING_SCOPE_MAP=tools/fixtures/s/anchors.sh sh tools/fixtures/a/mutant_scan.sh --window 1 --radius 6 --list 2>&1 ) || true
  mutated=$(printf '%s\n' "$out7" | awk '$1 == "mean_distance" && $2 == "g_beta" { print $3; exit }')
  legs=$((legs + 1))
  if [ "$mutated" = "0.00" ]; then
    faults=$((faults + 1)); say "leg mutation_bit FAULT the broken anchor rule read the same"
  else
    say "leg mutation_bit ok mutant_read=$mutated"
  fi
fi

say "legs=$legs"
say "faults=$faults"
if [ "$faults" -eq 0 ]; then say "control_verdict=ok"; else say "control_verdict=faults"; exit 1; fi
