#!/bin/sh
# tools/fixtures/b/shared_receipt_basis_scan.sh -- can a PEER's full green receipt stand as this
# pier's --scoped basis?
#
# Read-only. Usage, from the repository root:
#   sh tools/fixtures/b/shared_receipt_basis_scan.sh <peer-receipt-path> [<repo-dir>]
#
# WHY THE DIGEST CANNOT CARRY IT. tree_digest in tools/fixtures/s/standing_equipment_run.sh hashes
# HEAD, the porcelain, the diff, and every untracked file's content. Two checkouts at one commit
# still differ the moment either holds an edit, so a peer's `digest` never equals this pier's. The
# digest answers "is THIS tree the one that was proven"; it cannot answer "is that proof still a
# valid starting point for mine".
#
# WHAT CARRIES ACROSS INSTEAD. --scoped already answers the second question from the receipt's
# `head`: it runs only what the change since that head touches, and needs that head to be a commit
# this repository holds. Every ship pushes to one remote, so a peer's green head arrives here by
# fetch. This scan applies the same test to a peer's receipt:
#   1. the file exists and names the receipt format;
#   2. `scope` is `full` (receipts chain only from full greens, per the runner's own comment);
#   3. `head` names a commit this repository holds;
#   4. `head` is an ancestor of this HEAD, so the delta `head..HEAD` is a delta that exists here.
# A stand also prints `changed`, the count of paths in that delta, which is what a scoped pass
# would have to re-prove. Nothing is built, run, or written.
#
# WHAT THIS DOES NOT SAY. It does not say the peer's guards were green on THIS machine, and it does
# not wire the basis into --scoped; a stand is a reading a hand or a later lap may act on. The
# receipt's own `gated` line rides along unread, since a gated guard is a custody fact, not a fault.
#
# Verdicts: stands | refused, with one reason each. Exit 0 on stands, 1 on refused, 2 on usage.

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  echo "usage: sh tools/fixtures/b/shared_receipt_basis_scan.sh <peer-receipt-path> [<repo-dir>]" >&2
  exit 2
fi
receipt=$1
repo=${2:-.}

refuse() {
  echo "shared_basis=refused"
  echo "reason=$1"
  echo "verdict=refused"
  exit 1
}

# invariant: the reading never writes into the repository it reads.
cd "$repo" || { echo "reason=repo_missing"; echo "verdict=refused"; exit 2; }
git rev-parse --git-dir >/dev/null 2>&1 || { echo "reason=not_a_repository"; echo "verdict=refused"; exit 2; }

if [ ! -f "$receipt" ]; then
  refuse "receipt_missing"
fi

format=$(sed -n 's/^format //p' "$receipt" | head -1)
scope=$(sed -n 's/^scope //p' "$receipt" | head -1)
head=$(sed -n 's/^head //p' "$receipt" | head -1)
stamp=$(sed -n 's/^stamp //p' "$receipt" | head -1)
digest=$(sed -n 's/^digest //p' "$receipt" | head -1)

echo "receipt=$receipt"
echo "receipt_format=${format:-none}"
echo "receipt_scope=${scope:-none}"
echo "receipt_head=${head:-none}"
echo "receipt_stamp=${stamp:-none}"
echo "receipt_digest=${digest:-none}"
echo "digest_carries=no digest is per tree (HEAD plus worktree), so it cannot match across checkouts"

case "$format" in
  standing-equipment-receipt-v*) ;;
  *) refuse "format_not_receipt" ;;
esac
[ "$scope" = full ] || refuse "scope_not_full"
[ -n "$head" ] || refuse "head_missing"

if ! git cat-file -e "$head^{commit}" 2>/dev/null; then
  refuse "head_not_held_here"
fi
if ! git merge-base --is-ancestor "$head" HEAD 2>/dev/null; then
  refuse "head_not_ancestor_of_HEAD"
fi

changed=$(git diff --name-only "$head" HEAD | wc -l | tr -d ' ')
echo "here_head=$(git rev-parse --short=12 HEAD)"
echo "changed=$changed"
echo "shared_basis=stands"
echo "verdict=stands"
exit 0
