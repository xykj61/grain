#!/bin/sh
# tools/fixtures/r/reds_first_control.sh -- the reds-first law's crossing proven
# from both sides, in a throwaway pen.
#
# reds_first_scan.sh reads its six paths relative to the working directory, so
# proving a RED means mirroring that shape rather than passing the scan a pen
# argument it has none of. The pen carries the six real files, one citer's
# citation is broken, and the scan is run with that pen as its CWD.
set -eu

pen=$(mktemp -d session-output/reds-first.XXXXXX)
trap 'rm -rf "$pen"' EXIT

mkdir -p \
  "$pen/foundations" \
  "$pen/external-research/date/20260729" \
  "$pen/gratitude" \
  "$pen/construction" \
  "$pen/context" \
  "$pen/.claude/rules" \
  "$pen/.cursor/rules" \
  "$pen/tools/fixtures/r"

cp foundations/20260729-224828_reds-first-and-the-allocation.md "$pen/foundations/"
cp external-research/date/20260729/20260729-224828_the-line-that-stops-itself.md \
  "$pen/external-research/date/20260729/"
cp gratitude/toyota-production-system.md "$pen/gratitude/"
cp construction/REDS.md "$pen/construction/"
cp context/TAME_GUIDANCE.md "$pen/context/"
cp .claude/rules/reds-first.md "$pen/.claude/rules/"
cp .cursor/rules/reds-first.mdc "$pen/.cursor/rules/"
cp tools/fixtures/r/reds_first_scan.sh "$pen/tools/fixtures/r/"

# Leg 1 -- the real crossing, mirrored whole, reads ok.
set +e
clean=$(cd "$pen" && sh tools/fixtures/r/reds_first_scan.sh 2>&1)
clean_result=$?
set -e
printf '%s\n' "$clean"
[ "$clean_result" -eq 0 ] || { echo 'control_verdict=clean_leg_wrong_status'; exit 1; }
printf '%s\n' "$clean" | grep -qx 'verdict=ok' || { echo 'control_verdict=clean_leg_wrong_verdict'; exit 1; }

# Leg 2 -- break one citer's citation; the scan must refuse and name it.
sed -i.bak 's/20260729-224828_reds-first-and-the-allocation\.md//' \
  "$pen/.claude/rules/reds-first.md"

set +e
broken=$(cd "$pen" && sh tools/fixtures/r/reds_first_scan.sh 2>&1)
broken_result=$?
set -e
printf '%s\n' "$broken"
[ "$broken_result" -eq 1 ] || { echo 'control_verdict=broken_leg_wrong_status'; exit 1; }
printf '%s\n' "$broken" | grep -q 'does not cite the law -> \.claude/rules/reds-first\.md' \
  || { echo 'control_verdict=broken_leg_missed_citer'; exit 1; }
printf '%s\n' "$broken" | grep -qx 'verdict=law_not_single_homed' \
  || { echo 'control_verdict=broken_leg_wrong_verdict'; exit 1; }

echo 'control_verdict=ok'
