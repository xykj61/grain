#!/bin/sh
# tools/f/fleet_round_open.sh -- the fleet's self-healing round-open: adopt the anointed
# order, stash what a dead lap left, park what diverged, and report each state by its own name.
#
# WHY THIS EXISTS. On 20260828 two loops died in the same minute-shape. A lap finished its work
# and stopped before the send. The next iteration's `git pull --rebase xy main` refused on the
# dirty index. The loop's `||` handler then printed `PULL DIVERGED: upstream history was
# rewritten`, for a tree standing exactly level with xy/main. One handler carried one message for
# three faults: a dirty tree, a network failure, and a real rewrite. Each died the same death with
# the same wrong instruction. The refusal's own first line named the true fault both times, and the
# handler read its own assumption instead (the tail-reading class, REDS %-family of 20260827-28).
#
# THE CONSENSUS MAPPING, so the loops speak Mycelium's grammar through git itself:
#   - `xy` is the ANOINTED ORDER -- the sequencer every proposal is ordered by, the same
#     seat the derived-spine law gives it for ledger rows.
#   - a lap's send is a PROPOSAL; the fast-forward push is the compare-and-set, and its
#     refusal is an ordinary lost race, answered by re-deriving on the new head -- never
#     by force (the twice-pulled rota, seated 20260825.210819).
#   - at round-open the local tree ADOPTS the anointed order: RESET, NEVER MERGE (the
#     divergence word the loops learned at REDS %290). A local line the re-derivation
#     refuses is PARKED on a branch under refs/heads/pier/, the rota's own deferral shelf,
#     and main resets. Every byte is kept and every push stays fast-forward. The park is a
#     proposal awaiting its next derivation, much like an unshared ledger row awaiting its
#     number.
#   - what a dead lap left uncommitted is STASHED under a stamped name, wall-free. A
#     park-commit would meet the commit-msg wall, and a round-open stays able to open on
#     any prose at all. Stashes are the fleet's dead-letter box, and a hand or the lap
#     itself re-derives them.
#
# EXIT CODES, and the loop line that reads them:
#   0  round is open on the anointed order -- proceed
#   2  the network refused the fetch -- retry later; the loop sleeps and continues
# A loop line: sh tools/f/fleet_round_open.sh || { sleep 60; continue; }
# It opens the round in every state it can meet, and names which one it met.
set -u

say() { printf 'round-open: %s\n' "$1"; }

test -d .git || { say "not a repository root -- refusing"; exit 2; }

STAMP=$(TZ=America/New_York date +%Y%m%d-%H%M%S)

# 1) the fetch, the only step a network can refuse -- and the only exit-2
if ! git fetch xy main 2>&1; then
  say "fetch refused (network or remote) -- retry, nothing local changed"
  exit 2
fi

# 2) AN INTERRUPTED REBASE IS A CORPSE, AND IT MUST BE CLEARED BEFORE ANYTHING ELSE READS THE
# TREE. Every step below misreads it. The worktree of a conflicted rebase looks dirty, so the
# stash in step 3 would stash a half-replayed commit; HEAD is detached at whatever was replayed
# last, so step 4's `merge-base --is-ancestor HEAD xy/main` answers about a commit nobody asked
# about; and the `reset --hard` that follows abandons the rebase mid-flight, leaving the real
# branch behind and unnamed. Three steps each behaving correctly on a state none of them models.
#
# `git rebase --abort` restores the exact pre-rebase branch and HEAD -- that is git's own
# guarantee -- so aborting loses no committed work. The pre-rebase tip is parked by name first
# anyway, out of `orig-head`, because a park costs one ref and makes the state recoverable even
# if the abort itself misbehaves.
#
# THE HONEST LIMIT: conflict resolution staged but not yet committed inside the rebase is NOT
# preserved, and no script can preserve it. That is acceptable here because the fleet law is one
# writer per checkout -- if this loop is running, it is the writer, and a hand mid-rebase in a
# loop's tree has already crossed a different rule. A hand that was genuinely at work gets the
# park, the stamp, and a line saying exactly what happened.
if [ -d .git/rebase-merge ] || [ -d .git/rebase-apply ]; then
  RDIR=.git/rebase-merge
  [ -d "$RDIR" ] || RDIR=.git/rebase-apply
  ORIG=$(cat "$RDIR/orig-head" 2>/dev/null || true)
  RPARK="pier/rebase-$STAMP"
  if [ -n "$ORIG" ] && git branch "$RPARK" "$ORIG" >/dev/null 2>&1; then
    PARKED="the pre-rebase line is parked on $RPARK"
  else
    PARKED="no pre-rebase head could be parked"
  fi
  if git rebase --abort >/dev/null 2>&1; then
    say "an interrupted rebase stood at the open -- aborted; $PARKED"
  else
    say "an interrupted rebase stood and would not abort -- refusing; a hand is needed here"
    exit 2
  fi
fi

# 3) a dead lap's leavings go to the dead-letter box, named, wall-free
if ! git diff --quiet || ! git diff --cached --quiet || [ -n "$(git ls-files --others --exclude-standard 2>/dev/null | head -1)" ]; then
  git stash push -u -m "fleet-round-open $STAMP: a lap's unsent work, stashed at the open" >/dev/null 2>&1 \
    && say "dirty tree stashed as 'fleet-round-open $STAMP' -- $(git stash list | grep -c 'fleet-round-open') in the dead-letter box" \
    || say "stash refused; continuing on the tree as it stands"
fi

# 4) classify against the anointed order -- each state by name, never one message for three
if [ "$(git rev-parse HEAD)" = "$(git rev-parse xy/main)" ]; then
  say "already on the anointed order"
elif git merge-base --is-ancestor HEAD xy/main 2>/dev/null; then
  git reset --hard xy/main >/dev/null 2>&1
  say "behind -- adopted the anointed order (reset, never merge)"
elif git merge-base --is-ancestor xy/main HEAD 2>/dev/null; then
  say "ahead by $(git rev-list --count xy/main..HEAD) -- local sends pending; the lap's close will propose them"
else
  # TWO STATES FAIL BOTH ANCESTRY TESTS, AND NO REF-TOPOLOGY TEST TELLS THEM APART.
  # One is a genuine upstream rewrite, where the ground the line was built on is gone and
  # parking is right. The other is this fleet's ordinary outcome: a lap commits on base B, a
  # peer pushes on top of B, and the line re-derives whole. REDS %499 booked a discriminator
  # for this -- merge-base equals the parent of the oldest commit in xy/main..HEAD -- and it
  # is a TAUTOLOGY, measured on real repositories: everything in xy/main..HEAD is local-only,
  # so the parent of its oldest member IS the newest common ancestor, in both states. A test
  # that cannot fail told the fleet nothing, and the park it defaulted to cost ten commits
  # that never reached main between 20260828 and 20260906.
  #
  # So the re-derivation IS the discriminator, and it is git's own -- it knows patch-ids and
  # can drop a local commit whose rewritten twin already stands upstream, which no shell test
  # can see. Attempt it; park only when git itself refuses.
  #
  # THE PARK IS CUT BEFORE THE ATTEMPT, for step 2's reason one branch down: a ref costs
  # nothing and makes the pre-rebase tip recoverable even if the rebase dies mid-flight. It is
  # released only on a clean re-derivation that dropped nothing, so no byte leaves without a
  # name on it.
  PARK="pier/diverged-$STAMP"
  git branch "$PARK" >/dev/null 2>&1
  WAS=$(git rev-list --count xy/main..HEAD 2>/dev/null || echo 0)
  if git rebase xy/main >/dev/null 2>&1; then
    NOW=$(git rev-list --count xy/main..HEAD 2>/dev/null || echo 0)
    if [ "$NOW" = "$WAS" ]; then
      git branch -D "$PARK" >/dev/null 2>&1
      say "lost race -- re-derived $NOW commit(s) onto the anointed order; the lap's close will propose them"
    else
      say "lost race across a rewrite -- re-derived $NOW of $WAS; the rest already stood upstream, and the pre-rebase line is kept on $PARK"
    fi
  else
    git rebase --abort >/dev/null 2>&1
    git push xy "$PARK" >/dev/null 2>&1 && PUSHED=" and pushed" || PUSHED=" (push deferred; the branch is local)"
    git reset --hard xy/main >/dev/null 2>&1
    say "true divergence -- the re-derivation refused; local line parked on $PARK$PUSHED; adopted the anointed order"
  fi
fi

# 5) READ THE DEAD-LETTER BOX BACK OUT. Step 3 fills it; nothing ever emptied it (REDS %464).
# A stash holds bytes, and a record only exists once something a reader can reach carries it, so
# three of this ship's own laps had their reasoning parked here while their code shipped -- and the
# next lap paid to rediscover work already done. The report is one line and the read-back is a
# hand's, deliberately: applying a stash automatically would drop a dead lap's half-finished edits
# on top of a tree that has since moved.
#
# NEVER ALLOWED TO FAIL THE OPEN. The whole point of this script is that it cannot die at the
# open, so the reading is guarded by its own presence and its refusal is only ever a printed line.
#
# TWO DRAWERS, TWO LINES, ONE SCAN RUN (REDS %510). The reading answers about the RECORD and about
# the WORK, and they are different questions: a lap whose log landed while its code did not reads
# `unlanded=0` over a box still holding the files. Both are read out of one invocation, so naming
# the second drawer costs this open nothing.
SCAN=tools/fixtures/s/stash_record_scan.sh
if [ -r "$SCAN" ]; then
  # ONE INVOCATION, BOTH DRAWERS AND THE NAMES (`20260911`). `list` emits the orphan rows and then
  # the same counter block the bare mode prints, so every grep below reads exactly what it read
  # before and the naming costs this open no second scan -- 2.3s against 3.1s, measured here.
  BOX=$(sh "$SCAN" list 2>/dev/null)
  UNLANDED=$(printf '%s\n' "$BOX" | grep '^unlanded=' | cut -d= -f2)
  case "${UNLANDED:-0}" in
    ''|0) : ;;
    *) say "$UNLANDED session log(s) stand in the dead-letter box and nowhere else -- sh $SCAN list" ;;
  esac
  # THREE KINDS, AND ONLY ONE IS A LAP (REDS %592). The bare count was honest and unreadable: on
  # this field it stood at nineteen for a day and a half while every ship read past it, because
  # ten were fold shelves whose rows come off the living pin, three were a guard's own elder paths
  # from before a room fold, and six were the actual parked work. The open names the split so a
  # reader knows which number is worth a lap before deciding whether to run `list`.
  ORPHANS=$(printf '%s\n' "$BOX" | grep '^orphans=' | cut -d= -f2)
  WORK=$(printf '%s\n' "$BOX" | grep '^orphans_work=' | cut -d= -f2)
  SHELF=$(printf '%s\n' "$BOX" | grep '^orphans_shelf=' | cut -d= -f2)
  MOVED=$(printf '%s\n' "$BOX" | grep '^orphans_moved=' | cut -d= -f2)
  RENAMED=$(printf '%s\n' "$BOX" | grep '^orphans_renamed=' | cut -d= -f2)
  case "${ORPHANS:-0}" in
    ''|0) : ;;
    *) say "$ORPHANS file(s) stand in the dead-letter box and on no ref -- ${WORK:-?} parked work, ${SHELF:-?} fold shelves, ${MOVED:-?} moved, ${RENAMED:-?} renamed -- sh $SCAN list" ;;
  esac
  # AND THE PARKED WORK IS NAMED, NEVER MERELY COUNTED. A count tells a hand that something is in
  # the box; only a path tells them it is THEIRS. The split above was already honest and still cost
  # a peer an hour on `20260911`: that lap read `git stash list`, saw its own parked census counted,
  # judged the box not worth a `list`, and rebuilt 747 lines the stash had held finished for fifteen
  # seconds. Recognition runs on names, so the open spends its lines on the one kind that is a lap.
  #
  # ONLY `orphan:work` IS NAMED. A fold shelf comes off the living pin and a moved path is answered
  # elsewhere, so printing those would rebuild the unreadable nineteen `%592` split apart.
  #
  # BOUNDED AT EIGHT, because this report is read at a glance and a longer list is skimmed rather
  # than read -- which returns the reading to the count it replaced. Eight covers both fields
  # measured on the seating lap (five parked paths here, three on the peer that asked for this) with
  # headroom, and a box past it says how many it held back and where the whole list lives.
  BOX_NAME_MAX=8
  NAMED=0
  # The match is the kind's PREFIX rather than its whole field (`20260912.000053`): a `near`
  # reading rides in the same drawer as `orphan:work:near:<path>:<share>`, so an anchored
  # match would name every work path except the ones carrying a candidate worth checking.
  printf '%s\n' "$BOX" | grep '	orphan:work' | while IFS='	' read -r sref path kind; do
    NAMED=$((NAMED + 1))
    [ "$NAMED" -le "$BOX_NAME_MAX" ] && say "  parked work: $path -- $sref"
    [ "$NAMED" -eq "$BOX_NAME_MAX" ] && [ "${WORK:-0}" -gt "$BOX_NAME_MAX" ] \
      && say "  ... and $((WORK - BOX_NAME_MAX)) more parked path(s) -- sh $SCAN list"
    :
  done
fi

say "open on $(git rev-parse --short=10 HEAD)"
exit 0
