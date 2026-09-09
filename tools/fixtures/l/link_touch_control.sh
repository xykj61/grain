#!/bin/sh
# tools/fixtures/l/link_touch_control.sh -- prove the staged-page link reading.
#
# This control builds real Git repositories in a private test directory.
# Each case writes its own pages. A broken link is planted, observed, and repaired.
# The scan reads the same findings as readme_reach. Both readings see each plant.
# Two broken pages establish the scope: the staged page is this commit's concern.
# The other page remains visible in the report. Its repair belongs to its author.
# Separate cases remove and restore the reader. Python availability is tested too.
# The final cases drive the current commit hook through real Git commits.
# They check the named page and target, so the output prefix may evolve.
# The hook continues to own its present policy. This control adds evidence.
# All temporary repositories are removed when the control exits.
#
# Run from the repository root:
#   sh tools/fixtures/l/link_touch_control.sh
set -u

scan=tools/fixtures/l/link_touch_scan.sh
reach=tools/fixtures/r/readme_reach_scan.sh
[ -f "$scan" ] || { echo "control=refused"; echo "refused: $scan is what this pen drives, and it is absent" >&2; exit 1; }
[ -f "$reach" ] || { echo "control=refused"; echo "refused: $reach is the reading the wall takes, and it is absent" >&2; exit 1; }
command -v python3 >/dev/null 2>&1 || { echo "control=refused"; echo "refused: the reach scan wants python3" >&2; exit 1; }

# The pen carries this process id, so two copies of this control running from two trees on one pier
# never share a directory (REDS %549, %571).
pen=$(mktemp -d "${TMPDIR:-/tmp}/link-touch-$$.XXXXXX") || exit 1
trap 'rm -rf "$pen"' EXIT

fails=0
ok() { echo "case=$1 ok"; }
no() { echo "case=$1 FAILED -- $2"; fails=$((fails + 1)); }

mkdir -p "$pen/tools/fixtures/l" "$pen/tools/fixtures/r" "$pen/room"
cp "$scan"  "$pen/tools/fixtures/l/link_touch_scan.sh"
cp "$reach" "$pen/tools/fixtures/r/readme_reach_scan.sh"

( cd "$pen" && git init -q . && git config user.email pen@example.invalid \
  && git config user.name Pen && git config commit.gpgsign false ) || {
  echo "control=refused"; echo "refused: the pen could not become a git repository" >&2; exit 1; }

run()     { ( cd "$pen" && sh tools/fixtures/l/link_touch_scan.sh "$@" 2>/dev/null ); }
verdict() { run "$@" | grep '^verdict=' | head -1 | cut -d= -f2; }
key()     { k=$1; shift; run "$@" | grep "^$k=" | head -1 | cut -d= -f2; }
reach_verdict() { ( cd "$pen" && sh tools/fixtures/r/readme_reach_scan.sh 2>/dev/null ) \
                    | grep '^verdict=' | head -1 | cut -d= -f2; }

# The pen's front door reaches two living pages and one dated one, so every class the wall sorts by
# is present from the first commit.
cat > "$pen/README.md" <<'DOOR'
# Pen front door

- [mine](room/mine.md)
- [theirs](room/theirs.md)
- [testimony](room/20260830-224714_a-dated-page.md)
DOOR
printf '# Theirs\n\n[the door](../README.md)\n' > "$pen/room/theirs.md"
printf '# Testimony\n\n[the door](../README.md)\n' > "$pen/room/20260830-224714_a-dated-page.md"
printf '# Mine\n\n[the door](../README.md)\n' > "$pen/room/mine.md"

( cd "$pen" && git add -A && git commit -q -m "pen: three pages, every door open" ) || {
  echo "control=refused"; echo "refused: the pen could not make its first commit" >&2; exit 1; }

# --- 1. a tree whose doors all open passes free, and counts zero ---------------------------------
[ "$(verdict worktree)" = ok ] \
  && ok whole_tree_free || no whole_tree_free "a tree with no broken living link must pass"
[ "$(key living_broken_total worktree)" = 0 ] \
  && ok whole_tree_zero || no whole_tree_zero "and it must count zero"
[ "$(verdict staged)" = ok ] \
  && ok empty_stage_free || no empty_stage_free "a commit staging nothing must pass"

# --- 2. a break in a page THIS COMMIT stages is bitten -------------------------------------------
printf '# Mine\n\n[the door](../README.md)\n[a door that does not open](absent.md)\n' > "$pen/room/mine.md"
( cd "$pen" && git add room/mine.md )
[ "$(verdict staged)" = link_broken ] \
  && ok own_break_bitten || no own_break_bitten "a break in a staged page must refuse"
[ "$(key ours staged)" = 1 ] \
  && ok own_break_counted || no own_break_counted "the refusal must count one of its own"
run staged | grep -q '^ours: room/mine.md -> absent.md' \
  && ok own_break_named || no own_break_named "the refusal must name the page and the target"

# --- 3. and freed once repaired -- the refusal proven from both sides ----------------------------
printf '# Mine\n\n[the door](../README.md)\n' > "$pen/room/mine.md"
( cd "$pen" && git add room/mine.md )
[ "$(verdict staged)" = ok ] \
  && ok own_break_freed || no own_break_freed "the repaired page must pass"

# --- 4. THE SAFETY PROPERTY: a break in a page this commit does NOT stage passes free ------------
# Two breaks stand at once. Only the staged page's own break may bite; the other is counted under
# `elsewhere` and refuses nothing, so a peer's error can never stop this ship from committing.
printf '# Theirs\n\n[the door](../README.md)\n[peer break](gone.md)\n' > "$pen/room/theirs.md"
printf '# Mine\n\n[the door](../README.md)\n' > "$pen/room/mine.md"
( cd "$pen" && git add room/mine.md )
[ "$(verdict staged)" = ok ] \
  && ok peer_break_free || no peer_break_free "a break in an unstaged page must not refuse this commit"
[ "$(key elsewhere staged)" = 1 ] \
  && ok peer_break_counted || no peer_break_counted "and it must still be counted"
[ "$(key ours staged)" = 0 ] \
  && ok peer_break_not_ours || no peer_break_not_ours "a peer's break is never counted as ours"

# --- 5. two breaks, one staged: exactly one bites ------------------------------------------------
printf '# Mine\n\n[the door](../README.md)\n[my break](absent.md)\n' > "$pen/room/mine.md"
( cd "$pen" && git add room/mine.md )
[ "$(verdict staged)" = link_broken ] && [ "$(key ours staged)" = 1 ] && [ "$(key elsewhere staged)" = 1 ] \
  && ok split_by_authorship || no split_by_authorship "two standing breaks must split one ours, one elsewhere"

# --- 6. the two readings agree, proven by driving BOTH over one plant ----------------------------
[ "$(reach_verdict)" = living_link_broken ] \
  && ok both_refuse_planted || no both_refuse_planted "the roster reading must refuse the plant too"
printf '# Mine\n\n[the door](../README.md)\n' > "$pen/room/mine.md"
printf '# Theirs\n\n[the door](../README.md)\n' > "$pen/room/theirs.md"
( cd "$pen" && git add -A )
[ "$(reach_verdict)" = ok ] && [ "$(verdict staged)" = ok ] \
  && ok both_pass_repaired || no both_pass_repaired "both readings must pass once repaired"

# --- 7. testimony is left alone -- a dated page keeps every word it wrote ------------------------
printf '# Testimony\n\n[the door](../README.md)\n[an elder path](moved-away.md)\n' \
  > "$pen/room/20260830-224714_a-dated-page.md"
( cd "$pen" && git add room/20260830-224714_a-dated-page.md )
[ "$(verdict staged)" = ok ] \
  && ok testimony_free || no testimony_free "a dated page's stale reference is resolved, never refused"
[ "$(key living_broken_total staged)" = 0 ] \
  && ok testimony_uncounted || no testimony_uncounted "and the living reading must not count it at all"

# --- 8. a broken instrument refuses, rather than reading zero ------------------------------------
# An empty finding set and an absent reading look identical in the arithmetic and mean opposite
# things, so the wall must refuse the whole reading when its one instrument is gone (REDS %566).
mv "$pen/tools/fixtures/r/readme_reach_scan.sh" "$pen/tools/fixtures/r/readme_reach_scan.sh.away"
[ "$(verdict staged)" = no_reach_scan ] \
  && ok absent_instrument_refuses || no absent_instrument_refuses "an absent reach scan must refuse"
mv "$pen/tools/fixtures/r/readme_reach_scan.sh.away" "$pen/tools/fixtures/r/readme_reach_scan.sh"
[ "$(verdict staged)" = ok ] \
  && ok instrument_returned || no instrument_returned "and the reading must return when it comes back"

# --- 8b. a bench without python3 RESTS rather than refusing every commit ------------------------
# The wall rides in a commit hook. Refusing on a missing capability would stop every commit on such
# a bench, which is the fleet-that-cannot-commit outcome REDS %524 declined this lap for. The pen
# proves the rest by handing the wall a reach scan that answers no_python and nothing else.
cp "$pen/tools/fixtures/r/readme_reach_scan.sh" "$pen/reach.real"
printf '#!/bin/sh\necho verdict=no_python\nexit 1\n' > "$pen/tools/fixtures/r/readme_reach_scan.sh"
[ "$(verdict staged)" = rested_no_python ] \
  && ok no_python_rests || no no_python_rests "a bench without python3 must rest, never refuse"
( cd "$pen" && sh tools/fixtures/l/link_touch_scan.sh staged >/dev/null 2>&1 ) \
  && ok no_python_exit_zero || no no_python_exit_zero "and the rest must exit zero so a commit proceeds"
cp "$pen/reach.real" "$pen/tools/fixtures/r/readme_reach_scan.sh"
[ "$(verdict staged)" = ok ] \
  && ok python_returned || no python_returned "and the reading must return with the capability"

# --- 9. an unknown mode refuses ------------------------------------------------------------------
[ "$(verdict sideways)" = unknown_mode ] \
  && ok unknown_mode_refused || no unknown_mode_refused "a mode the scan does not know must refuse"

# --- 10. THE HOOK ITSELF turns a real `git commit` away, and lets a repaired one through --------
# A scan that refuses proves a reading; a hook that refuses proves the wall. The pen arms
# tools/hooks/pre-commit exactly as install_hooks does -- core.hooksPath at the tree's own hooks --
# and drives real commits through it.
hook=tools/hooks/pre-commit
if [ -f "$hook" ]; then
  mkdir -p "$pen/tools/hooks" "$pen/rishi/bin"
  cp "$hook" "$pen/tools/hooks/pre-commit"
  chmod +x "$pen/tools/hooks/pre-commit"
  # The hook rests unless rishi is executable here, so the pen carries a stub that answers nothing.
  # Every rule but this one rests for want of its own scan, which is what leaves rule six alone in
  # the pen -- the property under test.
  printf '#!/bin/sh\nexit 0\n' > "$pen/rishi/bin/rishi"
  chmod +x "$pen/rishi/bin/rishi"
  ( cd "$pen" && git config core.hooksPath tools/hooks )

  printf '# Mine\n\n[the door](../README.md)\n' > "$pen/room/mine.md"
  ( cd "$pen" && git add -A && git commit -q -m "pen: a page whose doors open" ) \
    && ok hook_lawful_commits || no hook_lawful_commits "the hook must let a page with open doors commit"

  printf '# Mine\n\n[the door](../README.md)\n[nowhere](absent.md)\n' > "$pen/room/mine.md"
  ( cd "$pen" && git add room/mine.md )
  hookout=$( cd "$pen" && git commit -q -m "pen: a page holding a broken link" 2>&1 ); hookrc=$?
  [ "$hookrc" -ne 0 ] \
    && ok hook_refuses_break || no hook_refuses_break "the hook must refuse a real commit"
  printf '%s' "$hookout" | grep -q 'opens nothing' \
    && ok hook_says_why || no hook_says_why "the refusal must say plainly what is wrong"
  printf '%s' "$hookout" | grep -q 'room/mine.md -> absent.md' \
    && ok hook_names_target || no hook_names_target "the refusal must name the page and the target"

  # The repair carries one new line, so the commit has something to make: a page returned to its
  # committed bytes is refused by git for being empty, which would read as the hook refusing.
  printf '# Mine\n\n[the door](../README.md)\n\nRepaired.\n' > "$pen/room/mine.md"
  ( cd "$pen" && git add room/mine.md && git commit -q -m "pen: repaired" ) \
    && ok hook_frees_repaired || no hook_frees_repaired "the hook must let the repaired page through"

  # And the safety property at the hook: a peer's break never stops this commit.
  printf '# Theirs\n\n[the door](../README.md)\n[peer break](gone.md)\n' > "$pen/room/theirs.md"
  printf '# Mine\n\n[the door](../README.md)\n\nRepaired, and one line more.\n' > "$pen/room/mine.md"
  ( cd "$pen" && git add room/mine.md && git commit -q -m "pen: mine is clean, theirs is not" ) \
    && ok hook_free_over_peer_break || no hook_free_over_peer_break "a peer's break must not stop this commit"
else
  echo "case=hook_refuses_break skipped -- tools/hooks/pre-commit absent here"
fi

echo "fails=$fails"
if [ "$fails" -eq 0 ]; then echo "control=ok"; exit 0; fi
echo "control=red"
exit 1
