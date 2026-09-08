#!/bin/sh
# font5x7_choir_control.sh -- prove the choir's refusals by planting each, then lifting it.
#
# WHY: a choir that has only ever passed cannot be told from a choir that cannot fail. Each leg
# below plants a condition, watches the scan refuse by NAME, removes the plant, and watches it pass
# again -- so a refusal is proven in both directions rather than asserted in one.
set -eu
root=$(cd "$(dirname "$0")/../../.." && pwd -P)
scan="$root/grain-incense/tools/fixtures/f/font5x7_choir_scan.sh"
[ -f "$scan" ] || scan="$(cd "$(dirname "$0")" && pwd -P)/font5x7_choir_scan.sh"
pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT
pass=0; fail=0
ok()  { pass=$((pass+1)); echo "ok   -- $1"; }
bad() { fail=$((fail+1)); echo "FAIL -- $1"; }

mkdir -p "$pen/tools/f" "$pen/rishi/bin"
# A stand-in runner: every witness passes unless its own name says otherwise, so the control tests
# the CHOIR's logic rather than the font's glyph tables, which their own witnesses already prove.
cat > "$pen/rishi/bin/rishi" <<'R'
#!/bin/sh
# The scan calls `rishi run <path>`, so the path is $2. The first draft read $3 and therefore
# matched nothing, which made a planted red look like a pass -- the one direction a control must
# never fail in.
case "$*" in *fails*) exit 1 ;; *) exit 0 ;; esac
R
chmod +x "$pen/rishi/bin/rishi"
cp "$scan" "$pen/scan.sh"
cd "$pen"

# 1 -- an empty corpus REFUSES rather than reporting success
if sh scan.sh 2>&1 | grep -q 'verdict=empty_corpus'; then ok "an empty corpus refuses by name"
else bad "an empty corpus did not refuse"; fi

# 2 -- LIFTED: with members present it passes
: > tools/f/font5x7_ascii_witness.rish
: > tools/f/font5x7_witness.rish
out=$(sh scan.sh 2>&1 || true)
echo "$out" | grep -q 'verdict=ok' && ok "members present, the choir passes" || bad "members present yet refused"

# 3 -- the segment-less member is DISCOVERED, which the first glob missed
echo "$out" | grep -q 'members=2' && ok "font5x7_witness.rish is discovered beside its siblings" \
  || bad "the segment-less member was missed: $(echo "$out" | grep members=)"

# 4 -- one failing member REFUSES and names its path
: > tools/f/font5x7_fails_witness.rish
out=$(sh scan.sh 2>&1 || true)
echo "$out" | grep -q 'verdict=member_red' && ok "one red member refuses the choir" || bad "a red member passed"
echo "$out" | grep -q 'red: tools/f/font5x7_fails_witness.rish' && ok "the refusal names the member's path" \
  || bad "the refusal named no path"

# 5 -- LIFTED: removing it returns the choir to green
rm -f tools/f/font5x7_fails_witness.rish
sh scan.sh 2>&1 | grep -q 'verdict=ok' && ok "removing the red member restores green" || bad "still red after the lift"

# 6 -- the bound refuses, proven from both sides at the bound itself
i=0; while [ "$i" -lt 3 ]; do : > "tools/f/font5x7_b${i}_witness.rish"; i=$((i+1)); done
FONT5X7_MAX=5 sh scan.sh 2>&1 | grep -q 'verdict=ok' && ok "a family exactly at the bound walks free" \
  || bad "a family at the bound was refused"
FONT5X7_MAX=4 sh scan.sh 2>&1 | grep -q 'verdict=over_bound' && ok "one past the bound refuses" \
  || bad "a family over the bound passed"

echo "coverage: 8 behaviors, every refusal planted and then lifted"
echo "pass=$pass fail=$fail"
[ "$fail" -eq 0 ]
