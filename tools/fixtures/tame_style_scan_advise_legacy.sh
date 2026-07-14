#!/bin/sh
# tame_style_scan_advise_legacy.sh — original shell ratchet lines (parity selftest only).
set -u
FILES=$(find mantra caravan linengrow comlink rishi/src tally aurora pond brushstroke rye/src \
    -name "*.rye" ! -type l 2>/dev/null)
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
memcpy_total=$(grep -h "@memcpy(" $FILES 2>/dev/null | wc -l | tr -d ' ')
memcpy_canonical=$(grep -c "@memcpy(" tally/copy.rye 2>/dev/null)
memcpy_app=$((memcpy_total - memcpy_canonical))
camel_total=$(grep -hE "^( *)?(pub )?fn [a-z]+[A-Z]" $FILES 2>/dev/null | wc -l | tr -d ' ')
parseint_total=$(grep -h "parseInt(" $FILES 2>/dev/null | wc -l | tr -d ' ')
parseint_canonical=$(grep -c "parseInt(" tally/parse_int.rye 2>/dev/null)
parseint_app=$((parseint_total - parseint_canonical))
ed25519_total=$(grep -h "Ed25519" $FILES 2>/dev/null | grep -vi "fromed25519" | wc -l | tr -d ' ')
ed25519_canonical=$(grep -c "Ed25519" tally/kumara.rye 2>/dev/null)
ed25519_app=$((ed25519_total - ed25519_canonical))
echo "ratchet: @memcpy application sites = ${memcpy_app} (migrate to copy_disjoint on touch)"
echo "ratchet: @memcpy canonical in tally/copy.rye = 1 (intentional inside copy_disjoint)"
echo "ratchet: camelCase fn declarations = ${camel_total} (snake_case on touch)"
echo "ratchet: parseInt( application sites = ${parseint_app} (migrate to tally/parse_int.rye on touch; leading-zero footgun otherwise silent)"
echo "ratchet: Ed25519 application sites = ${ed25519_app} (migrate to tally/kumara.rye on touch; identity at the seam)"
echo "ratchet: Ed25519 canonical in tally/kumara.rye = ${ed25519_canonical} (intentional inside kumara seam)"
echo "ratchet: functions past 70 lines —"
zero_assert_total=0
for f in $FILES; do
    if grep -qE '\bassert\(' "$f" 2>/dev/null; then
        continue
    fi
    case "$f" in
        comlink/guest_*|aurora/src/*|brushstroke/font8x8_data.rye|\
        caravan/supervisor_signal.rye|caravan/supervisor_exit.rye|pond/apps/window_input.rye|\
        tally/maybe.rye)
            continue ;;
    esac
    zero_assert_total=$((zero_assert_total + 1))
    echo "  $f (zero assert — review on touch)"
done
echo "ratchet: zero assert( files remaining = ${zero_assert_total} (honest exempt: virtio guests, aurora freestanding, signal handler, font table, thin line editor, exit constants, the dual-of-assert mark itself)"
"${ROOT}/rishi/bin/rishi" run tools/fixtures/tame_style_long_fn.rish
