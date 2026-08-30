#!/bin/sh
# tools/fixtures/p/pin_bound_touch_control.sh -- the pen for pin_bound_touch_scan.sh.
#
# Twenty cases on real git repositories in a throwaway directory. Every refusal is shown from both
# sides -- planted and then removed -- because a refusal proven only in the passing direction cannot
# be told from a bypass, and every welcome is asserted as hard as every refusal, because a guard
# that reds on ordinary work is a guard somebody turns off.
#
# The pen carries its own copy of the bound law with small numbers in it, so a plant is a few bytes
# rather than twenty-four kilobytes and the per-path exception can be proven without touching the
# real tree's law. The scan and the bound reader are copied in at the same relative layout they
# stand in here, since the reader resolves the law from its own location rather than from the
# caller's working directory.
#
#   bash tools/fixtures/p/pin_bound_touch_control.sh
#
# Run from the repository root; the pen is removed on exit whether it passes or fails.
set -u

# The Codex supervisor exposes its canonical Git through a small shell launcher. Invoke that
# launcher under the same explicit Bash proven for the scan; calling its macOS /bin/sh shebang
# directly would re-enter the selector this enclosure cannot read. Ordinary benches keep their
# native `git` command.
if [ -n "${GRAIN_MIND_GIT:-}" ] && [ -f "$GRAIN_MIND_GIT" ]; then
  git() { bash "$GRAIN_MIND_GIT" "$@"; }
fi

scan=tools/fixtures/p/pin_bound_touch_scan.sh
reader=tools/fixtures/l/living_pin_max_bytes.sh
for f in "$scan" "$reader"; do
  if [ ! -f "$f" ]; then
    echo "control=refused"
    echo "refused: $f is what this pen drives, and it is absent" >&2
    exit 1
  fi
done

mkdir -p .mind-state/tmp
pen=$(mktemp -d .mind-state/tmp/pin-bound.XXXXXX) || exit 1
trap 'rm -rf "$pen"' EXIT

fails=0
ok() { echo "case=$1 ok"; }
no() { echo "case=$1 FAILED -- $2"; fails=$((fails + 1)); }

# The pen wears the root's two markers -- rishi/bin and tools/fixtures -- and mirrors the folded
# letter rooms, so the copies' depth-proof walk (letter fold, seated 20260828) resolves the pen
# root: the scan reaches the reader at l/, and the reader reads the pen's own law.
mkdir -p "$pen/tools/fixtures/p" "$pen/tools/fixtures/l" "$pen/rishi/bin" "$pen/context/specs" "$pen/construction"
cp "$scan" "$pen/tools/fixtures/p/pin_bound_touch_scan.sh"
cp "$reader" "$pen/tools/fixtures/l/living_pin_max_bytes.sh"

# The pen's own law. Small numbers keep every plant a few bytes wide, and the bracketed line proves
# the per-path exception is honored by this reading rather than only by the roster guard.
cat > "$pen/context/specs/20260724-132812_pin-and-ledger-living-pin-max-bytes.md" <<'LAW'
# Pin and Ledger -- the pen's own bound law
living_pin_max_bytes = 100  // small on purpose: a plant is bytes, not kilobytes
living_pin_max_bytes[construction/WIDE.md] = 400  // the per-path exception, under test
LAW

TAB=$(printf '\t')
roster="tools/fixtures/roster.txt"
{
  echo "# the pen's roster"
  printf 'construction/A.md%s10%sPin A%senforce\n' "$TAB" "$TAB" "$TAB"
  printf 'construction/B.md%s10%sPin B%senforce\n' "$TAB" "$TAB" "$TAB"
  printf 'construction/SOFT.md%s10%sPin SOFT%sadvisory\n' "$TAB" "$TAB" "$TAB"
  printf 'construction/WIDE.md%s10%sPin WIDE%senforce\n' "$TAB" "$TAB" "$TAB"
} > "$pen/$roster"

# fill <path> <bytes> -- a file of exactly N bytes, so a boundary can be met from either side.
fill() {
  : > "$pen/$1"
  i=0
  while [ "$i" -lt "$2" ]; do printf 'x' >> "$pen/$1"; i=$((i + 1)); done
}

( cd "$pen" && git init -q . && git config user.email pen@example.invalid \
  && git config user.name Pen && git config commit.gpgsign false ) || {
  echo "control=refused"; echo "refused: the pen could not become a git repository" >&2; exit 1; }

run()      { ( cd "$pen" && PIN_BOUND_SHELL=bash bash tools/fixtures/p/pin_bound_touch_scan.sh "$@" 2>/dev/null ); }
verdict()  { run "$@" | grep '^verdict=' | head -1 | cut -d= -f2; }
key()      { k=$1; shift; run "$@" | grep "^$k=" | head -1 | cut -d= -f2; }
exits()    { ( cd "$pen" && PIN_BOUND_SHELL=bash bash tools/fixtures/p/pin_bound_touch_scan.sh "$@" >/dev/null 2>&1 ); echo $?; }

# --- a first commit, so HEAD exists and every pin starts lawful ---------------------------------
fill construction/A.md 50
fill construction/B.md 50
fill construction/SOFT.md 50
fill construction/WIDE.md 50
( cd "$pen" && git add -A && git commit -q -m "pen: the pins start lawful" ) || {
  echo "control=refused"; echo "refused: the pen could not make its first commit" >&2; exit 1; }

[ "$(verdict staged --roster "$roster")" = ok ] \
  && ok clean_index_green || no clean_index_green "an empty index touches no pin and must pass"

# --- 1. an over-bound enforced pin in the index, bitten -----------------------------------------
fill construction/A.md 150
( cd "$pen" && git add construction/A.md )
[ "$(verdict staged --roster "$roster")" = misread ] \
  && ok over_bitten || no over_bitten "a staged pin past its bound must refuse"
[ "$(exits staged --roster "$roster")" = 1 ] \
  && ok over_exits_nonzero || no over_exits_nonzero "a refusal must exit non-zero"
[ "$(key detail_path staged --roster "$roster")" = construction/A.md ] \
  && ok over_names_path || no over_names_path "the refusal must name the pin it caught"
[ "$(key detail_over_by staged --roster "$roster")" = 50 ] \
  && ok over_names_overage || no over_names_overage "the refusal must say how far over"

# --- 2. the same refusal from the other side: remove the plant ----------------------------------
fill construction/A.md 50
( cd "$pen" && git add construction/A.md )
[ "$(verdict staged --roster "$roster")" = ok ] \
  && ok over_freed || no over_freed "a pin brought back under bound must pass"

# --- 3. every pin is weighed before any refusal (the e123 first-exit fault) ----------------------
fill construction/A.md 150
fill construction/B.md 200
( cd "$pen" && git add construction/A.md construction/B.md )
[ "$(key over_bound_enforced staged --roster "$roster")" = 2 ] \
  && ok both_pins_weighed || no both_pins_weighed "two over-bound pins must both be counted"
run staged --roster "$roster" | grep -q '^detail_path=construction/B.md' \
  && ok second_pin_named || no second_pin_named "the second over-bound pin must be named, not hidden"
fill construction/A.md 50
fill construction/B.md 50
( cd "$pen" && git add construction/A.md construction/B.md )

# --- 4. advisory is reported and never refuses ---------------------------------------------------
fill construction/SOFT.md 150
( cd "$pen" && git add construction/SOFT.md )
[ "$(verdict staged --roster "$roster")" = ok ] \
  && ok advisory_free || no advisory_free "an advisory pin over bound is tidy debt, not a refusal"
[ "$(key over_bound_advisory staged --roster "$roster")" = 1 ] \
  && ok advisory_counted || no advisory_counted "an advisory overage must still be counted"
fill construction/SOFT.md 50
( cd "$pen" && git add construction/SOFT.md )

# --- 5. the per-path exception is honored --------------------------------------------------------
fill construction/WIDE.md 300
( cd "$pen" && git add construction/WIDE.md )
[ "$(verdict staged --roster "$roster")" = ok ] \
  && ok exception_honored || no exception_honored "a page with its own bound must be read by it"
[ "$(key pin_bound staged --roster "$roster")" = 400 ] \
  && ok exception_bound_read || no exception_bound_read "the exception's number must be the one read"
fill construction/WIDE.md 500
( cd "$pen" && git add construction/WIDE.md )
[ "$(verdict staged --roster "$roster")" = misread ] \
  && ok exception_still_bites || no exception_still_bites "a page past its own bound must still refuse"
fill construction/WIDE.md 50
( cd "$pen" && git add construction/WIDE.md )

# --- 6. the boundary, from both sides ------------------------------------------------------------
fill construction/A.md 100
( cd "$pen" && git add construction/A.md )
[ "$(verdict staged --roster "$roster")" = ok ] \
  && ok boundary_inside || no boundary_inside "exactly at the bound is inside it"
fill construction/A.md 101
( cd "$pen" && git add construction/A.md )
[ "$(verdict staged --roster "$roster")" = misread ] \
  && ok boundary_outside || no boundary_outside "one byte past the bound must refuse"
fill construction/A.md 50
( cd "$pen" && git add construction/A.md )

# --- 7. the index is the reading, not the disk ---------------------------------------------------
fill construction/A.md 150
( cd "$pen" && git add construction/A.md )
fill construction/A.md 50
[ "$(verdict staged --roster "$roster")" = misread ] \
  && ok index_over_disk || no index_over_disk "a fat blob in the index must refuse though disk is thin"
fill construction/A.md 150
( cd "$pen" && git add construction/A.md ) && fill construction/A.md 150
( cd "$pen" && git add construction/A.md )
fill construction/A.md 50
( cd "$pen" && git add construction/A.md )
fill construction/A.md 150
[ "$(verdict staged --roster "$roster")" = ok ] \
  && ok thin_index_passes || no thin_index_passes "a thin blob in the index passes though disk is fat"
fill construction/A.md 50

# --- 8. a round that touches no pin is untouched by this reading ----------------------------------
( cd "$pen" && git add -A && git commit -q -m "pen: back to lawful" >/dev/null 2>&1 || true )
fill construction/A.md 150
echo hello > "$pen/notes.txt"
( cd "$pen" && git add notes.txt )
[ "$(verdict staged --roster "$roster")" = ok ] \
  && ok untouched_pin_ignored || no untouched_pin_ignored "an over-bound pin the round never staged says nothing here"
[ "$(key touched_pins staged --roster "$roster")" = 0 ] \
  && ok untouched_counted_zero || no untouched_counted_zero "a round touching no pin reads zero touched"

# --- 9. worktree mode reads them all, and finds the one staged mode rightly ignored ---------------
[ "$(verdict worktree --roster "$roster")" = misread ] \
  && ok worktree_sees_all || no worktree_sees_all "worktree mode must weigh every rostered pin"
fill construction/A.md 50
( cd "$pen" && git add -A && git commit -q -m "pen: lawful again" )

# --- 10. head mode reads the commit that just landed ----------------------------------------------
fill construction/B.md 150
( cd "$pen" && git add construction/B.md && git commit -q -m "pen: ship a fat pin" )
[ "$(verdict head --roster "$roster")" = misread ] \
  && ok head_reads_commit || no head_reads_commit "head mode must weigh what HEAD shipped"
[ "$(key detail_path head --roster "$roster")" = construction/B.md ] \
  && ok head_names_path || no head_names_path "head mode must name the pin the commit shipped"
fill construction/B.md 50
( cd "$pen" && git add construction/B.md && git commit -q -m "pen: trim it back" )
[ "$(verdict head --roster "$roster")" = ok ] \
  && ok head_freed || no head_freed "head mode must pass once the pin is trimmed"

# --- 11. a deleted pin is absence, which belongs to the roster guard -------------------------------
( cd "$pen" && git rm -q construction/SOFT.md )
run staged --roster "$roster" | grep -q '^pin_absent=construction/SOFT.md' \
  && ok deleted_pin_absent || no deleted_pin_absent "a removed pin must read absent rather than refuse"
[ "$(verdict staged --roster "$roster")" = ok ] \
  && ok deleted_pin_free || no deleted_pin_free "absence is the roster guard's reading, not this one's"
( cd "$pen" && git reset -q HEAD -- construction/SOFT.md && git checkout -q -- construction/SOFT.md )

# --- 12. the instrument's own refusals -------------------------------------------------------------
[ "$(verdict staged --roster tools/fixtures/absent.txt)" = misread ] \
  && ok roster_absent_bitten || no roster_absent_bitten "a missing roster must refuse"
: > "$pen/tools/fixtures/empty.txt"
[ "$(verdict staged --roster tools/fixtures/empty.txt)" = misread ] \
  && ok roster_empty_bitten || no roster_empty_bitten "an empty roster must refuse rather than read green"
[ "$(verdict staged --roster "$roster" --nonsense)" = misread ] \
  && ok unknown_arg_bitten || no unknown_arg_bitten "an argument the scan does not know must refuse"
[ "$(verdict prove-red --roster "$roster")" = misread ] \
  && ok prove_red_refuses || no prove_red_refuses "prove-red must refuse"
[ "$(exits prove-red --roster "$roster")" = 1 ] \
  && ok prove_red_nonzero || no prove_red_nonzero "prove-red must exit non-zero"

# --- 13. the wall itself, armed the way a clone arms it and made to refuse a real commit ---------
# The scan is proven above; this proves the HOOK, by doing. A second pen gets the real
# tools/hooks/pre-commit, the real default roster path, a fake rishi so the hook's own top gate does
# not rest it, and a pin one byte past the bound -- then `git commit` is run for real.
hookpen=$(mktemp -d .mind-state/tmp/pin-bound-hook.XXXXXX) || exit 1
trap 'rm -rf "$pen" "$hookpen"' EXIT

if [ -f tools/hooks/pre-commit ]; then
  # The hookpen mirrors the folded letter rooms (letter fold, seated 20260828), so the copied
  # scan's depth-proof walk resolves the pen root and the hook finds each file where the real
  # tree now keeps it.
  mkdir -p "$hookpen/tools/hooks" "$hookpen/tools/fixtures/p" "$hookpen/tools/fixtures/l" \
           "$hookpen/context/specs" "$hookpen/construction" "$hookpen/rishi/bin"
  cp tools/hooks/pre-commit "$hookpen/tools/hooks/pre-commit"
  cp "$scan" "$hookpen/tools/fixtures/p/pin_bound_touch_scan.sh"
  cp "$reader" "$hookpen/tools/fixtures/l/living_pin_max_bytes.sh"
  chmod +x "$hookpen/tools/hooks/pre-commit"
  printf '#!/bin/sh\nexit 0\n' > "$hookpen/rishi/bin/rishi"
  chmod +x "$hookpen/rishi/bin/rishi"
  cp "$pen/context/specs/20260724-132812_pin-and-ledger-living-pin-max-bytes.md" \
     "$hookpen/context/specs/20260724-132812_pin-and-ledger-living-pin-max-bytes.md"
  printf 'construction/A.md%s10%sPin A%senforce\n' "$TAB" "$TAB" "$TAB" \
    > "$hookpen/tools/fixtures/l/living_pin_guard_roster.txt"

  hfill() {
    : > "$hookpen/$1"
    i=0
    while [ "$i" -lt "$2" ]; do printf 'x' >> "$hookpen/$1"; i=$((i + 1)); done
  }

  ( cd "$hookpen" && git init -q . && git config user.email pen@example.invalid \
    && git config user.name Pen && git config commit.gpgsign false \
    && git config core.hooksPath tools/hooks ) >/dev/null 2>&1

  hfill construction/A.md 50
  ( cd "$hookpen" && git add -A && git commit -q -m "pen: a lawful pin commits" ) >/dev/null 2>&1
  [ "$( cd "$hookpen" && git rev-list --count HEAD 2>/dev/null )" = 1 ] \
    && ok hook_lawful_commits || no hook_lawful_commits "a lawful pin must commit through the hook"

  hfill construction/A.md 150
  ( cd "$hookpen" && git add construction/A.md )
  hookout=$( cd "$hookpen" && git commit -m "pen: ship a fat pin" 2>&1 )
  [ "$( cd "$hookpen" && git rev-list --count HEAD 2>/dev/null )" = 1 ] \
    && ok hook_refuses_fat_pin || no hook_refuses_fat_pin "the hook must refuse a commit shipping an over-bound pin"
  printf '%s' "$hookout" | grep -q 'over the byte bound' \
    && ok hook_says_why || no hook_says_why "the refusal must say plainly what is wrong"
  printf '%s' "$hookout" | grep -q 'detail_over_by=50' \
    && ok hook_names_overage || no hook_names_overage "the refusal must name how far over the pin is"

  # Trim to a lawful size that differs from HEAD's, so the commit has something to carry -- a
  # trim back to the exact bytes already committed would read as an empty commit rather than as
  # the hook letting a lawful pin through.
  hfill construction/A.md 60
  ( cd "$hookpen" && git add construction/A.md && git commit -q -m "pen: trim and commit" ) >/dev/null 2>&1
  [ "$( cd "$hookpen" && git rev-list --count HEAD 2>/dev/null )" = 2 ] \
    && ok hook_frees_trimmed || no hook_frees_trimmed "a trimmed pin must commit -- the refusal proven from both sides"

  echo hello > "$hookpen/notes.txt"
  ( cd "$hookpen" && git add notes.txt && git commit -q -m "pen: a commit touching no pin" ) >/dev/null 2>&1
  [ "$( cd "$hookpen" && git rev-list --count HEAD 2>/dev/null )" = 3 ] \
    && ok hook_rests_off_pins || no hook_rests_off_pins "a commit touching no pin must pass free"
else
  no hook_present "tools/hooks/pre-commit is the wall this pen arms, and it is absent"
fi

echo "cases_failed=$fails"
if [ "$fails" -ne 0 ]; then
  echo "verdict=misread"
  exit 1
fi
echo "story=every_refusal_shown_from_both_sides"
echo "verdict=ok"
