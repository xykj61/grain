#!/bin/sh
# witness_family_control.sh -- prove the family choir's refusals by planting each, then lifting it.
#
# WHY: a choir that has only ever passed cannot be told from a choir that cannot fail. Each leg
# plants a condition, watches the scan refuse BY NAME, removes the plant, and watches it pass again.
set -eu
here=$(cd "$(dirname "$0")" && pwd -P)
scan="$here/witness_family_scan.sh"
pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT
pass=0; fail=0
ok()  { pass=$((pass+1)); echo "ok   -- $1"; }
bad() { fail=$((fail+1)); echo "FAIL -- $1"; }

mkdir -p "$pen/tools/x" "$pen/bin"
# A stand-in runner: a member passes unless its own path says `fails`, so this control tests the
# CHOIR's logic rather than any real module, which each member's own witness already proves. It
# reads "$*" rather than a fixed position -- the first draft read $3 where the path arrives as $2,
# so a planted red looked like a pass, which is the one direction a control must never fail in.
cat > "$pen/bin/runner" <<'R'
#!/bin/sh
case "$*" in *fails*) exit 1 ;; *) exit 0 ;; esac
R
chmod +x "$pen/bin/runner"
cd "$pen"
export WITNESS_FAMILY_RUNNER="$pen/bin/runner"
run() { sh "$scan" --dir tools/x --prefix demo "$@" 2>&1 || true; }

# 1 -- an empty corpus REFUSES rather than reporting success
run | grep -q 'verdict=empty_corpus' && ok "an empty corpus refuses by name" || bad "an empty corpus did not refuse"

# 2 -- LIFTED: with members present it passes
: > tools/x/demo_alpha_witness.rish
: > tools/x/demo_witness.rish
out=$(run)
echo "$out" | grep -q 'verdict=ok' && ok "members present, the family passes" || bad "members present yet refused"

# 3 -- the segment-less member is DISCOVERED, which a tighter glob would miss
echo "$out" | grep -q 'members=2' && ok "demo_witness.rish is discovered beside its siblings" \
  || bad "the segment-less member was missed: $(echo "$out" | grep members= || true)"

# 4 -- a choir file of the family's own name is never sung as a member
: > tools/x/demo_choir.rish
echo "$(run)" | grep -q 'members=2' && ok "the choir excludes itself from its own family" \
  || bad "the choir counted itself as a member"
rm -f tools/x/demo_choir.rish

# 5 -- one failing member REFUSES and names its path
: > tools/x/demo_fails_witness.rish
out=$(run)
echo "$out" | grep -q 'verdict=member_red' && ok "one red member refuses the family" || bad "a red member passed"
echo "$out" | grep -q 'red: tools/x/demo_fails_witness.rish' && ok "the refusal names the member's path" \
  || bad "the refusal named no path"

# 6 -- LIFTED: removing it returns the family to green
rm -f tools/x/demo_fails_witness.rish
run | grep -q 'verdict=ok' && ok "removing the red member restores green" || bad "still red after the lift"

# 7 -- the bound refuses, shown from BOTH sides at the bound itself
i=0; while [ "$i" -lt 3 ]; do : > "tools/x/demo_b${i}_witness.rish"; i=$((i+1)); done
run --max 5 | grep -q 'verdict=ok' && ok "a family exactly at the bound walks free" || bad "a family at the bound was refused"
run --max 4 | grep -q 'verdict=over_bound' && ok "one past the bound refuses" || bad "a family over the bound passed"

# 8 -- the arguments are required rather than defaulted, since a silent default picks a family
sh "$scan" --prefix demo 2>&1 | grep -q 'verdict=no_dir' && ok "a missing --dir refuses" || bad "a missing --dir defaulted"
sh "$scan" --dir tools/x 2>&1 | grep -q 'verdict=no_prefix' && ok "a missing --prefix refuses" || bad "a missing --prefix defaulted"

echo "coverage: 11 behaviors, every refusal planted and then lifted"
echo "pass=$pass fail=$fail"
[ "$fail" -eq 0 ]
