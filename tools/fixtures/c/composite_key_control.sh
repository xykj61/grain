#!/bin/sh
# tools/fixtures/c/composite_key_control.sh -- proves the behaviors of
# tools/fixtures/c/composite_key_scan.sh on planted populations in a throwaway pen.
#
# WHAT WANTS PROVING. The scan's three central checks are equalities: composite's evenness reading
# must equal the digest's own, composite's locality reading must equal the prefix's own, and
# composite's confidentiality reading must equal the prefix's own (the sell, and proposal 2's
# stated falsifier). A control run on real bytes proves the tree is what it is; what wants proving
# is that a REAL divergence between the fields -- the case where composition would actually matter
# -- is caught rather than papered over by an instrument that always reports agreement.
#
# THE PLANTED POPULATIONS.
#
#   TRADED -- the same shape the sibling locality_key_control.sh uses: rooms are real groups and
#   each room's files share a prefix, while the digest is an even sweep across the whole space.
#   Both fields carry real, DIFFERENT information, which is the ordinary case a real composite key
#   would face, and every equality must hold on it exactly as it holds on the tree's own bytes.
#
#   LOCKSTEP -- digest and prefix are the SAME sweep, so the fields carry identical information.
#   The equalities still hold (nothing about identical fields breaks the checks), which is the
#   boundary case naming why TRADED, where the fields genuinely differ, is the one that actually
#   tests independence.
#
#   TINY -- a population under the floor, refused by name.
#
# THE MUTATIONS. Each is cut into a COPY of the scan, living under the tree's own scratch room
# rather than in the pen (the scan finds its root by walking up from its own location, and a copy
# in /tmp has no tree above it). A mutation that changed no observable output would prove nothing,
# so each is shown to move the reading before its refusal is trusted.
#
#   m_storage -- composite_storage_chi is read from the PREFIX field instead of the digest field.
#   The equality to digest_chi must then fail on TRADED, where the two fields disagree.
#
#   m_recovery -- composite_recovery is read from the DIGEST field instead of the prefix field.
#   The equality to prefix_recovery must then fail on TRADED, and the sell verdict must flip to
#   no, since the low digest figure would then masquerade as the composite's own.
#
# Style: context/GAUGE_STYLE.md
#
#   sh tools/fixtures/c/composite_key_control.sh

set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_steps=0
while [ ! -d "$ROOT/tools/fixtures" ]; do
  _steps=$((_steps + 1))
  [ "$_steps" -gt 8 ] && { echo "$0: no tree root" >&2; exit 2; }
  ROOT=$(dirname "$ROOT")
done
SCAN="$ROOT/tools/fixtures/c/composite_key_scan.sh"

PEN=$(mktemp -d)
MUTPEN=$(mktemp -d "$ROOT/.lap/composite_key_control.XXXXXX")
trap 'rm -rf "$PEN" "$MUTPEN"' EXIT INT TERM
cd "$PEN" || { echo "$0: could not enter the pen $PEN" >&2; exit 2; }
[ "$(pwd -P)" = "$(CDPATH= cd -- "$PEN" && pwd -P)" ] || { echo "$0: pen not entered" >&2; exit 2; }

pass=0
fail=0
legs=0
LEGS_EXPECTED=16

ok() { legs=$((legs + 1)); pass=$((pass + 1)); echo "ok   $legs $1"; }
no() { legs=$((legs + 1)); fail=$((fail + 1)); echo "FAIL $legs $1"; }
check() { if [ "$2" = "$3" ]; then ok "$1"; else no "$1 -- wanted [$3], read [$2]"; fi; }
field() { printf '%s\n' "$2" | awk -v k="$1" -F= '$1 == k { print $2 }' | tail -1; }

# TRADED -- rooms are real groups and each room's files share a prefix (byte0 tied to the room
# number); the digest is an even sweep, so the two fields genuinely disagree.
awk 'BEGIN {
  for (i = 0; i < 512; i++) {
    r = int(i / 64)
    printf "room%d ", r
    for (j = 0; j < 64; j++) printf "%02x", (i * 37 + j * 11) % 256
    printf " %02x%02x path%d\n", r * 4, (i % 3), i
  }
}' > traded.txt

# LOCKSTEP -- digest and prefix carry the SAME sweep (prefix reads the digest's own leading byte).
awk 'BEGIN {
  for (i = 0; i < 512; i++) {
    r = int(i / 64)
    b0 = (i * 37) % 256
    b1 = (i * 37 + 11) % 256
    printf "room%d ", r
    printf "%02x%02x", b0, b1
    for (j = 2; j < 64; j++) printf "%02x", (i * 37 + j * 11) % 256
    printf " %02x%02x path%d\n", b0, b1, i
  }
}' > lockstep.txt

run_scan() { sh "$SCAN" --rows "$1"; }

out=$(run_scan traded.txt)
check "traded: the scan's arithmetic verdict holds" "$(field verdict "$out")" "ok"
check "traded: composite storage evenness matches the digest" "$(field composite_evenness_matches_digest "$out")" "yes"
check "traded: composite locality matches the prefix" "$(field composite_locality_matches_prefix "$out")" "yes"
check "traded: composite confidentiality matches the prefix" "$(field composite_confidentiality_matches_prefix "$out")" "yes"
check "traded: evenness is bought" "$(field composite_buys_evenness "$out")" "yes"
check "traded: confidentiality is sold" "$(field composite_sells_confidentiality "$out")" "yes"

out2=$(run_scan lockstep.txt)
check "lockstep: the scan's arithmetic verdict holds" "$(field verdict "$out2")" "ok"
check "lockstep: composite storage evenness matches the digest" "$(field composite_evenness_matches_digest "$out2")" "yes"
check "lockstep: composite confidentiality matches the prefix" "$(field composite_confidentiality_matches_prefix "$out2")" "yes"

printf 'room0 %s %s p0\n' "$(printf '%040d' 0)" "0000" > tiny.txt
out3=$(run_scan tiny.txt)
check "tiny: a population under the floor is unreadable" "$(field verdict "$out3")" "unreadable"

# --- mutations ---------------------------------------------------------------------------------
mutate() {
  sed "$2" "$SCAN" > "$MUTPEN/$1.sh"
  if cmp -s "$SCAN" "$MUTPEN/$1.sh"; then no "$1: the mutation applied"; else ok "$1: the mutation applied"; fi
}

mutate "m_storage" 's|printf "composite_storage_chi=%.2f\\n", cd|printf "composite_storage_chi=%.2f\\n", cp|'
mo=$(sh "$MUTPEN/m_storage.sh" --rows "$PEN/traded.txt")
check "m_storage: on TRADED the evenness equality now fails" "$(field composite_evenness_matches_digest "$mo")" "no"
check "m_storage: the arithmetic verdict reds" "$(field verdict "$mo")" "refused"

mutate "m_recovery" 's|printf "composite_recovery=%.4f\\n", psum / n|printf "composite_recovery=%.4f\\n", dsum / n|'
mr=$(sh "$MUTPEN/m_recovery.sh" --rows "$PEN/traded.txt")
check "m_recovery: on TRADED the confidentiality equality now fails" "$(field composite_confidentiality_matches_prefix "$mr")" "no"
check "m_recovery: the sell verdict flips" "$(field composite_sells_confidentiality "$mr")" "no"

echo "legs_expected=$LEGS_EXPECTED"
echo "legs_run=$legs"
echo "control_pass=$pass"
echo "control_fail=$fail"
if [ "$fail" -eq 0 ] && [ "$legs" -eq "$LEGS_EXPECTED" ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=refused"
fi
