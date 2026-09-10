#!/bin/sh
# tools/fixtures/s/standing_equipment_redleg_control.sh -- prove the red-leg meter can red, on a
# pen it builds and throws away.
#
# A meter over whether guards can red is exactly the meter that must be proven able to red itself,
# or the strand it measures has a hole at its own centre. Every refusal below is planted and then
# lifted, and every welcome is asserted as hard as every refusal -- a refusal proven only in the
# passing direction cannot be told from a bypass.
#
#   sh tools/fixtures/s/standing_equipment_redleg_control.sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
SCAN="$root/tools/fixtures/s/standing_equipment_redleg_scan.sh"

pen=$(mktemp -d "${TMPDIR:-/tmp}/redleg-control.XXXXXX")
trap 'rm -rf "$pen"' EXIT INT TERM

checks=0
fail=0
ok() { checks=$((checks + 1)); printf 'ok %s\n' "$1"; }
bad() { checks=$((checks + 1)); fail=$((fail + 1)); printf 'FAIL %s\n' "$1"; }

mkdir -p "$pen/construction" "$pen/tools/p"

# A witness that asserts and demonstrates its own refusal -- the shape the meter must wave through.
cat > "$pen/tools/p/toothed_witness.rish" <<'EOF'
let red = run ["sh" "tools/fixtures/p/pen_scan.sh" "prove-red"]
assert (red.ok == false) else "pen: prove-red must refuse"
assert red.ok else "pen: the toothed reading holds"
EOF

# A witness that asserts against a child run and demonstrates nothing itself -- the choir shape,
# counted under the ceiling and never gated.
cat > "$pen/tools/p/choir_witness.rish" <<'EOF'
let child = run ["rishi/bin/rishi" "run" "tools/p/toothed_witness.rish"]
assert child.ok else "pen: the child rung went red"
EOF

# A witness carrying no assertion at all -- the vacuum REDS row 59 was booked for.
cat > "$pen/tools/p/vacuous_witness.rish" <<'EOF'
say "GREEN: pen -- everything is fine"
EOF

roster="$pen/construction/pen-equipment.kyri"
write_roster() {
  : > "$roster"
  for g in "$@"; do
    printf 'guard %s\npath tools/p/%s_witness.rish\nseated 20260909.000000\n\n' "$g" "$g" >> "$roster"
  done
}

run_scan() {
  ( cd "$pen" && REDLEG_ROOT="$pen" REDLEG_ROSTER="construction/pen-equipment.kyri" \
      REDLEG_CEILING="${1:-53}" sh "$SCAN" ) 2>&1
}

# --- the welcome: a toothed roster passes, and the counts are read rather than assumed ---
write_roster toothed
out=$(run_scan 0 || true)
echo "$out" | grep -q 'guards=1' && ok "a one-guard roster reads one guard" || bad "a one-guard roster reads one guard"
echo "$out" | grep -q 'guards_no_assert=0' && ok "a toothed witness carries an assert" || bad "a toothed witness carries an assert"
echo "$out" | grep -q 'guards_no_refusal_marker=0' && ok "a toothed witness demonstrates its refusal" || bad "a toothed witness demonstrates its refusal"
echo "$out" | grep -q 'verdict=ok' && ok "a toothed roster balances" || bad "a toothed roster balances"

# --- the gate, planted: a witness with no assert refuses ---
write_roster toothed vacuous
out=$(run_scan 0 || true)
echo "$out" | grep -q 'guards_no_assert=1' && ok "a witness with no assert is counted" || bad "a witness with no assert is counted"
echo "$out" | grep -q 'verdict=vacuous_guard' && ok "a witness with no assert refuses the verdict" || bad "a witness with no assert refuses the verdict"
run_scan 0 | grep -q 'no-assert' && : # the list mode names it
( cd "$pen" && REDLEG_ROOT="$pen" REDLEG_ROSTER="construction/pen-equipment.kyri" sh "$SCAN" list ) \
  | grep -q 'no-assert: vacuous' && ok "list names the vacuous guard" || bad "list names the vacuous guard"

# --- the gate, lifted: removing the plant returns the verdict ---
write_roster toothed
run_scan 0 | grep -q 'verdict=ok' && ok "lifting the plant returns the verdict" || bad "lifting the plant returns the verdict"

# --- the ceiling, proven from both sides ---
write_roster toothed choir
out=$(run_scan 1 || true)
echo "$out" | grep -q 'guards_no_refusal_marker=1' && ok "a delegating witness is counted, never gated" || bad "a delegating witness is counted, never gated"
echo "$out" | grep -q 'ceiling_ok=yes' && ok "one marker-less guard at a ceiling of one passes" || bad "one marker-less guard at a ceiling of one passes"
echo "$out" | grep -q 'verdict=ok' && ok "at the ceiling the verdict stands" || bad "at the ceiling the verdict stands"
out=$(run_scan 0 || true)
echo "$out" | grep -q 'ceiling_ok=no' && ok "one past the ceiling refuses" || bad "one past the ceiling refuses"
echo "$out" | grep -q 'verdict=ceiling_raised' && ok "one past the ceiling names the raise" || bad "one past the ceiling names the raise"
# A RAISED CEILING NAMES WHAT RAISED IT. Three ships surfaced this ceiling's own raise on
# `20260909` and none could act on it, because a count says something arrived and never what. The
# free side matters as much: a pass that HOLDS must stay quiet, or the reading becomes a wall of
# names on every green lap and a reader stops looking at it.
echo "$out" | grep -q 'over_ceiling: choir ' && ok "a raised ceiling names the guard that raised it" || bad "a raised ceiling names the guard that raised it"
out=$(run_scan 1 || true)
echo "$out" | grep -q 'over_ceiling:' && bad "a held ceiling stays quiet" || ok "a held ceiling stays quiet"

# --- an absent path is counted rather than crashed over ---
write_roster toothed ghost
out=$(run_scan 0 || true)
echo "$out" | grep -q 'guards_absent=1' && ok "a rostered path that is gone is counted" || bad "a rostered path that is gone is counted"

# --- an empty roster refuses rather than reporting a clean sweep ---
: > "$roster"
if run_scan 0 >/dev/null 2>&1; then bad "an empty roster refuses"; else ok "an empty roster refuses"; fi

# --- an absent roster refuses ---
rm -f "$roster"
if run_scan 0 >/dev/null 2>&1; then bad "an absent roster refuses"; else ok "an absent roster refuses"; fi

echo "control_checks=$checks"
echo "control_failures=$fail"
if [ "$fail" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=red"; exit 1; fi
