#!/bin/sh
# fleet_watch_codex.sh -- restart a stopped Codex loop when its seat is ready.
#
# This watch checks the fleet at a set interval. It reads each seat from the roster
# and finds its tmux window by name. A running loop keeps its seat. A stopped loop
# may start again once the window holds a shell prompt and its tree is ready.
#
# The watch keeps the stop files in charge. A hand can clock a ship out and trust
# that it stays stopped. A custody marker holds it for the same reason: the next
# choice belongs to a hand. Each held seat gets a message that says why.
#
# Window names are read fresh on each pass, so a changed window order is safe.
# A duplicate name holds the seat until a hand can choose the right window.
# Repeated starts that end too soon also hold the seat, with a count in the report.
# These checks keep the watch from typing into a busy pane or spending a night on
# a loop that needs help to start.
#
# Background: six ships stopped between 07:21 and 07:28 on 20260906, before their
# session limit reset at 07:30 (REDS %471). The loop now holds through that limit.
# This watch handles a loop that exits: a deadline, interrupt, closed terminal,
# or failure may leave a seat ready to start again.
#
# Usage:
#   sh tools/f/fleet_watch_codex.sh                  # watch until stopped
#   sh tools/f/fleet_watch_codex.sh --once           # one pass, then exit
#   sh tools/f/fleet_watch_codex.sh --once --dry-run # report one pass; send no keys
#
# --dry-run chooses what a pass may do; --once chooses how many passes run.
# Pair them to get a report that returns to the shell. --dry-run alone keeps
# watching at the chosen interval. The tutorial once showed that form as a
# command that would return, which is why the usage line now carries both flags.
#
# Settings and defaults (seconds for each time value):
#   WATCH_SESSION   this pane's tmux session, else pier
#   WATCH_INTERVAL  60 seconds between passes
#   WATCH_SKIP      incense; an explicit empty value includes every live seat
#   WATCH_ARM_MAX   3 fruitless starts before holding a seat
#   WATCH_SETTLE    180 seconds a started loop must last to clear its count
#   WATCH_PASSES    0 means keep watching; --once chooses 1 pass
#   WATCH_HOME      $HOME, the parent directory of each seat's tree
#   FLEET_BARE      1 is passed to each restart; Codex itself always runs bare
#   FLEET_ROSTER    optional seat table, read by fleet_roster_scan.sh
#
# Hold checks:
#   - a live Claude or Codex loop already owns the seat (%291)
#   - the pane holds something other than a shell at a complete prompt
#   - several windows share the seat's name, or its checkout is absent
#   - .loop-clockout or its elder spelling .loop-drain records a hand's stop
#   - .loop-gates-only, .mind-state/CUSTODY, or .mind-state/TRANSACTION holds work
#   - WATCH_ARM_MAX starts have ended inside WATCH_SETTLE
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
cd "$root"
[ -f construction/ITINERARY.md ] || { echo "fleet-watch-codex: $root is not a tree root"; exit 2; }

roster_scan=tools/fixtures/f/fleet_roster_scan.sh
[ -f "$roster_scan" ] || { echo "fleet-watch-codex: missing $roster_scan -- the seat table is unreadable"; exit 2; }

interval=${WATCH_INTERVAL:-60}
# `${WATCH_SKIP-incense}` rather than `:-` -- AN EXPLICIT EMPTY MEANS SKIP NOTHING. The colon form
# treats an empty value as unset and quietly restores the default, so a hand asking for no skips at
# all got the captain's bench skipped anyway and no message saying so. That is the fallback-reads-as-
# an-answer shape this tree books reds for, and it cost a night's incense loop on `20260907`. Unset
# still means the default; empty now means what it says.
skip=${WATCH_SKIP-incense}
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
  *) echo "fleet-watch-codex: unknown option $arg"; exit 2 ;;
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

command -v tmux >/dev/null 2>&1 || { echo "fleet-watch-codex: tmux is not on PATH -- nothing to watch"; exit 2; }
tmux has-session -t "$session" 2>/dev/null || { echo "fleet-watch-codex: no tmux session named '$session'"; exit 2; }

say() { printf 'fleet-watch-codex %s: %s\n' "$(TZ=America/New_York date +%H:%M:%S)" "$1"; }

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
  # process-reach: bounded -- a seat name, which construction/fleet-roster.kyri makes unique
  # across the whole fleet, so this pattern names one ship's loop and can match no peer's.
  pgrep -f "fleet-loop(-codex)?\.sh $1\$" >/dev/null 2>&1
}

pane_at_prompt() {
  # The last non-blank line of the pane ends in a shell prompt character. Fail closed: anything
  # else -- a running agent, a pager, a half-typed line -- reads as "not mine to type into".
  _commands=$(tmux list-panes -t "$session:$1" -F '#{pane_current_command}')
  case "$_commands" in bash|sh|zsh|fish) ;; *) return 1 ;; esac
  _tail=$(tmux capture-pane -p -t "$session:$1" 2>/dev/null | grep -v '^[[:space:]]*$' | tail -1)
  case "$_tail" in
  *'$'|*'$ '|*'#'|*'# ') return 0 ;;
  *) return 1 ;;
  esac
}

gated() {
  # The same wall fleet_rearm.sh prints instead of a paste.
  [ -f "$1/.loop-gates-only" ] && { echo "loop-gates-only"; return 0; }
  [ -f "$1/.loop-clockout" ] && { echo "loop-clockout"; return 0; }
  [ -f "$1/.loop-drain" ] && { echo "loop-drain"; return 0; }
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

    if loop_running "$seat"; then
      last=$(state_get "$armed_at" "$seat"); last=${last:-0}
      if [ "$last" -eq 0 ] || [ $((now - last)) -ge "$settle" ]; then
        fruitless=$(state_set "$fruitless" "$seat" 0)
        armed_at=$(state_set "$armed_at" "$seat" 0)
      fi
      continue
    fi

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
    # Codex runs bare by construction. Keep the watch's FLEET_BARE value in the
    # restart command as launch context; fleet-loop-codex.sh has no jail branch.
    line="cd $tree && ${bare_prefix}sh tools/f/fleet-loop-codex.sh $seat"
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
