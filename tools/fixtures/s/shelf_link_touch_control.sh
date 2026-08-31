#!/bin/sh
# tools/fixtures/s/shelf_link_touch_control.sh -- the pen for shelf_link_touch_scan.sh.
#
# Real git repositories in a throwaway directory. Every refusal is shown from both sides -- planted
# and then removed -- because a refusal proven only in the passing direction cannot be told from a
# bypass, and every welcome is asserted as hard as every refusal, because a guard that reds on
# ordinary work is a guard somebody turns off.
#
# THE CASE THIS PEN EXISTS FOR is the agreement between two readings. `readme_reach` is the slow,
# whole-tree gate that found the fourteen rows of REDS %383; this scan is the instant, commit-time
# one. Two roofs over one question are refused by law unless they cannot disagree, so the pen
# plants ONE fault and drives BOTH scans over it, requiring both to refuse and then both to pass
# once it is repaired. That is the agreement proven by measurement rather than asserted in a
# comment.
#
#   bash tools/fixtures/s/shelf_link_touch_control.sh
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

scan=tools/fixtures/s/shelf_link_touch_scan.sh
reach=tools/fixtures/r/readme_reach_scan.sh
if [ ! -f "$scan" ]; then
  echo "control=refused"
  echo "refused: $scan is what this pen drives, and it is absent" >&2
  exit 1
fi

mkdir -p .mind-state/tmp
pen=$(mktemp -d .mind-state/tmp/shelf-link.XXXXXX) || exit 1
hookpen=$(mktemp -d .mind-state/tmp/shelf-link-hook.XXXXXX) || exit 1
trap 'rm -rf "$pen" "$hookpen"' EXIT

fails=0
ok() { echo "case=$1 ok"; }
no() { echo "case=$1 FAILED -- $2"; fails=$((fails + 1)); }

mkdir -p "$pen/tools/fixtures/s" "$pen/tools/fixtures/r" "$pen/session-logs/date/20260830"
cp "$scan" "$pen/tools/fixtures/s/shelf_link_touch_scan.sh"
[ -f "$reach" ] && cp "$reach" "$pen/tools/fixtures/r/readme_reach_scan.sh"

( cd "$pen" && git init -q . && git config user.email pen@example.invalid \
  && git config user.name Pen && git config commit.gpgsign false ) || {
  echo "control=refused"; echo "refused: the pen could not become a git repository" >&2; exit 1; }

run()     { ( cd "$pen" && sh tools/fixtures/s/shelf_link_touch_scan.sh "$@" 2>/dev/null ); }
verdict() { run "$@" | grep '^verdict=' | head -1 | cut -d= -f2; }
key()     { k=$1; shift; run "$@" | grep "^$k=" | head -1 | cut -d= -f2; }

# The pen's own shelf and its one log, in the shape every folded room wears: the log inside the day
# room, the shelf one directory above it.
log=session-logs/date/20260830/20260830-224714_the-fold-writes-its-own-trail.kyri
shelf=session-logs/date/README-index-20260830.md

write_shelf() {
  # $1 is the link target exactly as a row would spell it.
  cat > "$pen/$shelf" <<SHELF
# session-logs day index -- 20260830

| Stamp | Log | What it recorded |
|---|---|---|
| \`20260830.224714\` | [The fold writes its own trail]($1) | the loom takes back its three facts |
SHELF
}

printf 'stamp 20260830.224714\n' > "$pen/$log"

# --- 1. the lawful row: the day room named, and the log carried by the same commit ---------------
write_shelf "20260830/20260830-224714_the-fold-writes-its-own-trail.kyri"
( cd "$pen" && git add -A && git commit -q -m "pen: a lawful shelf row" ) || {
  echo "control=refused"; echo "refused: the pen could not make its first commit" >&2; exit 1; }

[ "$(verdict head)" = ok ] \
  && ok lawful_row_free || no lawful_row_free "a row naming its day room must pass free"
[ "$(key bare_stamped_absent head)" = 0 ] \
  && ok lawful_row_counts_zero || no lawful_row_counts_zero "a lawful shelf counts zero"

# --- 2. the planted fault: the bare basename, which is REDS %383 exactly -------------------------
write_shelf "20260830-224714_the-fold-writes-its-own-trail.kyri"
( cd "$pen" && git add "$shelf" )
[ "$(verdict staged)" = misread ] \
  && ok bare_basename_bitten || no bare_basename_bitten "a bare stamped basename must refuse"
[ "$(key bare_stamped_absent staged)" = 1 ] \
  && ok bare_basename_counted || no bare_basename_counted "the refusal must count one"
run staged | grep -q '^detail=RED_shelf_row_link_absent' \
  && ok bare_basename_named || no bare_basename_named "the refusal must carry its named detail"
[ "$(key detail_repair staged)" = "20260830/20260830-224714_the-fold-writes-its-own-trail.kyri" ] \
  && ok repair_named || no repair_named "the refusal must name the one right answer"
[ "$(key detail_repair_exists staged)" = yes ] \
  && ok repair_exists_seen || no repair_exists_seen "the repair standing in the index must be seen"

# --- 3. and freed once repaired -- the refusal proven from both sides ----------------------------
write_shelf "20260830/20260830-224714_the-fold-writes-its-own-trail.kyri"
( cd "$pen" && git add "$shelf" )
[ "$(verdict staged)" = ok ] \
  && ok bare_basename_freed || no bare_basename_freed "the repaired row must pass"

# --- 4. the two readings agree, proven by driving BOTH over one plant ----------------------------
if [ -f "$pen/tools/fixtures/r/readme_reach_scan.sh" ] && command -v python3 >/dev/null 2>&1; then
  printf '# Pen front door\n\n- [the shelf](%s)\n' "$shelf" > "$pen/README.md"
  reach_verdict() { ( cd "$pen" && sh tools/fixtures/r/readme_reach_scan.sh README.md 2>/dev/null ) \
                      | grep '^verdict=' | head -1 | cut -d= -f2; }

  write_shelf "20260830/20260830-224714_the-fold-writes-its-own-trail.kyri"
  ( cd "$pen" && git add -A )
  [ "$(reach_verdict)" = ok ] && [ "$(verdict staged)" = ok ] \
    && ok both_pass_repaired || no both_pass_repaired "both readings must pass the repaired row"

  write_shelf "20260830-224714_the-fold-writes-its-own-trail.kyri"
  ( cd "$pen" && git add -A )
  [ "$(reach_verdict)" = living_link_broken ] && [ "$(verdict staged)" = misread ] \
    && ok both_refuse_planted || no both_refuse_planted "both readings must refuse the planted row"
else
  echo "case=both_refuse_planted skipped -- readme_reach or python3 absent here"
fi

# --- 5. the reported half: a broken link that is NOT the gated class -----------------------------
# A `../yonder/<stamped>.md` row is the shape forty-one closed active-designing shelves carry, and
# a stale dated reference is RESOLVED rather than rewritten. It is counted and printed, never gated.
write_shelf "../yonder/20260618-225712_aurora.md"
( cd "$pen" && git add "$shelf" )
[ "$(verdict staged)" = ok ] \
  && ok other_broken_free || no other_broken_free "a dated cross-room reference must not refuse a commit"
[ "$(key other_broken_reported staged)" = 1 ] \
  && ok other_broken_counted || no other_broken_counted "and it must still be counted and printed"

# --- 6. the index is the reading, not the disk ---------------------------------------------------
# The row is staged naming a log that stands on disk and was never added. A worktree read would
# call that green; the commit would carry a row pointing at nothing.
mkdir -p "$pen/session-logs/date/20260831"
printf 'stamp 20260831.000100\n' > "$pen/session-logs/date/20260831/20260831-000100_untracked.kyri"
cat > "$pen/session-logs/date/README-index-20260831.md" <<'SHELF2'
# session-logs day index -- 20260831

| Stamp | Log | What it recorded |
|---|---|---|
| `20260831.000100` | [Untracked](20260831/20260831-000100_untracked.kyri) | a log the commit forgot |
SHELF2
write_shelf "20260830/20260830-224714_the-fold-writes-its-own-trail.kyri"
( cd "$pen" && git add "$shelf" session-logs/date/README-index-20260831.md )
[ "$(verdict staged)" = ok ] \
  && ok index_reads_tracked_log || no index_reads_tracked_log "a row whose log the index carries must pass"
( cd "$pen" && git rm -q --cached session-logs/date/20260831/20260831-000100_untracked.kyri >/dev/null 2>&1 || true )
[ "$(verdict worktree)" = ok ] \
  && ok worktree_sees_disk || no worktree_sees_disk "the worktree reading sees a file on disk"
( cd "$pen" && git add -A && git commit -q -m "pen: the second shelf lands" ) >/dev/null 2>&1

# --- 7. external and fragment links pass free ----------------------------------------------------
cat > "$pen/$shelf" <<'SHELF3'
# session-logs day index -- 20260830

- [the web](https://example.invalid/page)
- [a heading](#the-shelves)
- [mail](mailto:someone@example.invalid)
SHELF3
( cd "$pen" && git add "$shelf" )
[ "$(verdict staged)" = ok ] && [ "$(key other_broken_reported staged)" = 0 ] \
  && ok external_links_free || no external_links_free "http, mailto and a bare fragment are not tree paths"

# --- 8. a commit touching no shelf reads nothing -------------------------------------------------
write_shelf "20260830/20260830-224714_the-fold-writes-its-own-trail.kyri"
( cd "$pen" && git add -A && git commit -q -m "pen: back to lawful" ) >/dev/null 2>&1
echo hello > "$pen/notes.txt"
( cd "$pen" && git add notes.txt )
[ "$(key shelves_read staged)" = 0 ] && [ "$(verdict staged)" = ok ] \
  && ok no_shelf_no_reading || no no_shelf_no_reading "a round touching no shelf must read none"

# --- 9. a deleted shelf reads absent rather than broken ------------------------------------------
( cd "$pen" && git rm -q "$shelf" >/dev/null 2>&1 )
run staged | grep -q "^shelf_absent=$shelf" \
  && ok deleted_shelf_absent || no deleted_shelf_absent "a removed shelf carries no rows to read"
[ "$(verdict staged)" = ok ] \
  && ok deleted_shelf_free || no deleted_shelf_free "removing a shelf must not refuse"
( cd "$pen" && git checkout -q -- "$shelf" 2>/dev/null || git reset -q HEAD "$shelf" 2>/dev/null; git checkout -q -- . 2>/dev/null || true )

# --- 10. the instrument's own refusals ------------------------------------------------------------
[ "$(verdict prove-red)" = misread ] \
  && ok prove_red_refuses || no prove_red_refuses "prove-red must refuse"
( cd "$pen" && sh tools/fixtures/s/shelf_link_touch_scan.sh prove-red >/dev/null 2>&1 )
[ "$?" = 1 ] \
  && ok prove_red_nonzero || no prove_red_nonzero "prove-red must exit non-zero"
[ "$(verdict --nonsense)" = misread ] \
  && ok unknown_arg_bitten || no unknown_arg_bitten "an argument the scan does not know must refuse"
run --nonsense | grep -q '^detail=RED_unknown_argument' \
  && ok unknown_arg_named || no unknown_arg_named "the unknown argument must be named"

# --- 11. the wall itself, armed the way a clone arms it and made to refuse a real commit ---------
# The scan is proven above; this proves the HOOK, by doing. A second pen gets the real
# tools/hooks/pre-commit, a fake rishi so the hook's own top gate does not rest it, and a shelf row
# of the planted shape -- then `git commit` is run for real.
if [ -f tools/hooks/pre-commit ]; then
  mkdir -p "$hookpen/tools/hooks" "$hookpen/tools/fixtures/s" "$hookpen/rishi/bin" \
           "$hookpen/session-logs/date/20260830"
  cp tools/hooks/pre-commit "$hookpen/tools/hooks/pre-commit"
  cp "$scan" "$hookpen/tools/fixtures/s/shelf_link_touch_scan.sh"
  chmod +x "$hookpen/tools/hooks/pre-commit"
  printf '#!/bin/sh\nexit 0\n' > "$hookpen/rishi/bin/rishi"
  chmod +x "$hookpen/rishi/bin/rishi"

  ( cd "$hookpen" && git init -q . && git config user.email pen@example.invalid \
    && git config user.name Pen && git config commit.gpgsign false \
    && git config core.hooksPath tools/hooks ) >/dev/null 2>&1

  printf 'stamp 20260830.224714\n' > "$hookpen/$log"
  hshelf() {
    cat > "$hookpen/$shelf" <<HS
# session-logs day index -- 20260830

| \`20260830.224714\` | [The fold writes its own trail]($1) | one row |
HS
  }

  hshelf "20260830/20260830-224714_the-fold-writes-its-own-trail.kyri"
  ( cd "$hookpen" && git add -A && git commit -q -m "pen: a lawful shelf commits" ) >/dev/null 2>&1
  [ "$( cd "$hookpen" && git rev-list --count HEAD 2>/dev/null )" = 1 ] \
    && ok hook_lawful_commits || no hook_lawful_commits "a lawful shelf row must commit through the hook"

  hshelf "20260830-224714_the-fold-writes-its-own-trail.kyri"
  ( cd "$hookpen" && git add "$shelf" )
  hookout=$( cd "$hookpen" && git commit -m "pen: ship a bare row" 2>&1 )
  [ "$( cd "$hookpen" && git rev-list --count HEAD 2>/dev/null )" = 1 ] \
    && ok hook_refuses_bare_row || no hook_refuses_bare_row "the hook must refuse a commit shipping a bare row"
  printf '%s' "$hookout" | grep -q 'stages a day-shelf row that links a file' \
    && ok hook_says_why || no hook_says_why "the refusal must say plainly what is wrong"
  printf '%s' "$hookout" | grep -q 'detail_repair=20260830/' \
    && ok hook_names_repair || no hook_names_repair "the refusal must name the one right answer"

  # The repair carries one more byte than HEAD's row, so the commit has something to carry -- a
  # repair back to the exact bytes already committed reads as an empty commit rather than as the
  # hook letting a lawful row through.
  hshelf "20260830/20260830-224714_the-fold-writes-its-own-trail.kyri"
  printf '\n<!-- repaired -->\n' >> "$hookpen/$shelf"
  ( cd "$hookpen" && git add "$shelf" && git commit -q -m "pen: repair and commit" ) >/dev/null 2>&1
  [ "$( cd "$hookpen" && git rev-list --count HEAD 2>/dev/null )" = 2 ] \
    && ok hook_frees_repaired || no hook_frees_repaired "a repaired row must commit -- the refusal proven from both sides"

  echo hello > "$hookpen/notes.txt"
  ( cd "$hookpen" && git add notes.txt && git commit -q -m "pen: a commit touching no shelf" ) >/dev/null 2>&1
  [ "$( cd "$hookpen" && git rev-list --count HEAD 2>/dev/null )" = 3 ] \
    && ok hook_rests_off_shelves || no hook_rests_off_shelves "a commit touching no shelf must pass free"
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
