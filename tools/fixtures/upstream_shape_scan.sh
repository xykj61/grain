#!/bin/sh
# tools/fixtures/upstream_shape_scan.sh -- read the shape of the ordering remote before rebasing onto it.
#
# WHAT THIS IS FOR. Every round opens by pulling the anointed ordering remote, which the sync rota
# seated on 20260825.210819. Fifteen sentences describe that rota and every one of them assumes the
# two piers share a history. A custody-gated deep debride is the one sanctioned act that breaks the
# assumption: it rewrites every commit and force-pushes, so the ordering remote and every pier that
# has not yet re-cloned share no common ancestor at all. This guard reads that shape and says which
# of it is true, before a rebase acts on the wrong one.
#
# WHAT IT COSTS WHEN IT IS MISSED, measured on metal by this file's own prove- legs. Against a
# rewritten upstream `git pull --rebase` behaves two entirely different ways, and which one you get
# turns on a reflog rather than on anything in the tree:
#
#   * The remote-tracking reflog still remembers the pre-rewrite position, so `--fork-point` finds
#     it and replays only the commits this pier actually owns. Correct, and quiet.
#   * The reflog is gone -- expired at git's 90-day default, or never written because the clone is
#     fresh -- so there is no fork point, and the rebase replays EVERY local commit onto the new
#     head. On this tree that is 3,467 replays, each conflict a chance to carry back the very
#     content the debride removed.
#
# The second reading is proven here rather than argued: prove-rewritten builds both repositories,
# expires the reflog, and shows the whole history queued for replay with the debrided name back in
# the working tree.
#
#   sh tools/fixtures/upstream_shape_scan.sh                  # read the live shape and gate
#   sh tools/fixtures/upstream_shape_scan.sh prove-rewritten  # reflog absent: replays everything
#   sh tools/fixtures/upstream_shape_scan.sh prove-forkpoint  # reflog present: replays only ours
#   sh tools/fixtures/upstream_shape_scan.sh prove-ordinary   # a shared history must NOT refuse
#   sh tools/fixtures/upstream_shape_scan.sh prove-shallow    # a shallow clone must NOT refuse
#
# WHAT GATES AND WHAT REPORTS. `verdict=rewritten` refuses, because that is the reading a rebase
# must never act on unexamined. Two readings pass as machine facts rather than tree reds, since a
# guard that reds on a missing network or a deliberate clone depth is a guard somebody turns off:
# `no_remote_ref` for a pier that has not fetched, and `shallow_repository` for a clone that has no
# ancestors to find. That second one matters because a shallow clone and a rewritten upstream look
# identical from a merge base alone, so the shape asks git which it is. Every other shape reports
# its numbers and passes.
#
# WRITTEN IN PORTABLE SHELL, on purpose and for the same reason the dialect meter is: a guard about
# two piers that only runs on one of them proves nothing about the other (REDS %240).
set -eu

REMOTE="${UPSTREAM_SHAPE_REMOTE:-xykj61}"
BRANCH="${UPSTREAM_SHAPE_BRANCH:-main}"
mode="${1:-measure}"

# read_shape <ref> -- print the shape of HEAD against <ref> as plain key=value lines, and return
# 1 only when the shape is `rewritten`. Kept as one function so the live reading and all three
# proof legs measure through exactly the same code; a proof that reads its subject differently
# from the way the subject is used proves the reading rather than the subject (REDS %240).
read_shape() {
  ref="$1"
  head_sha=$(git rev-parse HEAD)
  up_sha=$(git rev-parse "$ref")
  base=$(git merge-base HEAD "$ref" 2>/dev/null || true)

  # `--fork-point` consults the remote-tracking reflog, so it answers where a plain merge-base
  # cannot: it is the whole difference between replaying two commits and replaying three thousand.
  fork=$(git merge-base --fork-point "$ref" HEAD 2>/dev/null || true)

  counts=$(git rev-list --left-right --count "HEAD...$ref")
  local_ahead=$(echo "$counts" | cut -f1)
  up_ahead=$(echo "$counts" | cut -f2)
  replay=$(git rev-list --count "$ref..HEAD")

  echo "remote_ref=$ref"
  echo "head=$head_sha"
  echo "upstream=$up_sha"
  echo "local_ahead=$local_ahead"
  echo "upstream_ahead=$up_ahead"

  if [ -n "$base" ]; then
    echo "merge_base=$base"
  else
    echo "merge_base=none"
  fi

  if [ -n "$fork" ]; then
    echo "fork_point=$fork"
    echo "replay_count=$(git rev-list --count "$fork..HEAD")"
  else
    echo "fork_point=absent"
    echo "replay_count=$replay"
  fi

  if [ -z "$base" ]; then
    # A shallow clone has no ancestors to find either, and would otherwise read as a rewrite. Ask
    # git rather than guess: the two states look identical from a merge-base alone, and only one of
    # them is a fault.
    if [ "$(git rev-parse --is-shallow-repository 2>/dev/null || echo false)" = true ]; then
      echo "verdict=shallow_repository"
      echo "note: no merge base, and this clone is shallow -- deepen it before the shape can be read."
      return 0
    fi
    echo "verdict=rewritten"
    echo "refused: no common ancestor with $ref -- the ordering remote was rewritten."
    echo "         a plain rebase would replay $replay local commits onto a history that never held them."
    if [ -n "$fork" ]; then
      echo "         the remote-tracking reflog still holds the pre-rewrite position at $fork."
      echo "         replay only what this pier owns:  git rebase --onto $ref $fork"
    else
      echo "         the remote-tracking reflog is gone, so no fork point can be computed."
      echo "         find the last commit this pier shares with $ref by subject, and rebase --onto from there."
    fi
    return 1
  fi

  if [ "$head_sha" = "$up_sha" ]; then echo "verdict=up_to_date"; return 0; fi
  if [ "$base" = "$head_sha" ]; then echo "verdict=fast_forward"; return 0; fi
  if [ "$base" = "$up_sha" ]; then echo "verdict=ahead"; return 0; fi
  echo "verdict=diverged"
  return 0
}

# build_pen <dir> <upstream_commits> -- two real repositories: an upstream carrying a name, and a
# clone of it that has since made local commits of its own. The pen stays small on purpose: REDS
# %239 was a pen the size of this repository that filled the tmpfs and reddened four unrelated
# guards mid-run, so a pen here is a handful of one-line files.
build_pen() {
  d="$1"; n="$2"
  GIT_AUTHOR_NAME=pen GIT_AUTHOR_EMAIL=pen@pen
  GIT_COMMITTER_NAME=pen GIT_COMMITTER_EMAIL=pen@pen
  GIT_AUTHOR_DATE="2026-08-26T00:00:00" GIT_COMMITTER_DATE="2026-08-26T00:00:00"
  export GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL GIT_COMMITTER_NAME GIT_COMMITTER_EMAIL
  export GIT_AUTHOR_DATE GIT_COMMITTER_DATE

  git init -q -b main "$d/up"
  (cd "$d/up" && git config commit.gpgsign false
   i=1; while [ "$i" -le "$n" ]; do
     echo "line $i, written by PENNAME" > "f$i.txt"
     git add . && git commit -qm "c$i"
     i=$((i + 1))
   done)
  git clone -q "$d/up" "$d/down"
  (cd "$d/down" && git config commit.gpgsign false
   echo mine > mine.txt && git add . && git commit -qm "this pier's own lap")
}

# debride_upstream <dir> -- the sanctioned act, performed for real: every commit rewritten so the
# name leaves the whole history, then one commit recording it. In-place editing is written as
# redirect-then-cat rather than `sed -i`, which BSD sed spells differently and which would drop a
# tracked file's mode (.claude/rules/exec-bit.md).
debride_upstream() {
  d="$1"
  (cd "$d/up"
   git filter-branch -f --tree-filter '
     for f in *.txt; do
       [ -f "$f" ] || continue
       sed "s/PENNAME/PSEUDONYM/g" "$f" > "$f.t" && cat "$f.t" > "$f" && rm -f "$f.t"
     done' -- --all >/dev/null 2>&1
   echo recorded > record.txt && git add . && git commit -qm "tree: the pseudonym")
}

if [ "$mode" = prove-rewritten ] || [ "$mode" = prove-forkpoint ]; then
  pen=$(mktemp -d)
  trap 'rm -rf "$pen"' EXIT
  build_pen "$pen" 8
  # Six more local commits, so the difference between a fork point and none is a number nobody
  # could mistake for noise: seven owned commits against fifteen replayed.
  (cd "$pen/down" && i=1; while [ "$i" -le 6 ]; do
     echo "lap $i" > "lap$i.txt"; git add . && git commit -qm "lap $i"; i=$((i + 1)); done)
  debride_upstream "$pen"
  cd "$pen/down"
  git fetch -q origin

  if [ "$mode" = prove-rewritten ]; then
    # The reflog is what a fresh clone lacks and what git expires at ninety days. Removing it is
    # how the pen reaches the state a pier reaches by waiting.
    rm -f .git/logs/refs/remotes/origin/main
    git reflog expire --expire=now --all >/dev/null 2>&1 || true
    echo "upstream-shape: the reflog absent -- a fresh clone, or ninety days of waiting."
  else
    echo "upstream-shape: the reflog present -- the pre-rewrite position still remembered."
  fi

  echo "reflog_entries=$(git reflog show origin/main 2>/dev/null | grep -c . || true)"
  shape=$(read_shape refs/remotes/origin/main 2>&1) && rc=0 || rc=$?
  echo "$shape"
  [ "$rc" -eq 1 ] || { echo "refused: a rewritten upstream must read verdict=rewritten"; exit 1; }

  replay=$(echo "$shape" | grep '^replay_count=' | cut -d= -f2)
  fork=$(echo "$shape" | grep '^fork_point=' | cut -d= -f2)

  if [ "$mode" = prove-rewritten ]; then
    [ "$fork" = absent ] || { echo "refused: want no fork point, found $fork"; exit 1; }
    [ "$replay" -eq 15 ] || { echo "refused: want 15 commits queued for replay, found $replay"; exit 1; }
    # Reproduced rather than asserted: the pull itself, and the debrided name back on disk.
    git pull --rebase origin main >/dev/null 2>&1 || true
    residue=$(grep -rl PENNAME . --exclude-dir=.git 2>/dev/null | grep -c . || true)
    git rebase --abort >/dev/null 2>&1 || true
    echo "name_residue_after_pull=$residue"
    [ "$residue" -ge 1 ] || { echo "refused: the debrided name must be back in the tree for this to be the fault it claims"; exit 1; }
    echo "verdict=ok"
    exit 0
  fi

  [ "$fork" != absent ] || { echo "refused: want a fork point, found none"; exit 1; }
  [ "$replay" -eq 7 ] || { echo "refused: want 7 owned commits queued for replay, found $replay"; exit 1; }
  git pull --rebase origin main >/dev/null 2>&1 || { echo "refused: the fork-point pull must succeed"; exit 1; }
  residue=$(grep -rl PENNAME . --exclude-dir=.git 2>/dev/null | grep -c . || true)
  echo "name_residue_after_pull=$residue"
  [ "$residue" -eq 0 ] || { echo "refused: the fork-point pull must carry no debrided name back"; exit 1; }
  echo "verdict=ok"
  exit 0
fi

if [ "$mode" = prove-shallow ]; then
  # The false positive, proven not to fire. A shallow clone has no merge base with anything, so
  # without this reading every shallow pier would be told its upstream had been rewritten -- a
  # refusal on ordinary work, which is the shape of a wall people disable.
  pen=$(mktemp -d)
  trap 'rm -rf "$pen"' EXIT
  build_pen "$pen" 6
  git clone -q --depth 1 "file://$pen/up" "$pen/shallow"
  (cd "$pen/shallow" && git config commit.gpgsign false
   echo mine > mine.txt && git add . && git commit -qm "a lap on a shallow clone")
  # The upstream advances past the clone's depth, and the clone re-fetches at the same depth. A
  # depth-1 clone that has NOT been outrun still finds its merge base, so this walk past the
  # boundary is what actually produces the empty one -- measured before it was written down.
  (cd "$pen/up" && i=7; while [ "$i" -le 9 ]; do
     echo "line $i" > "f$i.txt"; git add . && git commit -qm "c$i"; i=$((i + 1)); done)
  cd "$pen/shallow"
  git fetch -q --depth 1 origin
  echo "upstream-shape: a shallow clone -- no ancestors to find, and no rewrite either."
  echo "is_shallow=$(git rev-parse --is-shallow-repository)"
  echo "merge_base_found=$(git merge-base HEAD refs/remotes/origin/main 2>/dev/null | grep -c . || true)"
  shape=$(read_shape refs/remotes/origin/main) || { echo "refused: a shallow clone must not read as rewritten"; exit 1; }
  echo "$shape"
  echo "$shape" | grep -q '^verdict=shallow_repository$' || { echo "refused: want verdict=shallow_repository"; exit 1; }
  echo "verdict=ok"
  exit 0
fi

if [ "$mode" = prove-ordinary ]; then
  # The other side of the refusal. A wall that fires on ordinary work is a wall somebody turns off,
  # so the ordinary shape is proven to pass as hard as the rewritten one is proven to refuse.
  pen=$(mktemp -d)
  trap 'rm -rf "$pen"' EXIT
  build_pen "$pen" 4
  (cd "$pen/up" && echo more > more.txt && git add . && git commit -qm "upstream moves on")
  cd "$pen/down"
  git fetch -q origin
  echo "upstream-shape: an ordinary shared history, both sides moved."
  shape=$(read_shape refs/remotes/origin/main) || { echo "refused: an ordinary divergence must not refuse"; exit 1; }
  echo "$shape"
  echo "$shape" | grep -q '^verdict=diverged$' || { echo "refused: want verdict=diverged"; exit 1; }
  echo "$shape" | grep -q '^merge_base=[0-9a-f]' || { echo "refused: want a merge base named"; exit 1; }
  echo "verdict=ok"
  exit 0
fi

root=$(git rev-parse --show-toplevel 2>/dev/null) || {
  echo "refused: not a git repository -- this guard reads the shape of a remote against HEAD" >&2
  exit 1
}
cd "$root"

echo "upstream-shape: the ordering remote's shape, read before a rebase acts on it."
ref="refs/remotes/$REMOTE/$BRANCH"
if ! git rev-parse --verify --quiet "$ref" >/dev/null; then
  # A pier that has not fetched, or a clone with a different remote name. Machine fact, not a red.
  echo "remote_ref=$ref"
  echo "verdict=no_remote_ref"
  echo "note: nothing fetched from $REMOTE -- run git fetch $REMOTE before the shape can be read."
  exit 0
fi
read_shape "$ref"
