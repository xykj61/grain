#!/bin/sh
# cyclic_witness_control.sh -- prove the cycle scan sees residue, and sees its absence.
#
# WHY A CONTROL IN SHELL. The plant is a small witness file whose body carries quotes inside quotes.
# Generating that from inside a Rishi string was tried first and refused with `UndefinedName`, which
# is the nested-quoting seam this tree has met before. Shell owns quoting; the witness owns
# assertions. Each language does the job it is good at.
#
# WHAT IS PROVEN, both directions:
#   - a witness that passes AND leaves a file behind reads `verdict=residue`, with the path named
#   - the same witness, once its file is removed, leaves the tree exactly as found
#   - the plant lifts completely, so this control leaves no residue of its own
set -eu
here=$(cd "$(dirname "$0")/../../.." && pwd -P)
cd "$here"
scan="tools/fixtures/c/cyclic_witness_scan.sh"
plant="tools/w/cyclic_probe_witness.rish"
leftover="tools/.cyclic_probe_leftover"

pass=0; fail=0
ok()  { pass=$((pass+1)); echo "ok   -- $1"; }
bad() { fail=$((fail+1)); echo "FAIL -- $1"; }

cleanup() { rm -f "$plant" "$leftover"; }
trap cleanup EXIT

# THE FALSIFIER THE DESIGN PAGE NAMED: a witness that PASSES while leaving residue.
cat > "$plant" <<'PLANT'
say "leaky: writing a file and leaving it behind"
let w = run ["sh" "-c" "echo residue > tools/.cyclic_probe_leftover"]
assert w.ok else "leaky: could not write"
say "GREEN: leaky -- passed, and left something behind"
PLANT

out=$(sh "$scan" "$plant" --bound 120 2>&1 || true)
echo "$out" | grep -q 'verdict=residue' \
  && ok "a witness that passes while leaving a file reads residue" \
  || bad "residue went unseen: $(echo "$out" | grep -E '^verdict=' || true)"
echo "$out" | grep -q 'cyclic_probe_leftover' \
  && ok "the residue verdict names the path a reader must find" \
  || bad "the residue verdict named no path"

# LIFTED: remove what the plant wrote, and the same witness family cycles.
rm -f "$leftover"
cat > "$plant" <<'QUIET'
say "quiet: touching nothing"
say "GREEN: quiet -- passed, and left the tree as found"
QUIET
out2=$(sh "$scan" "$plant" --bound 120 2>&1 || true)
echo "$out2" | grep -q 'verdict=cycles' \
  && ok "a witness that touches nothing cycles" \
  || bad "a quiet witness failed to cycle: $(echo "$out2" | grep -E '^verdict=' || true)"
echo "$out2" | grep -q 'residue_paths=0' \
  && ok "a cycling witness reports zero residue paths" \
  || bad "a cycling witness reported residue paths"

# Both digests are printed, so a reader compares by eye rather than trusting one word.
echo "$out2" | grep -q '^entry=' && ok "an entry digest is printed" || bad "no entry digest"
echo "$out2" | grep -q '^exit='  && ok "an exit digest is printed"  || bad "no exit digest"

# The two required refusals.
sh "$scan" 2>&1 | grep -q 'verdict=no_path' \
  && ok "a missing path refuses rather than defaulting" || bad "a missing path defaulted"
sh "$scan" tools/w/there_is_no_such_witness.rish 2>&1 | grep -q 'verdict=absent' \
  && ok "an absent witness is named absent" || bad "an absent witness was not named"

# THE CONTROL CLEANS UP AFTER ITSELF, and proves it. A control that plants and leaves residue makes
# the next lap's reading wrong, which is the fault this whole instrument exists to find.
cleanup
if [ -e "$plant" ] || [ -e "$leftover" ]; then
  bad "the control left its own plant behind"
else
  ok "the control leaves the tree as it found it"
fi

echo "coverage: 9 behaviors, residue shown from both sides, the control's own lift proven"
echo "pass=$pass fail=$fail"
[ "$fail" -eq 0 ]
