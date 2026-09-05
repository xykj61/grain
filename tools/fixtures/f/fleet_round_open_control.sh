#!/bin/sh
# Proves tools/f/fleet_round_open.sh on real git repositories in a throwaway pen -- with a real
# anointed remote, a real conflicted rebase, and every state the script claims to tell apart.
#
# This script runs `git reset --hard` on live fleet trees every twenty minutes and had no control
# at all. The rebase leg is why it now does: mid-rebase, the tree reads dirty, HEAD is detached at
# a half-replayed commit, and the reset abandons the rebase and leaves the branch behind.
set -u
src=$(CDPATH= cd -- "$(dirname -- "$0")/../../f" && pwd)/fleet_round_open.sh
[ -f "$src" ] || { echo "control: REFUSED -- $src is absent" >&2; exit 2; }
pen=$(mktemp -d) || exit 1
trap 'rm -rf "$pen"' EXIT
pass=0; fail=0
ck() { if printf '%s' "$3" | grep -q -- "$2"; then pass=$((pass+1)); else
  fail=$((fail+1)); echo "  FAIL $1: wanted '$2'"; printf '%s\n' "$3" | sed 's/^/        /'; fi; }

export GIT_AUTHOR_NAME=pen GIT_AUTHOR_EMAIL=pen@pen GIT_COMMITTER_NAME=pen GIT_COMMITTER_EMAIL=pen@pen
g() { git -c commit.gpgsign=false -c core.hooksPath=/dev/null "$@"; }

# An anointed remote with two commits, and a working tree pointed at it as `xy`.
g init -q -b main "$pen/anointed"
( cd "$pen/anointed" && echo one > f.txt && g add -A && g commit -qm one )
g clone -q "$pen/anointed" "$pen/work" 2>/dev/null
g -C "$pen/work" remote rename origin xy
( cd "$pen/anointed" && echo two > f.txt && g add -A && g commit -qm two )

run_open() { ( cd "$pen/work" && sh "$src" 2>&1 ); }

# 1-2. Behind the anointed order: adopt by reset, and say which.
out=$(run_open)
ck "behind adopts"        "adopted the anointed order" "$out"
ck "behind ends open"     "open on"                    "$out"

# 3. Already level: named as itself, not as an adoption.
ck "level is named" "already on the anointed order" "$(run_open)"

# 4-5. A dead lap's dirt goes to the dead-letter box under a stamped name.
echo dirty > "$pen/work/left.txt"
out=$(run_open)
ck "dirt stashed"      "dead-letter box" "$out"
ck "stash really made" "fleet-round-open" "$(g -C "$pen/work" stash list)"

# 6-9. THE REBASE CORPSE. A conflicted rebase is left standing, exactly as a dead lap leaves one.
( cd "$pen/anointed" && echo upstream > f.txt && g add -A && g commit -qm upstream )
( cd "$pen/work" && g fetch -q xy && echo local > f.txt && g add -A && g commit -qm local
  g rebase xy/main >/dev/null 2>&1 )   # conflicts, and stays open
before=$(g -C "$pen/work" rev-parse --verify refs/heads/main 2>/dev/null)
ck "pen really is mid-rebase" "." "$( [ -d "$pen/work/.git/rebase-merge" ] || [ -d "$pen/work/.git/rebase-apply" ] && echo . )"
out=$(run_open)
ck "rebase corpse named"   "an interrupted rebase stood" "$out"
ck "pre-rebase line parked" "parked on pier/rebase-"     "$out"
ck "the round still opens"  "open on"                    "$out"

# 10-11. The park is a real ref holding the real pre-rebase tip -- no bytes lost.
park=$(g -C "$pen/work" for-each-ref --format='%(refname:short)' 'refs/heads/pier/rebase-*' | head -1)
ck "park ref exists" "pier/rebase-" "$park"
[ -n "$park" ] && [ "$(g -C "$pen/work" rev-parse "$park")" = "$before" ] \
  && pass=$((pass+1)) || { fail=$((fail+1)); echo "  FAIL park holds the pre-rebase tip"; }

# 12. And no rebase is left standing afterward.
if [ -d "$pen/work/.git/rebase-merge" ] || [ -d "$pen/work/.git/rebase-apply" ]; then
  fail=$((fail+1)); echo "  FAIL a rebase still stands after the open"
else pass=$((pass+1)); fi

# 13. A network the fetch cannot reach is exit 2 -- retry, never a lie about divergence.
g -C "$pen/work" remote set-url xy "$pen/nowhere"
out=$(run_open); rc=$?
ck "unreachable remote refuses" "fetch refused" "$out"
[ "$rc" = 2 ] && pass=$((pass+1)) || { fail=$((fail+1)); echo "  FAIL fetch refusal exit: got $rc wanted 2"; }

echo "pass=$pass fail=$fail"
[ "$fail" -eq 0 ] || exit 1
