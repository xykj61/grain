#!/bin/sh
# tools/fixtures/p/pre_push_spine_control.sh -- prove the pre-push spine wall on real git
# repositories in a throwaway pen, refusals and welcomes both.
#
# WHY BOTH DIRECTIONS. A refusal proven only in the passing direction cannot be told from a bypass:
# a hook that always exits 0 passes every "clean tree" case a control thinks to write. So every
# refusal here is planted and then lifted, and each welcome is asserted as hard as each refusal.
#
# WHY A REAL `git push` RATHER THAN A CALL TO THE SCRIPT. The wall's whole claim is that git reaches
# it -- through `core.hooksPath`, the way `tools/i/install_hooks.rish` arms every clone. A control
# that invoked the file directly would prove the file and leave the arming untested, which is the
# half that actually failed the fleet. So every case here runs `git push` against a bare repository
# in the pen and reads what the remote holds afterward.
#
#   sh tools/fixtures/p/pre_push_spine_control.sh
#
# Exit 0 when every case behaves, 1 when one does not. No network, no key, no funds, no device.
set -eu

here="$(cd "$(dirname "$0")" && pwd)"
root="$(cd "$here/../../.." && pwd)"
HOOK="$root/tools/hooks/pre-push"
SCAN="$root/tools/fixtures/r/reds_spine_derive_scan.sh"
FILES="$root/tools/fixtures/r/reds_spine_files.sh"

for f in "$HOOK" "$SCAN" "$FILES"; do
  [ -f "$f" ] || { echo "FAIL: $f is missing -- nothing to prove"; exit 1; }
done

pen="$(mktemp -d)"
trap 'rm -rf "$pen"' EXIT INT TERM

pass=0
fail=0

ok() { echo "PASS: $1"; pass=$((pass + 1)); }
no() { echo "FAIL: $1"; fail=$((fail + 1)); }

row() {
  # $1 number, $2 stamp, $3 headline
  printf '**REDS %%%s (`%s`) -- %s** *What went wrong:* a planted case. *What caught it:* the pen. *What it taught:* nothing beyond this control. **OPEN**\n\n' "$1" "$2" "$3"
}

# ---- the pen: a bare anointed remote, and a working clone armed exactly as a ship is ----
mkdir -p "$pen/up.git"
git init --quiet --bare -b main "$pen/up.git"

work="$pen/work"
mkdir -p "$work/construction/archive" "$work/tools/fixtures/r" "$work/tools/hooks"
cp "$SCAN" "$FILES" "$work/tools/fixtures/r/"
cp "$HOOK" "$work/tools/hooks/pre-push"
chmod +x "$work/tools/hooks/pre-push"

{
  echo "# REDS -- the pen's ledger"
  echo
  row 10 20260101.010101 "the first planted row."
  row 11 20260101.020202 "the second planted row."
} > "$work/construction/REDS.md"

cd "$work"
git init --quiet -b main .
git config user.email pen@example.invalid
git config user.name "Pen Hand"
git config commit.gpgsign false
git config core.hooksPath tools/hooks
git remote add xy "$pen/up.git"
git add -A
git commit --quiet -m "pen: the ledger as it stands"

# Case 1 -- a clean spine publishes.
if git push --quiet xy main 2>/dev/null; then
  ok "a clean spine publishes"
else
  no "a clean spine was refused"
fi

remote_head() { git --git-dir="$pen/up.git" rev-parse --verify --quiet refs/heads/main || echo none; }
before="$(remote_head)"

# Case 2 -- the plant mutates: the scan itself must see the double before the hook is asked.
{
  echo "# REDS -- the pen's ledger"
  echo
  row 10 20260101.010101 "the first planted row."
  row 11 20260101.020202 "the second planted row."
  row 11 20260101.030303 "a second row wearing the same number."
} > construction/REDS.md
git add -A
git commit --quiet -m "pen: plant a double-booked number"

set +e
scan_out="$(sh tools/fixtures/r/reds_spine_derive_scan.sh 2>&1)"
scan_code=$?
set -e
if [ "$scan_code" -eq 1 ] && echo "$scan_out" | grep -q '^double_booked=1$'; then
  ok "the plant mutates -- the scan reads double_booked=1 and exits 1"
else
  no "the plant did not mutate the scan (exit $scan_code)"
fi

# Case 3 -- and the wall refuses the push that would publish it.
set +e
git push --quiet xy main 2>/dev/null
push_code=$?
set -e
if [ "$push_code" -ne 0 ] && [ "$(remote_head)" = "$before" ]; then
  ok "a double-booked number is refused, and the remote is untouched"
else
  no "a double-booked number reached the remote (push exit $push_code)"
fi

# Case 4 -- the refusal names the number and the allocator.
set +e
refusal="$(git push xy main 2>&1)"
set -e
if echo "$refusal" | grep -q 'double_booked %11' && echo "$refusal" | grep -q -- '--next'; then
  ok "the refusal names the doubled number and the command that answers the next one"
else
  no "the refusal named neither the number nor the allocator"
fi

# Case 5 -- lift the plant and the same push goes through. Both sides of one gate.
{
  echo "# REDS -- the pen's ledger"
  echo
  row 10 20260101.010101 "the first planted row."
  row 11 20260101.020202 "the second planted row."
  row 12 20260101.030303 "the row renumbered off the collision."
} > construction/REDS.md
git add -A
git commit --quiet -m "pen: renumber the unshared row"
if git push --quiet xy main 2>/dev/null && [ "$(remote_head)" != "$before" ]; then
  ok "the renumbered row publishes -- the gate lifts"
else
  no "the renumbered row was still refused"
fi

# Case 6 -- a REBINDING: upstream binds %12 to one stamp, this tree rewrites it to another.
before="$(remote_head)"
sed -i.bak 's/`20260101\.030303`/`20260101.040404`/' construction/REDS.md
rm -f construction/REDS.md.bak
git add -A
git commit --quiet -m "pen: rebind a published number to a different stamp"
set +e
git push --quiet xy main 2>/dev/null
push_code=$?
set -e
if [ "$push_code" -ne 0 ] && [ "$(remote_head)" = "$before" ]; then
  ok "a rebinding of a published number is refused, and the remote is untouched"
else
  no "a rebinding reached the remote (push exit $push_code)"
fi
git reset --quiet --hard HEAD~1

# Case 7 -- a PUBLISHED DOUBLE already upstream is never refused. A second clone with no hooks
# arms nothing, so it can publish the pair this wall exists to prevent; the wall then has to
# welcome every later push, because no lap may repair what is already shared (derived-spine rule 3).
git clone --quiet "$pen/up.git" "$pen/rogue"
(
  cd "$pen/rogue"
  git config user.email rogue@example.invalid
  git config user.name "Rogue Hand"
  git config commit.gpgsign false
  printf '\n' >> construction/REDS.md
  {
    echo "# REDS -- the pen's ledger"
    echo
    printf '**REDS %%10 (`20260101.010101`) -- the first planted row.** **OPEN**\n\n'
    printf '**REDS %%11 (`20260101.020202`) -- the second planted row.** **OPEN**\n\n'
    printf '**REDS %%12 (`20260101.030303`) -- the row renumbered off the collision.** **OPEN**\n\n'
    printf '**REDS %%12 (`20260101.050505`) -- a peer that booked the same number.** **OPEN**\n\n'
  } > construction/REDS.md
  git add -A
  git commit --quiet -m "rogue: publish a double the wall would have refused"
  git push --quiet origin main 2>/dev/null
)
git fetch --quiet xy
git reset --quiet --hard xy/main
printf '\n*a later lap, touching the pin and adding no number.*\n' >> construction/REDS.md
git add -A
git commit --quiet -m "pen: a later lap over a published double"
set +e
out7="$(git push xy main 2>&1)"
push_code=$?
set -e
if [ "$push_code" -eq 0 ]; then
  ok "a published double already upstream is welcomed, never refused"
else
  no "the wall refused a published double no lap may repair: $out7"
fi

# Case 8 -- a push carrying NO ledger change never asks the scan at all. Proven by taking the
# scan away: if the range read were decorative, this push would refuse.
mv tools/fixtures/r/reds_spine_derive_scan.sh "$pen/scan.hidden"
mkdir -p notes
echo "a lap that touched no ledger surface" > notes/plain.txt
git add -A
git commit --quiet -m "pen: a lap that touches no ledger surface"
if git push --quiet xy main 2>/dev/null; then
  ok "a push carrying no ledger change passes without the scan"
else
  no "a push carrying no ledger change was refused"
fi

# Case 9 -- and the same missing scan REFUSES the moment the push carries the ledger.
before="$(remote_head)"
row 13 20260101.060606 "a row pushed while the instrument is missing." >> construction/REDS.md
git add -A
git commit --quiet -m "pen: a ledger row with the instrument absent"
set +e
out9="$(git push xy main 2>&1)"
push_code=$?
set -e
if [ "$push_code" -ne 0 ] && [ "$(remote_head)" = "$before" ] && echo "$out9" | grep -q 'is missing'; then
  ok "a missing scan refuses a ledger-carrying push, naming what is absent"
else
  no "a missing scan let a ledger-carrying push through (exit $push_code)"
fi

# Case 10 -- an instrument that REFUSES is not an instrument that agrees. Exit 2 is a refusal.
cat > tools/fixtures/r/reds_spine_derive_scan.sh <<'STUB'
#!/bin/sh
echo "verdict=missing_ledger"
exit 2
STUB
set +e
out10="$(git push xy main 2>&1)"
push_code=$?
set -e
if [ "$push_code" -ne 0 ] && echo "$out10" | grep -q 'exit 2'; then
  ok "a scan that exits 2 refuses the push and says the reading refused"
else
  no "a scan exiting 2 was read as a clean ledger (exit $push_code)"
fi

# Case 11 -- restore the real scan and the same commit publishes. The exit-2 refusal lifts.
cp "$pen/scan.hidden" tools/fixtures/r/reds_spine_derive_scan.sh
if git push --quiet xy main 2>/dev/null; then
  ok "the restored scan lets the same commit publish -- the exit-2 gate lifts"
else
  no "the restored scan still refused"
fi

# Case 12 -- a delete publishes nothing, so it is never read for a ledger change. Proven with the
# scan hidden again: a delete that consulted the scan would refuse here.
git push --quiet xy main:refs/heads/scratch 2>/dev/null
mv tools/fixtures/r/reds_spine_derive_scan.sh "$pen/scan.hidden2"
if git push --quiet xy :refs/heads/scratch 2>/dev/null; then
  ok "a delete-only push passes without asking the scan"
else
  no "a delete-only push was refused"
fi
cp "$pen/scan.hidden2" tools/fixtures/r/reds_spine_derive_scan.sh

echo
echo "cases_ok=$pass cases_red=$fail"
if [ "$fail" -ne 0 ]; then echo "control_verdict=red"; exit 1; fi
echo "control_verdict=ok"
