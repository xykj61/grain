#!/bin/sh
# fleet_watch.sh -- the captain's watch: a loop that keeps the other loops alive.
#
# WHY THIS EXISTS. A fleet loop can die for four reasons -- three instant laps against an
# unreachable agent, a spent LOOP_HOURS deadline, an interrupt, or a terminal that closed -- and
# when it does, nothing brings it back. On `20260906` six ships stopped themselves between 07:21
# and 07:28 against a session limit that reset at 07:30, and the fleet sat dark until a hand woke
# up and read the panes (REDS %471). The hold seated in fleet-loop.sh answers the limit; this
# answers everything else, because a loop that has already exited cannot hold.
#
# WHAT IT DOES, once per interval: read the tmux windows BY NAME, match each name against the live
# seats in construction/fleet-roster.kyri, and for any seat whose `fleet-loop.sh <seat>` process is
# absent, send that seat's own relaunch line into that seat's own window.
#
# NOTHING IS NUMBERED. Window indices are discovered from `tmux list-windows` on every pass and are
# never written down here, because a layout written into a script is a layout that will be true
# until somebody moves a window -- and then the watcher types a ship's relaunch into a stranger's
# keyboard. The seat table already binds seat -> tree; tmux already binds name -> index; this file
# adds no third copy of either (REDS %409's law, one room over).
#
#   sh tools/l/fleet_watch.sh                 # watch until stopped
#   sh tools/l/fleet_watch.sh --once          # one pass, then exit
#   sh tools/l/fleet_watch.sh --dry-run       # decide and print; send no keystroke
#
# ENV, all bounded:
#   WATCH_SESSION   tmux session to read (default: this pane's session, else `pier`)
#   WATCH_INTERVAL  seconds between passes (default 60)
#   WATCH_SKIP      space-separated seats never armed (default `incense` -- the captain's own bench)
#   WATCH_ARM_MAX   consecutive fruitless arms before a seat is reported and left alone (default 3)
#   WATCH_SETTLE    seconds an armed loop must survive to count as taking hold (default 180)
#   WATCH_PASSES    stop after this many passes (default 0, unbounded; --once sets 1)
#   WATCH_HOME      the directory a seat's tree sits under (default $HOME) -- the control's pen door
#   FLEET_BARE      1 to re-arm every seat WITHOUT the jail, matching how the fleet was launched
#   FLEET_ROSTER    the seat table to read (honored by fleet_roster_scan.sh) -- the control's roster
#
# WHAT IT REFUSES, and why each refusal is the safe direction:
#   - a seat whose loop is ALREADY RUNNING -- one writer per checkout (%291); this is the whole
#     reason the check is a process lookup rather than a guess from the pane's words.
#   - a window whose pane does not end at a shell prompt -- somebody or something else has that
#     keyboard, and typing into it would interleave with their line.
#   - a seat name that appears on two windows -- ambiguous, and a watcher must never pick.
#   - a tree carrying .loop-gates-only, .mind-state/CUSTODY or .mind-state/TRANSACTION -- the same
#     wall fleet_rearm.sh stands behind: a gated choice belongs to a hand.
#   - a seat that has burned WATCH_ARM_MAX arms without taking hold -- the loop's own quickfail law
#     one level up. An arm that dies instantly every time is a fault upstream of the watcher, and
#     re-arming it forever is the shape this file exists to prevent, not to become.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
cd "$root"
[ -f construction/ITINERARY.md ] || { echo "fleet-watch: $root is not a tree root"; exit 2; }

roster_scan=tools/fixtures/f/fleet_roster_scan.sh
[ -f "$roster_scan" ] || { echo "fleet-watch: missing $roster_scan -- the seat table is unreadable"; exit 2; }

interval=${WATCH_INTERVAL:-60}
skip=${WATCH_SKIP:-incense}
arm_max=${WATCH_ARM_MAX:-3}
settle=${WATCH_SETTLE:-180}
passes_max=${WATCH_PASSES:-0}
watch_home=${WATCH_HOME:-$HOME}
# Passed through to every re-armed loop; empty unless this watcher was launched with FLEET_BARE=1.
bare_prefix=""
[ "${FLEET_BARE:-0}" = 1 ] && bare_prefix="FLEET_BARE=1 "
dry=0

for arg in "$@"; do
  case "$arg" in
  --once)    passes_max=1 ;;
  --dry-run) dry=1 ;;
  -h|--help) sed -n '2,40p' "$0"; exit 0 ;;
  *) echo "fleet-watch: unknown option $arg"; exit 2 ;;
  esac
done

# The session is discovered, not spelled: a watcher started inside the fleet's own tmux reads the
# session it is already in. `pier` is the fallback for a watcher started from outside one.
if [ -n "${WATCH_SESSION:-}" ]; then
  session=$WATCH_SESSION
elif [ -n "${TMUX:-}" ] && session=$(tmux display-message -p '#{session_name}' 2>/dev/null) && [ -n "$session" ]; then
  :
else
  session=pier
fi

command -v tmux >/dev/null 2>&1 || { echo "fleet-watch: tmux is not on PATH -- nothing to watch"; exit 2; }
tmux has-session -t "$session" 2>/dev/null || { echo "fleet-watch: no tmux session named '$session'"; exit 2; }

say() { printf 'fleet-watch %s: %s\n' "$(TZ=America/New_York date +%H:%M:%S)" "$1"; }

# Per-seat state, held in two space-separated strings rather than in files: a watcher that restarts
# has no history worth keeping, and a counter on disk is a counter that goes stale behind a reboot.
fruitless=""   # "seat:count" pairs
armed_at=""    # "seat:epoch" pairs

state_get() {
  # $1 = table, $2 = seat; prints the value or 0
  echo "$1" | tr ' ' '\n' | while IFS=: read -r k v; do
    [ "$k" = "$2" ] && { echo "$v"; break; }
  done | head -1
}

state_set() {
  # $1 = table, $2 = seat, $3 = value; prints the new table
  _out=""
  for pair in $1; do
    case "$pair" in "$2":*) continue ;; esac
    _out="$_out $pair"
  done
  echo "$_out $2:$3"
}

loop_running() {
  # invariant: a seat is healthy when its own loop process exists -- read from the process table,
  # never inferred from the pane's words, because a pane can print anything and a process cannot.
  pgrep -f "fleet-loop\.sh $1\$" >/dev/null 2>&1
}

pane_at_prompt() {
  # The last non-blank line of the pane ends in a shell prompt character. Fail closed: anything
  # else -- a running agent, a pager, a half-typed line -- reads as "not mine to type into".
  _tail=$(tmux capture-pane -p -t "$session:$1" 2>/dev/null | grep -v '^[[:space:]]*$' | tail -1)
  case "$_tail" in
  *'$'|*'$ '|*'#'|*'# ') return 0 ;;
  *) return 1 ;;
  esac
}

gated() {
  # The same wall fleet_rearm.sh prints instead of a paste.
  [ -f "$1/.loop-gates-only" ] && { echo "loop-gates-only"; return 0; }
  [ -f "$1/.mind-state/CUSTODY" ] && { echo "CUSTODY"; return 0; }
  [ -f "$1/.mind-state/TRANSACTION" ] && { echo "TRANSACTION"; return 0; }
  return 1
}

pass=0
say "watching session '$session' -- interval ${interval}s, skip '$skip', arm-max $arm_max, settle ${settle}s$([ "$dry" = 1 ] && echo ' (DRY RUN)')"

while :; do
  pass=$((pass + 1))
  now=$(date +%s)
  live=$(sh "$roster_scan" --live)
  windows=$(tmux list-windows -t "$session" -F '#{window_name}' 2>/dev/null || true)

  for seat in $live; do
    case " $skip " in *" $seat "*) continue ;; esac

    # name -> window, discovered every pass. Two windows wearing one name is ambiguous, and a
    # watcher that picks one is a watcher that will one day pick wrong.
    hits=$(printf '%s\n' "$windows" | grep -cx "$seat" || true)
    [ "$hits" = 0 ] && continue
    if [ "$hits" != 1 ]; then
      say "$seat -- $hits windows wear that name; refusing to choose"
      continue
    fi

    loop_running "$seat" && { fruitless=$(state_set "$fruitless" "$seat" 0); continue; }

    tree="$watch_home/$(sh "$roster_scan" --tree "$seat")"
    [ -d "$tree/.git" ] || { say "$seat -- no tree at $tree; not this host"; continue; }

    if reason=$(gated "$tree"); then
      say "$seat -- GATED by $reason; the choice belongs to a hand"
      continue
    fi

    # An arm that did not take hold counts against the seat. `settle` is read from when we armed it.
    last=$(state_get "$armed_at" "$seat"); last=${last:-0}
    count=$(state_get "$fruitless" "$seat"); count=${count:-0}
    if [ "$last" -gt 0 ] && [ $((now - last)) -lt "$settle" ]; then
      count=$((count + 1))
      fruitless=$(state_set "$fruitless" "$seat" "$count")
    fi

    if [ "$count" -ge "$arm_max" ]; then
      say "$seat -- $count arms in a row died inside ${settle}s; leaving it alone, a hand is needed"
      continue
    fi

    if ! pane_at_prompt "$seat"; then
      say "$seat -- loop absent yet the pane is not at a prompt; not typing into it"
      continue
    fi

    # NO PULL IN THE ARM LINE, on purpose. The hand-pasted relaunch carries `git pull --ff-only`
    # because a hand wants to see a refusal; a watcher does not, and an `&&` chain that stops on a
    # dirty tree would never reach the loop at all. fleet_round_open.sh is the loop's first act and
    # already fetches, clears an interrupted rebase, stashes a dead lap's leavings, and adopts the
    # anointed order -- strictly more than the pull, and it cannot refuse the launch.
    # THE ENCLOSURE CHOICE TRAVELS WITH THE WATCH. `fleet-loop.sh` wraps a Linux lap in
    # agent-jail unless `FLEET_BARE=1`, and Keaton's word `20260906` is that this pier runs
    # WITHOUT jails. A watcher that re-armed the default would quietly put the fleet back in the
    # enclosure one ship at a time, which is the worst shape a disagreement can take: nobody typed
    # it and nothing announced it. So the watch passes its OWN `FLEET_BARE` through, and a hand
    # launching the watch chooses for every re-arm it will ever make.
    line="cd $tree && ${bare_prefix}sh tools/l/fleet-loop.sh $seat"
    if [ "$dry" = 1 ]; then
      say "$seat -- WOULD ARM: $line"
    else
      tmux send-keys -t "$session:$seat" "$line" C-m
      armed_at=$(state_set "$armed_at" "$seat" "$now")
      say "$seat -- armed (arm $((count + 1)) of $arm_max)"
    fi
  done

  [ "$passes_max" -gt 0 ] && [ "$pass" -ge "$passes_max" ] && break
  sleep "$interval"
done

say "watch ended after $pass pass(es)"
