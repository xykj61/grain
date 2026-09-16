#!/bin/sh
# claim_preserve_control.sh -- prove claim_preserve_scan.sh from both sides.
#
# Seated 20260915. The guard has stood since 20260724 with no control at all, so
# every claim it makes about itself has been a claim about code nobody exercised.
# This builds a real git repository in a throwaway pen, plants each refusal and
# then lifts it, and asserts the welcomes as hard as the refusals -- a refusal
# proven only in the passing direction cannot be told from a bypass.
#
# The reading under test is the MODALITY CLASS SPLIT: the scan sorts a drifted
# modal term into `obligation` (what the tree owes) or `register` (the words the
# register law asks a lap to recast) and prints a count of each. The refusal is
# unchanged -- any drift exits 1 -- so the legs below check the DIAGNOSIS.
#
#   sh tools/fixtures/c/claim_preserve_control.sh
#
# Emits `legs=N failures=M` and `control_verdict=ok|red`.
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$ROOT/rishi/bin" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done
cd "$ROOT"

# GNU `sed -i` and BSD `sed -i` have no common spelling, so the tree writes neither: the portable
# helper edits through a temporary and copies back through the original inode, which also keeps the
# mode the repository tracks. Gated at zero by tools/s/shell_dialect_witness.rish.
. "$ROOT/tools/fixtures/s/shell_portable.sh"

[ -x rishi/bin/rishi ] || { echo "control_verdict=red"; echo "detail: rishi/bin/rishi absent -- build it first"; exit 1; }

pen=$(mktemp -d "${TMPDIR:-/tmp}/claim-preserve-control.XXXXXX")
trap 'rm -rf "$pen"' EXIT

legs=0
failures=0

leg() {
  # leg <name> <expected: ok|red> <actual-exit> [<grep-pattern> <output-file>]
  legs=$((legs + 1))
  _name=$1
  _want=$2
  _got=$3
  if [ "$_want" = ok ] && [ "$_got" -ne 0 ]; then
    echo "leg ${_name} FAILED -- wanted exit 0, read ${_got}"
    failures=$((failures + 1))
    return 0
  fi
  if [ "$_want" = red ] && [ "$_got" -eq 0 ]; then
    echo "leg ${_name} FAILED -- wanted a refusal, read exit 0"
    failures=$((failures + 1))
    return 0
  fi
  if [ $# -ge 5 ]; then
    if grep -qF "$4" "$5"; then
      echo "leg ${_name} ok"
    else
      echo "leg ${_name} FAILED -- output lacks: $4"
      failures=$((failures + 1))
    fi
    return 0
  fi
  echo "leg ${_name} ok"
}

# ---- build the pen -------------------------------------------------------
# A real repository, since the scan reads BEFORE with `git show BASE:path` and
# derives its room roster from `git ls-files`.
mkdir -p "$pen/rishi/bin" "$pen/tools/fixtures/c" "$pen/tools/fixtures/p" \
         "$pen/tools/w" "$pen/linengrow" "$pen/doc"
cp rishi/bin/rishi "$pen/rishi/bin/rishi"
cp tools/fixtures/c/claim_preserve_scan.sh "$pen/tools/fixtures/c/"
cp tools/fixtures/c/claim_preserve_extract.rish "$pen/tools/fixtures/c/"
cp tools/fixtures/c/claim_preserve_modality.rish "$pen/tools/fixtures/c/"
cp tools/fixtures/p/prose_register_scan.sh "$pen/tools/fixtures/p/"

# Pin homes: the scan greps one line out of each, so a stub carrying that line
# is the whole of what it reads.
printf 'let corpus_digest = "penpenpen"\nlet corpus_count_pin = 7\n' >"$pen/tools/w/waymark_derive.rish"
printf 'const expected_demo_root_hex = "abcdef";\n' >"$pen/linengrow/seva_b0_fold.rye"

# The page under test. Its BEFORE body carries one obligation word and one
# negation word, so each class can be moved on its own.
cat >"$pen/doc/page.md" <<'PAGE'
# The pen page

A lap must stage exactly its own set.
A reviewer may read the staged set before the commit.
This page never reaches the public seed.
PAGE

cd "$pen"
git init -q .
git -c user.email=pen@example.invalid -c user.name=Pen add -A
git -c user.email=pen@example.invalid -c user.name=Pen commit -q -m "pen base"

# run_scan <outfile> -- CLAIM_PRESERVE_FILES already exported. It leaves the exit
# status in $scan_rc and returns 0 itself, so errexit never has to be toggled off
# around a call. Toggling it is what an earlier draft did, and the function's own
# `set -e` on the way out re-armed errexit before returning a refusal, which ended
# the control at its first planted red -- a control that stops on the thing it is
# proving reads exactly like a control that passed.
run_scan() {
  scan_rc=0
  sh tools/fixtures/c/claim_preserve_scan.sh >"$1" 2>&1 || scan_rc=$?
  return 0
}

export CLAIM_PRESERVE_FILES='doc/page.md'

# ---- leg 1: an untouched page is clean, and says so in both classes -------
run_scan "$pen/out1"; rc=$scan_rc
leg untouched_clean ok "$rc" "obligation_drift=0 register_drift=0" "$pen/out1"

# ---- leg 2: a weakened obligation is refused and named obligation ---------
sed_inplace 's/A lap must stage/A lap may stage/' doc/page.md
run_scan "$pen/out2"; rc=$scan_rc
leg obligation_refused red "$rc" "obligation_drift=2 register_drift=0" "$pen/out2"
leg obligation_named red "$rc" "obligation must: 1 -> 0" "$pen/out2"
git checkout -q -- doc/page.md

# ---- leg 3: a register recast is refused and named register --------------
# The very move the register law asks for: lead with what is.
sed_inplace 's/This page never reaches the public seed./This page stays inside the working field./' doc/page.md
run_scan "$pen/out3"; rc=$scan_rc
leg register_refused red "$rc" "register never: 1 -> 0" "$pen/out3"
leg register_not_obligation red "$rc" "obligation_drift=0 register_drift=1" "$pen/out3"
git checkout -q -- doc/page.md

# ---- leg 4: the restatement half -- `all` rises with no negation removed --
# This is the shape measured on skate/README.md at f258e5f58: a positive
# restatement raises a quantifier no negation vocabulary would ever name. The
# sentence is APPENDED rather than swapped, so `all` is the only term that moves.
printf 'The pen, the page and the counter all stay inside the pen.\n' >>doc/page.md
run_scan "$pen/out4"; rc=$scan_rc
leg restatement_is_register red "$rc" "register all: 0 -> 1" "$pen/out4"
leg restatement_not_obligation red "$rc" "obligation_drift=0 register_drift=1" "$pen/out4"
git checkout -q -- doc/page.md

# ---- leg 5: both classes move at once, and both are counted --------------
sed_inplace 's/A lap must stage/A lap may stage/' doc/page.md
sed_inplace 's/This page never reaches the public seed./This page stays inside the working field./' doc/page.md
run_scan "$pen/out5"; rc=$scan_rc
leg both_classes red "$rc" "obligation_drift=2 register_drift=1" "$pen/out5"
git checkout -q -- doc/page.md

# ---- leg 6: a vacuous call fails closed ----------------------------------
rc=0
CLAIM_PRESERVE_FILES= sh tools/fixtures/c/claim_preserve_scan.sh >"$pen/out6" 2>&1 || rc=$?
leg vacuous_refused red "$rc" "CLAIM_PRESERVE_FILES empty" "$pen/out6"

# ---- leg 7: a named file absent from the working tree is refused ---------
rc=0
CLAIM_PRESERVE_FILES='doc/absent.md' sh tools/fixtures/c/claim_preserve_scan.sh >"$pen/out7" 2>&1 || rc=$?
leg absent_refused red "$rc" "FAIL missing working tree" "$pen/out7"

# ---- leg 8: a file the BASE does not carry is refused --------------------
printf 'new page\n' >doc/fresh.md
rc=0
CLAIM_PRESERVE_FILES='doc/fresh.md' sh tools/fixtures/c/claim_preserve_scan.sh >"$pen/out8" 2>&1 || rc=$?
leg unborn_refused red "$rc" "claim_preserve compares an existing file" "$pen/out8"
rm -f doc/fresh.md

# ---- leg 9: a moved pinned digest is refused -----------------------------
sed_inplace 's/penpenpen/movedmoved/' tools/w/waymark_derive.rish
run_scan "$pen/out9"; rc=$scan_rc
leg pin_moved_refused red "$rc" "FAIL pinned digest moved" "$pen/out9"
git checkout -q -- tools/w/waymark_derive.rish

# ---- MUTATION A: drop the derived negation vocabulary --------------------
# The scan reads prose_register_scan.sh's own `neg` line. Break that line and the
# scan must refuse rather than silently calling every term an obligation.
cp tools/fixtures/p/prose_register_scan.sh "$pen/preg.keep"
sed_inplace 's/^\([[:space:]]*\)neg = "/\1negX = "/' tools/fixtures/p/prose_register_scan.sh
run_scan "$pen/outA"; rc=$scan_rc
leg mutation_neg_unreadable red "$rc" "FAIL negation vocabulary unreadable" "$pen/outA"
cp "$pen/preg.keep" tools/fixtures/p/prose_register_scan.sh

# ---- MUTATION B: empty the restatement list ------------------------------
# With RESTATE_WORDS empty, `all` falls through to the negation test, which does
# not name it, so the scan would call a restatement an obligation. Leg 4's
# reading is what bites.
cp tools/fixtures/c/claim_preserve_scan.sh "$pen/scan.keep"
sed_inplace 's/^RESTATE_WORDS=.*/RESTATE_WORDS=" "/' tools/fixtures/c/claim_preserve_scan.sh
printf 'The pen, the page and the counter all stay inside the pen.\n' >>doc/page.md
run_scan "$pen/outB"; rc=$scan_rc
legs=$((legs + 1))
if grep -qF "obligation all: 0 -> 1" "$pen/outB"; then
  echo "leg mutation_restatement_bites ok"
else
  echo "leg mutation_restatement_bites FAILED -- emptying RESTATE_WORDS changed no classification"
  failures=$((failures + 1))
fi
git checkout -q -- doc/page.md
cp "$pen/scan.keep" tools/fixtures/c/claim_preserve_scan.sh

# ---- MUTATION C: send the derived negation branch to the wrong class -------
# Mutation A proves the scan REFUSES when the vocabulary is unreadable. This
# proves the vocabulary is what actually classifies: flip the branch that the
# grep against prose_register_scan.sh's own `neg` list feeds, and leg 3's
# `never` must come back named obligation.
cp tools/fixtures/c/claim_preserve_scan.sh "$pen/scan.keep2"
awk '{ if ($0 == "    echo register") print "    echo obligation"; else print }' \
  "$pen/scan.keep2" >tools/fixtures/c/claim_preserve_scan.sh
sed_inplace 's/This page never reaches the public seed./This page stays inside the working field./' doc/page.md
run_scan "$pen/outC"; rc=$scan_rc
legs=$((legs + 1))
if grep -qF "obligation never: 1 -> 0" "$pen/outC"; then
  echo "leg mutation_derived_branch_bites ok"
else
  echo "leg mutation_derived_branch_bites FAILED -- the derived vocabulary classifies nothing"
  failures=$((failures + 1))
fi
git checkout -q -- doc/page.md
cp "$pen/scan.keep2" tools/fixtures/c/claim_preserve_scan.sh

echo "legs=${legs} failures=${failures}"
if [ "$failures" -gt 0 ]; then
  echo "control_verdict=red"
  exit 1
fi
echo "control_verdict=ok"
exit 0
