#!/bin/sh
# rish_report_bound_control.sh -- the ceiling, the asymmetry, and the census, each proven by doing.
#
#   sh tools/fixtures/r/rish_report_bound_control.sh
#
# Three claims stand behind tools/r/rish_report_bound_witness.rish, and an argument is not a proof:
#
#   1. Rishi refuses an interpolated `say` past its 4,096-byte StrBuf, with `StringTooLong`.
#   2. A bare `say <value>` carries the SAME bytes with no ceiling at all.
#   3. An `assert ... else` message of the same size does NOT end the run -- it falls back to its
#      raw literal, which is why the refusal path was never the one at risk.
#
# Each is run against the real `rishi/bin/rishi` on metal rather than read out of main.rye, so a
# change in the interpreter reddens this control on the lap it lands. The census legs then plant
# and lift each counted and uncounted shape in a real git repository in a throwaway pen.

set -u
_fd_root=$(cd "$(dirname "$0")/../../.." && pwd)
cd "$_fd_root" || exit 2
. "$_fd_root/tools/fixtures/p/plant.sh"
# `sed_inplace` rather than `sed -i`: GNU takes no argument and BSD requires a backup suffix, so
# the two spellings have no overlap. The helper writes through the original inode, which keeps the
# mode the repository tracks (the exec-bit law) where `mv` would not.
. "$_fd_root/tools/fixtures/s/shell_portable.sh"

pass=0
fail=0
note() {
    if [ "$1" = ok ]; then pass=$((pass + 1)); else fail=$((fail + 1)); echo "FAIL: $2"; fi
}

pen=$(mktemp -d) || exit 2
trap 'rm -rf "$pen"' EXIT

rishi="$_fd_root/rishi/bin/rishi"
if [ ! -x "$rishi" ]; then
    echo "detail: rishi/bin/rishi is absent, so the interpreter legs cannot run on metal"
    echo "pass=0 fail=1"
    exit 1
fi

# ---------------------------------------------------------------- the interpreter, on metal
# A reading comfortably past the buffer. 5,000 bytes, written by the pen rather than spelled.
awk 'BEGIN { for (i = 0; i < 100; i++) printf "verdict=ok filler line %02d ----------------------------------\n", i }' > "$pen/big.txt"
big_bytes=$(wc -c < "$pen/big.txt")
[ "$big_bytes" -gt 4096 ] && note ok || note bad "the pen's reading did not clear 4,096 bytes ($big_bytes)"

cat > "$pen/interp.rish" <<'EOF'
let reading = run ["cat" "PEN/big.txt"]
say "label: ${reading.out}"
say "reached-the-end"
EOF
sed_inplace "s|PEN|$pen|" "$pen/interp.rish"
out=$("$rishi" run "$pen/interp.rish" 2>&1)
echo "$out" | grep -q "StringTooLong" && note ok || note bad "claim 1: an interpolated say past the buffer did not refuse StringTooLong"
echo "$out" | grep -q "reached-the-end" && note bad "claim 1: the run continued past the refusal" || note ok

cat > "$pen/bare.rish" <<'EOF'
let reading = run ["cat" "PEN/big.txt"]
say "label:"
say reading.out
say "reached-the-end"
EOF
sed_inplace "s|PEN|$pen|" "$pen/bare.rish"
out=$("$rishi" run "$pen/bare.rish" 2>&1)
echo "$out" | grep -q "reached-the-end" && note ok || note bad "claim 2: a bare say of the same bytes did not reach the end"
echo "$out" | grep -q "StringTooLong" && note bad "claim 2: a bare say refused, so the repair does not clear the ceiling" || note ok

# Claim 3 -- the asymmetry. The assert FAILS on purpose, so the run ends non-zero either way; what
# is proven is HOW it ends: naming the assert's own reason rather than StringTooLong.
cat > "$pen/msg.rish" <<'EOF'
let reading = run ["cat" "PEN/big.txt"]
assert reading.out contains "no-such-word" else "the reason survives --\n${reading.out}"
EOF
sed_inplace "s|PEN|$pen|" "$pen/msg.rish"
out=$("$rishi" run "$pen/msg.rish" 2>&1)
echo "$out" | grep -q "the reason survives" && note ok || note bad "claim 3: an oversized assert message did not fall back to its literal"
echo "$out" | grep -q "StringTooLong" && note bad "claim 3: an assert message refused, so the refusal path carries the ceiling too" || note ok

# ---------------------------------------------------------------- the census, in a pen repository
mk_pen() {
    p="$1"
    rm -rf "$p"
    mkdir -p "$p/tools/fixtures/r" "$p/rishi/src" || return 1
    cp "$_fd_root/tools/fixtures/r/rish_report_bound_scan.sh" "$p/tools/fixtures/r/" || return 1
    printf '    bytes: [4096]u8 = undefined,\n' > "$p/rishi/src/main.rye"
    ( cd "$p" && git init -q . && git config user.email a@b && git config user.name a ) || return 1
}

# A counted site: a say composing a capture the file also reads as a verdict-bearing report.
counted() {
    cat > "$1" <<'EOF'
let scan = run ["sh" "-c" "echo verdict=ok"]
assert scan.out contains "verdict=ok" else "no"
say "label: ${scan.out}"
EOF
}

pen1="$pen/r1"
mk_pen "$pen1" || { note bad "the pen repository would not initialize"; }
counted "$pen1/tools/fixtures/r/guard_witness.rish"
( cd "$pen1" && git add -A && git commit -qm x ) >/dev/null 2>&1
out=$( cd "$pen1" && sh tools/fixtures/r/rish_report_bound_scan.sh )
echo "$out" | grep -q "^sites=1$" && note ok || note bad "the census did not count a planted site -- $(echo "$out" | tr '\n' ' ')"

# The repair reads clean, or the ratchet could never fall.
cat > "$pen1/tools/fixtures/r/guard_witness.rish" <<'EOF'
let scan = run ["sh" "-c" "echo verdict=ok"]
assert scan.out contains "verdict=ok" else "no"
say "label:"
say scan.out
EOF
( cd "$pen1" && git add -A && git commit -qm y ) >/dev/null 2>&1
out=$( cd "$pen1" && sh tools/fixtures/r/rish_report_bound_scan.sh )
echo "$out" | grep -q "^sites=0$" && note ok || note bad "the census counted the repair itself -- $(echo "$out" | tr '\n' ' ')"

# A comment naming the shape is a mention, never a promise.
cat > "$pen1/tools/fixtures/r/guard_witness.rish" <<'EOF'
let scan = run ["sh" "-c" "echo verdict=ok"]
assert scan.out contains "verdict=ok" else "no"
# say "label: ${scan.out}" -- the shape this guard teaches against
say scan.out
EOF
( cd "$pen1" && git add -A && git commit -qm z ) >/dev/null 2>&1
out=$( cd "$pen1" && sh tools/fixtures/r/rish_report_bound_scan.sh )
echo "$out" | grep -q "^sites=0$" && note ok || note bad "the census read a comment as a site -- $(echo "$out" | tr '\n' ' ')"

# An assert message carries no ceiling, so it is not a site however long.
cat > "$pen1/tools/fixtures/r/guard_witness.rish" <<'EOF'
let scan = run ["sh" "-c" "echo verdict=ok"]
assert scan.out contains "verdict=ok" else "reason --\n${scan.out}"
say scan.out
EOF
( cd "$pen1" && git add -A && git commit -qm w ) >/dev/null 2>&1
out=$( cd "$pen1" && sh tools/fixtures/r/rish_report_bound_scan.sh )
echo "$out" | grep -q "^sites=0$" && note ok || note bad "the census counted an assert message -- $(echo "$out" | tr '\n' ' ')"

# A probe the file never reads with `contains` is a one-line answer, not a report.
cat > "$pen1/tools/fixtures/r/guard_witness.rish" <<'EOF'
let probe = run ["sh" "-c" "echo one"]
assert probe.ok else "no"
say "label: ${probe.out}"
EOF
( cd "$pen1" && git add -A && git commit -qm v ) >/dev/null 2>&1
out=$( cd "$pen1" && sh tools/fixtures/r/rish_report_bound_scan.sh )
echo "$out" | grep -q "^sites=0$" && note ok || note bad "the census counted a one-line probe -- $(echo "$out" | tr '\n' ' ')"

# An untracked file is not the tree's promise.
counted "$pen1/tools/fixtures/r/loose_witness.rish"
out=$( cd "$pen1" && sh tools/fixtures/r/rish_report_bound_scan.sh )
echo "$out" | grep -q "^sites=0$" && note ok || note bad "the census read an untracked file -- $(echo "$out" | tr '\n' ' ')"
rm -f "$pen1/tools/fixtures/r/loose_witness.rish"

# The ceiling, from both sides, by planting the number rather than by spelling it here twice --
# and the plant names the FORM, `ceiling=[0-9][0-9]*`, rather than today's value. This scan's own
# header says "The ceiling only falls", so every repair lap that lowers it disarms a plant
# spelling the elder number: %519's fault arriving by design rather than by accident. Proven on
# metal `20260909.194013` with the ceiling moved 38 -> 37 -- the value plant answers
# `plant_matched_nothing`, the form plant lands. The second plant keeps its literal `1`, which is
# this control's own number, written by the line above it and moved by nothing.
counted "$pen1/tools/fixtures/r/guard_witness.rish"
( cd "$pen1" && git add -A && git commit -qm u ) >/dev/null 2>&1
plant_apply "$pen1/tools/fixtures/r/rish_report_bound_scan.sh" 's/^ceiling=[0-9][0-9]*$/ceiling=1/' ceiling_one || note bad "the ceiling plant matched nothing"
out=$( cd "$pen1" && sh tools/fixtures/r/rish_report_bound_scan.sh ); rc=$?
{ [ "$rc" -eq 0 ] && echo "$out" | grep -q "verdict=under_ceiling"; } && note ok || note bad "one site under a ceiling of one did not pass"
plant_apply "$pen1/tools/fixtures/r/rish_report_bound_scan.sh" 's/^ceiling=1$/ceiling=0/' ceiling_zero || note bad "the second ceiling plant matched nothing"
out=$( cd "$pen1" && sh tools/fixtures/r/rish_report_bound_scan.sh ); rc=$?
{ [ "$rc" -ne 0 ] && echo "$out" | grep -q "verdict=over_ceiling"; } && note ok || note bad "one site over a ceiling of zero did not refuse"

echo "pass=$pass fail=$fail"
[ "$fail" -eq 0 ] || exit 1
