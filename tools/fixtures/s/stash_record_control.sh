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

# 36-48. A RECORD IS NOT THE WORK (REDS %510), proven in its OWN repository so every number here is
# absolute. The pen above deliberately keeps an unlanded record standing from leg 19, so the whole
# tree verdict cannot return to `ok` in it -- and the leg that pays for this widening is exactly a
# verdict of `ok` over a box that still holds work, which needs a box holding nothing else.
g init -q -b main "$pen/box"
mkdir -p "$pen/box/tools"
( cd "$pen/box" && echo seed > seed.txt && echo old > tools/kept.sh && g add -A && g commit -qm seed )
box() { ( cd "$pen/box" && sh "$src" "$@" 2>&1 ); }

# One stash holding all three shapes at once: a NEW file nothing else has, an EDIT to a tracked
# file, and a record. Together in one stash on purpose -- the classification has to hold when the
# three arrive mixed, which is how a real lap parks them.
mkdir -p "$pen/box/session-logs/date/20260101"
printf 'format session-log-v1\n' > "$pen/box/session-logs/date/20260101/20260101-080808_the-work.kyri"
echo lost > "$pen/box/tools/lost.sh"
echo new > "$pen/box/tools/kept.sh"
( cd "$pen/box" && g stash push -u -m "fleet-round-open 20260101-080809: a lap's unsent work, stashed at the open" >/dev/null 2>&1 )
out=$(box)
ck "the non-record paths are counted"          "paths=2"    "$out"
ck "a file nothing carries is an orphan"       "orphans=1"  "$out"
ck "an EDIT to a carried file is unread"       "unread=1"   "$out"
ck "and the record is still counted once"      "records=1"  "$out"
outall=$(box all)
ck "the orphan is named with its stash"        "tools/lost.sh	orphan"    "$outall"
ck "the edited file is not called an orphan"   "tools/kept.sh"            "$outall"
nk "-- it holds an edit this probe cannot read" "tools/kept.sh	orphan"   "$outall"
nk "and a record is never also an orphan"      "20260101-080808_the-work.kyri	orphan" "$outall"
ck "list names the orphan beside the record"   "tools/lost.sh"            "$(box list)"

# THE LEG THAT PAYS FOR THE WIDENING. Land the RECORD alone -- exactly the state a lap reaches when
# its log ships and its code does not -- and the elder reading calls the whole box clean while the
# work is still inside it.
mkdir -p "$pen/box/session-logs/date/20260101"
printf 'format session-log-v1\n' > "$pen/box/session-logs/date/20260101/20260101-080808_the-work.kyri"
( cd "$pen/box" && g add -A && g commit -qm "land the record, not the work" )
out=$(box)
ck "the record gate closes"                    "unlanded=0" "$out"
ck "and the verdict reads ok"                  "verdict=ok" "$out"
ck "over a box that still holds the work"      "orphans=1"  "$out"

# And the orphan lifts the same way a record does: land the FILE, leave the stash exactly where it
# stands, and the reading falls. It moves to `unread` rather than vanishing, since the path now
# exists and its stashed edit is no longer readable here -- which is the partition, held.
( cd "$pen/box" && echo lost > tools/lost.sh && g add -A && g commit -qm "land the work" )
out=$(box)
ck "a landed file is no longer an orphan"      "orphans=0"  "$out"
ck "it counts as unread instead"               "unread=2"   "$out"
ck "and paths is still their sum"              "paths=2"    "$out"
ck "with the stash still standing"             "fleet-round-open" "$( g -C "$pen/box" stash list )"

# A hand's own stash is not the fleet's box, and that exclusion has to reach paths as well as
# records -- legs 13-14 proved it for the record alone, which would have let every file through.
echo mine > "$pen/box/tools/mine.sh"
( cd "$pen/box" && g stash push -u -m "wip: my own thing" >/dev/null 2>&1 )
nk "a hand's own stash adds no path" "tools/mine.sh" "$(box all)"

# NINETEEN ORPHANS ARE THREE KINDS (REDS %592), and each kind is proven in its own repository so
# every count here is absolute. The field's reading was honest and unreadable -- one number for ten
# fold shelves, three copies of this guard's elder self, and six files of parked work -- and only
# the six were a lap. Built in a fresh pen because the box above deliberately ends holding an
# orphan and two unread paths, and a partition asserted on numbers a previous leg moved is a
# partition proving the pen.
g init -q -b main "$pen/kinds"
mkdir -p "$pen/kinds/tools/s" "$pen/kinds/tools/fixtures/s" "$pen/kinds/construction/archive"
( cd "$pen/kinds" && echo seed > seed.txt
  # The living path a moved orphan is answered BY. Its content differs from the stashed elder on
  # purpose: a blob probe finds nothing across a room move in this tree, which is why the basename
  # is what ships, and a pen where the bytes matched would prove the wrong instrument.
  echo "the living version" > tools/s/moved_guard.rish
  g add -A && g commit -qm seed )
kinds() { ( cd "$pen/kinds" && sh "$src" "$@" 2>&1 ); }

# One stash carrying all four shapes at once, because a real lap parks them mixed and the
# classification has to hold when it meets them that way.
mkdir -p "$pen/kinds/tools/fixtures/f" "$pen/kinds/construction/archive" "$pen/kinds/tools/fixtures/a"
echo "the elder version" > "$pen/kinds/tools/fixtures/f/moved_guard.rish"
printf '# rows\n'        > "$pen/kinds/construction/archive/REDS-a-pen-shelf-rows-1.md"
printf '# accounts\n'    > "$pen/kinds/construction/archive/20260101-010101_itinerary-landed-accounts.md"
printf '# a real pen\n'  > "$pen/kinds/tools/fixtures/a/parked_pen_control.sh"
( cd "$pen/kinds" && g stash push -u -m "fleet-round-open 20260101-090909: a lap's unsent work, stashed at the open" >/dev/null 2>&1 )
out=$(kinds); outall=$(kinds all)
ck "four orphans, mixed in one stash"        "orphans=4"       "$out"
ck "one answered by a moved file"            "orphans_moved=1" "$out"
ck "two fold shelves"                        "orphans_shelf=2" "$out"
ck "and one file of actual parked work"      "orphans_work=1"  "$out"
ck "the three kinds partition the count"     "orphan_kinds=partition" "$out"
ck "the moved one NAMES where it moved to"   "tools/fixtures/f/moved_guard.rish	orphan:moved:tools/s/moved_guard.rish" "$outall"
ck "a REDS shelf is a shelf"                 "REDS-a-pen-shelf-rows-1.md	orphan:shelf"        "$outall"
ck "an accounts shelf is a shelf too"        "20260101-010101_itinerary-landed-accounts.md	orphan:shelf" "$outall"
ck "a pen nothing carries is work"           "tools/fixtures/a/parked_pen_control.sh	orphan:work" "$outall"
nk "and work is never called a shelf"        "parked_pen_control.sh	orphan:shelf"         "$outall"
ck "list still names every orphan"           "moved_guard.rish"  "$(kinds list)"

# THE SHELF CLASS IS BOUND BY ITS ROOM, not by its name. A file named exactly like a fold shelf and
# living anywhere else is parked work, or the class would swallow any path a hand named that way.
printf '# not a shelf\n' > "$pen/kinds/tools/REDS-a-pen-shelf-rows-2.md"
( cd "$pen/kinds" && g stash push -u -m "fleet-round-open 20260101-091010: a lap's unsent work, stashed at the open" >/dev/null 2>&1 )
outall=$(kinds all)
ck "a shelf name outside the room is work"  "tools/REDS-a-pen-shelf-rows-2.md	orphan:work" "$outall"
nk "and never a shelf"                      "tools/REDS-a-pen-shelf-rows-2.md	orphan:shelf" "$outall"
ck "the partition still holds"              "orphan_kinds=partition" "$(kinds)"

# AN AMBIGUOUS BASENAME IS NOT A CLAIM. Two tracked files answering to one name make `moved` a
# guess, and a guess in a triage column is worse than the count it replaced -- so the orphan falls
# through and stays whatever it would otherwise be. Proven by ADDING a second living copy under the
# same name, so the only thing differing from the welcome above is the number of answers.
( cd "$pen/kinds" && mkdir -p tools/other && echo "a second living version" > tools/other/moved_guard.rish
  g add -A && g commit -qm "a second file answering to the same name" )
outall=$(kinds all)
nk "two answers make no moved claim" "moved_guard.rish	orphan:moved" "$outall"
ck "the orphan falls through to work" "tools/fixtures/f/moved_guard.rish	orphan:work" "$outall"
ck "and the moved count falls to zero" "orphans_moved=0" "$(kinds)"

# MOVED BEATS SHELF when a shelf's own basename is uniquely answered elsewhere, since naming the
# living path is strictly more useful than naming the class. Ordering is a decision rather than an
# accident, so it is asserted.
# `git stash push -u` carries an untracked directory away WITH its files, so the rooms a plant
# used are gone by the time the next leg writes into them -- caught here by a redirect failing on
# an absent `construction/`. Each plant makes its own room.
( cd "$pen/kinds" && mkdir -p construction && printf '# the landed shelf\n' > construction/REDS-a-pen-shelf-rows-1.md
  g add -A && g commit -qm "land the shelf under a path of its own" )
outall=$(kinds all)
ck "a shelf answered elsewhere reads moved" "construction/archive/REDS-a-pen-shelf-rows-1.md	orphan:moved:construction/REDS-a-pen-shelf-rows-1.md" "$outall"
nk "and stops being read as a shelf"        "construction/archive/REDS-a-pen-shelf-rows-1.md	orphan:shelf" "$outall"
ck "so the shelf count falls by one"        "orphans_shelf=1" "$(kinds)"

# AND THE KINDS LIFT THE WAY THE COUNT DOES -- one at a time, which is the whole point of the
# split. Land the parked pen and leave every stash standing: `orphans_work` falls by exactly one
# while `moved` and `shelf` hold still, and the landed path moves to `unread` rather than
# vanishing, since it exists now and its stashed edit is no longer readable by a path probe.
( cd "$pen/kinds" && mkdir -p tools/fixtures/a && printf '# a real pen\n' > tools/fixtures/a/parked_pen_control.sh
  g add -A && g commit -qm "land the work" )
out=$(kinds)
ck "landing one file moves one kind"     "orphans_work=2"  "$out"
ck "and the other two hold still"        "orphans_moved=1" "$out"
ck "-- both of them"                     "orphans_shelf=1" "$out"
ck "the landed path counts as unread"    "unread=1"        "$out"
ck "with the partition still holding"    "orphan_kinds=partition" "$out"
ck "and every stash still standing"      "fleet-round-open" "$( g -C "$pen/kinds" stash list )"

echo "pass=$pass fail=$fail"
[ "$fail" -eq 0 ] || exit 1
