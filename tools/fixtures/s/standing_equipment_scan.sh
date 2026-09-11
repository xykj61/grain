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
#   No run-card line records a red or an absent guard -- EXCEPT this guard's own row, which is
#     REPORTED at `runs_red_self` and never counted. The reasoning is written at the count itself;
#     it is named here so this list and the code beneath it say the same thing.
#   A PEER'S ROW DESCRIBES THIS PASS, not the last one (REDS %483, repaired `20260906`). This scan
#     reads whatever `STANDING_CARD` names, and the runner hands it a PEN-LOCAL live view rather
#     than the working-tree card -- rewritten after each guard answers -- so a red repaired earlier
#     in the pass reads green here. The elder reading counted that stale red, the phantom cost the
#     receipt, and the next lap paid a full pass for a fault nobody had. A peer that has NOT yet run
#     still shows its last recorded verdict, which is what such a peer honestly has; the runner
#     defers its own guard to the end of the todo list, so that set is empty when this scan reads.
#     The self row stays REPORTED and never counted (REDS %475) -- a different fault, and this
#     scan's own output can never become its own evidence whatever the card says.
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
# the every-lap tier reports its own absence by simply not running. `cadence_never_run_oldest:`
# NAMES that population, bounded and oldest-first, so a lap can turn the clock for the guards
# whose promise has stood unkept longest rather than counting them again.
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
unrostered=$(mktemp); reds=$(mktemp); ranlist=$(mktemp); reds_self=$(mktemp)
badtiers=$(mktemp); cadence_names=$(mktemp); badhosts=$(mktemp); badcaps=$(mktemp); badgates=$(mktemp)
undeclaredrows=$(mktemp); timedrows=$(mktemp); cadence_rows=$(mktemp); cadence_never_rows=$(mktemp)
trap 'rm -f "$names" "$paths_missing" "$halfrows" "$unrostered" "$reds" "$reds_self" "$ranlist" "$badtiers" "$cadence_names" "$badhosts" "$badcaps" "$badgates" "$undeclaredrows" "$timedrows" "$cadence_rows" "$cadence_never_rows"' EXIT

rostered=0
red_self=0
# The one name this scan may not use as evidence about itself.
self_guard=standing_equipment
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
seated=""
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
  # THE NAMES BESIDE THE COUNT (REDS %592). This ratchet is the only reading here that printed a
  # quantity and no name, and it is the one that reds -- so a lap meeting the ceiling asked "which
  # guard is new?" and answered it by hand-walking the roster with awk. That happened on
  # `20260907` and again on `20260908`, which is a lantern firing twice. The rows are recorded by
  # their own `seated` stamp so the report can name the NEWEST, which is the one a lap can act on:
  # a ratchet that only falls rises exactly when a guard is seated without the field, and its
  # author is the hand still holding the context. A guard carrying no `seated` line sorts first
  # under a zero stamp rather than vanishing, since a record missing two fields is not less
  # interesting than one missing one.
  [ -n "$tier" ] || { undeclared_tier=$((undeclared_tier + 1)); echo "${seated:-00000000.000000} $name" >> "$undeclaredrows"; }
  t="${tier:-lap}"
  case " $known_tiers " in
    *" $t "*) ;;
    *) unknown_tier=$((unknown_tier + 1)); echo "$name -> $t" >> "$badtiers" ;;
  esac
  if [ "$t" = cadence ]; then
    tier_cadence=$((tier_cadence + 1))
    echo "$name" >> "$cadence_names"
    # THE SEATED STAMP BESIDE THE NAME, so the never-run report below can order by how long
    # the promise has stood unkept. A guard carrying no `seated` line sorts first under a zero
    # stamp, for the reason the undeclared ratchet above already gives.
    echo "${seated:-00000000.000000} $name" >> "$cadence_rows"
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
  name=""; sawpath=0; tier=""; seated=""; host=""; capability=""; gate=""
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
    seated\ *)
      [ -n "$name" ] || continue
      seated=$(printf '%s' "$line" | awk '{print $2}')
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
             echo "$rseconds $rname" >> "$timedrows"
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
        # A GUARD'S OWN RECORD IS ITS OUTPUT, NEVER ITS EVIDENCE (REDS %475). This scan is itself
        # rostered, so the runner writes `ran standing_equipment <stamp> <verdict>` after it
        # answers -- and if that row were counted here, one red would be absorbing: the reading
        # that produced it becomes the reading that reproduces it, forever, with no state left
        # anywhere else to clear it. Proven on metal `20260906.091058`: with the row present the
        # scan reads `runs_red=1 verdict=roster_broken`, and removing that one row -- changing
        # nothing else -- reads `runs_red=0 verdict=ok`. So the row is REPORTED and never counted;
        # a hand still sees it, and every other guard's red keeps its full teeth. Same family as
        # `%458` one room over, where a scan read its own header as tree evidence.
        if [ "$rverdict" != "green" ] && [ "$rverdict" != "gated" ]; then
          if [ "$rname" = "$self_guard" ]; then
            red_self=$((red_self + 1))
            echo "$rname $rverdict" >> "$reds_self"
          else
            red=$((red + 1))
            echo "$rname $rverdict" >> "$reds"
          fi
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
if [ -s "$cadence_rows" ]; then
  while IFS= read -r row; do
    n=${row#* }
    if [ ! -s "$ranlist" ] || ! grep -qx "$n" "$ranlist" 2>/dev/null; then
      never_cadence=$((never_cadence + 1))
      echo "$row" >> "$cadence_never_rows"
    fi
  done < "$cadence_rows"
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
echo "runs_red_self=$red_self"
echo "runs_seconds_total=$seconds_total"
echo "runs_seconds_absent=$seconds_absent"
echo "runs_slowest=$slowest_name:$slowest_sec"

# THE SHAPE BETWEEN THE SUM AND THE MAX. `runs_seconds_total` and `runs_slowest` are a sum and a
# maximum, and between them a reader cannot tell a suite of 239 uniformly slow guards from one fast
# suite carrying a short heavy tail. Those two trees want opposite repairs -- the first wants every
# guard looked at, the second wants five. Measured `20260908.020050` over the card's 239 timed rows:
# median 4s, p90 51s, and the five costliest carrying 2,417s of 6,464. So the tree is the second
# kind, which is the shape `foundations/20260826-194850_the-happy-zone-and-the-thin-edge.md` asks a
# suite to have -- a fast isolated middle with a few honest slow witnesses at the edge -- and no
# reading said so.
#
# THE MEDIAN IS THE HALF THAT SAYS THE SUITE IS HEALTHY; the share is the half that says where an
# hour went. Both are needed, because either alone reads as the other tree: a median of 4 with no
# share hides that ten guards cost more than the other 229, and a share with no median cannot say
# whether the remaining guards are cheap or merely less expensive.
#
# NAMED AND BOUNDED, like every other list this scan prints -- the repairable question is which
# guards to look at, never how many there were. REPORTED, NEVER GATED: a guard that takes ten
# minutes because it builds a toolchain is doing its job, and a ceiling could not tell it from one
# that has quietly gone slow. The number is the finding; a ceiling is a later word.
slowest_show="${SLOWEST_SHOW:-5}"
echo "runs_slowest_shown=$slowest_show"
if [ -s "$timedrows" ]; then
  timed_n=$(wc -l < "$timedrows" | tr -d ' ')
  # The median reads the LOWER of the two middles on an even count, which is the ordinary
  # order-statistic answer and needs no arithmetic a shell would round differently.
  median_row=$(((timed_n + 1) / 2))
  echo "runs_seconds_median=$(sort -n "$timedrows" | sed -n "${median_row}p" | awk '{print $1}')"
  slowest_sum=$(sort -rn "$timedrows" | head -n "$slowest_show" | awk '{s += $1} END {print s + 0}')
  echo "runs_seconds_slowest_sum=$slowest_sum"
  # Integer percent, floored. A tenth of a percent changes no decision a reader makes here, and
  # integer division is the one arithmetic every POSIX shell agrees on.
  if [ "$seconds_total" -gt 0 ]; then
    echo "runs_seconds_slowest_share_pct=$((100 * slowest_sum / seconds_total))"
  else
    echo "runs_seconds_slowest_share_pct=0"
  fi
  sort -rn "$timedrows" | head -n "$slowest_show" | sed 's/^\([0-9]*\) \(.*\)$/runs_slowest_named: \2 \1s/'
else
  # An untimed card answers with the absence rather than with a zero, for the reason the block
  # above already names one layer down: a missing measurement reading as a free guard is the fault.
  echo "runs_seconds_median=absent"
  echo "runs_seconds_slowest_sum=absent"
  echo "runs_seconds_slowest_share_pct=absent"
fi
echo "guards_never_run_here=$never"
echo "cadence_never_run_here=$never_cadence"
# NAMED AND BOUNDED, the last reading here that printed a quantity and no name (REDS %592 made
# exactly this repair one reading over, and this one was left). A count cannot be acted on: a lap
# that wants to turn the cadence clock has to know WHICH guards it owes, and two laps answered that
# by hand-walking the roster with awk before this line existed -- a lantern firing twice.
#
# ORDERED OLDEST-FIRST, which is the opposite of the undeclared ratchet above, and the reason is
# the opposite too. That ratchet rises when a guard is seated without a tier, so the NEWEST row is
# the one whose author still holds the context. This reading rises when nobody turns the clock, so
# the OLDEST row is the promise that has stood unkept longest -- the one a lap should pay first.
cadence_never_show="${CADENCE_NEVER_SHOW:-8}"
echo "cadence_never_run_shown=$cadence_never_show"
[ "$never_cadence" -eq 0 ] || sort "$cadence_never_rows" | head -n "$cadence_never_show" \
  | sed 's/^\([^ ]*\) \(.*\)$/cadence_never_run_oldest: \2 seated \1/'
echo "oldest_run=${oldest:-none}"
echo "newest_run=${newest:-none}"

[ "$missing" -eq 0 ] || sed 's/^/missing: /' "$paths_missing"
[ "$half" -eq 0 ] || sed 's/^/half_written: /' "$halfrows"
[ "$unknown_tier" -eq 0 ] || sed 's/^/unknown_tier: /' "$badtiers"
# NAMED NEWEST-FIRST, AND BOUNDED. Sixty-three names every run would be a wall of text nobody
# reads, and the repairable question is never "which sixty-three" -- it is "which one arrived".
# The bound is named here rather than left to a pipe so a reader can see it, and the count above
# stays the whole population, so this list narrows the report without narrowing the reading.
undeclared_show="${UNDECLARED_TIER_SHOW:-5}"
echo "undeclared_tier_shown=$undeclared_show"
[ "$undeclared_tier" -eq 0 ] || sort -r "$undeclaredrows" | head -n "$undeclared_show" \
  | sed 's/^\([^ ]*\) \(.*\)$/undeclared_tier_newest: \2 seated \1/'
[ "$unknown_host" -eq 0 ] || sed 's/^/unknown_host: /' "$badhosts"
[ "$unknown_capability" -eq 0 ] || sed 's/^/unknown_capability: /' "$badcaps"
[ "$unknown_gate" -eq 0 ] || sed 's/^/unknown_gate: /' "$badgates"
[ "$stray" -eq 0 ] || sed 's/^/unrostered: /' "$unrostered"
[ "$red" -eq 0 ] || sed 's/^/red: /' "$reds"
[ "$red_self" -eq 0 ] || sed 's/^/red_self: /' "$reds_self"

if [ "$missing" -eq 0 ] && [ "$half" -eq 0 ] && [ "$unknown_tier" -eq 0 ] && [ "$unknown_host" -eq 0 ] \
   && [ "$unknown_capability" -eq 0 ] && [ "$unknown_gate" -eq 0 ] \
  && [ "$stray" -eq 0 ] && [ "$red" -eq 0 ]; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=roster_broken"
echo "refused: the standing roster names something the tree cannot honor -- read the lines above" >&2
exit 1
