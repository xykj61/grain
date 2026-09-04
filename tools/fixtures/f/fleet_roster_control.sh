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
loop=tools/l/fleet-loop.sh
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
  [ -f "tools/l/${s}_seat_prompt.txt" ] || missing=$((missing + 1))
done
case "$missing" in 0) say "every_live_seat_has_a_prompt=yes" ;; *) say "every_live_seat_has_a_prompt=no" ;; esac

# The loop no longer spells a seat table of its own. A seat name surviving in a case arm here is a
# seventh copy being born, which is the whole fault this row repaired.
if grep -qE '^(incense \| pheromone|incense\) want_tree)' "$loop"; then
  say "loop_spells_no_seat_table=no"; else say "loop_spells_no_seat_table=yes"; fi

# --- the loop reads the table ----------------------------------------------------------------
# FLEET_DRY prints a command and runs nothing, so the engine word can be proven without a lap.
out=$(FLEET_DRY=1 sh "$loop" incense 2>&1 || true)
case "$out" in *"claude"*) say "dry_run_names_the_engine=yes" ;; *) say "dry_run_names_the_engine=no" ;; esac
case "$out" in *"engine=claude"*) say "banner_names_the_engine=yes" ;; *) say "banner_names_the_engine=no" ;; esac

# A seat the roster does not hold is refused, and the refusal names the seats that exist rather
# than reciting a list this file would then have to keep in step.
out=$(sh "$loop" nosuchseat 2>&1 || true)
case "$out" in *"usage:"*) say "unknown_seat_refused_by_loop=yes" ;; *) say "unknown_seat_refused_by_loop=no" ;; esac
case "$out" in *"incense"*) say "refusal_names_real_seats=yes" ;; *) say "refusal_names_real_seats=no" ;; esac

# THE BITING DIRECTION for the tree check: this tree is grain-incense, so the incense seat walks
# free and every other live seat is refused by basename -- one writer per checkout (%291).
out=$(FLEET_DRY=1 sh "$loop" petrichor 2>&1 || true)
case "$out" in *"refusing"*) say "wrong_tree_refused=yes" ;; *) say "wrong_tree_refused=no" ;; esac

# An elder name reaches the loop and is corrected there, which is the half that never reached
# fleet_rearm.sh while the remap lived in a case arm.
out=$(sh "$loop" furrow 2>&1 || true)
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

echo "control_checks=$checks"
echo "control_failures=$failures"
if [ "$failures" -eq 0 ]; then echo "control_verdict=ok"; exit 0; fi
echo "control_verdict=broken"; exit 1
