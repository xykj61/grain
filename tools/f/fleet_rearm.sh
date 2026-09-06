#!/bin/sh
# fleet_rearm.sh -- after a loop stops, one run prints per seat: where its git
# stands, why it stopped, and the exact relaunch paste. It REFUSES to print a
# relaunch over a CUSTODY or TRANSACTION sentinel, because that choice belongs
# to the hand -- the supervisor's own law (tools/c/chatgpt-mind.rish), spoken
# here before the paste instead of after it.
#
#   sh tools/f/fleet_rearm.sh                    # every seat found under $HOME
#   FLEET_HOME=<dir> sh tools/f/fleet_rearm.sh   # the witness's pen door
#
# A printer, never an executor: the loops run in foreground terminals this
# script cannot reach, so the hand still pastes -- the script replaces the
# diagnosis, not the keystroke. Seated on the living card 20260830.211500,
# from the credits reading's first door.
#
# Bounds, and why: 9 seats (the three Earth ships plus the six aether seats,
# so absence is reported rather than silent); 8 tail lines and 800 bytes per
# stop-reason or sentinel print (enough to read a refusal, too little to flood
# a terminal).
set -eu

home=${FLEET_HOME:-$HOME}
git_bin=${FLEET_GIT:-git}

# This fleet spans a Mac and a Linux pier, so the mtime question has the tree's
# one answer rather than a second copy of it. Root by upward walk (the spelling
# every fixtures guard carries since the letter fold), then source the helper.
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
. "$_fd_root/tools/fixtures/s/shell_portable.sh"

# `file_mtime` asks GNU first, because GNU's refusal is the clean one: BSD `stat -f`
# on a GNU host reads as --file-system and prints a block report BEFORE the `||`
# ever fires, so a BSD-first pair answers with both legs concatenated (REDS %260).
# The helper answers in fractional seconds and the age arithmetic below is whole
# seconds, so the fraction is dropped here rather than in the shared answer.
mtime_of() {
  _m=$(file_mtime "$1" 2>/dev/null) || _m=
  [ -n "$_m" ] || _m=0
  echo "${_m%%.*}"
}

# One seat per call: name, directory under $home, kind (codex|claude|field).
report_seat() {
  name=$1
  dir=$2
  kind=$3
  tree="$home/$dir"
  echo ""
  echo "== $name -- $tree =="
  if [ ! -d "$tree" ]; then
    echo "   not on this host (directory absent) -- this seat runs elsewhere"
    return 0
  fi
  if [ "$kind" = field ]; then
    echo "   the interactive field -- no loop to re-arm (Incense unattended paste is the incense row)"
    return 0
  fi
  if [ ! -d "$tree/.git" ]; then
    echo "   directory stands yet holds no git repository -- not a seat tree"
    return 0
  fi

  head_now=$("$git_bin" -C "$tree" rev-parse --short=10 HEAD 2>/dev/null || echo unborn)
  dirty=$("$git_bin" -C "$tree" status --porcelain --ignore-submodules=all 2>/dev/null | wc -l | tr -d ' ')
  if "$git_bin" -C "$tree" fetch xy --quiet 2>/dev/null; then
    behind=$("$git_bin" -C "$tree" rev-list --count HEAD..xy/main 2>/dev/null || echo "?")
    ahead=$("$git_bin" -C "$tree" rev-list --count xy/main..HEAD 2>/dev/null || echo "?")
  else
    behind="?"
    ahead="?"
    echo "   (fetch of xy failed -- behind/ahead read the last known xy/main)"
  fi
  echo "   git: HEAD $head_now, $dirty uncommitted paths, behind xy/main: $behind, ahead: $ahead"

  # The stop reason, from where each kind writes it -- and its age, because a
  # seat whose words are minutes old may still be RUNNING, and a paste over a
  # live loop wrecks the lap it interrupts. The bounded print ends with its
  # own newline since head -c can cut a line mid-breath.
  activity=""
  if [ "$kind" = codex ] && [ -f "$tree/.mind-state/logs/supervisor.err" ]; then
    activity="$tree/.mind-state/logs/supervisor.err"
    echo "   last supervisor words:"
    tail -8 "$activity" 2>/dev/null | head -c 800 | sed 's/^/   | /'
    echo ""
  fi
  if { [ "$kind" = claude ] || [ "$kind" = cursor ]; } && [ -f "$tree/session-output/$name.txt" ]; then
    activity="$tree/session-output/$name.txt"
    echo "   last transcript words:"
    tail -8 "$activity" 2>/dev/null | head -c 800 | sed 's/^/   | /'
    echo ""
  fi
  if [ -n "$activity" ]; then
    age=$(( $(date +%s) - $(mtime_of "$activity") ))
    echo "   last activity ${age}s ago"
    if [ "$age" -lt 900 ]; then
      echo "   CAUTION -- words this fresh mean the loop may still be RUNNING; relaunch only a terminal that has stopped."
    fi
  fi

  # The wall before the paste: a sentinel means the choice belongs to the hand.
  for sentinel in CUSTODY TRANSACTION; do
    if [ -f "$tree/.mind-state/$sentinel" ]; then
      echo "   GATED -- .mind-state/$sentinel stands; no relaunch line is printed."
      head -c 800 "$tree/.mind-state/$sentinel" | sed 's/^/   | /'
      echo ""
      echo "   honor the recorded choice, then: rm $tree/.mind-state/$sentinel"
      return 0
    fi
  done

  if [ "$dirty" != "0" ]; then
    echo "   PARK FIRST -- the tree carries uncommitted leavings; the loop opens only clean:"
    echo "   cd $tree && git stash push -u -m \"mind-park hand re-arm leavings\""
  fi
  echo "   RELAUNCH:"
  case $name in
  mind)
    cat <<'PASTE'
   cd ~/grain-mind && git pull --ff-only xy main && GRAIN_ROOT=$(git rev-parse --show-toplevel) && (cd "$GRAIN_ROOT" && env MIND_SEAT=cardinal "$GRAIN_ROOT/rishi/bin/rishi" run "$GRAIN_ROOT/tools/c/chatgpt-mind.rish" loop --arm-loop --max-laps 3 --failure-ceiling 2 --backoff-seconds 15)
PASTE
    ;;
  mystery)
    cat <<'PASTE'
   cd ~/grain-mystery && git pull --ff-only xy main && GRAIN_ROOT=$(git rev-parse --show-toplevel) && (cd "$GRAIN_ROOT" && env MIND_SEAT=mystery "$GRAIN_ROOT/rishi/bin/rishi" run "$GRAIN_ROOT/tools/c/chatgpt-mind.rish" loop --arm-loop --max-laps 3 --failure-ceiling 2 --backoff-seconds 15)
PASTE
    ;;
  # EVERY OTHER SEAT IS A FLEET-LOOP SEAT, AND THE LINE IS DERIVED RATHER THAN LISTED (REDS %409's
  # lesson, one branch over). This arm used to spell six seat names -- silence, hush, dream,
  # incense, pheromone, petrichor -- and the roster grew five more without it: bakery, diffuser,
  # grass, copal, patchouli each fell through the case and printed the word RELAUNCH followed by
  # nothing. Five of eight LIVE ships could not be re-armed from the printer whose whole job is the
  # paste. The seat table drives the report already; it drives the paste now, so a ship added by one
  # roster row arrives here armed. `field` returned above and mind/mystery are matched by name, so
  # anything reaching this line is a loop seat by construction.
  *)
    echo "   cd $tree && git pull --ff-only xy main && sh tools/f/fleet-loop.sh $name"
    ;;
  esac
}

echo "fleet-rearm: the roster, every seat reported (home=$home)"
# ONE SEAT TABLE, READ RATHER THAN SPELLED (REDS %409). These rows were the fleet's sixth
# independent copy of seat -> tree -> engine, and they had already drifted from fleet-loop.sh's:
# this file reported nine seats where the loop admitted six, and the elder-name remap seated on
# Keaton's word `20260904` lived in the loop and never reached here. Both read the roster now.
#
# Mind and Mystery are absent from the roster on purpose -- they are Codex supervisor seats with
# their own law, and the relaunch case below still knows them by name. A seat this loop does not
# find is reported by the fallback rows beneath, so a roster that cannot be read still prints a
# card rather than nothing.
fleet_roster_scan="$_fd_root/tools/fixtures/f/fleet_roster_scan.sh"
if [ -f "$fleet_roster_scan" ]; then
  sh "$fleet_roster_scan" | while read -r _seat _tree _engine _status; do
    report_seat "$_seat" "$_tree" "$_engine"
  done
else
  echo "fleet-rearm: no seat table at $fleet_roster_scan -- reporting the seats this file knows"
  report_seat sound grain field
  report_seat incense grain-incense claude
  report_seat pheromone grain-pheromone claude
  report_seat petrichor grain-petrichor claude
  report_seat silence grain-silence claude
  report_seat hush grain-hush claude
  report_seat dream grain-dream codex
fi
report_seat mind grain-mind codex
report_seat mystery grain-mystery codex
echo ""
echo "fleet-rearm: a printed paste is an offer, never an act -- the hand chooses."
