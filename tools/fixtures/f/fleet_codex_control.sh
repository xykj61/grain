#!/bin/sh
# Exercise the actual Codex loop in a disposable tree, with no network or model calls.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
. "$root/tools/fixtures/p/plant.sh"
mkdir -p "$root/session-output"
pen=$(mktemp -d "$root/session-output/codex-control.XXXXXX")
trap 'rm -rf "$pen"' EXIT
# Defaults must be tested independently of the invoking fleet's override.
unset CODEX_MODEL CONTROL_EXIT CONTROL_MID_STOP CONTROL_PROBE_FAIL
mkdir -p "$pen/bin"
setup_tree() {
  seat=$1
  tree="$pen/grain-$seat"
  room=$(printf '%s' "$seat" | cut -c1)
  mkdir -p "$tree/tools/f" "$tree/tools/$room" "$tree/tools/fixtures/f"
  cp "$root/tools/f/fleet-loop-codex.sh" "$tree/tools/f/"
  printf 'BATON_CONTROL\n' > "$tree/tools/f/fleet_baton.txt"
  printf 'LANE_CONTROL\n' > "$tree/tools/$room/${seat}_seat_prompt.txt"
  printf '#!/bin/sh\necho grain-%s\n' "$seat" > "$tree/tools/fixtures/f/fleet_roster_scan.sh"
  printf '#!/bin/sh\nexit 0\n' > "$tree/tools/f/fleet_round_open.sh"
}
cat > "$pen/bin/codex" <<'STUB'
#!/bin/sh
case "$*" in
  *'Reply with exactly:'*)
    printf '%s\n' "$@" >> probe-args.txt
    while [ "$#" -gt 0 ]; do
      if [ "$1" = -o ]; then shift; reply=$1; fi
      shift
    done
    echo CODEX_ALIVE
    [ "${CONTROL_PROBE_FAIL:-0}" = 0 ] || exit 1
    echo CODEX_ALIVE > "$reply"
    exit 0 ;;
esac
printf '%s\n' "$@" >> lap-args.txt
cat > received-prompt.txt
[ "${CONTROL_MID_STOP:-0}" = 0 ] || touch .loop-clockout
exit "${CONTROL_EXIT:-0}"
STUB
chmod +x "$pen/bin/codex"
export PATH="$pen/bin:$PATH"
export LOOP_HOURS=1 LOOP_LAPS=1 LOOP_BACKOFF=0 LOOP_LIMIT_WAIT=0
run() {
  rm -f "$tree/probe-args.txt" "$tree/lap-args.txt"
  sh "$tree/tools/f/fleet-loop-codex.sh" "$seat"
}
check_model() {
  # One argument per line preserves exact values and keeps the calls separate.
  # Exactly one pair also refuses duplicated model flags or repeated calls.
  awk -v expected="$2" '
    pending { if ($0 != expected) bad=1; pending=0; next }
    $0 == "-m" { count++; pending=1 }
    END { exit (count != 1 || pending || bad) }
  ' "$tree/$1-args.txt"
}
check_models() {
  check_model probe "$1" || return 1
  check_model lap "$1" || return 1
}
for control_seat in incense bakery; do
  setup_tree "$control_seat"
  case "$seat" in bakery) expected=gpt-6-astra ;; *) expected=gpt-6-sol ;; esac
  run > "$pen/out"
  check_models "$expected"
  echo "ok -- $seat default model reaches both probe and lap exactly"
  CODEX_MODEL=control-model run > "$pen/out"
  check_models control-model
  echo "ok -- $seat explicit model override reaches both probe and lap exactly"
done

# Each call must fail its own check while the other call remains correct.
for phase in probe lap; do
  case "$phase" in
    probe) address='/^if timeout 90 codex exec/'; other=lap ;;
    lap) address='/^  timeout .* codex exec/'; other=probe ;;
  esac
  for mutation in omitted suffix; do
    case "$mutation" in
      omitted) program='s/ -m "$CODEX_MODEL"//' ;;
      suffix) program='s/"$CODEX_MODEL"/"${CODEX_MODEL}-wrong"/' ;;
    esac
    plant_write "$root/tools/f/fleet-loop-codex.sh" "$tree/tools/f/fleet-loop-codex.sh" \
      "$address $program" "$phase-$mutation"
    run > "$pen/out"
    check_model "$other" "$expected"
    if check_models "$expected"; then
      echo "FAIL -- $phase $mutation model accepted"; exit 1
    fi
    echo "ok -- $phase $mutation model refused while $other stays correct"
  done
done

setup_tree incense
run > "$pen/out"
check_models gpt-6-sol
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
