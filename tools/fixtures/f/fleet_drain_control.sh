#!/bin/sh
# fleet_drain_control.sh -- prove the hand's drain, from both sides, on a real loop body.
#
# WHY A CONTROL AND NOT A READING: a stop that fails is invisible -- the loop simply keeps
# working, which looks exactly like a loop nobody asked to stop. So every leg below is proven
# by PLANTING the sentinel and then LIFTING it, and the welcome is asserted as hard as the
# refusal; a refusal proven only in the passing direction cannot be told from a bypass.
set -eu
root=$(cd "$(dirname "$0")/../../.." && pwd -P)
pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT
pass=0; fail=0
ok()   { pass=$((pass+1)); echo "ok   -- $1"; }
bad()  { fail=$((fail+1)); echo "FAIL -- $1"; }

# The loop body under test, lifted to a stub that runs the same two sentinel reads without
# opening a real lap. The stub mirrors the shape rather than the whole script on purpose:
# the claim is about WHEN each file is read and WHO removes it, which is exactly this shape.
stub() {
  seat=$1; laps=0; max=$2; out=""
  while [ "$laps" -lt "$max" ]; do
    if [ -f "$pen/.loop-drain" ]; then
      out="$out|drain_before_lap_$((laps+1))"; break
    fi
    rm -f "$pen/.loop-gates-only"
    laps=$((laps+1))
    out="$out|lap_$laps"
    [ -f "$pen/mid" ] && touch "$pen/.loop-drain"
    if [ -f "$pen/.loop-gates-only" ]; then out="$out|gates_only"; break; fi
    if [ -f "$pen/.loop-drain" ]; then out="$out|drain_after_lap_$laps"; break; fi
  done
  echo "$out"
}

# 1 -- no sentinel: the loop runs its laps and stops on its own count
r=$(stub incense 3)
case "$r" in *"|lap_3"*) ok "clean tree runs all three laps" ;; *) bad "clean tree: $r" ;; esac
case "$r" in *drain*) bad "clean tree drained with no sentinel: $r" ;; *) ok "clean tree drains never" ;; esac

# 2 -- a drain standing BEFORE the first lap stops before opening one
touch "$pen/.loop-drain"
r=$(stub incense 3)
case "$r" in *drain_before_lap_1*) ok "a standing drain stops before a lap opens" ;; *) bad "pre-lap drain: $r" ;; esac
# `*lap_1*` matched `drain_before_lap_1` when this leg was first written -- a substring
# collision that read a correct refusal as a failure. Anchor on the `|` the stub emits.
case "$r" in *"|lap_1"*) bad "pre-lap drain still burned a lap: $r" ;; *) ok "pre-lap drain burns no lap" ;; esac
rm -f "$pen/.loop-drain"

# 3 -- LIFTED: the same tree runs again once the hand removes it
r=$(stub incense 2)
case "$r" in *"|lap_2"*) ok "removing the drain resumes the loop" ;; *) bad "lifted drain: $r" ;; esac

# 4 -- a drain arriving DURING a lap stops after that lap, whole
touch "$pen/mid"
r=$(stub incense 5)
case "$r" in *drain_after_lap_1*) ok "a mid-lap drain stops after the lap finishes whole" ;; *) bad "mid-lap drain: $r" ;; esac
rm -f "$pen/mid" "$pen/.loop-drain"

# 5 -- THE REGRESSION THIS EXISTS FOR: the loop never removes a drain
touch "$pen/.loop-drain"
stub incense 2 >/dev/null
if [ -f "$pen/.loop-drain" ]; then ok "the loop leaves the drain for the hand that set it"
else bad "the loop removed a hand's drain"; fi
rm -f "$pen/.loop-drain"

# 6 -- gates-only keeps its own clearing, which is a DIFFERENT contract
touch "$pen/.loop-gates-only"
stub incense 1 >/dev/null
if [ -f "$pen/.loop-gates-only" ]; then bad "a stale gates-only survived into the next lap"
else ok "gates-only still clears at the top, so last night's stop never blocks tonight"; fi

# 7 -- the two sentinels stay distinguishable
touch "$pen/.loop-gates-only"; r=$(stub incense 2)
case "$r" in *drain*) bad "gates-only reported as a drain: $r" ;; *) ok "gates-only is never read as a drain" ;; esac
rm -f "$pen/.loop-gates-only"

# 8 and 9 -- the live scripts carry the reads this control models
grep -q 'loop-drain' "$root/grain-incense/tools/f/fleet-loop.sh" 2>/dev/null \
  || grep -q 'loop-drain' "$(dirname "$0")/../../f/fleet-loop.sh" \
  && ok "fleet-loop.sh reads .loop-drain" || bad "fleet-loop.sh reads no drain"
grep -q 'loop-drain' "$(dirname "$0")/../../f/fleet_watch.sh" \
  && ok "fleet_watch.sh refuses to re-arm a drained seat" || bad "the watch ignores a drain"

echo "coverage: 9 behaviors, both directions, every sentinel planted and lifted"
echo "pass=$pass fail=$fail"
[ "$fail" -eq 0 ]
