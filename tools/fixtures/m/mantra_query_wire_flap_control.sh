#!/bin/sh
# tools/fixtures/m/mantra_query_wire_flap_control.sh -- the flap counter, shown answering every way.
#
# WHAT THIS DOES. tools/fixtures/m/mantra_query_wire_flap_scan.sh runs one guard many times over one
# unchanged tree and reports `green`, `red`, and `flap`. Its whole worth rests on one property:
# that `flap=no` means something. An instrument that has only ever answered `no` cannot be told
# from an instrument that cannot answer `yes` -- and the reading it exists to take, REDS %700, is
# precisely a guard that mostly passes. So this control plants three stub guards in a throwaway
# pen, each with a KNOWN answer, and watches the scan report each one correctly.
#
# WHY STUBS RATHER THAN THE REAL GUARD. The real guard's flap rate is the unknown this whole lap
# is measuring; proving the counter against it would be circular. A stub that fails on every odd
# run flaps at exactly 50%, by construction, so the counter's arithmetic is checkable against a
# number nobody had to observe.
#
# SEVEN PHASES.
#   clean_green      -- a stub that always passes: green=6, red=0, flap=no, verdict=ok, exit 0.
#                       The innocence leg. Without it every refusal below could be the pen.
#   always_red       -- a stub that always refuses: green=0, red=6, flap=no, verdict=red_every_run.
#                       This is the leg that keeps `flap` honest: a guard that is simply BROKEN is
#                       not flapping, and an instrument calling it a flap would send a lap hunting
#                       a race that was never there.
#   alternating      -- a stub refusing on every odd run: green=3, red=3, flap=yes, verdict=flap.
#                       The reading the instrument was built for, shown arriving.
#   reason_carried   -- the alternating stub's own refusal sentence reaches `red_reason`, rather
#                       than a line number. This is the harvest of the 20260910.203444 repair; a
#                       counter that logged "leg 4 refused" would leave the next lap exactly where
#                       %700 already stands.
#   odd_repeat       -- five runs of the alternating stub: green=2, red=3. Proves the count follows
#                       the runs rather than an assumed even split.
#   bound_refused    -- --repeat past MAX_REPEAT refuses with verdict=over_bound, exit 2.
#   absent_guard     -- a guard path that is not a file refuses with verdict=no_guard, exit 2,
#                       rather than counting zero runs and calling the silence green.
#
# WHAT THIS CANNOT SAY. Whether the real guard flaps, and at what rate. This proves the counter,
# never its subject -- the subject is what the scan itself is run to read.
#
# EXPECTED: verdict=ok with control_failed=0.

set -u

pen=$(mktemp -d "${TMPDIR:-/tmp}/grain_flapctl.XXXXXX") || { echo "verdict=no_pen"; exit 2; }
trap 'rm -rf "$pen"' EXIT INT TERM

failed=0
note() {
  # name expected actual
  if [ "$2" = "$3" ]; then
    echo "$1=ok"
  else
    echo "$1=RED want=$2 read=$3"
    failed=$((failed + 1))
  fi
}

cat > "$pen/always_green.rish" <<'STUB'
say "GREEN: the planted stub passes by construction."
STUB

cat > "$pen/always_red.rish" <<'STUB'
let r = run ["sh" "-c" "exit 1"]
assert r.ok else "the always-red stub refuses by construction"
say "GREEN: never reached."
STUB

# The alternating stub keeps its count in the pen, so run N knows what run N-1 did. Odd runs
# refuse, even runs pass, which fixes the rate at one half without anybody having to observe it.
cat > "$pen/alternating.rish" <<STUB
let r = run ["sh" "-c" "c=\$(cat '$pen/n' 2>/dev/null || echo 0); c=\$((c+1)); echo \$c > '$pen/n'; [ \$((c % 2)) -eq 0 ]"]
assert r.ok else "the alternating stub refuses on an odd run"
say "GREEN: the alternating stub passes on an even run."
STUB

scan="tools/fixtures/m/mantra_query_wire_flap_scan.sh"

read_key() {
  # file key -- the value of key=value, or the empty string
  sed -n "s/^$2=//p" "$1" | head -1
}

# --- clean_green ------------------------------------------------------------
sh "$scan" --repeat 6 --guard "$pen/always_green.rish" > "$pen/o.green" 2>&1
echo "clean_exit=$?"
note clean_green_count 6 "$(read_key "$pen/o.green" green)"
note clean_green_red 0 "$(read_key "$pen/o.green" red)"
note clean_green_flap no "$(read_key "$pen/o.green" flap)"
note clean_green_verdict ok "$(read_key "$pen/o.green" verdict)"

# --- always_red -------------------------------------------------------------
sh "$scan" --repeat 6 --guard "$pen/always_red.rish" > "$pen/o.red" 2>&1
note always_red_exit 1 "$?"
note always_red_green 0 "$(read_key "$pen/o.red" green)"
note always_red_count 6 "$(read_key "$pen/o.red" red)"
note always_red_flap no "$(read_key "$pen/o.red" flap)"
note always_red_verdict red_every_run "$(read_key "$pen/o.red" verdict)"

# --- alternating ------------------------------------------------------------
rm -f "$pen/n"
sh "$scan" --repeat 6 --guard "$pen/alternating.rish" > "$pen/o.alt" 2>&1
note alternating_exit 1 "$?"
note alternating_green 3 "$(read_key "$pen/o.alt" green)"
note alternating_red 3 "$(read_key "$pen/o.alt" red)"
note alternating_flap yes "$(read_key "$pen/o.alt" flap)"
note alternating_verdict flap "$(read_key "$pen/o.alt" verdict)"

# --- reason_carried ---------------------------------------------------------
if grep -q 'red_reason=.*alternating stub refuses on an odd run' "$pen/o.alt"; then
  echo "reason_carried=ok"
else
  echo "reason_carried=RED -- the stub's own sentence did not reach red_reason"
  failed=$((failed + 1))
fi
# And the line number must NOT be what got harvested in its place.
if grep -q '^red_reason=[[:space:]]*at line' "$pen/o.alt"; then
  echo "reason_not_line_number=RED -- red_reason carried a source line rather than the message"
  failed=$((failed + 1))
else
  echo "reason_not_line_number=ok"
fi

# --- odd_repeat -------------------------------------------------------------
rm -f "$pen/n"
sh "$scan" --repeat 5 --guard "$pen/alternating.rish" > "$pen/o.odd" 2>&1
note odd_repeat_green 2 "$(read_key "$pen/o.odd" green)"
note odd_repeat_red 3 "$(read_key "$pen/o.odd" red)"
note odd_repeat_flap yes "$(read_key "$pen/o.odd" flap)"

# --- bound_refused ----------------------------------------------------------
sh "$scan" --repeat 999 --guard "$pen/always_green.rish" > "$pen/o.bound" 2>&1
note bound_exit 2 "$?"
note bound_verdict over_bound "$(read_key "$pen/o.bound" verdict)"

# --- absent_guard -----------------------------------------------------------
sh "$scan" --repeat 2 --guard "$pen/nothing_is_here.rish" > "$pen/o.absent" 2>&1
note absent_exit 2 "$?"
note absent_verdict no_guard "$(read_key "$pen/o.absent" verdict)"

echo "control_failed=$failed"
if [ "$failed" -eq 0 ]; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=red"
exit 1
