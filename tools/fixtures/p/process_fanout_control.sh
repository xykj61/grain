#!/bin/sh
# process_fanout_control.sh -- prove the fan-out meter from both sides, in a throwaway pen.
#
#   sh tools/fixtures/p/process_fanout_control.sh
#
# WHY A PEN RATHER THAN THE TREE. The meter's subject is how many programs a scan starts, and a pen
# lets that number be KNOWN rather than measured -- a planted scan starting exactly n programs is
# the only way to prove the counter counts. Against the real tree every leg would compare one
# measurement with another, which proves agreement rather than correctness.
#
# Every refusal below is planted and then lifted, because a refusal proven only in the failing
# direction cannot be told from a meter that refuses everything.

set -u

root=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
scan="$root/tools/fixtures/p/process_fanout_scan.sh"
[ -f "$scan" ] || { echo "control_verdict=scan_missing"; exit 1; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM

legs=0
failed=0
leg() {
  legs=$((legs + 1))
  echo "$1=$2"
  [ "$2" = yes ] || failed=$((failed + 1))
}

# A pen tree wearing the two files the meter reads, plus a scan whose spawn count we CHOSE.
# `spawns` programs are started, one per loop, so the execve count is known ahead of the reading.
build() {
  d=$1; name=$2; spawns=$3; wall=$4; tier=${5:-lap}
  mkdir -p "$d/construction" "$d/tools/fixtures/x" "$d/tools/x"
  printf 'guard %s\npath tools/x/%s_witness.rish\ntier %s\nseated 20260917.200026\n' "$name" "$name" "$tier" > "$d/construction/standing-equipment.kyri"
  printf 'format standing-equipment-runs-v1\nran %s 20260917.200026 green %s %s 1000\n' "$name" "$tier" "$wall" > "$d/construction/standing-equipment-runs.kyri"
  {
    echo '#!/bin/sh'
    echo "i=0; while [ \$i -lt $spawns ]; do /bin/true; i=\$((i+1)); done"
  } > "$d/tools/fixtures/x/${name}_scan.sh"
  chmod +x "$d/tools/fixtures/x/${name}_scan.sh"
}

run() { PROCESS_FANOUT_ROOT="$1" sh "$scan" "$2" "$3" 2>&1; }

# 1 -- CALIBRATION HAPPENS ON THE HOST, and prints before anything else can depend on it.
out=$(PROCESS_FANOUT_ROOT="$pen" sh "$scan" --calibrate-only 2>&1)
echo "$out" | grep -q 'calib_blend_us=[0-9]' && leg calibration_measured yes || leg calibration_measured no
echo "$out" | grep -q 'calib_fork_us=[0-9]' && leg calibration_names_floor yes || leg calibration_names_floor no
echo "$out" | grep -q 'verdict=calibrated' && leg calibrate_only_stops_there yes || leg calibrate_only_stops_there no
echo "$out" | grep -q 'fanout ' && leg calibrate_only_traces_nothing no || leg calibrate_only_traces_nothing yes

# 2 -- THE COUNT IS THE PLANTED COUNT. A scan starting 50 programs reads near 50 rather than near
# zero or near a thousand. The band is wide on purpose: the shell itself execs, and `sh -c` costs
# differ per shell, so an exact equality would be a reading of /bin/sh rather than of the meter.
build "$pen/fifty" planted 50 5
out=$(run "$pen/fifty" --guard planted)
n=$(echo "$out" | sed -n 's/.*execve=\([0-9]*\).*/\1/p' | head -1)
[ -n "$n" ] && [ "$n" -ge 50 ] && [ "$n" -le 60 ] && leg count_is_planted_count yes || leg count_is_planted_count no

# 3 -- AND IT MOVES WITH THE PLANT. Doubling the spawns roughly doubles the reading; a counter that
# returned a constant would pass leg 2 and fail here.
build "$pen/hundred" planted 100 5
out2=$(run "$pen/hundred" --guard planted)
m=$(echo "$out2" | sed -n 's/.*execve=\([0-9]*\).*/\1/p' | head -1)
[ -n "$m" ] && [ -n "$n" ] && [ "$m" -gt "$n" ] && leg count_tracks_the_plant yes || leg count_tracks_the_plant no

# 4 -- THE SHARE DIVIDES BY THE CARD'S WALL. Same plant, twice the wall seconds, half the share.
build "$pen/slow" planted 100 10
out3=$(run "$pen/slow" --guard planted)
s_fast=$(echo "$out2" | sed -n 's/.*startup_per_mille=\([0-9]*\).*/\1/p' | head -1)
s_slow=$(echo "$out3" | sed -n 's/.*startup_per_mille=\([0-9]*\).*/\1/p' | head -1)
[ -n "$s_fast" ] && [ -n "$s_slow" ] && [ "$s_slow" -lt "$s_fast" ] && leg share_divides_by_wall yes || leg share_divides_by_wall no

# 5 -- THE CARD'S STAMP TRAVELS WITH THE ROW, so a reader can tell a fresh reading from an elder.
echo "$out2" | grep -q 'card_stamp=20260917.200026' && leg card_stamp_reported yes || leg card_stamp_reported no

# 6 -- REFUSALS, each planted and then lifted rather than argued.
rm -f "$pen/fifty/construction/standing-equipment-runs.kyri"
out=$(run "$pen/fifty" --guard planted)
echo "$out" | grep -q 'verdict=card_missing' && leg absent_card_refuses yes || leg absent_card_refuses no
printf 'format standing-equipment-runs-v1\nran planted 20260917.200026 green lap 5 1000\n' > "$pen/fifty/construction/standing-equipment-runs.kyri"
out=$(run "$pen/fifty" --guard planted)
echo "$out" | grep -q 'verdict=read' && leg restored_card_reads yes || leg restored_card_reads no

mv "$pen/fifty/construction/standing-equipment.kyri" "$pen/fifty/construction/roster.away"
out=$(run "$pen/fifty" --guard planted)
echo "$out" | grep -q 'verdict=roster_missing' && leg absent_roster_refuses yes || leg absent_roster_refuses no
mv "$pen/fifty/construction/roster.away" "$pen/fifty/construction/standing-equipment.kyri"

out=$(PROCESS_FANOUT_ROOT="$pen/fifty" sh "$scan" --nonsense 2>&1)
echo "$out" | grep -q 'verdict=bad_argument' && leg unknown_argument_refuses yes || leg unknown_argument_refuses no
out=$(PROCESS_FANOUT_ROOT="$pen/fifty" sh "$scan" --sample abc 2>&1)
echo "$out" | grep -q 'verdict=bad_sample' && leg bad_sample_refuses yes || leg bad_sample_refuses no

# 7 -- A GUARD WITH NO SCAN IS OUTSIDE THE POPULATION rather than counted as zero, since a witness
# doing its own work is a different subject and a zero would read as a guard that spawns nothing.
build "$pen/noscan" lonely 10 5
rm -f "$pen/noscan/tools/fixtures/x/lonely_scan.sh"
out=$(run "$pen/noscan" --guard lonely)
echo "$out" | grep -q 'verdict=nothing_sampled' && leg scanless_guard_excluded yes || leg scanless_guard_excluded no

# 8 -- THE SAMPLE IS BOUNDED, and asking past the ceiling is clamped rather than obeyed.
build "$pen/many" planted 10 5
out=$(PROCESS_FANOUT_ROOT="$pen/many" sh "$scan" --sample 9999 2>&1)
echo "$out" | grep -q 'verdict=read' && leg oversized_sample_clamped yes || leg oversized_sample_clamped no

# 9 -- A CADENCE GUARD IS OUTSIDE THE LAP POPULATION, because the reading is about what an ordinary
# lap pays. The cadence choir is a different question with a different clock.
build "$pen/cad" slowly 20 5 cadence
out=$(PROCESS_FANOUT_ROOT="$pen/cad" sh "$scan" 2>&1)
echo "$out" | grep -q 'population_with_scan_and_card=0' && leg cadence_outside_lap_population yes || leg cadence_outside_lap_population no

echo "control_legs=$legs"
echo "control_failed=$failed"
[ "$failed" -eq 0 ] && echo "control_verdict=ok" || echo "control_verdict=leg_failed"
