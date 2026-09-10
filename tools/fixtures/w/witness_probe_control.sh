#!/bin/sh
# witness_probe_control.sh -- prove the probe's four verdicts, each planted deliberately.
#
# WHY: the probe exists to tell a HUNG run from a RED one, and a probe that has only ever seen green
# cannot be trusted to make that distinction when it matters. Every verdict below is planted, watched,
# and named.
set -eu
here=$(cd "$(dirname "$0")" && pwd -P)
scan="$here/witness_probe_scan.sh"
pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT
pass=0; fail=0
ok()  { pass=$((pass+1)); echo "ok   -- $1"; }
bad() { fail=$((fail+1)); echo "FAIL -- $1"; }

# A stand-in runner: the witness path tells it what to do, so this control tests the PROBE rather
# than any real witness.
cat > "$pen/runner" <<'R'
#!/bin/sh
case "$2" in
  *hangs*) sleep 30 ;;
  *fails*) exit 1 ;;
  *) exit 0 ;;
esac
R
chmod +x "$pen/runner"
: > "$pen/passes_witness.rish"; : > "$pen/fails_witness.rish"; : > "$pen/hangs_witness.rish"
export WITNESS_PROBE_RUNNER="$pen/runner"

v() { sh "$scan" "$1" --bound "${2:-5}" 2>&1 || true; }

v "$pen/passes_witness.rish" | grep -q 'verdict=green' && ok "a passing witness reads green" || bad "green missed"
v "$pen/fails_witness.rish"  | grep -q 'verdict=red'   && ok "a refusing witness reads red"  || bad "red missed"
v "$pen/hangs_witness.rish"  | grep -q 'verdict=over_bound'  && ok "a witness past its bound reads over_bound" || bad "over_bound missed"

# THE DISTINCTION THIS FILE EXISTS FOR, asserted from the other side too: a hang must never be
# reported as a red, since one is a claim about the run and the other about the tree.
v "$pen/hangs_witness.rish" | grep -q 'verdict=red' && bad "an over-bound run was reported as a red" || ok "an over-bound run is never called a red"
v "$pen/fails_witness.rish" | grep -q 'verdict=over_bound' && bad "a refusal was reported as over_bound" || ok "a refusal is never called an over-bound run"

v "$pen/absent_witness.rish" | grep -q 'verdict=absent' && ok "a missing file reads absent" || bad "absent missed"

# A hung run must still report the seconds it burned, so a reader can tell a slow witness from a
# stuck one without running it again.
v "$pen/hangs_witness.rish" | grep -q 'seconds=' && ok "an over-bound run reports the seconds it burned" || bad "no seconds on an over-bound run"

# The bound is honoured rather than ignored: a longer bound lets the same witness finish.
sh "$scan" "$pen/hangs_witness.rish" --bound 40 2>&1 | grep -q 'verdict=green' \
  && ok "a bound past the sleep lets the same witness finish green" || bad "the bound was not honoured"

sh "$scan" 2>&1 | grep -q 'verdict=no_path' && ok "no path refuses rather than defaulting" || bad "no path defaulted"

echo "coverage: 9 behaviors, all four verdicts planted, the over-bound-versus-red distinction proven both ways"
echo "pass=$pass fail=$fail"
[ "$fail" -eq 0 ]
