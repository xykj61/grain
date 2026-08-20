#!/bin/sh
# Witness claim-check guard (REDS %76 -> #85) -- a witness reads its own claim natively, never through
# a shell grep over interpolated output.
#
# The lantern fired twice. A witness that checked its GREEN line with
#   run ["sh" "-c" "printf '%s' '${out}' | grep -q 'the source's window' && echo yes"]
# hands captured program output to the shell inside a single-quoted word. One apostrophe in that
# output closes the quote early, the grep misses a run that was truly GREEN, and the witness reds
# while the code is sound -- the shell lying about the module. REDS %76 caught it at HUNK49, taught
# the convention, and converted two files; REDS %85 caught the same shape again in the image family,
# because a witness template written before the rule kept seeding fragile checks forward. A lantern
# that fires twice becomes a loom, and this is that loom.
#
# The convention it enforces: check a claim with Rishi's native `contains`
#   assert out contains "GREEN image-place" else "..."
# which reads the captured string in the interpreter, where an apostrophe is only a letter.
#
# Two rosters, by what can be proven on this pier:
#   ENFORCE  -- every tools/*.rish that runs here; ZERO captured-output interpolations inside shell
#               single quotes ('${something.out}'), and zero of the fragile printf-into-grep shape.
#   ADVISORY -- the device-gated host scripts (HAWM adb/Seva, SETU hearth carry, TUBE install proof)
#               that need a phone or an outer terminal, so their conversion cannot be proven GREEN
#               from inside the jail. Their remaining sites are REPORTED as a ratchet to sweep on the
#               lap a hand next runs them, never force-rewritten blind.
#
#   sh tools/fixtures/witness_claim_check_scan.sh
#   sh tools/fixtures/witness_claim_check_scan.sh prove-red
#
# No network, no key, no funds. Plain 7-bit ASCII throughout.
set -eu

MODE=${1:-}

# ADVISORY roster -- device/outer-terminal gated; a conversion here cannot be witnessed from the jail.
ADVISORY="tools/hawm1_seva_witness.rish tools/hawm3_seva_device_witness.rish tools/setu0_hearth_pull_onpath_host.rish tools/tube05_install_proof_onpath_host.rish"
CONTROL=tools/fixtures/witness_claim_check_control/fragile_control.rish

# A captured command result interpolated into a shell single-quoted word -- the exact hazard.
CAPTURED="'\\\$\\{[A-Za-z_][A-Za-z0-9_]*\\.out\\}'"
# The wider shape: any single-quoted interpolation fed straight into grep. Reported, never enforced --
# a derived four-letter word cannot carry an apostrophe, so the shape alone is debt rather than a red.
FRAGILE="(printf|echo)[^\"]*'\\\$\\{[A-Za-z_][A-Za-z0-9_.]*\\}'[^\"]*\\| *grep"

count_hits() {
  LC_ALL=C grep -c -E "$2" "$1" 2>/dev/null || true
}

is_advisory() {
  for a in $ADVISORY; do
    test "$a" = "$1" && return 0
  done
  return 1
}

if test "$MODE" = "prove-red"; then
  # The control MUST still carry the fragile shape, and the rule MUST catch it.
  if ! git ls-files --error-unmatch "$CONTROL" >/dev/null 2>&1; then
    echo "detail=RED_control_untracked"
    echo "verdict=misread"
    exit 1
  fi
  CHITS=$(count_hits "$CONTROL" "$CAPTURED")
  if test "$CHITS" -lt 1; then
    echo "detail=RED_control_was_repaired"
    echo "verdict=misread"
    exit 1
  fi
  echo "control_fragile_sites=$CHITS"
  echo "detail=RED_shell_grep_claim_check_caught"
  echo "verdict=misread"
  exit 1
fi

# ENFORCE: every runnable witness reads its claim natively.
ENFORCE_FILES=0
for p in tools/*.rish; do
  test -f "$p" || continue
  if is_advisory "$p"; then
    continue
  fi
  HITS=$(count_hits "$p" "$CAPTURED")
  if test "$HITS" -ne 0; then
    echo "enforce=failed"
    echo "detail=shell_grep_over_captured_output"
    echo "detail_path=$p"
    echo "detail_captured_sites=$HITS"
    echo "verdict=misread"
    exit 1
  fi
  ENFORCE_FILES=$((ENFORCE_FILES + 1))
done
echo "enforce_files_clean=$ENFORCE_FILES"
echo "enforce=honored"

# ADVISORY: report the device-gated remainder as a ratchet, swept on the lap a hand runs them.
ADV_TOTAL=0
for p in $ADVISORY; do
  if ! test -f "$p"; then
    echo "advisory_absent=$p"
    continue
  fi
  HITS=$(count_hits "$p" "$CAPTURED")
  echo "advisory_captured_sites=$p=$HITS"
  ADV_TOTAL=$((ADV_TOTAL + HITS))
done
echo "advisory_total_captured_sites=$ADV_TOTAL"

# The wider single-quoted-interpolation-into-grep shape, tree-wide, reported as debt to sweep on touch.
SHAPE_TOTAL=0
for p in tools/*.rish; do
  test -f "$p" || continue
  FRAG=$(count_hits "$p" "$FRAGILE")
  if test "$FRAG" -ne 0; then
    echo "advisory_shape_sites=$p=$FRAG"
    SHAPE_TOTAL=$((SHAPE_TOTAL + FRAG))
  fi
done
echo "advisory_total_shape_sites=$SHAPE_TOTAL"
echo "advisory=ratchet_report"

# The control must stay fragile, or prove-red would quietly stop proving anything.
CHITS=$(count_hits "$CONTROL" "$CAPTURED")
if test "$CHITS" -lt 1; then
  echo "control_kept=failed"
  echo "detail=control_was_repaired"
  echo "verdict=misread"
  exit 1
fi
echo "control_kept=honored"
echo "control_fragile_sites=$CHITS"

echo "story=every_runnable_witness_reads_natively>device_gated_ratcheted>fragile_control_caught"
echo "verdict=ok"
