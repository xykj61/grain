#!/bin/sh
# tools/fixtures/s/standing_equipment_scan.sh -- the roster is real, it names a tier, and it says when each guard ran.
#
# WHY. The standing-equipment roster lived in one paragraph of construction/ITINERARY.md. A paragraph
# can be trusted; it cannot be run, counted, or dated. REDS %147 found eight standing witnesses
# each holding a count its source had moved past, and REDS %149 found the living-pin bound guard
# unrun for four laps while the pin it measures sat 2,050 bytes over its bound. Both were found
# by a hand that happened to run something, which is a lantern rather than a loom.
#
# WHAT IS GATED, hard.
#   Every `path` in construction/standing-equipment.kyri names a file that exists on disk.
#   Every `guard` record carries exactly one `path` -- a row with none, or with two, is refused
#     rather than half-read by a runner that would take only the first.
#   Every `tier` names one of the words the runner knows -- `lap` or `cadence`. A guard naming a
#     tier no runner honors would run on no lap at all, silently, which is REDS %219 wearing a
#     field name. Absent means `lap`, so the roster's own history needs no editing.
#   Every `ran` line in the run card names a guard the roster actually seats.
#   No run-card line records a red or an absent guard.
#
# WHAT THE PASS COST, reported rather than gated. `runs_seconds_total` sums the run card's sixth
# field, `runs_seconds_absent` counts the rows written before that field existed, and
# `runs_slowest` names the single guard that cost the most. Reported, because a slow guard is a
# fact about the work rather than a defect (REDS %388).
#
# WHAT IS REPORTED, as a ratchet rather than a gate. The count per tier; how many rostered guards
# have never run on this pier, in total and for the cadence tier alone; and the oldest recorded
# run. A fresh clone has genuinely run nothing, so `never run here` is an honest reading rather
# than a defect, and gating it would red every clone on the day it lands. The cadence figure is
# printed on its own because that tier is where a guard can go quiet without anyone noticing --
# the every-lap tier reports its own absence by simply not running.
#
# USAGE
#   sh tools/fixtures/s/standing_equipment_scan.sh
#
# Driven by tools/s/standing_equipment_witness.rish. Run from the repository root.

set -eu

roster="${STANDING_ROSTER:-construction/standing-equipment.kyri}"
card="${STANDING_CARD:-construction/standing-equipment-runs.kyri}"

[ -f "$roster" ] || { echo "verdict=no_roster"; echo "refused: no roster at $roster" >&2; exit 1; }

# The tiers the runner honors. A roster naming anything else is refused rather than run past.
known_tiers="lap cadence"
# The hosts the runner honors (REDS %295): a row carrying `host macos` or `host linux` runs only
# on that host and is reported skipped by name elsewhere. A word outside this list is refused the
# same way an unknown tier is -- a guard gated to a host no runner answers to would run nowhere.
known_hosts="macos linux"
# The capabilities the runner probes (seated 20260829): a row carrying `capability ipv6` runs only
# where the runner's own probe finds that capability present, and is reported skipped by name
# everywhere else. `host` is a tier for PLACE and `tier` is a tier for TIME; this is a tier for what
# a host CAN DO, and the two are genuinely different questions -- a Linux bench routing IPv6 keeps a
# promise a bench without it cannot, so gating that guard on `host linux` would encode something
# untrue about every Linux bench that lacks it. The roster's own note under `comlink_r1_dual_stack`
# asked for exactly this word and declined to guess at it. A capability outside this list is refused
# the same way an unknown tier is: a guard gated on a capability no runner probes would run nowhere,
# in silence, which is REDS %219's shape wearing a third field.
# DERIVED FROM THE RUNNER, never restated here (REDS %468). This read `known_capabilities="ipv6"`
# by hand until 20260906, and on 20260906 a peer taught the runner a second probe, `jail_nesting`,
# so `agent_jail_enclosure` could name what a nested jail cannot do. The runner honored the word and
# skipped that guard by name -- `run_verdict=ok skipped_capability=1` -- while this scan, holding the
# elder one-word list, refused the whole roster as `roster_broken`, and `standing_equipment_witness`
# went red and stayed red, because the roster's own guard stands on no roster and nothing read it.
# The runner's own comment beside `capability_state()` names the trap it then fell into: *"Two copies
# of one list is the drift this tree keeps paying for."* It covered one direction -- a word the
# runner does not know reads `unknown` and runs -- and this was the other. So the list is read off
# the runner's own probe arms: the outer `case` labels inside `capability_state()`, four-space
# indented bare words, which excludes the `*)` default and the nested arms of the ipv6 probe.
# Resolved BESIDE THIS SCRIPT rather than from the working directory. The control `cd`s into a pen
# holding a roster and no tools/ at all, so a cwd-relative path reads `runner_missing` there and
# every one of the control's cases dies at once -- which is what the first draft of this block did,
# and what the control caught within a minute of it being written. The runner is this scan's own
# sibling; the pair ships together, so the pair is read together.
runner_path="${STANDING_RUNNER:-$(CDPATH= cd -- "$(dirname "$0")" && pwd)/standing_equipment_run.sh}"
if [ ! -f "$runner_path" ]; then
  echo "verdict=runner_missing"
  echo "refused: the capability list is read off $runner_path, which is not there" >&2
  exit 1
fi
known_capabilities=$(awk '
  /^capability_state\(\) \{/ { inside = 1; next }
  inside && /^\}/             { inside = 0 }
  inside && /^    [a-z_][a-z0-9_]*\)$/ {
    word = $0
    sub(/^    /, "", word); sub(/\)$/, "", word)
    print word
  }
' "$runner_path" | tr '\n' ' ')
known_capabilities=$(echo "$known_capabilities" | sed 's/[[:space:]]*$//')
# A derivation that reads nothing accepts everything, which is the silence this whole field exists
# to prevent. Refuse rather than pass, the way an empty rose refuses rather than reading as a walk.
if [ -z "$known_capabilities" ]; then
  echo "verdict=capability_list_empty"
  echo "refused: no probe arm read out of $runner_path -- the derivation found nothing" >&2
  exit 1
fi
# The gates the runner honors (REDS %374, Keaton's word `20260904`): a row carrying `gate %5` says
# this guard's red is a reading PARKED at a custody gate the living card names, rather than a broken
# one, so a full pass carrying only such reds still earns its receipt. `host` is a tier for PLACE,
# `tier` a tier for TIME, `capability` a tier for what a host CAN DO -- this is a tier for what a
# MAINTAINER HAS PARKED, and it is the one of the four that could become a free pass, because a
# hand types it about its own tree.
#
# SO THE VOCABULARY IS NOT KEPT HERE. It is read out of `construction/ITINERARY.md`'s own custody
# section -- the numbered list under the heading that tells an autonomous agent where to stop -- so
# a roster can only claim a gate the card actually declares, and retiring a gate on the card
# retires every roster row that leaned on it in the same edit. Two copies of one list is the drift
# this tree keeps paying for; here it would also be the loophole.
card_pin="${CARD_PIN:-construction/ITINERARY.md}"
known_gates=$(
  if [ -f "$card_pin" ]; then
    sed -n '/^## Custody gates/,/^Everything else/p' "$card_pin" \
      | sed -n 's/^\([0-9][0-9]*\)\. \*\*.*/%\1/p'
  fi | tr '\n' ' '
)
# An empty vocabulary refuses every gate rather than welcoming them all: a card that cannot be read
# is the one state where a gate claim has nothing behind it at all.

names=$(mktemp); paths_missing=$(mktemp); halfrows=$(mktemp)
unrostered=$(mktemp); reds=$(mktemp); ranlist=$(mktemp)
badtiers=$(mktemp); cadence_names=$(mktemp); badhosts=$(mktemp); badcaps=$(mktemp); badgates=$(mktemp)
trap 'rm -f "$names" "$paths_missing" "$halfrows" "$unrostered" "$reds" "$ranlist" "$badtiers" "$cadence_names" "$badhosts" "$badcaps" "$badgates"' EXIT

rostered=0
missing=0
half=0
unknown_tier=0
undeclared_tier=0
unknown_host=0
host_gated=0
unknown_capability=0
capability_gated=0
unknown_gate=0
gate_parked=0
tier_lap=0
tier_cadence=0

# One record at a time: a `guard` opens it, `path` and `tier` fill it, the next `guard` closes it.
name=""
sawpath=0
tier=""
host=""
capability=""
gate=""
close_record() {
  [ -n "$name" ] || return 0
  if [ "$sawpath" -ne 1 ]; then half=$((half + 1)); echo "$name" >> "$halfrows"; fi
  # A GUARD WITH NO `tier` LINE DEFAULTS TO `lap` SILENTLY, and 78 of 122 lap guards reached that
  # tier by default rather than by decision (measured `20260905`). They ran every lap because nobody
  # chose. The default stays -- a roster that refuses on a missing field would red on 62 guards at
  # once, and a wall that reds on ordinary work is a wall somebody turns off -- so the count is
  # REPORTED as a ratchet that only falls, and a hand deciding one on touch lowers it.
  [ -n "$tier" ] || undeclared_tier=$((undeclared_tier + 1))
  t="${tier:-lap}"
  case " $known_tiers " in
    *" $t "*) ;;
    *) unknown_tier=$((unknown_tier + 1)); echo "$name -> $t" >> "$badtiers" ;;
  esac
  if [ "$t" = cadence ]; then
    tier_cadence=$((tier_cadence + 1))
    echo "$name" >> "$cadence_names"
  elif [ "$t" = lap ]; then
    tier_lap=$((tier_lap + 1))
  fi
  if [ -n "$host" ]; then
    host_gated=$((host_gated + 1))
    case " $known_hosts " in
      *" $host "*) ;;
      *) unknown_host=$((unknown_host + 1)); echo "$name -> $host" >> "$badhosts" ;;
    esac
  fi
  if [ -n "$capability" ]; then
    capability_gated=$((capability_gated + 1))
    case " $known_capabilities " in
      *" $capability "*) ;;
      *) unknown_capability=$((unknown_capability + 1)); echo "$name -> $capability" >> "$badcaps" ;;
    esac
  fi
  if [ -n "$gate" ]; then
    gate_parked=$((gate_parked + 1))
    case " $known_gates " in
      *" $gate "*) ;;
      *) unknown_gate=$((unknown_gate + 1)); echo "$name -> $gate" >> "$badgates" ;;
    esac
  fi
  name=""; sawpath=0; tier=""; host=""; capability=""; gate=""
}

while IFS= read -r line; do
  case "$line" in
    guard\ *)
      close_record
      name=$(printf '%s' "$line" | awk '{print $2}')
      rostered=$((rostered + 1))
      echo "$name" >> "$names"
      ;;
    path\ *)
      path=$(printf '%s' "$line" | awk '{print $2}')
      [ -n "$name" ] || continue
      sawpath=$((sawpath + 1))
      if [ ! -f "$path" ]; then
        missing=$((missing + 1))
        echo "$name -> $path" >> "$paths_missing"
      fi
      ;;
    tier\ *)
      [ -n "$name" ] || continue
      tier=$(printf '%s' "$line" | awk '{print $2}')
      ;;
    host\ *)
      [ -n "$name" ] || continue
      host=$(printf '%s' "$line" | awk '{print $2}')
      ;;
    capability\ *)
      [ -n "$name" ] || continue
      capability=$(printf '%s' "$line" | awk '{print $2}')
      ;;
    gate\ *)
      [ -n "$name" ] || continue
      gate=$(printf '%s' "$line" | awk '{print $2}')
      ;;
    *) ;;
  esac
done < "$roster"
close_record

recorded=0
stray=0
red=0
newest=""
oldest=""
# WHAT THE PASS COST, read from the run card's sixth field (REDS %388). A row written before the
# field existed carries five, and those count as ABSENT rather than as zero seconds -- a missing
# measurement reading as a free guard is the same fault this reading exists to repair, one layer
# down. `runs_slowest` names the guard rather than only its number, because the question a lap
# actually asks is which guard to expect to wait on.
seconds_total=0
seconds_absent=0
slowest_sec=0
slowest_name="-"

if [ -f "$card" ]; then
  while IFS= read -r line; do
    case "$line" in
      ran\ *)
        rname=$(printf '%s' "$line" | awk '{print $2}')
        rstamp=$(printf '%s' "$line" | awk '{print $3}')
        rverdict=$(printf '%s' "$line" | awk '{print $4}')
        rseconds=$(printf '%s' "$line" | awk '{print $6}')
        case "$rseconds" in
          ''|*[!0-9]*) seconds_absent=$((seconds_absent + 1)) ;;
          *) seconds_total=$((seconds_total + rseconds))
             # The FIRST timed row always claims the seat, rather than only one costing more than
             # zero. Comparing on `-gt` alone left a card whose every timed guard cost 0 reading
             # `-:0`, which is the reading an entirely UNTIMED card gives -- two states wearing one
             # answer, which is the fault this whole field exists to repair, one layer down.
             if [ "$slowest_name" = "-" ] || [ "$rseconds" -gt "$slowest_sec" ]; then
               slowest_sec=$rseconds
               slowest_name=$rname
             fi ;;
        esac
        recorded=$((recorded + 1))
        echo "$rname" >> "$ranlist"
        if ! grep -qx "$rname" "$names"; then
          stray=$((stray + 1))
          echo "$rname" >> "$unrostered"
        fi
        # `gated` joins `green` as a verdict this scan does not count as red (REDS %374). The row
        # says the runner ran the guard, it answered red, and its roster row parks that red at a
        # card-named custody gate -- which is the state this instrument was itself unrunnable in,
        # since the guard that proves the roster honest refused on exactly the trees carrying a gate.
        if [ "$rverdict" != "green" ] && [ "$rverdict" != "gated" ]; then
          red=$((red + 1))
          echo "$rname $rverdict" >> "$reds"
        fi
        if [ -z "$newest" ] || [ "$rstamp" \> "$newest" ]; then newest="$rstamp"; fi
        if [ -z "$oldest" ] || [ "$rstamp" \< "$oldest" ]; then oldest="$rstamp"; fi
        ;;
      *) ;;
    esac
  done < "$card"
fi

never=0
while IFS= read -r n; do
  if [ ! -s "$ranlist" ] || ! grep -qx "$n" "$ranlist" 2>/dev/null; then never=$((never + 1)); fi
done < "$names"

never_cadence=0
if [ -s "$cadence_names" ]; then
  while IFS= read -r n; do
    if [ ! -s "$ranlist" ] || ! grep -qx "$n" "$ranlist" 2>/dev/null; then never_cadence=$((never_cadence + 1)); fi
  done < "$cadence_names"
fi

echo "guards_rostered=$rostered"
echo "guards_path_missing=$missing"
echo "guards_half_written=$half"
echo "guards_unknown_tier=$unknown_tier"
echo "guards_undeclared_tier=$undeclared_tier"
undeclared_ceiling="${UNDECLARED_TIER_CEILING:-62}"
echo "undeclared_tier_ceiling=$undeclared_ceiling"
if [ "$undeclared_tier" -le "$undeclared_ceiling" ]; then echo "undeclared_tier_under_ceiling=yes"; else echo "undeclared_tier_under_ceiling=no"; fi
echo "guards_host_gated=$host_gated"
echo "guards_unknown_host=$unknown_host"
echo "guards_capability_gated=$capability_gated"
echo "guards_unknown_capability=$unknown_capability"
echo "guards_gate_parked=$gate_parked"
echo "guards_unknown_gate=$unknown_gate"
echo "tier_lap=$tier_lap"
echo "tier_cadence=$tier_cadence"
echo "runs_recorded=$recorded"
echo "runs_unrostered=$stray"
echo "runs_red=$red"
echo "runs_seconds_total=$seconds_total"
echo "runs_seconds_absent=$seconds_absent"
echo "runs_slowest=$slowest_name:$slowest_sec"
echo "guards_never_run_here=$never"
echo "cadence_never_run_here=$never_cadence"
echo "oldest_run=${oldest:-none}"
echo "newest_run=${newest:-none}"

[ "$missing" -eq 0 ] || sed 's/^/missing: /' "$paths_missing"
[ "$half" -eq 0 ] || sed 's/^/half_written: /' "$halfrows"
[ "$unknown_tier" -eq 0 ] || sed 's/^/unknown_tier: /' "$badtiers"
[ "$unknown_host" -eq 0 ] || sed 's/^/unknown_host: /' "$badhosts"
[ "$unknown_capability" -eq 0 ] || sed 's/^/unknown_capability: /' "$badcaps"
[ "$unknown_gate" -eq 0 ] || sed 's/^/unknown_gate: /' "$badgates"
[ "$stray" -eq 0 ] || sed 's/^/unrostered: /' "$unrostered"
[ "$red" -eq 0 ] || sed 's/^/red: /' "$reds"

if [ "$missing" -eq 0 ] && [ "$half" -eq 0 ] && [ "$unknown_tier" -eq 0 ] && [ "$unknown_host" -eq 0 ] \
   && [ "$unknown_capability" -eq 0 ] && [ "$unknown_gate" -eq 0 ] \
  && [ "$stray" -eq 0 ] && [ "$red" -eq 0 ]; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=roster_broken"
echo "refused: the standing roster names something the tree cannot honor -- read the lines above" >&2
exit 1
