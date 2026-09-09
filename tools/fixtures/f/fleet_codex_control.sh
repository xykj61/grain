#!/bin/sh
# Exercise the actual Codex loop in a disposable tree, with no network or model calls.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT
tree="$pen/grain-incense"
mkdir -p "$tree/tools/f" "$tree/tools/i" "$tree/tools/fixtures/f" "$pen/bin"
cp "$root/tools/f/fleet-loop-codex.sh" "$tree/tools/f/"
printf 'BATON_CONTROL\n' > "$tree/tools/f/fleet_baton.txt"
printf 'LANE_CONTROL\n' > "$tree/tools/i/incense_seat_prompt.txt"
printf '#!/bin/sh\necho grain-incense\n' > "$tree/tools/fixtures/f/fleet_roster_scan.sh"
printf '#!/bin/sh\nexit 0\n' > "$tree/tools/f/fleet_round_open.sh"
cat > "$pen/bin/codex" <<'STUB'
#!/bin/sh
case "$*" in
  *'Reply with exactly:'*)
    while [ "$#" -gt 0 ]; do
      if [ "$1" = -o ]; then shift; reply=$1; fi
      shift
    done
    echo CODEX_ALIVE
    [ "${CONTROL_PROBE_FAIL:-0}" = 0 ] || exit 1
    echo CODEX_ALIVE > "$reply"
    exit 0 ;;
esac
cat > received-prompt.txt
[ "${CONTROL_MID_STOP:-0}" = 0 ] || touch .loop-clockout
exit "${CONTROL_EXIT:-0}"
STUB
chmod +x "$pen/bin/codex"
export PATH="$pen/bin:$PATH"
export LOOP_HOURS=1 LOOP_LAPS=1 LOOP_BACKOFF=0 LOOP_LIMIT_WAIT=0
run() { sh "$tree/tools/f/fleet-loop-codex.sh" incense; }
run > "$pen/out"
grep -q BATON_CONTROL "$tree/received-prompt.txt"
grep -q LANE_CONTROL "$tree/received-prompt.txt"
grep -q fifteen-asks-sorted-for-the-fleet "$tree/received-prompt.txt"
grep -q the-scrub-that-remembers "$tree/received-prompt.txt"
echo 'ok -- actual lap receives baton, lane, and expanding prompt context'
CONTROL_EXIT=42 run > "$pen/out"
grep -q 'exited 42 (failure 1' "$pen/out"
echo 'ok -- producer failure survives a successful tee'
for marker in .loop-clockout .loop-drain; do
  rm -f "$tree/received-prompt.txt"
  touch "$tree/$marker"
  run > "$pen/out"
  test ! -f "$tree/received-prompt.txt"
  test -f "$tree/$marker"
  rm "$tree/$marker"
  echo "ok -- $marker prevents a lap and remains owned by the hand"
done
CONTROL_MID_STOP=1 run > "$pen/out"
grep -q 'stopped after lap 1' "$pen/out"
test -f "$tree/received-prompt.txt"
test -f "$tree/.loop-clockout"
echo 'ok -- mid-lap clockout lets the lap finish'
if sh "$tree/tools/f/fleet-loop-codex.sh" diffuser > "$pen/out" 2>&1; then
  echo 'FAIL -- missing lane accepted'; exit 1
fi
echo 'ok -- missing lane refused'

rm -f "$tree/.loop-clockout"
if CONTROL_PROBE_FAIL=1 run > "$pen/out"; then
  echo 'FAIL -- echoed probe request accepted'; exit 1
fi
echo 'ok -- failed probe cannot pass through echoed request text'
for marker in .mind-state/CUSTODY .mind-state/TRANSACTION; do
  mkdir -p "$tree/.mind-state"
  touch "$tree/$marker"
  CONTROL_PROBE_FAIL=1 run > "$pen/out"
  test -f "$tree/$marker"
  rm "$tree/$marker"
  echo "ok -- $marker stops before auth"
done
(
  flock -n 9
  if run > "$pen/out"; then exit 1; fi
  grep -q 'another loop owns' "$pen/out"
) 9>"$tree/loops/codex/writer.lock"
echo 'ok -- duplicate loop refused by checkout lock'
