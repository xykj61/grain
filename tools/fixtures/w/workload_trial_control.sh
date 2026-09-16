#!/bin/sh
# tools/fixtures/w/workload_trial_control.sh -- proves the behaviors of
# tools/fixtures/w/workload_trial_scan.sh in a throwaway pen, every reading shown from both sides.
#
# WHAT IS PLANTED AND WHAT IS MUTATED. Readings 1 and 2 have a population -- a page and the
# instruments it names -- so they are proven by PLANTING pages and instruments whose right answer
# is known by construction, then removing the plant and watching the reading return. Reading 3
# opens no file, so its arithmetic is proven by MUTATING a copy of the scan and asserting the
# verdict moves; a mutation that no longer applies reads exactly like one that passed, so each
# asserts it was applied before it is run.
#
#   sh tools/fixtures/w/workload_trial_control.sh

set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_steps=0
while [ ! -d "$ROOT/tools/fixtures" ]; do
  _steps=$((_steps + 1))
  [ "$_steps" -gt 8 ] && { echo "$0: no tree root" >&2; exit 2; }
  ROOT=$(dirname "$ROOT")
done
SCAN="$ROOT/tools/fixtures/w/workload_trial_scan.sh"

# One shell dialect on both piers: `sed -i` takes no argument on GNU and REQUIRES a backup suffix on
# BSD, so the flag is gated at zero tree-wide and `sed_inplace` is the portable form.
. "$ROOT/tools/fixtures/s/shell_portable.sh"

PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT INT TERM

pass=0
fail=0
legs=0
LEGS_EXPECTED=62

ok() { legs=$((legs + 1)); pass=$((pass + 1)); echo "ok   $legs $1"; }
no() { legs=$((legs + 1)); fail=$((fail + 1)); echo "FAIL $legs $1"; }
check() { if [ "$2" = "$3" ]; then ok "$1"; else no "$1 -- wanted [$3], read [$2]"; fi; }
gt()  { if [ "$2" -gt "$3" ] 2>/dev/null; then ok "$1"; else no "$1 -- wanted over $3, read [$2]"; fi; }
field() { awk -v k="$1" -F= '$1 == k { print $2 }' "$2" | tail -1; }

# --- the pen's own tree -------------------------------------------------------------------------
# The scan reads instrument paths relative to the working directory, so the pen is entered and the
# plants are laid out under it exactly as they sit in the real tree.

mkdir -p "$PEN/tools/fixtures/p" "$PEN/tools/p" "$PEN/pages"
cd "$PEN"

plant_page() {
  # $1 destination, then each further argument is one erratum line's instrument list.
  _dest="$1"; shift
  {
    echo "# A planted page"
    _n=1
    for _ins in "$@"; do
      echo "**Row $_n erratum:** \`$_ins\` produced this reading. Recommended re-rank: last."
      _n=$((_n + 1))
    done
    echo ""
    echo "## What this page is"
    echo ""
    echo "### 1. A row with no number in it"
    echo "**Claim.** The wrap carries the bound."
    echo "**Confidence.** Medium."
    echo ""
    echo "### 2. A second row, equally numberless"
    echo "**Claim.** A bearing meets rather than floods."
    echo "**Confidence.** Low."
    echo ""
    echo "## The ranking"
    echo ""
    echo "| Rank | Row | Why here |"
  } > "$_dest"
}

# --- absence refuses ----------------------------------------------------------------------------

sh "$SCAN" --page "pages/nothing-here.md" --no-timing > "$PEN/absent.txt" 2>&1 || true
check "an absent page refuses" "$(field verdict "$PEN/absent.txt")" "unreadable"
check "an absent page names the path" \
  "$(grep -c 'detail: page absent' "$PEN/absent.txt")" "1"

# --- bounds refuse ------------------------------------------------------------------------------

plant_page "pages/plain.md" "tools/fixtures/p/plain_scan.sh"
printf '#!/bin/sh\necho hi\n' > tools/fixtures/p/plain_scan.sh

sh "$SCAN" --page "pages/plain.md" --runs 1 > "$PEN/lo.txt" 2>&1 || true
check "a baseline of one refuses" "$(field verdict "$PEN/lo.txt")" "unreadable"
sh "$SCAN" --page "pages/plain.md" --runs 999 > "$PEN/hi.txt" 2>&1 || true
check "a baseline past the ceiling refuses" "$(field verdict "$PEN/hi.txt")" "unreadable"
sh "$SCAN" --page "pages/plain.md" --runs twelve > "$PEN/nan.txt" 2>&1 || true
check "a baseline that is not a count exits 2" "$?" "0"
check "a non-count baseline says so on stderr" \
  "$(grep -c 'not a count' "$PEN/nan.txt")" "1"
sh "$SCAN" --page "pages/plain.md" --nonsense > "$PEN/flag.txt" 2>&1 || true
check "an unknown flag says so" "$(grep -c 'unknown flag' "$PEN/flag.txt")" "1"

# --- reading 1 -- the four classifications, each planted -----------------------------------------

cat > tools/fixtures/p/host_scan.sh <<'EOF'
#!/bin/sh
cat /sys/class/powercap/intel-rapl/energy_uj
EOF
cat > tools/fixtures/p/metal_scan.sh <<'EOF'
#!/bin/sh
rye run tools/rye/something.rye
EOF
cat > tools/fixtures/p/bytes_scan.sh <<'EOF'
#!/bin/sh
git ls-files | wc -l
EOF
cat > tools/fixtures/p/arith_scan.sh <<'EOF'
#!/bin/sh
awk 'BEGIN{ print 2 + 2 }'
EOF

plant_page "pages/four.md" \
  "tools/fixtures/p/host_scan.sh" \
  "tools/fixtures/p/metal_scan.sh" \
  "tools/fixtures/p/bytes_scan.sh" \
  "tools/fixtures/p/arith_scan.sh"

sh "$SCAN" --page "pages/four.md" --no-timing > "$PEN/four.txt" 2>&1 || true
check "four errata counted"        "$(field errata_found "$PEN/four.txt")"       "4"
check "four instruments named"     "$(field instruments_named "$PEN/four.txt")"  "4"
check "a host read reads host"     "$(field funded_host "$PEN/four.txt")"        "1"
check "a compiler run reads metal" "$(field funded_metal "$PEN/four.txt")"       "1"
check "a tracked read reads bytes" "$(field funded_bytes "$PEN/four.txt")"       "1"
check "arithmetic reads arithmetic" "$(field funded_arithmetic "$PEN/four.txt")" "1"
check "nothing absent"             "$(field funded_absent "$PEN/four.txt")"      "0"
check "four re-ranks counted"      "$(field reranks_recommended "$PEN/four.txt")" "4"
check "no timing reads partial"    "$(field verdict "$PEN/four.txt")"            "partial"
check "no timing says it skipped"  "$(field timing "$PEN/four.txt")"             "skipped"

# --- a named instrument that is not there --------------------------------------------------------

plant_page "pages/gone.md" "tools/fixtures/p/vanished_scan.sh"
sh "$SCAN" --page "pages/gone.md" --no-timing > "$PEN/gone.txt" 2>&1 || true
check "a named absent instrument counts"  "$(field funded_absent "$PEN/gone.txt")" "1"
check "and names itself on a detail line" \
  "$(grep -c 'instrument named and absent' "$PEN/gone.txt")" "1"
check "and lands in no classification" \
  "$(( $(field funded_host "$PEN/gone.txt") + $(field funded_metal "$PEN/gone.txt") \
     + $(field funded_bytes "$PEN/gone.txt") + $(field funded_arithmetic "$PEN/gone.txt") ))" "0"

# --- a moved instrument resolves, and an absent one still refuses ---------------------------------
# The page carries a one-clock stamp, so it is testimony and keeps the path it wrote; `tools/` folds
# by first sprig letter and that fold is a pure function of the basename, so an elder path is
# recomputed rather than read as absent. Both sides are shown: the plant resolves, and removing it
# returns the reading to absent.

mkdir -p tools/fixtures/b tools/fixtures/be
plant_page "pages/moved.md" "tools/fixtures/m/bearing_scan.sh"
printf '#!/bin/sh\ngit ls-files "*.rye"\n' > tools/fixtures/b/bearing_scan.sh
sh "$SCAN" --page "pages/moved.md" --no-timing > "$PEN/moved.txt" 2>&1 || true
check "a moved instrument is not absent" "$(field funded_absent "$PEN/moved.txt")" "0"
check "and says where it now stands" \
  "$(grep -c 'instrument resolved' "$PEN/moved.txt")" "1"
check "and is classified from the room it moved to" \
  "$(field funded_bytes "$PEN/moved.txt")" "1"

rm -f tools/fixtures/b/bearing_scan.sh
sh "$SCAN" --page "pages/moved.md" --no-timing > "$PEN/moved-gone.txt" 2>&1 || true
check "and without the plant it is absent again" \
  "$(field funded_absent "$PEN/moved-gone.txt")" "1"

printf '#!/bin/sh\ngit ls-files "*.rye"\n' > tools/fixtures/be/bearing_scan.sh
sh "$SCAN" --page "pages/moved.md" --no-timing > "$PEN/moved2.txt" 2>&1 || true
check "the two-letter room resolves too" "$(field funded_absent "$PEN/moved2.txt")" "0"
rm -f tools/fixtures/be/bearing_scan.sh

# --- a comment is not a reading ------------------------------------------------------------------
# The one false positive this family is prone to: these instruments cite each other in prose, so a
# header naming /sys or a compiler must not classify the instrument that merely mentions it.

cat > tools/fixtures/p/talks_scan.sh <<'EOF'
#!/bin/sh
# This scan's elder read /sys/class/powercap and ran `rye run` over git ls-files output.
# It does none of those now; the header says so and nothing below opens a file.
awk 'BEGIN{ print 1 }'
EOF
plant_page "pages/talks.md" "tools/fixtures/p/talks_scan.sh"
sh "$SCAN" --page "pages/talks.md" --no-timing > "$PEN/talks.txt" 2>&1 || true
check "a header naming /sys reads arithmetic" \
  "$(field funded_arithmetic "$PEN/talks.txt")" "1"
check "and reads host zero" "$(field funded_host "$PEN/talks.txt")" "0"
check "and reads metal zero" "$(field funded_metal "$PEN/talks.txt")" "0"

# --- one delegation hop, and a mention is not a delegate -------------------------------------------

cat > tools/fixtures/p/deep_control.sh <<'EOF'
#!/bin/sh
rye run tools/rye/driver.rye -femit-bin=/tmp/x
EOF
cat > tools/p/deep_witness.rish <<'EOF'
let ctl = run ["sh" "tools/fixtures/p/deep_control.sh"]
assert ctl.ok else "control failed"
EOF
plant_page "pages/deep.md" "tools/p/deep_witness.rish"
sh "$SCAN" --page "pages/deep.md" --no-timing > "$PEN/deep.txt" 2>&1 || true
check "a witness inherits its control's metal" "$(field funded_metal "$PEN/deep.txt")" "1"
check "and does not read arithmetic" "$(field funded_arithmetic "$PEN/deep.txt")" "0"

cat > tools/fixtures/p/reader_scan.sh <<'EOF'
#!/bin/sh
# The population this reads is a compiler source; reading its text is not running it.
grep -c 'fn ' tally/copy.rye
EOF
mkdir -p tally
printf 'fn copy_disjoint() {}\n' > tally/copy.rye
plant_page "pages/reader.md" "tools/fixtures/p/reader_scan.sh"
sh "$SCAN" --page "pages/reader.md" --no-timing > "$PEN/reader.txt" 2>&1 || true
check "naming a .rye source reads bytes, never metal" \
  "$(field funded_bytes "$PEN/reader.txt")" "1"
check "and reads metal zero" "$(field funded_metal "$PEN/reader.txt")" "0"

# --- an instrument cannot classify itself ----------------------------------------------------------
# The scan's own classifier holds every marker it looks for as a grep argument, so reading its own
# body would count its questions as its answers. It read `host` on the lap its own erratum landed.

mkdir -p tools/fixtures/w
cat > tools/fixtures/w/workload_trial_scan.sh <<'EOF'
#!/bin/sh
grep -qE '/sys/|powercap' "$1"
EOF
plant_page "pages/self.md" "tools/fixtures/w/workload_trial_scan.sh"
sh "$SCAN" --page "pages/self.md" --no-timing > "$PEN/self.txt" 2>&1 || true
check "the scan reads past its own path"   "$(field instruments_named "$PEN/self.txt")" "0"
check "and says so on a detail line"   "$(grep -c 'an instrument cannot classify itself' "$PEN/self.txt")" "1"
check "so it lands in no classification" "$(field funded_host "$PEN/self.txt")" "0"
check "and the erratum is still counted" "$(field errata_found "$PEN/self.txt")" "1"

# --- a .rye instrument is metal by its own extension ----------------------------------------------

mkdir -p tools/rye
printf 'const std = @import("std");\n' > tools/rye/measure.rye
plant_page "pages/rye.md" "tools/rye/measure.rye"
sh "$SCAN" --page "pages/rye.md" --no-timing > "$PEN/rye.txt" 2>&1 || true
check "a .rye instrument reads metal" "$(field funded_metal "$PEN/rye.txt")" "1"

# --- reading 2 -- the operand, from both sides ----------------------------------------------------

plant_page "pages/noeffect.md" "tools/fixtures/p/arith_scan.sh"
sh "$SCAN" --page "pages/noeffect.md" --no-timing > "$PEN/noeffect.txt" 2>&1 || true
check "two row bodies read"      "$(field rows_read "$PEN/noeffect.txt")" "2"
check "no effect size found"     "$(field rows_with_effect_size "$PEN/noeffect.txt")" "0"

plant_page "pages/effect.md" "tools/fixtures/p/arith_scan.sh"
sed_inplace 's/^\*\*Claim\.\*\* The wrap carries the bound\./**Claim.** The wrap cuts wake-ups by 40 percent./' \
  "pages/effect.md"
sh "$SCAN" --page "pages/effect.md" --no-timing > "$PEN/effect.txt" 2>&1 || true
check "a percentage is an effect size" \
  "$(field rows_with_effect_size "$PEN/effect.txt")" "1"

plant_page "pages/multiplier.md" "tools/fixtures/p/arith_scan.sh"
sed_inplace 's/^\*\*Claim\.\*\* The wrap carries the bound\./**Claim.** The wrap is 3.5x faster than the mesh./' \
  "pages/multiplier.md"
sh "$SCAN" --page "pages/multiplier.md" --no-timing > "$PEN/mult.txt" 2>&1 || true
check "a multiplier is an effect size" \
  "$(field rows_with_effect_size "$PEN/mult.txt")" "1"

# --- a page with no row bodies at all --------------------------------------------------------------

printf '# no rows here\n\nnothing at all\n' > "pages/empty.md"
sh "$SCAN" --page "pages/empty.md" --no-timing > "$PEN/empty.txt" 2>&1 || true
check "a page with no row bodies says so" \
  "$(field rows_with_effect_size "$PEN/empty.txt")" "unreadable"
check "and names why on a detail line" \
  "$(grep -c 'row bodies unlocatable' "$PEN/empty.txt")" "1"

# --- the bold re-rank form counts ------------------------------------------------------------------

plant_page "pages/bold.md" "tools/fixtures/p/arith_scan.sh"
sed_inplace 's/Recommended re-rank: last\./Recommended **re-aim rather than re-rank**: keep the row./' \
  "pages/bold.md"
sh "$SCAN" --page "pages/bold.md" --no-timing > "$PEN/bold.txt" 2>&1 || true
check "a bolded re-aim counts too" "$(field reranks_recommended "$PEN/bold.txt")" "1"

# --- the verdicts, each from its own side -----------------------------------------------------------

check "no operand names itself" "$(field verdict "$PEN/four.txt")" "partial"

sh "$SCAN" --page "pages/four.md" --runs 2 --trials 2 > "$PEN/timed.txt" 2>&1 || true
check "a page with no effect size reads falsifier_without_operand" \
  "$(field verdict "$PEN/timed.txt")" "falsifier_without_operand"
check "and says the operand is absent" \
  "$(field operand_present "$PEN/timed.txt")" "no"
check "and reports the metal funding it found" \
  "$(field ordering_funded_by_metal "$PEN/timed.txt")" "yes"

plant_page "pages/nometal.md" "tools/fixtures/p/arith_scan.sh"
sed_inplace 's/^\*\*Claim\.\*\* The wrap carries the bound\./**Claim.** The wrap cuts wake-ups by 40 percent./' \
  "pages/nometal.md"
sh "$SCAN" --page "pages/nometal.md" --runs 2 --trials 2 > "$PEN/nometal.txt" 2>&1 || true
check "an operand present with no metal reads funded_without_metal" \
  "$(field verdict "$PEN/nometal.txt")" "funded_without_metal"
check "and says the operand is present" \
  "$(field operand_present "$PEN/nometal.txt")" "yes"
check "and says metal funded nothing" \
  "$(field ordering_funded_by_metal "$PEN/nometal.txt")" "no"

plant_page "pages/runnable.md" "tools/fixtures/p/metal_scan.sh"
sed_inplace 's/^\*\*Claim\.\*\* The wrap carries the bound\./**Claim.** The wrap cuts wake-ups by 40 percent./' \
  "pages/runnable.md"
sh "$SCAN" --page "pages/runnable.md" --runs 2 --trials 2 > "$PEN/runnable.txt" 2>&1 || true
check "an operand and metal together read runnable" \
  "$(field verdict "$PEN/runnable.txt")" "runnable"

# --- reading 3 -- the timing arithmetic ---------------------------------------------------------------

sh "$SCAN" --page "pages/plain.md" --runs 4 --trials 3 > "$PEN/time.txt" 2>&1 || true
check "the baseline run count is reported" "$(field baseline_runs "$PEN/time.txt")" "4"
check "the trial count is reported"        "$(field trial_runs "$PEN/time.txt")"    "3"
gt "a wall minimum was measured"  "$(field wall_min_ms "$PEN/time.txt")" "0"
gt "a wall maximum was measured"  "$(field wall_max_ms "$PEN/time.txt")" "0"

_lo=$(field wall_min_ms "$PEN/time.txt")
_hi=$(field wall_max_ms "$PEN/time.txt")
if [ "$_hi" -ge "$_lo" ]; then ok "the maximum is at or above the minimum"
else no "the maximum is at or above the minimum -- read $_hi against $_lo"; fi

_in=$(field trials_inside_baseline "$PEN/time.txt")
if [ "$_in" -ge 0 ] && [ "$_in" -le 3 ]; then ok "the inside count is inside the trial count"
else no "the inside count is inside the trial count -- read $_in of 3"; fi

check "the resolvable floor is the spread" \
  "$(field resolvable_floor_pct "$PEN/time.txt")" "$(field spread_pct "$PEN/time.txt")"

# --- mutations, each asserted applied before it is run -------------------------------------------------

mutate() {
  # $1 label, $2 sed program, $3 the key that must move, $4 the value it must NOT keep,
  # $5 the planted page the mutation is read against
  cp "$SCAN" "$PEN/mutant.sh"
  sed_inplace "$2" "$PEN/mutant.sh"
  if cmp -s "$SCAN" "$PEN/mutant.sh"; then
    no "$1 -- the mutation did not apply, so the leg proves nothing"
    return
  fi
  sh "$PEN/mutant.sh" --page "$5" --no-timing > "$PEN/mutant.txt" 2>&1 || true
  _got=$(field "$3" "$PEN/mutant.txt")
  if [ "$_got" = "$4" ]; then
    no "$1 -- $3 still reads [$4] with the mutation in"
  else
    ok "$1 -- $3 moved off [$4] to [$_got]"
  fi
}

mutate "dropping the delegation hop loses the witness's metal" \
  '/kind=$(heavier "$kind" "$dkind")/d' funded_metal 1 "pages/deep.md"

mutate "dropping comment stripping breaks the classification" \
  "s|_body=\$(sed 's/\^\[\[:space:\]\]\*#\.\*\$//' \"\$_f\")|_body=\$(cat \"\$_f\")|" \
  funded_arithmetic 1 "pages/talks.md"

check "every mutation applied and bit" "$fail" "0"

# --- the tally -----------------------------------------------------------------------------------------

echo "control_legs=$legs"
echo "control_expected=$LEGS_EXPECTED"
echo "control_passed=$pass"
echo "control_failed=$fail"
if [ "$legs" -ne "$LEGS_EXPECTED" ]; then
  echo "detail: leg count moved -- a leg added or lost is a leg nobody heard"
  echo "control_verdict=leg_count_moved"
  exit 0
fi
if [ "$fail" -ne 0 ]; then
  echo "control_verdict=failed"
  exit 0
fi
echo "control_verdict=ok"
