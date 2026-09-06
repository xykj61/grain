#!/bin/sh
# fleet_watch_control.sh -- the captain's watch proven on a real tmux session in a throwaway pen.
#
# Every refusal is planted and then LIFTED, so a refusal proven only in the passing direction cannot
# be told from a watcher that refuses everything. The pen builds its own tmux session, its own seat
# table, and its own trees, so nothing here reads or touches the living fleet.
#
#   sh tools/fixtures/l/fleet_watch_control.sh
#
# Prints `pass=N fail=N` and exits non-zero on any failure. Bounded: 14 cases, one session, one pen.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
cd "$root"

watch=tools/l/fleet_watch.sh
pen=${TMPDIR:-/tmp}/fleet-watch-pen-$$
sess=fleet-watch-pen-$$

pass=0
fail=0
check() {
  if [ "$3" = "$2" ]; then pass=$((pass + 1)); else
    fail=$((fail + 1)); printf 'FAIL %s -- wanted %s, got %s\n' "$1" "$2" "$3" >&2
  fi
}
has() { case "$1" in *"$2"*) echo yes ;; *) echo no ;; esac; }

cleanup() {
  tmux kill-session -t "$sess" 2>/dev/null || true
  pkill -f "fleet-loop\.sh penone\$" 2>/dev/null || true
  rm -rf "$pen"
}
trap cleanup EXIT INT TERM

command -v tmux >/dev/null 2>&1 || { echo "fleet-watch-control: tmux absent -- cannot prove a tmux watcher"; exit 2; }

# -- the pen: three seats, three trees, one stranger window ------------------------------------
mkdir -p "$pen/grain-penone/.git" "$pen/grain-pentwo/.git" "$pen/grain-penthree/.git" "$pen/grain-penskip/.git"
cat > "$pen/roster.kyri" <<'ROSTER'
format fleet-roster-v1
seat penone
tree grain-penone
engine claude
lane the pen's first seat
status live
seated 20260906.090000

seat pentwo
tree grain-pentwo
engine claude
lane the pen's second seat
status live
seated 20260906.090000

seat penthree
tree grain-penthree
engine claude
lane the pen's third seat
status live
seated 20260906.090000

seat penskip
tree grain-penskip
engine claude
lane the seat the watcher is told to leave alone
status live
seated 20260906.090000

seat pengone
tree grain-pengone
engine claude
lane a live seat whose tree is not on this host
status live
seated 20260906.090000
ROSTER

# A detached session whose FIRST window is a stranger -- window 0 is never a ship.
tmux new-session -d -s "$sess" -n rishi 2>/dev/null
for w in penone pentwo penthree penskip; do tmux new-window -d -t "$sess" -n "$w" 2>/dev/null; done
# let each pane reach its prompt

# WAIT FOR A PANE TO REACH ITS PROMPT, rather than sleeping a number and hoping. A fixed sleep is a
# guess about the machine's load, and this pen runs beside a full roster pass and seven ships: on
# `20260906` the control passed by hand and reddened inside that pass, which is the shape a flaky
# guard takes -- it teaches a reader to re-run rather than to trust. Bounded at 40 half-seconds, so
# a pane that never arrives refuses instead of hanging.
wait_prompt() {
  _w=$1
  _i=0
  while [ "$_i" -lt 40 ]; do
    case "$(tmux capture-pane -p -t "$sess:$_w" 2>/dev/null | grep -v '^[[:space:]]*$' | tail -1)" in
      *'$'|*'$ '|*'#'|*'# ') return 0 ;;
    esac
    sleep 0.5
    _i=$((_i + 1))
  done
  return 1
}

# The same shape for a pane that must NOT be at a prompt -- case 12 sends `cat` and needs the pane
# to have actually taken it before the watcher reads.
wait_busy() {
  _w=$1
  _i=0
  while [ "$_i" -lt 40 ]; do
    case "$(tmux capture-pane -p -t "$sess:$_w" 2>/dev/null | grep -v '^[[:space:]]*$' | tail -1)" in
      *'$'|*'$ '|*'#'|*'# ') : ;;
      *) return 0 ;;
    esac
    sleep 0.5
    _i=$((_i + 1))
  done
  return 1
}

for w in penone pentwo penthree penskip; do
  tmux send-keys -t "$sess:$w" '' C-m 2>/dev/null || true
done
for w in penone pentwo penthree penskip; do
  wait_prompt "$w" || { echo "refused: pen pane $w never reached a prompt" >&2; exit 2; }
done

run_watch() {
  env WATCH_SESSION="$sess" WATCH_HOME="$pen" FLEET_ROSTER="$pen/roster.kyri" \
      WATCH_PASSES=1 WATCH_SKIP=penskip \
      sh "$watch" --dry-run 2>&1
}

out=$(run_watch)

# 1-3) a seat with a window, a tree, no loop and a prompt is armed -- and the stranger is not
check "penone would be armed"        yes "$(has "$out" 'penone -- WOULD ARM')"
check "pentwo would be armed"        yes "$(has "$out" 'pentwo -- WOULD ARM')"
check "the stranger window is never a ship" no "$(has "$out" 'rishi')"

# 4) the skip list is honored
check "the skipped seat is left alone" no "$(has "$out" 'penskip -- WOULD ARM')"

# 5) a live seat with no window at all is silent, never an error
check "a seat with no window is silent" no "$(has "$out" 'pengone')"

# 6-7) a gate refuses, and lifting it returns the arm
: > "$pen/grain-penthree/.loop-gates-only"
out_gated=$(run_watch)
check "a gated tree refuses the arm"  yes "$(has "$out_gated" 'penthree -- GATED by loop-gates-only')"
check "and prints no arm for it"      no  "$(has "$out_gated" 'penthree -- WOULD ARM')"
rm -f "$pen/grain-penthree/.loop-gates-only"
out_lifted=$(run_watch)
check "lifting the gate returns the arm" yes "$(has "$out_lifted" 'penthree -- WOULD ARM')"

# 8-9) a custody sentinel is the same wall, by its own name
mkdir -p "$pen/grain-penthree/.mind-state"
: > "$pen/grain-penthree/.mind-state/CUSTODY"
out_cust=$(run_watch)
check "a CUSTODY sentinel refuses"    yes "$(has "$out_cust" 'penthree -- GATED by CUSTODY')"
rm -f "$pen/grain-penthree/.mind-state/CUSTODY"

# 10-11) a running loop is left alone -- read from the process table, then proven by killing it
cat > "$pen/fleet-loop.sh" <<'LOOP'
#!/bin/sh
sleep 60
LOOP
chmod +x "$pen/fleet-loop.sh"
sh "$pen/fleet-loop.sh" penone >/dev/null 2>&1 &
loop_pid=$!
sleep 1
out_running=$(run_watch)
check "a running loop is never re-armed" no "$(has "$out_running" 'penone -- WOULD ARM')"
kill "$loop_pid" 2>/dev/null || true
wait "$loop_pid" 2>/dev/null || true
sleep 1
out_dead=$(run_watch)
check "and its death returns the arm"    yes "$(has "$out_dead" 'penone -- WOULD ARM')"

# 12) a pane that is not at a prompt is never typed into
tmux send-keys -t "$sess:pentwo" 'cat' C-m 2>/dev/null || true
wait_busy pentwo || { echo "refused: pen pane pentwo never left its prompt" >&2; exit 2; }
out_busy=$(run_watch)
check "a busy pane refuses the keystroke" yes "$(has "$out_busy" 'pentwo -- loop absent yet the pane is not at a prompt')"
tmux send-keys -t "$sess:pentwo" C-c 2>/dev/null || true

# 13) two windows wearing one name is ambiguous, and the watcher refuses to choose
tmux new-window -d -t "$sess" -n penone 2>/dev/null
wait_prompt penone || true
out_dup=$(run_watch)
check "a duplicated window name refuses" yes "$(has "$out_dup" 'penone -- 2 windows wear that name')"

# 14) an unknown option refuses rather than guessing
if env WATCH_SESSION="$sess" WATCH_HOME="$pen" FLEET_ROSTER="$pen/roster.kyri" sh "$watch" --nonsense >/dev/null 2>&1; then
  check "an unknown option refuses" refused accepted
else
  check "an unknown option refuses" refused refused
fi

printf 'pass=%d fail=%d\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
