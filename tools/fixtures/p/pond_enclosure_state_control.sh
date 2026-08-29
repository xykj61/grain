#!/usr/bin/env sh
# pond_enclosure_state_control.sh -- prove the enclosure state-room guard from both sides.
#
# WHY. A refusal proven only in the passing direction cannot be told from a bypass. Every behavior
# below is exercised against real files in a throwaway pen, so the scan is asked the same question
# the tree asks it rather than a question shaped to the answer. The bound is proven from both
# sides -- sixteen adopt pairs pass and seventeen refuse -- so no override exists and none is
# wanted.
#
# WHAT IT PROVES -- six refusals bitten, seven honest readings left free:
#
#   BITTEN                                          FREE
#   1  one variable pinned to its elder path        1  an example naming no state path at all
#   2  two pinned, the tree's own 20260828 shape    2  an example naming the seated room
#   3  an elder pinned without the $REPO/ prefix    3  an example naming a third, deliberate path
#   4  an adopt roster past max_pairs (17)          4  a room variable no adopt pair ever names
#   5  a launcher that is not there                 5  a host conf pinning an elder -- reported
#   6  an example that is not there                 6  a stranded room on disk -- reported
#                                                   7  an adopt roster exactly at 16
#
# USAGE
#   sh tools/fixtures/p/pond_enclosure_state_control.sh
#
# Driven by tools/p/pond_enclosure_state_witness.rish. Run from the repository root.
set -eu

SCAN=$(cd "$(dirname "$0")" && pwd)/pond_enclosure_state_scan.sh
[ -f "$SCAN" ] || { echo "control=absent detail=no_scan"; exit 1; }

PEN=$(mktemp -d "${TMPDIR:-/tmp}/pond-enclosure-state-control.XXXXXX")
trap 'rm -rf "$PEN"' EXIT INT TERM

pass=0
fail=0
note() {
  if [ "$1" = ok ]; then
    pass=$((pass + 1)); echo "ok   $2"
  else
    fail=$((fail + 1)); echo "FAIL $2"
  fi
}

# pen_root <name> -- a fresh pen root carrying the two directories the scan reads.
pen_root() {
  root="$PEN/$1"
  rm -rf "$root"
  mkdir -p "$root/tools/ag" "$root/tools/e" "$root/loops"
  echo "$root"
}

# launcher <root> <pairs...> -- write a launcher seating N adopt pairs and their room variables.
# Each pair is "<elder-basename>:<room>:<VAR_NAME>".
launcher() {
  root=$1; shift
  {
    echo '#!/usr/bin/env bash'
    echo 'LOOPS="${LOOPS:-$REPO/loops}"'
    for spec in "$@"; do
      elder=${spec%%:*}; rest=${spec#*:}; room=${rest%%:*}
      echo "adopt_state_dir \"\$REPO/$elder\"        \"\$LOOPS/$room\""
    done
    for spec in "$@"; do
      rest=${spec#*:}; room=${rest%%:*}; var=${rest#*:}
      echo "$var=\"\${$var:-\$LOOPS/$room}\""
    done
  } >"$root/tools/ag/agent-jail.sh"
}

# run_scan <root> -- print the scan output; never abort the control on a refusal.
run_scan() {
  set +e
  out=$(sh "$SCAN" --root "$1" 2>&1)
  code=$?
  set -e
  printf '%s\n' "$out"
  return $code
}

expect_verdict() {
  want=$1; root=$2; label=$3
  out=$(run_scan "$root" || true)
  got=$(printf '%s\n' "$out" | sed -n 's/^verdict=//p' | tail -1)
  if [ "$got" = "$want" ]; then note ok "$label (verdict=$got)"; else note FAIL "$label -- want verdict=$want got '${got:-none}'"; printf '%s\n' "$out"; fi
}

expect_reading() {
  key=$1; want=$2; root=$3; label=$4
  out=$(run_scan "$root" || true)
  got=$(printf '%s\n' "$out" | sed -n "s/^$key=//p" | tail -1)
  if [ "$got" = "$want" ]; then note ok "$label ($key=$got)"; else note FAIL "$label -- want $key=$want got '${got:-none}'"; printf '%s\n' "$out"; fi
}

THREE="claude-state:claude:CLAUDE_STATE cursor-state:cursor:CURSOR_AGENT_STATE dream-state:codex:CODEX_STATE"

# --- BITTEN 1: one variable pinned to its elder --------------------------------------------
root=$(pen_root bit1); launcher "$root" $THREE
printf 'CLAUDE_STATE="$REPO/claude-state"\n' >"$root/tools/e/enclosure.conf.example"
expect_verdict pinned_elder "$root" "BITTEN one variable pinned to its elder"
expect_reading pinned_elders 1 "$root" "BITTEN the pinned variable is counted once"

# --- BITTEN 2: two pinned, the shape this tree carried on 20260828 -------------------------
root=$(pen_root bit2); launcher "$root" $THREE
printf 'CLAUDE_STATE="$REPO/claude-state"\nCURSOR_AGENT_STATE="$REPO/cursor-state"\n' >"$root/tools/e/enclosure.conf.example"
expect_reading pinned_elders 2 "$root" "BITTEN the tree's own two-pin shape"

# --- BITTEN 3: an elder pinned without the $REPO/ prefix -----------------------------------
root=$(pen_root bit3); launcher "$root" $THREE
printf 'CLAUDE_STATE="claude-state"\n' >"$root/tools/e/enclosure.conf.example"
expect_verdict pinned_elder "$root" "BITTEN a bare relative elder path still refuses"

# --- BITTEN 4: an adopt roster past max_pairs ----------------------------------------------
root=$(pen_root bit4)
seventeen=""
i=1; while [ "$i" -le 17 ]; do seventeen="$seventeen s$i-state:room$i:VAR${i}_STATE"; i=$((i + 1)); done
launcher "$root" $seventeen
: >"$root/tools/e/enclosure.conf.example"
expect_verdict unbounded "$root" "BITTEN seventeen adopt pairs pass the bound"

# --- BITTEN 5 and 6: a half of the seam that is not there ----------------------------------
root=$(pen_root bit5); : >"$root/tools/e/enclosure.conf.example"
out=$(run_scan "$root" || true)
printf '%s\n' "$out" | grep -q 'detail=no_launcher' && note ok "BITTEN an absent launcher is named" || note FAIL "BITTEN absent launcher"
root=$(pen_root bit6); launcher "$root" $THREE
out=$(run_scan "$root" || true)
printf '%s\n' "$out" | grep -q 'detail=no_example' && note ok "BITTEN an absent example is named" || note FAIL "BITTEN absent example"

# --- FREE 1: an example naming no state path at all ----------------------------------------
root=$(pen_root free1); launcher "$root" $THREE
printf '# nothing but a comment\nUSE_GPU=true\n' >"$root/tools/e/enclosure.conf.example"
expect_verdict green "$root" "FREE an example naming no state path"
expect_reading absent_pins 3 "$root" "FREE all three defaults are left to win"

# --- FREE 2: an example naming the seated room ---------------------------------------------
root=$(pen_root free2); launcher "$root" $THREE
printf 'CLAUDE_STATE="$REPO/loops/claude"\n' >"$root/tools/e/enclosure.conf.example"
expect_verdict green "$root" "FREE an example naming the seated room"
expect_reading agreeing_pins 1 "$root" "FREE the agreeing pin is counted as agreeing"

# --- FREE 3: a third path, neither elder nor room ------------------------------------------
root=$(pen_root free3); launcher "$root" $THREE
printf 'CLAUDE_STATE="/srv/agent/claude"\n' >"$root/tools/e/enclosure.conf.example"
expect_verdict green "$root" "FREE a deliberate third path is not an elder"

# --- FREE 4: a room variable no adopt pair ever names ---------------------------------------
root=$(pen_root free4)
launcher "$root" "claude-state:claude:CLAUDE_STATE"
printf 'ZED_STATE="$REPO/zed-state"\n' >"$root/tools/e/enclosure.conf.example"
expect_verdict green "$root" "FREE a variable outside the adopt roster"

# --- FREE 5: a host conf pinning an elder is reported, never gated --------------------------
root=$(pen_root free5); launcher "$root" $THREE
: >"$root/tools/e/enclosure.conf.example"
printf 'CLAUDE_STATE="$REPO/claude-state"\n' >"$root/tools/e/enclosure.conf"
expect_verdict green "$root" "FREE a host conf pinning an elder stays green"
expect_reading host_pinned_elders 1 "$root" "FREE the host pin is reported"

# --- FREE 6: a stranded room on disk is reported, never gated -------------------------------
root=$(pen_root free6); launcher "$root" $THREE
: >"$root/tools/e/enclosure.conf.example"
mkdir -p "$root/claude-state" "$root/loops/claude"
: >"$root/loops/claude/credentials.json"
expect_verdict green "$root" "FREE a stranded room stays green"
expect_reading stranded_rooms 1 "$root" "FREE the stranded room is reported"

# --- FREE 7: an adopt roster exactly at the bound -------------------------------------------
root=$(pen_root free7)
sixteen=""
i=1; while [ "$i" -le 16 ]; do sixteen="$sixteen s$i-state:room$i:VAR${i}_STATE"; i=$((i + 1)); done
launcher "$root" $sixteen
: >"$root/tools/e/enclosure.conf.example"
expect_verdict green "$root" "FREE sixteen adopt pairs sit exactly at the bound"


# --- The heal, exercised exactly as the launcher ships it -----------------------------------
# prefer_adopted_room is LIFTED OUT of tools/ag/agent-jail.sh rather than copied here, so these
# legs prove the code that actually runs rather than a second spelling of it. Losing the source
# makes the leg refuse instead of guess -- the same discipline qa_report_card.sh keeps when it
# lifts measure() out of prose_register_scan.sh.
# Root by upward walk (seated 20260828): the letter fold moved this script one
# directory deeper, and fixed ../.. depth arithmetic is what broke. The walk finds
# the first ancestor holding rishi/bin and tools/fixtures -- git-free so pen copies
# outside a repository still resolve -- bounded at 8 steps, loud past the bound.
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
JAIL_SRC=$_fd_root/tools/ag/agent-jail.sh
if [ ! -f "$JAIL_SRC" ]; then
  note FAIL "HEAL the launcher source is absent"
else
  sed -n '/^prefer_adopted_room() {$/,/^}$/p' "$JAIL_SRC" >"$PEN/heal.bash"
  if [ ! -s "$PEN/heal.bash" ]; then
    note FAIL "HEAL prefer_adopted_room could not be lifted from the launcher"
  else
    heal_case() {
      # heal_case <label> <pin-shape> <room-shape> <want>
      #   pin-shape:  absent | empty | occupied | same
      #   room-shape: empty | occupied
      label=$1; pinshape=$2; roomshape=$3; want=$4
      case_dir="$PEN/heal-$(echo "$label" | tr ' ' '-')"
      rm -rf "$case_dir"; mkdir -p "$case_dir/loops/claude"
      [ "$roomshape" = occupied ] && : >"$case_dir/loops/claude/credentials.json"
      case "$pinshape" in
        empty) mkdir -p "$case_dir/claude-state" ;;
        occupied) mkdir -p "$case_dir/claude-state"; : >"$case_dir/claude-state/settings.json" ;;
      esac
      pin="$case_dir/claude-state"
      [ "$pinshape" = same ] && pin="$case_dir/loops/claude"
      got=$(bash -c '
        . "$1"
        CLAUDE_STATE="$2"
        prefer_adopted_room CLAUDE_STATE "$3" 2>/dev/null
        printf "%s" "$CLAUDE_STATE"
      ' _ "$PEN/heal.bash" "$pin" "$case_dir/loops/claude")
      if [ "$want" = room ]; then expect="$case_dir/loops/claude"; else expect="$pin"; fi
      if [ "$got" = "$expect" ]; then note ok "HEAL $label"; else note FAIL "HEAL $label -- want $expect got $got"; fi
    }
    heal_case "an absent pin yields to an occupied room"   absent   occupied room
    heal_case "an empty pin yields to an occupied room"    empty    occupied room
    heal_case "an occupied pin keeps its place"            occupied occupied pin
    heal_case "an empty room never outranks a pin"         empty    empty    pin
    heal_case "a pin already naming the room is a no-op"   same     occupied pin
    said=$(bash -c '
      . "$1"
      mkdir -p "$2/loops/claude" "$2/claude-state"
      : >"$2/loops/claude/credentials.json"
      CLAUDE_STATE="$2/claude-state"
      prefer_adopted_room CLAUDE_STATE "$2/loops/claude" 2>&1 >/dev/null
    ' _ "$PEN/heal.bash" "$PEN/heal-said")
    case "$said" in
      *"holds no file"*) note ok "HEAL the swap is announced on stderr" ;;
      *) note FAIL "HEAL the swap said nothing: '$said'" ;;
    esac
  fi
fi

echo "control_pass=$pass"
echo "control_fail=$fail"
if [ "$fail" -ne 0 ]; then echo "control=red"; exit 1; fi
echo "control=green"
