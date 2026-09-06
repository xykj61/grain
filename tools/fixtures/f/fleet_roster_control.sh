#!/usr/bin/env sh
# fleet_roster_control.sh -- prove the fleet's one seat table, and the loop that reads it.
#
# WHY. The binding seat -> tree -> engine stood in six independent places across two executables
# and two had already drifted: fleet-loop.sh admitted six seat names while fleet_rearm.sh reported
# nine, and the elder-name remap seated on Keaton's word `20260904` lived in one file and never
# reached the other (REDS %409). Seating the table once only helps if the readers cannot disagree,
# so every leg below asks the roster and the loop the same question and compares the answers.
#
# EVERY REFUSAL IS SHOWN FROM BOTH SIDES. A refusal proven only in the passing direction cannot be
# told from a bypass, so each plant is made, bitten, removed, and shown to walk free again.
#
#   sh tools/fixtures/f/fleet_roster_control.sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
cd "$ROOT"
scan=tools/fixtures/f/fleet_roster_scan.sh
loop=tools/f/fleet-loop.sh
checks=0
failures=0
say() { checks=$((checks + 1)); printf '%s\n' "$1"; case "$1" in *=no) failures=$((failures + 1)) ;; esac; }

# --- the reader answers, and answers once ----------------------------------------------------
case "$(sh "$scan" --tree incense)" in
  grain-incense) say "reader_names_the_tree=yes" ;; *) say "reader_names_the_tree=no" ;;
esac
# One answer, not two: awk's `exit` jumps to END, and an END that flushes again printed the match
# twice on the first draft -- invisible to a caller reading one line, a fault to one reading all.
case "$(sh "$scan" --tree incense | wc -l | tr -d ' ')" in
  1) say "reader_answers_once=yes" ;; *) say "reader_answers_once=no" ;;
esac
case "$(sh "$scan" --engine dream)" in
  codex) say "reader_names_the_engine=yes" ;; *) say "reader_names_the_engine=no" ;;
esac
# An elder name resolves; a living one passes through, so a caller may pipe every seat word here
# without first asking whether it needed translating.
case "$(sh "$scan" --resolve furrow)" in
  pheromone) say "elder_name_resolves=yes" ;; *) say "elder_name_resolves=no" ;;
esac
case "$(sh "$scan" --resolve incense)" in
  incense) say "living_name_passes_through=yes" ;; *) say "living_name_passes_through=no" ;;
esac
# A seat the table does not hold exits 2 and prints NOTHING, so a caller that forgets to check
# cannot mistake an empty answer for a real one.
out=$(sh "$scan" --tree nosuchseat 2>/dev/null || true)
if [ -z "$out" ]; then say "unknown_seat_prints_nothing=yes"; else say "unknown_seat_prints_nothing=no"; fi
if sh "$scan" --tree nosuchseat >/dev/null 2>&1; then say "unknown_seat_refuses=no"; else say "unknown_seat_refuses=yes"; fi

# --- the table and the tree agree ------------------------------------------------------------
# Every live seat owns a seat prompt file, because the loop reads one and a live row promising a
# lap the tree cannot run is the drift this table exists to end.
missing=0
for s in $(sh "$scan" --live); do
  [ -f "tools/$(printf '%s' "$s" | cut -c1)/${s}_seat_prompt.txt" ] || missing=$((missing + 1))
done
case "$missing" in 0) say "every_live_seat_has_a_prompt=yes" ;; *) say "every_live_seat_has_a_prompt=no" ;; esac

# The loop no longer spells a seat table of its own. A seat name surviving in a case arm here is a
# seventh copy being born, which is the whole fault this row repaired.
if grep -qE '^(incense \| pheromone|incense\) want_tree)' "$loop"; then
  say "loop_spells_no_seat_table=no"; else say "loop_spells_no_seat_table=yes"; fi

# --- the loop reads the table ----------------------------------------------------------------
# WHICH SEAT IS AT HOME IS READ FROM THE TREE THIS CONTROL STANDS IN, never spelled (REDS %422).
# The elder draft wrote `incense` for the free direction and `petrichor` for the bitten one, which
# is exactly right in grain-incense and INVERTED in every other tree of the fleet. Measured on the
# petrichor pier 20260905: the loop answered BOTH correctly -- `petrichor` walked free with its
# banner, `incense` was refused by basename -- and this control read both right answers as three
# failures, so the guard reported the law working as a violation. A control that names one machine
# cannot be run on the fleet it guards, and the baton's own words are that a seat is a chair rather
# than a computer.
here=$(basename "$ROOT")
home_seat=$(sh "$scan" | awk -v t="$here" '$2 == t && $4 == "live" { print $1; exit }')
away_seat=$(sh "$scan" | awk -v t="$here" '$2 != t && $2 != "-" && $4 == "live" { print $1; exit }')
# A checkout that is no live seat's tree can prove neither direction, so it names the instrument it
# lacks rather than reading zero: an empty answer here would be byte-identical to a passing one.
[ -n "$home_seat" ] && [ -n "$away_seat" ] \
  || { echo "control_verdict=not_a_fleet_tree ($here holds no live seat)"; exit 1; }
home_engine=$(sh "$scan" --engine "$home_seat")

# FLEET_DRY prints a command and runs nothing, so the engine word can be proven without a lap. The
# engine word is read from the table too, so this leg proves the loop's banner AGREES with the
# roster rather than matching a literal this file would then have to keep in step.
out=$(FLEET_DRY=1 sh "$loop" "$home_seat" 2>&1 || true)
case "$out" in *"$home_engine"*) say "dry_run_names_the_engine=yes" ;; *) say "dry_run_names_the_engine=no" ;; esac
case "$out" in *"engine=$home_engine"*) say "banner_names_the_engine=yes" ;; *) say "banner_names_the_engine=no" ;; esac

# A seat the roster does not hold is refused, and the refusal names the seats that exist rather
# than reciting a list this file would then have to keep in step.
out=$(FLEET_DRY=1 sh "$loop" nosuchseat 2>&1 || true)
case "$out" in *"usage:"*) say "unknown_seat_refused_by_loop=yes" ;; *) say "unknown_seat_refused_by_loop=no" ;; esac
case "$out" in *"incense"*) say "refusal_names_real_seats=yes" ;; *) say "refusal_names_real_seats=no" ;; esac

# THE BITING DIRECTION for the tree check: the seat whose tree is this one walks free above, and
# any OTHER live seat is refused by basename -- one writer per checkout (%291).
#
# The refusal must also NAME the tree it wants, which is the reading that makes it useful at a
# prompt: a hand told only "refusing" has to go read the table, where a hand told "belongs in
# grain-incense" already knows which checkout to open. The wanted tree is read from the roster
# rather than spelled, for the reason the block above carries (REDS %422).
away_tree=$(sh "$scan" --tree "$away_seat")
out=$(FLEET_DRY=1 sh "$loop" "$away_seat" 2>&1 || true)
case "$out" in *"refusing"*) say "wrong_tree_refused=yes" ;; *) say "wrong_tree_refused=no" ;; esac
case "$out" in
  *"belongs in $away_tree"*) say "refusal_names_the_wanted_tree=yes" ;;
  *) say "refusal_names_the_wanted_tree=no" ;;
esac

# An elder name reaches the loop and is corrected there, which is the half that never reached
# fleet_rearm.sh while the remap lived in a case arm.
#
# FLEET_DRY=1 IS LOAD-BEARING HERE, not tidiness (REDS %425, found by the pheromone seat). `furrow`
# resolves to a REAL seat, so without it this leg runs a real lap. On a checkout whose basename does
# not match, the want-tree refusal stops it and the leg looks harmless; on `grain-pheromone` it
# matches, sails past that refusal into round-open, and blocks on a fetch the jail cannot make --
# 1298 seconds of a rostered guard sitting at zero CPU. The resolve line is printed before either
# check, so the dry run proves exactly what the wet one did.
out=$(FLEET_DRY=1 sh "$loop" furrow 2>&1 || true)
case "$out" in *"is now pheromone"*) say "loop_resolves_elder_name=yes" ;; *) say "loop_resolves_elder_name=no" ;; esac

# --- the plant: a roster the loop cannot read refuses rather than guessing --------------------
pen=$(mktemp -d)
cp "$scan" "$pen/scan.sh"
cat > "$pen/roster.kyri" <<'EOF'
format fleet-roster-v1
seat alpha
tree grain-alpha
engine claude
status live
EOF
mkdir -p "$pen/construction"; cp "$pen/roster.kyri" "$pen/construction/fleet-roster.kyri"
case "$(FLEET_ROSTER=$pen/roster.kyri sh "$pen/scan.sh" --tree alpha 2>/dev/null || true)" in
  grain-alpha) say "pen_roster_read=yes" ;; *) say "pen_roster_read=no" ;;
esac
# ...and the same question against a roster that does not hold that seat answers nothing at all.
cat > "$pen/roster.kyri" <<'EOF'
format fleet-roster-v1
seat beta
tree grain-beta
engine claude
status live
EOF
out=$(FLEET_ROSTER=$pen/roster.kyri sh "$pen/scan.sh" --tree alpha 2>/dev/null || true)
if [ -z "$out" ]; then say "pen_lifted_seat_refuses=yes"; else say "pen_lifted_seat_refuses=no"; fi
rm -rf "$pen"

# --- the recipe, and the one launcher that prints it -------------------------------------------
# The per-seat lines live in the reader rather than in the launcher, because Rishi's for-each takes
# one statement over a list literal and has no string split -- a launcher looping over seats would
# have to spell the seat list again, which is the seventh copy this table exists to prevent.
out=$(sh "$scan" --recipe 2>&1 || true)
case "$out" in *"fleet-loop.sh incense"*) say "recipe_names_the_loop=yes" ;; *) say "recipe_names_the_loop=no" ;; esac
# Every live seat gets a block, and no parked one does -- a recipe for a tree no host holds is a
# command that fails on the machine reading it.
live_n=$(sh "$scan" --live | grep -c .)
block_n=$(printf '%s\n' "$out" | grep -c '^-- ')
if [ "$live_n" = "$block_n" ]; then say "recipe_covers_every_live_seat=yes"; else say "recipe_covers_every_live_seat=no"; fi
case "$out" in *"(parked)"*) say "recipe_skips_parked=no" ;; *) say "recipe_skips_parked=yes" ;; esac
# A named seat prints alone, so a hand asking about one ship does not read the whole card.
case "$(sh "$scan" --recipe petrichor 2>&1 | grep -c '^-- ')" in
  1) say "named_seat_prints_alone=yes" ;; *) say "named_seat_prints_alone=no" ;;
esac
# ...and a seat the table does not hold refuses rather than printing an empty recipe, which would
# read to a hand exactly like a seat with nothing to do.
if sh "$scan" --recipe nosuchseat >/dev/null 2>&1; then say "recipe_unknown_seat_refuses=no"; else say "recipe_unknown_seat_refuses=yes"; fi
# --recipe is the one branch that calls ITSELF, so a pen pointing FLEET_ROSTER at its own table has
# to reach the recursion too -- otherwise a pen would silently read the tree's roster, which is the
# quietest kind of wrong answer because it looks exactly like a right one.
rpen=$(mktemp -d)
cat > "$rpen/alt.kyri" <<'EOF'
format fleet-roster-v1
seat zeta
tree grain-zeta
engine claude
lane a pen seat
status live
EOF
case "$(FLEET_ROSTER=$rpen/alt.kyri sh "$scan" --recipe 2>&1)" in
  *grain-zeta*) say "pen_roster_drives_the_recipe=yes" ;; *) say "pen_roster_drives_the_recipe=no" ;;
esac
rm -rf "$rpen"

launcher=tools/l/launch-fleet-chapter.rish
if [ -f "$launcher" ]; then
  out=$(rishi/bin/rishi run "$launcher" 2>&1 || true)
  case "$out" in *"GREEN: fleet recipe printed"*) say "launcher_runs=yes" ;; *) say "launcher_runs=no" ;; esac
  case "$out" in *"grain-pheromone"*) say "launcher_reads_the_table=yes" ;; *) say "launcher_reads_the_table=no" ;; esac
else
  say "launcher_runs=no"
fi

# --- THE BREACH, ENFORCED RATHER THAN DECLARED ------------------------------------------------
# A launcher is named for its seat, never for its modality. `planet`, `fixed`, `cardinal` and
# `dual` named which body orbits which star; the arrangement changed and six filenames did not.
# The six elders keep every byte and are bannered as testimony, so the reading that matters is the
# one that catches the NEXT one being born: a living launcher filename carrying a modality word
# and NOT carrying the elder banner. Zero, enforced -- a declaration nothing measures is a habit.
unbannered=0
for f in tools/l/launch-*-chapter.rish; do
  [ -f "$f" ] || continue
  case "$f" in
    *-planet-*|*-fixed-*|*-cardinal-*|*-dual-*) ;;
    *) continue ;;
  esac
  grep -q 'STATUS -- elder printer' "$f" || unbannered=$((unbannered + 1))
done
case "$unbannered" in 0) say "no_unbannered_modality_launcher=yes" ;; *) say "no_unbannered_modality_launcher=no" ;; esac
# THE BITING DIRECTION, in a pen: an unbannered modality filename is found, and the same file
# bannered walks free. A refusal proven only in the passing direction cannot be told from a bypass.
bpen=$(mktemp -d); mkdir -p "$bpen/tools/l"
: > "$bpen/tools/l/launch-acme-planet-chapter.rish"
found=0
for f in "$bpen"/tools/l/launch-*-chapter.rish; do
  case "$f" in *-planet-*|*-fixed-*|*-cardinal-*|*-dual-*) ;; *) continue ;; esac
  grep -q 'STATUS -- elder printer' "$f" || found=$((found + 1))
done
case "$found" in 1) say "pen_unbannered_modality_bitten=yes" ;; *) say "pen_unbannered_modality_bitten=no" ;; esac
echo '# STATUS -- elder printer, kept as testimony.' > "$bpen/tools/l/launch-acme-planet-chapter.rish"
found=0
for f in "$bpen"/tools/l/launch-*-chapter.rish; do
  case "$f" in *-planet-*|*-fixed-*|*-cardinal-*|*-dual-*) ;; *) continue ;; esac
  grep -q 'STATUS -- elder printer' "$f" || found=$((found + 1))
done
case "$found" in 0) say "pen_bannered_modality_walks_free=yes" ;; *) say "pen_bannered_modality_walks_free=no" ;; esac
rm -rf "$bpen"

# --- the baton, and the third status word -----------------------------------------------------
# Every ship shares one opening and it is written ONCE. A seat prompt restating it would be the
# same rule written six times -- the fault this whole table exists to close, one room over.
baton=tools/f/fleet_baton.txt
if [ -f "$baton" ]; then say "baton_exists=yes"; else say "baton_exists=no"; fi
# Every seat on the roster owns a lane stanza, berthed and parked ones included: a seat named with
# no prompt is a ship the loop would refuse at the last moment instead of the first.
# A `field` seat runs no unattended loop and needs no stanza, which is what that engine word MEANS
# -- requiring one would ask the interactive bench for a prompt nothing would ever read.
missing=0
for s in $(sh "$scan" --seats); do
  [ "$(sh "$scan" --engine "$s")" = field ] && continue
  [ -f "tools/$(printf '%s' "$s" | cut -c1)/${s}_seat_prompt.txt" ] || missing=$((missing + 1))
done
case "$missing" in 0) say "every_looping_seat_has_a_stanza=yes" ;; *) say "every_looping_seat_has_a_stanza=no" ;; esac
# ...and no stanza restates the baton. One distinctive line from it is enough to catch a copy.
copied=0
# The prompts live in eleven letter rooms now, one per seat initial, so the walk is a glob over
# every single-letter room rather than over one. Same set, found by the fold rule.
for f in tools/?/*_seat_prompt.txt; do
  grep -q '^THE BATON --' "$f" && copied=$((copied + 1))
done
case "$copied" in 0) say "no_stanza_restates_the_baton=yes" ;; *) say "no_stanza_restates_the_baton=no" ;; esac
# The loop prepends it rather than the stanza carrying it.
# The reading that matters is what reaches the AGENT: no invocation may read the stanza directly,
# since one that did would launch a lap with no baton and look identical to one that did not.
if grep -q 'seat_prompt()' "$loop" && ! grep -qE '(-p |exec .*)"\$\(cat "\$prompt_file"\)"' "$loop"; then
  say "loop_prepends_the_baton=yes"; else say "loop_prepends_the_baton=no"; fi
# ...and the prepended text actually carries the baton, rather than the function existing empty.
joined=$(cat tools/f/fleet_baton.txt; echo; cat tools/i/incense_seat_prompt.txt)
b_line=$(printf '%s\n' "$joined" | grep -n '^THE BATON --' | head -1 | cut -d: -f1)
s_line=$(printf '%s\n' "$joined" | grep -n '^YOU ARE INCENSE' | head -1 | cut -d: -f1)
if [ -n "$b_line" ] && [ -n "$s_line" ] && [ "$b_line" -lt "$s_line" ]; then
  say "baton_precedes_the_stanza=yes"; else say "baton_precedes_the_stanza=no"; fi

# A berthed seat has a lane and a name and no tree, so it is excluded from what would run it and
# named by what merely lists it -- `live` would report a missing ship, `parked` a stopped one.
#
# PLANTED IN A PEN RATHER THAN READ OFF THE FLEET. These legs named `bakery` as their berthed
# example and asserted against the real roster, so they measured the tree's current data instead of
# the scan's behaviour -- and they broke the hour bakery was lawfully promoted to `live`
# (`20260905`, when the pier grew to eight cores and eight ships were wanted). A control a lawful
# edit can red is a control that gets edited back rather than believed.
# The scan walks up for a tree root before it reads FLEET_ROSTER, so the pen needs the marker file
# as well as the override -- the same shape the pen above uses.
spen=$(mktemp -d); cp "$scan" "$spen/scan.sh"; mkdir -p "$spen/construction"
cat > "$spen/roster.kyri" <<'ROSTER_EOF'
format fleet-roster-v1
seat sailing
tree grain-sailing
engine claude
status live

seat waiting
tree grain-waiting
engine claude
status berthed
ROSTER_EOF
cp "$spen/roster.kyri" "$spen/construction/fleet-roster.kyri"
sp() { FLEET_ROSTER="$spen/roster.kyri" sh "$spen/scan.sh" "$@" 2>&1; }
if sp --live | grep -qx waiting; then say "berthed_excluded_from_live=no"; else say "berthed_excluded_from_live=yes"; fi
if sp --seats | grep -qx waiting; then say "berthed_named_by_seats=yes"; else say "berthed_named_by_seats=no"; fi
case "$(sp --recipe)" in *grain-waiting*) say "berthed_excluded_from_recipe=no" ;; *) say "berthed_excluded_from_recipe=yes" ;; esac
# ...and the live seat beside it IS listed, so this proves an exclusion rather than an empty read.
if sp --live | grep -qx sailing; then say "live_seat_is_listed=yes"; else say "live_seat_is_listed=no"; fi
rm -rf "$spen"
# The fourth berthed leg is GONE rather than moved into the pen, because it was a duplicate of
# `wrong_tree_refused` above written the wrong way round (REDS %445). It ran the real fleet --
# `FLEET_DRY=1 sh fleet-loop.sh bakery`, wanting *belongs in grain-bakery* -- which asserts where
# bakery's CHECKOUT is rather than what the loop DOES, so it read green on every tree except the
# one it names and went red the first lap that ran inside `grain-bakery`. Seven ships saw a green
# control and the eighth saw a broken one, over a behaviour correct on all eight. The reading it
# uniquely carried, that the message says WHICH tree, now stands beside its sibling above, derived
# from the roster and biting on every tree in the fleet.

# A LANE-LESS LAP IS REFUSED (`20260906`). `seat_prompt` let `cat` fail into an empty answer, so
# a missing prompt sent the agent the baton alone -- no lane, no seat, no peers -- and seven ships
# ran that way for one lap when a relaunch crossed the commit that moved the prompts into their
# letter rooms. Both reads are guarded now, and the caller refuses rather than invoking.
if grep -q 'cat "$prompt_file" ||' tools/f/fleet-loop.sh \
   && grep -q 'cat "$baton_file" ||' tools/f/fleet-loop.sh \
   && grep -q '_prompt=$(seat_prompt) ||' tools/f/fleet-loop.sh; then
  say "a_lane_less_lap_is_refused=yes"
else
  say "a_lane_less_lap_is_refused=no"
fi

echo "control_checks=$checks"
echo "control_failures=$failures"
if [ "$failures" -eq 0 ]; then echo "control_verdict=ok"; exit 0; fi
echo "control_verdict=broken"; exit 1
