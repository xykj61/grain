#!/bin/sh
# fleet_watch_control.sh -- the captain's watch proven on a real tmux session in a throwaway pen.
#
# Every refusal is planted and then LIFTED, so a refusal proven only in the passing direction cannot
# be told from a watcher that refuses everything. The pen builds its own tmux session, its own seat
# table, and its own trees, so nothing here reads or touches the living fleet.
#
#   sh tools/fixtures/f/fleet_watch_control.sh
#
# Prints `pass=N fail=N` and exits non-zero on any failure. Bounded: 17 cases, one session, one pen.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
cd "$root"

watch=${FLEET_WATCH_TEST:-tools/f/fleet_watch.sh}
pen=${TMPDIR:-/tmp}/fleet-watch-pen-$$
sess=fleet-watch-pen-$$

# THE SEAT NAMES ARE UNIQUE PER RUN, and this line was written after the control reddened three
# times under a full roster pass and passed every time it was run alone (`20260907.000903`,
# `20260907.050053`, and this lap's cold open). `fleet_watch.sh` asks the process table
# `pgrep -f "fleet-loop\.sh <seat>$"`, which matches a command line by its ENDING and never by its
# path -- so the fake loop this control plants at `$pen/fleet-loop.sh penone` is indistinguishable
# from the one a PEER SHIP'S copy of this control plants in its own pen. Eight ships run the roster
# from eight trees on one pier, so two controls overlapping for one second is ordinary. Proven on
# metal this lap: with `sh /tmp/foreign-fleet/fleet-loop.sh penone` alive, case 1 fails with exactly
# the line the cold open printed. The pen was already unique in its directory and its tmux session;
# the seat name was the one thing it shared with every other pen on the host.
id=$$
s1=penone$id
s2=pentwo$id
s3=penthree$id
s4=penskip$id
s5=pengone$id

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
  # Scoped to THIS run's seat name: the elder line killed any `fleet-loop.sh penone`
  # on the host, which is a peer control's planted process (REDS %515's family).
  # process-reach: bounded -- $s1 is `penone$$`, unique to this control run, so the pattern
  # cannot reach a live seat or a peer control's planted process.
  pkill -f "fleet-loop\.sh $s1\$" 2>/dev/null || true
  rm -rf "$pen"
}
trap cleanup EXIT INT TERM

command -v tmux >/dev/null 2>&1 || { echo "fleet-watch-control: tmux absent -- cannot prove a tmux watcher"; exit 2; }

# -- the pen: three seats, three trees, one stranger window ------------------------------------
mkdir -p "$pen/grain-penone/.git" "$pen/grain-pentwo/.git" "$pen/grain-penthree/.git" "$pen/grain-penskip/.git"
cat > "$pen/roster.kyri" <<ROSTER
format fleet-roster-v1
seat $s1
tree grain-penone
engine claude
lane the pen's first seat
status live
seated 20260906.090000

seat $s2
tree grain-pentwo
engine claude
lane the pen's second seat
status live
seated 20260906.090000

seat $s3
tree grain-penthree
engine claude
lane the pen's third seat
status live
seated 20260906.090000

seat $s4
tree grain-penskip
engine claude
lane the seat the watcher is told to leave alone
status live
seated 20260906.090000

seat $s5
tree grain-pengone
engine claude
lane a live seat whose tree is not on this host
status live
seated 20260906.090000
ROSTER

# A detached session whose FIRST window is a stranger -- window 0 is never a ship.
tmux new-session -d -s "$sess" -n rishi 2>/dev/null
for w in "$s1" "$s2" "$s3" "$s4"; do tmux new-window -d -t "$sess" -n "$w" 2>/dev/null; done
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

# THE SAME SHAPE FOR THE PROCESS TABLE. Cases 10 and 11 planted a background loop and then slept a
# bare second before reading, in a file whose every other leg polls -- a fixed sleep is a guess
# about the machine's load, and a peer named this line as a candidate root on `20260907.050053`
# without being able to make it fire. Both directions poll now, bounded at 40 half-seconds, so a
# plant that never appears refuses instead of answering the wrong thing.
wait_loop() {
  _i=0
  while [ "$_i" -lt 40 ]; do
    # process-reach: bounded -- a pen-unique seat name passed in by the caller
    pgrep -f "fleet-loop\.sh $1\$" >/dev/null 2>&1 && return 0
    sleep 0.5
    _i=$((_i + 1))
  done
  return 1
}

wait_noloop() {
  _i=0
  while [ "$_i" -lt 40 ]; do
    # process-reach: bounded -- a pen-unique seat name passed in by the caller
    pgrep -f "fleet-loop\.sh $1\$" >/dev/null 2>&1 || return 0
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

for w in "$s1" "$s2" "$s3" "$s4"; do
  tmux send-keys -t "$sess:$w" '' C-m 2>/dev/null || true
done
for w in "$s1" "$s2" "$s3" "$s4"; do
  wait_prompt "$w" || { echo "refused: pen pane $w never reached a prompt" >&2; exit 2; }
done

# FLEET_BARE IS UNSET RATHER THAN MERELY UNPASSED, and this line was written after the control
# read it out of the caller's shell and answered the wrong thing. `env` without `-u` inherits, so
# a hand who had exported FLEET_BARE for any reason got a pen whose "no jail flag" case silently
# carried one. A control whose answer depends on who ran it is not a control.
run_watch() {
  env -u FLEET_BARE WATCH_SESSION="$sess" WATCH_HOME="$pen" FLEET_ROSTER="$pen/roster.kyri" \
      WATCH_PASSES=1 WATCH_SKIP="$s4" \
      sh "$watch" --dry-run 2>&1
}

out=$(run_watch)

# 1-3) a seat with a window, a tree, no loop and a prompt is armed -- and the stranger is not
check "penone would be armed"        yes "$(has "$out" "$s1 -- WOULD ARM")"
check "pentwo would be armed"        yes "$(has "$out" "$s2 -- WOULD ARM")"
check "the stranger window is never a ship" no "$(has "$out" 'rishi')"

# 3b) A PEER'S PEN CANNOT REACH THIS ONE. This is the leg the whole repair exists for: a loop
# planted from a foreign path under the ELDER shared seat name is exactly what a second copy of this
# control puts on the host, and `pgrep -f` matches a command line's ending rather than its path.
# Before the seat names carried this run's own id, this plant turned case 1 from WOULD ARM to
# silence -- the line three cold opens printed. Killed by PID, never by pattern, since a pattern
# kill is how a peer's process dies (REDS %515).
foreign_dir=$pen/foreign
mkdir -p "$foreign_dir"
printf '#!/bin/sh\nsleep 900\n' > "$foreign_dir/fleet-loop.sh"
chmod +x "$foreign_dir/fleet-loop.sh"
sh "$foreign_dir/fleet-loop.sh" penone >/dev/null 2>&1 &
foreign_pid=$!
wait_loop penone || { echo "refused: the foreign plant never reached the process table" >&2; exit 2; }
out_foreign=$(run_watch)
check "a peer pen's loop never blinds this one" yes "$(has "$out_foreign" "$s1 -- WOULD ARM")"
kill "$foreign_pid" 2>/dev/null || true
wait "$foreign_pid" 2>/dev/null || true

# 4) the skip list is honored
check "the skipped seat is left alone" no "$(has "$out" "$s4 -- WOULD ARM")"

# 5) a live seat with no window at all is silent, never an error
check "a seat with no window is silent" no "$(has "$out" "$s5")"

# 6-7) a gate refuses, and lifting it returns the arm
: > "$pen/grain-penthree/.loop-gates-only"
out_gated=$(run_watch)
check "a gated tree refuses the arm"  yes "$(has "$out_gated" "$s3 -- GATED by loop-gates-only")"
check "and prints no arm for it"      no  "$(has "$out_gated" "$s3 -- WOULD ARM")"
rm -f "$pen/grain-penthree/.loop-gates-only"
out_lifted=$(run_watch)
check "lifting the gate returns the arm" yes "$(has "$out_lifted" "$s3 -- WOULD ARM")"

# 8-9) a custody sentinel is the same wall, by its own name
mkdir -p "$pen/grain-penthree/.mind-state"
: > "$pen/grain-penthree/.mind-state/CUSTODY"
out_cust=$(run_watch)
check "a CUSTODY sentinel refuses"    yes "$(has "$out_cust" "$s3 -- GATED by CUSTODY")"
rm -f "$pen/grain-penthree/.mind-state/CUSTODY"

# 10-11) a running loop is left alone -- read from the process table, then proven by killing it
cat > "$pen/fleet-loop.sh" <<'LOOP'
#!/bin/sh
sleep 60
LOOP
chmod +x "$pen/fleet-loop.sh"
sh "$pen/fleet-loop.sh" "$s1" >/dev/null 2>&1 &
loop_pid=$!
wait_loop "$s1" || { echo "refused: the planted loop never reached the process table" >&2; exit 2; }
out_running=$(run_watch)
check "a running loop is never re-armed" no "$(has "$out_running" "$s1 -- WOULD ARM")"
kill "$loop_pid" 2>/dev/null || true
wait "$loop_pid" 2>/dev/null || true
wait_noloop "$s1" || { echo "refused: the planted loop never left the process table" >&2; exit 2; }
out_dead=$(run_watch)
check "and its death returns the arm"    yes "$(has "$out_dead" "$s1 -- WOULD ARM")"

# 12) a pane that is not at a prompt is never typed into
tmux send-keys -t "$sess:$s2" 'cat' C-m 2>/dev/null || true
wait_busy "$s2" || { echo "refused: pen pane pentwo never left its prompt" >&2; exit 2; }
out_busy=$(run_watch)
check "a busy pane refuses the keystroke" yes "$(has "$out_busy" "$s2 -- loop absent yet the pane is not at a prompt")"
tmux send-keys -t "$sess:$s2" C-c 2>/dev/null || true

# 13) two windows wearing one name is ambiguous, and the watcher refuses to choose
tmux new-window -d -t "$sess" -n "$s1" 2>/dev/null
wait_prompt "$s1" || true
out_dup=$(run_watch)
check "a duplicated window name refuses" yes "$(has "$out_dup" "$s1 -- 2 windows wear that name")"

# 14-15) the enclosure choice travels with the watch (Keaton's word 20260906: no jails on this
# pier). A watcher that re-armed the default would put the fleet back in the enclosure one ship at
# a time, unannounced -- so FLEET_BARE is passed through, and its absence is proven too.
out_bare=$(env WATCH_SESSION="$sess" WATCH_HOME="$pen" FLEET_ROSTER="$pen/roster.kyri" \
    WATCH_PASSES=1 WATCH_SKIP="$s4" FLEET_BARE=1 sh "$watch" --dry-run 2>&1)
check "FLEET_BARE travels into the arm line" yes "$(has "$out_bare" 'FLEET_BARE=1 sh tools/f/fleet-loop')"
check "and its absence leaves the line bare" no  "$(has "$(run_watch)" 'FLEET_BARE=1')"

# 16) an unknown option refuses rather than guessing
if env WATCH_SESSION="$sess" WATCH_HOME="$pen" FLEET_ROSTER="$pen/roster.kyri" sh "$watch" --nonsense >/dev/null 2>&1; then
  check "an unknown option refuses" refused accepted
else
  check "an unknown option refuses" refused refused
fi

printf 'pass=%d fail=%d\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
