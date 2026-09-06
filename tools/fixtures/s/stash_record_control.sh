#!/bin/sh
# Proves tools/fixtures/s/stash_record_scan.sh on real git repositories in a throwaway pen --
# every refusal planted and then removed, and every welcome asserted as hard as every refusal,
# since a refusal proven only in the passing direction cannot be told from a bypass.
#
# THE LEG THAT EARNS THE PEN is 6-7: the obvious probe, `git log --all`, is shown FINDING a record
# that lives only in the stash, in the same pen where the scan calls that record unlanded. The
# header's central claim is therefore proven by doing rather than asserted in prose -- if a future
# git stops reaching refs/stash from `--all`, this leg says so on the lap it changes.
set -u
src=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/stash_record_scan.sh
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
run() { ( cd "$pen/work" && sh "$src" "$@" 2>&1 ); }

# A repository with one landed commit, and a shelf the room already carries.
g init -q -b main "$pen/work"
mkdir -p "$pen/work/session-logs/date/20260101"
( cd "$pen/work" && echo seed > seed.txt && g add -A && g commit -qm seed )

# 1-3. An empty box: nothing counted, nothing refused. A guard measuring an empty set must still
# report, or a room that vanishes from a meter is a room whose pass nobody witnessed.
out=$(run)
ck "empty box counts zero stashes" "stashes=0"  "$out"
ck "empty box counts zero records" "records=0"  "$out"
ck "empty box is ok"               "verdict=ok" "$out"

# 4-5. A record parked and never read back: the fault, planted.
# `git stash push -u` carries an untracked directory away with its files, so a plant makes its own
# shelf every time rather than assuming the last one survived.
plant() {
  mkdir -p "$pen/work/session-logs/date/20260101"
  printf 'format session-log-v1\nstamp %s\n' "$2" > "$pen/work/session-logs/date/20260101/$1"
}
plant "20260101-010101_a-parked-record.kyri" "20260101.010101"
( cd "$pen/work" && g stash push -u -m "fleet-round-open 20260101-010102: a lap's unsent work, stashed at the open" >/dev/null 2>&1 )
out=$(run)
ck "a parked record is counted"  "unlanded=1"               "$out"
ck "and refuses"                 "verdict=records_unlanded" "$out"

# 6-8. THE SHARP EDGE, and it cuts both ways. `git log --all` reaches refs/stash, so on a record
# that was STAGED when the lap died it finds the stash's own index commit and reports the record as
# history -- which is the field's exact shape, where `98b56e594` turned out to be `stash@{0}^2`.
# On a record that was merely UNTRACKED it finds nothing, because `-u` puts those bytes in the
# stash's third parent and the default history walk prunes it. Same probe, same question, opposite
# answers, and neither answer is about whether the record landed. Both readings are taken here in
# the same pen, on real paths, so a future git that changes either one says so on the lap it does.
( cd "$pen/work" && g add -A 2>/dev/null )
plant "20260101-011111_a-staged-record.kyri" "20260101.011111"
( cd "$pen/work" && g add -A && g stash push -u -m "fleet-round-open 20260101-011112: a lap's unsent work, stashed at the open" >/dev/null 2>&1 )
allsees=$( cd "$pen/work" && g log --all --oneline -- '*20260101-011111*' 2>/dev/null | wc -l | tr -d ' ' )
ck "git log --all sees a staged record (false safe)" "1" "$allsees"
idx=$( cd "$pen/work" && g rev-parse --short 'stash@{0}^2' 2>/dev/null )
ck "and what it saw IS the stash index commit" "$idx" "$( cd "$pen/work" && g log --all --format=%h -- '*20260101-011111*' 2>/dev/null )"
allsees=$( cd "$pen/work" && g log --all --oneline -- '*20260101-010101*' 2>/dev/null | wc -l | tr -d ' ' )
ck "git log --all misses an untracked record" "0" "$allsees"

# 9. The scan reads both alike, because it asks refs by name and never --all.
ck "the scan counts both parked records" "unlanded=2" "$(run)"
( cd "$pen/work" && g stash drop 'stash@{0}' >/dev/null 2>&1 )

# 10-12. THE BOX IS NOT THE READING. Land the record on a branch and leave the stash exactly where
# it stands: the scan goes green because the RECORD is safe, never because the box was emptied.
( cd "$pen/work" && g stash show --include-untracked -p 'stash@{0}' 2>/dev/null | g apply - 2>/dev/null || true )
plant "20260101-010101_a-parked-record.kyri" "20260101.010101"
( cd "$pen/work" && g add -A && g commit -qm "land the record" )
out=$(run)
ck "a landed record is landed"       "landed=1"    "$out"
ck "and refuses nothing"             "verdict=ok"  "$out"
ck "with the stash still standing"   "fleet-round-open" "$( g -C "$pen/work" stash list )"

# 13-14. A hand's own stash is not the fleet's dead-letter box, so its contents are not this
# reading's business. Planted with a record inside, which is the only way the exclusion is proven.
plant "20260101-020202_a-hand-s-own-note.kyri" "20260101.020202"
( cd "$pen/work" && g stash push -u -m "wip: my own thing" >/dev/null 2>&1 )
out=$(run)
ck "a hand's stash is not counted" "stashes=1" "$out"
nk "and its record is not read"    "020202"    "$(run all)"
( cd "$pen/work" && g stash drop 'stash@{0}' >/dev/null 2>&1 )

# 15-16. A shelf index is a living page every ship appends to, so it is not a record. Planted
# alone, so the reading is proven by the count rather than by reading past it.
mkdir -p "$pen/work/session-logs/date"
printf '| Stamp | Log |\n' > "$pen/work/session-logs/date/README-index-20260101.md"
( cd "$pen/work" && g stash push -u -m "fleet-round-open 20260101-030303: a lap's unsent work, stashed at the open" >/dev/null 2>&1 )
out=$(run)
ck "a shelf index adds no record" "records=1" "$out"
ck "and the box still counts it"  "stashes=2" "$out"

# 17-18. A SPRIGLESS LOG IS A RECORD (REDS %175). 237 logs in the field carry a stamp and no
# sprig; a pattern requiring one reads every last of them as living and this box as empty.
plant "20260101-040404.kyri" "20260101.040404"
( cd "$pen/work" && g stash push -u -m "fleet-round-open 20260101-040405: a lap's unsent work, stashed at the open" >/dev/null 2>&1 )
out=$(run)
ck "a sprigless log is a record" "unlanded=1"               "$out"
ck "and refuses like any other"  "verdict=records_unlanded" "$out"

# 19. A record standing in the WORKTREE and on no branch is landed enough to read back -- the
# bytes are in front of the hand, which is the whole question this guard asks.
plant "20260101-040404.kyri" "20260101.040404"
ck "a worktree record is landed" "landed:worktree" "$(run all)"
rm -f "$pen/work/session-logs/date/20260101/20260101-040404.kyri"

# 20-21. A record carried by a REMOTE-TRACKING ref counts as landed: it stands in the anointed
# order, which is further into the channel than this tree is. Built so the record is in the box AND
# on the remote AND nowhere else -- no worktree copy, no local branch -- or the leg proves nothing.
g clone -q "$pen/work" "$pen/anointed" 2>/dev/null
( cd "$pen/work" && g remote add xy "$pen/anointed" 2>/dev/null || true )
( cd "$pen/work" && g checkout -q -b side )
plant "20260101-050505_landed-upstream.kyri" "20260101.050505"
( cd "$pen/work" && g add -A && g commit -qm upstream-record >/dev/null
  g push -q xy side:refs/heads/side 2>/dev/null
  g checkout -q main && g branch -q -D side && g fetch -q xy 2>/dev/null )
plant "20260101-050505_landed-upstream.kyri" "20260101.050505"
( cd "$pen/work" && g stash push -u -m "fleet-round-open 20260101-050506: a lap's unsent work, stashed at the open" >/dev/null 2>&1 )
out=$(run all)
ck "a remote-tracking record is landed" "landed:refs/remotes/xy/side" "$out"
# The needle is anchored on the BASENAME rather than the stamp: a line reads
# `<stash>\t<path>\t<state>`, and the stamp sits inside the path, so `050505<TAB>unlanded` matches
# nothing in any state -- a negative assertion that could never fire, passing for the wrong reason
# from the day it was written (found `20260906` while adding legs 23-35 the same way, REDS %507).
nk "and is not called unlanded"         "landed-upstream.kyri	unlanded" "$out"

# 22. Outside a repository the scan says so rather than guessing.
ck "not a repository is named" "verdict=not_a_repository" "$( cd "$pen" && sh "$src" 2>&1 )"

# 23-29. A `pier/` PARK IS NOT A LANDING (REDS %507), and this is the leg that pays for the whole
# widening. The round open has two drawers: it stashes an unsent tree, and it parks a diverged
# line on `refs/heads/pier/diverged-<stamp>`. Until this reading was widened the second drawer
# certified the first empty -- a record carried only by a park read `landed:refs/heads/pier/...`,
# `unlanded=0`, `verdict=ok`, while nothing a reader reaches held it. Built the only way that
# proves anything: the record is in the box AND on a park ref AND nowhere else -- no worktree
# copy, no `main`.
( cd "$pen/work" && g checkout -q -b pier/diverged-20260101-060606 )
plant "20260101-060606_parked-on-a-pier-branch.kyri" "20260101.060606"
( cd "$pen/work" && g add -A && g commit -qm parked-record >/dev/null && g checkout -q main )
plant "20260101-060606_parked-on-a-pier-branch.kyri" "20260101.060606"
( cd "$pen/work" && g stash push -u -m "fleet-round-open 20260101-060607: a lap's unsent work, stashed at the open" >/dev/null 2>&1 )
out=$(run all)
ck "a park-only record is unlanded"       "parked-on-a-pier-branch.kyri	unlanded:parked:refs/heads/pier/diverged-20260101-060606" "$out"
ck "and the park is counted"              "parked=1"                 "$out"
ck "and the single gate fires"            "verdict=records_unlanded" "$out"
nk "and it is never called landed"        "parked-on-a-pier-branch.kyri	landed"           "$out"
ck "and list shows it"                    "060606"                   "$(run list)"

# `pier/rebase-<stamp>` is a park too: the round open writes both, and the exclusion follows the
# NAMESPACE rather than one prefix, so a park named differently tomorrow is still a park.
( cd "$pen/work" && g branch -q -m pier/diverged-20260101-060606 pier/rebase-20260101-060606 )
ck "a rebase park is a park as well" "parked-on-a-pier-branch.kyri	unlanded:parked:refs/heads/pier/rebase-20260101-060606" "$(run all)"

# 30-32. THE SAME RECORD OFF THE PARK IS LANDED. Shown by RENAMING the branch rather than by
# building a second pen, so the one thing that differs between the refusal above and the welcome
# here is which namespace carries the record -- which is the claim itself, and nothing else moved.
#
# The assertion is the record's own line and the park count, rather than `verdict=ok`: leg 19
# deliberately left `20260101-040404.kyri` unlanded in this same box, so the whole-repository
# verdict cannot return to ok from here without undoing a leg that is proving something else. A
# welcome asserted on a number the pen cannot reach is a welcome that proves the pen.
( cd "$pen/work" && g branch -q -m pier/rebase-20260101-060606 arrived && g merge -q --ff-only arrived >/dev/null 2>&1 )
out=$(run all)
ck "the same record off the park is landed" "parked-on-a-pier-branch.kyri	landed" "$out"
ck "the park count falls back to zero"      "parked=0"                    "$out"
nk "and list no longer names it"            "parked-on-a-pier-branch"     "$(run list)"
( cd "$pen/work" && g checkout -q main && rm -f "$pen/work/session-logs/date/20260101/20260101-060606_parked-on-a-pier-branch.kyri" )

# 33-35. A REMOTE park is a park. Legs 20-21 proved a remote-tracking ref counts as landed, which
# is right for `xy/main` and exactly wrong for `xy/pier/diverged-*` -- `%499` measured ten of those
# on the anointed remote that no hand ever brought home. Pushing a park upstream moves no record
# into the channel, so the exclusion has to reach `refs/remotes/*/pier/*` or legs 20-21 would let
# every parked record back in through the remote door.
( cd "$pen/work" && g checkout -q -b pier/diverged-20260101-070707 )
plant "20260101-070707_parked-upstream.kyri" "20260101.070707"
( cd "$pen/work" && g add -A && g commit -qm parked-upstream >/dev/null
  g push -q xy pier/diverged-20260101-070707:refs/heads/pier/diverged-20260101-070707 2>/dev/null
  g checkout -q main && g branch -q -D pier/diverged-20260101-070707 && g fetch -q xy 2>/dev/null )
plant "20260101-070707_parked-upstream.kyri" "20260101.070707"
( cd "$pen/work" && g stash push -u -m "fleet-round-open 20260101-070708: a lap's unsent work, stashed at the open" >/dev/null 2>&1 )
out=$(run all)
ck "a record parked on the REMOTE is unlanded" "parked-upstream.kyri	unlanded:parked:refs/remotes/xy/pier/diverged-20260101-070707" "$out"
nk "and is not called landed"                  "parked-upstream.kyri	landed"     "$out"
ck "and the gate fires"                        "verdict=records_unlanded" "$out"

echo "pass=$pass fail=$fail"
[ "$fail" -eq 0 ] || exit 1
