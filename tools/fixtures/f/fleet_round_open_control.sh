#!/bin/sh
# Proves tools/f/fleet_round_open.sh on real git repositories in a throwaway pen -- with a real
# anointed remote, a real conflicted rebase, and every state the script claims to tell apart.
#
# This script runs `git reset --hard` on live fleet trees every twenty minutes and had no control
# at all. The rebase leg is why it now does: mid-rebase, the tree reads dirty, HEAD is detached at
# a half-replayed commit, and the reset abandons the rebase and leaves the branch behind.
#
# AND FOR ITS FIRST DAY THIS CONTROL NEVER PLANTED THE DIVERGED STATE (REDS %503). Seventeen legs
# proved behind, level, dirty, mid-rebase, an unreachable remote and the dead-letter box -- and the
# one branch holding `git branch`, `git push xy` and `reset --hard` together was the one branch no
# leg reached. Legs A, B and C below plant it three ways, because it is three states rather than
# one: an ordinary lost race that re-derives, a rewrite whose replay collides and must park, and a
# rewrite whose replay drops a patch already standing upstream. Against the elder script these
# fail 8 of their 17.
set -u
src=$(CDPATH= cd -- "$(dirname -- "$0")/../../f" && pwd)/fleet_round_open.sh
[ -f "$src" ] || { echo "control: REFUSED -- $src is absent" >&2; exit 2; }
pen=$(mktemp -d) || exit 1
trap 'rm -rf "$pen"' EXIT
pass=0; fail=0
ck() { if printf '%s' "$3" | grep -q -- "$2"; then pass=$((pass+1)); else
  fail=$((fail+1)); echo "  FAIL $1: wanted '$2'"; printf '%s\n' "$3" | sed 's/^/        /'; fi; }
nk() { if printf '%s' "$3" | grep -q -- "$2"; then
  fail=$((fail+1)); echo "  FAIL $1: did NOT want '$2'"; printf '%s\n' "$3" | sed 's/^/        /';
  else pass=$((pass+1)); fi; }

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

# 15-16. THE DEAD-LETTER BOX IS READ BACK OUT (REDS %464). Step 3 fills it and, until this leg,
# nothing ever looked inside. The report is proven by running the open over a planted record rather
# than by grepping the script for a string, since a line that exists and never prints is the same
# absence wearing a passing test.
g -C "$pen/work" remote set-url xy "$pen/anointed"
mkdir -p "$pen/work/tools/fixtures/f" "$pen/work/session-logs/date/20260101"
# THE SCAN LIVES IN ITS OWN LETTER ROOM (`20260906`), so the pen copies it from there into the
# same room the open reads. A sibling `dirname $0` lookup found it while both sat under `f/`,
# and the letter fold moved it to `s/` where its basename says it belongs -- at which point the
# pen silently held no scan, the open printed nothing, and two cases failed on an absence
# rather than on a fault.
_fro_root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
mkdir -p "$pen/work/tools/fixtures/s"
cp "$_fro_root/tools/fixtures/s/stash_record_scan.sh" "$pen/work/tools/fixtures/s/"
( cd "$pen/work" && g add -A && g commit -qm "carry the scan" >/dev/null 2>&1 )
printf 'format session-log-v1\nstamp 20260101.010101\n' > "$pen/work/session-logs/date/20260101/20260101-010101_parked.kyri"
( cd "$pen/work" && g stash push -u -m "fleet-round-open 20260101-010102: a lap's unsent work, stashed at the open" >/dev/null 2>&1 )
out=$(run_open)
ck "the open reports the parked record" "stand in the dead-letter box" "$out"
ck "and names how to read it"           "stash_record_scan.sh list"    "$out"

# 17. Land the record and the line goes quiet, with the stash left exactly where it stands.
mkdir -p "$pen/work/session-logs/date/20260101"
printf 'format session-log-v1\nstamp 20260101.010101\n' > "$pen/work/session-logs/date/20260101/20260101-010101_parked.kyri"
( cd "$pen/work" && g add -A && g commit -qm "read the record back" >/dev/null 2>&1 )
nk "a landed record is not reported" "dead-letter box and nowhere" "$(run_open)"


# a fresh work tree pointed at a fresh anointed remote, both one commit deep
fresh() {
  rm -rf "$pen/anointed" "$pen/work"
  g init -q -b main "$pen/anointed"
  ( cd "$pen/anointed" && echo one > f.txt && g add -A && g commit -qm one )
  g clone -q "$pen/anointed" "$pen/work" 2>/dev/null
  g -C "$pen/work" remote rename origin xy
}
open_it() { ( cd "$pen/work" && sh "$src" 2>&1 ); }
corpse() { [ -d "$pen/work/.git/rebase-merge" ] || [ -d "$pen/work/.git/rebase-apply" ]; }

# ---- A. ORDINARY LOST RACE: peer pushed on the base this line was built on.
fresh
( cd "$pen/work" && echo mine > mine.txt && g add -A && g commit -qm "the lap's own work" )
( cd "$pen/anointed" && echo peer > peer.txt && g add -A && g commit -qm "a peer's round" )
out=$(open_it)
ck "A1 lost race re-derives"      "re-derived"                  "$out"
nk "A2 and is not called divergence" "true divergence"          "$out"
ck "A3 the lap's commit survives" "the lap's own work" "$(g -C "$pen/work" log --format=%s xy/main..HEAD)"
ck "A4 it stands on the new head" "a peer's round" "$(g -C "$pen/work" log --format=%s -3)"
nk "A5 no park litters the refs"  "pier/diverged" "$(g -C "$pen/work" for-each-ref --format='%(refname:short)' 'refs/heads/pier/*')"
if corpse; then fail=$((fail+1)); echo "  FAIL A6 a rebase stands after a lost race"; else pass=$((pass+1)); fi

# ---- B. TRUE REWRITE that collides: the park is still exactly right.
fresh
( cd "$pen/work" && echo mine > f.txt && g add -A && g commit -qm "the lap's own work" )
( cd "$pen/anointed" && echo rewritten > f.txt && g add -A && g commit -q --amend -m "one, rewritten" )
tip=$(g -C "$pen/work" rev-parse HEAD)
out=$(open_it)
ck "B1 a real rewrite is named"   "true divergence"    "$out"
ck "B2 and says the rebase refused" "re-derivation refused" "$out"
park=$(g -C "$pen/work" for-each-ref --format='%(refname:short)' 'refs/heads/pier/diverged-*' | head -1)
ck "B3 the park ref exists" "pier/diverged-" "$park"
[ -n "$park" ] && [ "$(g -C "$pen/work" rev-parse "$park")" = "$tip" ] \
  && pass=$((pass+1)) || { fail=$((fail+1)); echo "  FAIL B4 park holds the pre-open tip"; }
[ "$(g -C "$pen/work" rev-parse HEAD)" = "$(g -C "$pen/work" rev-parse xy/main)" ] \
  && pass=$((pass+1)) || { fail=$((fail+1)); echo "  FAIL B5 main did not adopt the anointed order"; }
if corpse; then fail=$((fail+1)); echo "  FAIL B6 a rebase stands after a refused re-derivation"; else pass=$((pass+1)); fi

# ---- C. REWRITE with no collision: git drops the already-upstream patch, and the park is KEPT.
fresh
( cd "$pen/work" && echo mine > mine.txt && g add -A && g commit -qm "the lap's own work" )
( cd "$pen/anointed" && g commit -q --amend -m "one, reworded" )
out=$(open_it)
ck "C1 the drop is named"       "already stood upstream" "$out"
ck "C2 and counted honestly"    "re-derived 1 of 2"      "$out"
ck "C3 the park is kept"        "pier/diverged" "$(g -C "$pen/work" for-each-ref --format='%(refname:short)' 'refs/heads/pier/*')"
ck "C4 the lap's commit survives" "the lap's own work" "$(g -C "$pen/work" log --format=%s xy/main..HEAD)"
if corpse; then fail=$((fail+1)); echo "  FAIL C5 a rebase stands after a drop"; else pass=$((pass+1)); fi

echo "pass=$pass fail=$fail"
[ "$fail" -eq 0 ] || exit 1
