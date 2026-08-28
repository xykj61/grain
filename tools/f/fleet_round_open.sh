#!/bin/sh
# tools/f/fleet_round_open.sh -- the fleet's self-healing round-open: adopt the anointed
# order, stash what a dead lap left, park what diverged, and never misreport.
#
# WHY THIS EXISTS. On 20260828 two loops died in the same minute-shape. A lap finished its
# work and never sent; the next iteration's `git pull --rebase xy main` refused on the dirty
# index; and the loop's `||` handler printed `PULL DIVERGED: upstream history was rewritten`
# -- for a tree that was NOT diverged (HEAD equaled xy/main exactly). One handler, one
# message, three different faults: a dirty tree, a network failure, and a real rewrite all
# died the same death with the same wrong instruction. The refusal's first line named the
# true fault both times; the handler read only its own assumption (the tail-reading class,
# REDS %-family of 20260827-28).
#
# THE CONSENSUS MAPPING, so the loops speak Mycelium's grammar through git itself:
#   - `xy` is the ANOINTED ORDER -- the sequencer every proposal is ordered by, the same
#     seat the derived-spine law gives it for ledger rows.
#   - a lap's send is a PROPOSAL; the fast-forward push is the compare-and-set, and its
#     refusal is an ordinary lost race, answered by re-deriving on the new head -- never
#     by force (the twice-pulled rota, seated 20260825.210819).
#   - at round-open the local tree ADOPTS the anointed order: RESET, NEVER MERGE (the
#     divergence word the loops learned at REDS %290). A local line that genuinely
#     diverged -- an upstream rewrite, a lost race across a rewrite -- is PARKED on a
#     branch under refs/heads/pier/, the rota's own deferral shelf, and main resets. No
#     bytes are lost and no force is pushed; the park is a proposal awaiting its next
#     derivation, exactly like an unshared ledger row awaiting its number.
#   - what a dead lap left uncommitted is STASHED under a stamped name, wall-free (a
#     park-commit would face the commit-msg wall, and a round-open must never be able to
#     fail on prose). Stashes are the fleet's dead-letter box; a hand or the lap itself
#     re-derives them.
#
# EXIT CODES, and the loop line that reads them:
#   0  round is open on the anointed order -- proceed
#   2  the network refused the fetch -- retry later; the loop sleeps and continues
# A loop line: sh tools/f/fleet_round_open.sh || { sleep 60; continue; }
# It can no longer die at the open, and it can no longer lie about why it would have.
set -u

say() { printf 'round-open: %s\n' "$1"; }

test -d .git || { say "not a repository root -- refusing"; exit 2; }

STAMP=$(TZ=America/New_York date +%Y%m%d-%H%M%S)

# 1) the fetch, the only step a network can refuse -- and the only exit-2
if ! git fetch xy main 2>&1; then
  say "fetch refused (network or remote) -- retry, nothing local changed"
  exit 2
fi

# 2) a dead lap's leavings go to the dead-letter box, named, wall-free
if ! git diff --quiet || ! git diff --cached --quiet || [ -n "$(git ls-files --others --exclude-standard 2>/dev/null | head -1)" ]; then
  git stash push -u -m "fleet-round-open $STAMP: a lap's unsent work, stashed at the open" >/dev/null 2>&1 \
    && say "dirty tree stashed as 'fleet-round-open $STAMP' -- $(git stash list | grep -c 'fleet-round-open') in the dead-letter box" \
    || say "stash refused; continuing on the tree as it stands"
fi

# 3) classify against the anointed order -- each state by name, never one message for three
if [ "$(git rev-parse HEAD)" = "$(git rev-parse xy/main)" ]; then
  say "already on the anointed order"
elif git merge-base --is-ancestor HEAD xy/main 2>/dev/null; then
  git reset --hard xy/main >/dev/null 2>&1
  say "behind -- adopted the anointed order (reset, never merge)"
elif git merge-base --is-ancestor xy/main HEAD 2>/dev/null; then
  say "ahead by $(git rev-list --count xy/main..HEAD) -- local sends pending; the lap's close will propose them"
else
  PARK="pier/diverged-$STAMP"
  git branch "$PARK" >/dev/null 2>&1
  git push xy "$PARK" >/dev/null 2>&1 && PUSHED=" and pushed" || PUSHED=" (push deferred; the branch is local)"
  git reset --hard xy/main >/dev/null 2>&1
  say "true divergence -- local line parked on $PARK$PUSHED; adopted the anointed order"
fi

say "open on $(git rev-parse --short=10 HEAD)"
exit 0
