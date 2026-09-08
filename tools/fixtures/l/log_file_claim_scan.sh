#!/bin/sh
# tools/fixtures/l/log_file_claim_scan.sh -- a session log's `file` field is a claim, and nothing
# was reading it.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
#   values key=value - detail: prefixed - verdict= its own key - status agrees.
#
# WHAT THIS IS FOR. Every session log closes with `file <path> <why>` lines naming what the lap
# touched. That path is a promise of exactly the kind `.claude/rules/collaboration.md` seats --
# references are promises -- and it is written at the end of a lap, from a stamp the lap already
# holds, which is the moment a path is most likely to be composed rather than read.
#
# WHAT IT COSTS WHEN IT IS MISSED, measured `20260907.221500` by this scan over 4,352 tracked
# session logs. **16,924 path-shaped `file` fields stand, and 228 name a basename that exists
# nowhere in the tree at all** -- a claim about a file that was never written. A path whose room
# merely folded keeps its basename and is not counted, since `tools/d/dated_path_resolve.rish`
# answers it by computation; that larger population is `dated_path`'s to report, and it read 9,800
# recoverable against 94 lost the same day.
#
# The recent slice is the part that moves: **32 of the 228 were written today**, and 27 of today's
# logs and 26 of yesterday's carry at least one, against 3 a day the week before. The fleet went to
# eight ships, and the live front began folding to
# `construction/archive/<stamp>_itinerary-landed-accounts.md` on `20260905.130819`.
#
# A HAND COUNT OF THE SAME QUESTION READ 349, and the difference is the path shape rather than a
# disagreement about the tree: the hand took every `file` value, including those wearing no
# extension this tree writes. The scan's number is the smaller one on purpose, for the same reason
# the hook reads only tree-shaped paths -- the fault closed here is a fabricated citation, and a
# reading that also catches typos in prose cannot be gated at zero.
#
# THE SHAPE, READ FROM TWELVE OF THEM. A lap folds its live-front block to a shelf, then writes
# `file construction/archive/<its own log's stamp>_itinerary-landed-accounts.md`. The shelf carries
# a different stamp, because it was written at a different second. Checked against every commit on
# every branch, not one of those twelve paths has ever existed. The lap composed the path from the
# stamp in its hand instead of reading the name off disk.
#
# WHY IT IS PERMANENT. A session log's basename carries a one-clock stamp, so the mark law calls it
# testimony and accrete-never-break forbids repairing it. The wrong citation stands forever, and
# the only guard that sees it is `dated_path`, which counts it into `refs_lost` -- a ceiling mixing
# a class a lap must repair with a class no lap may touch, on `tier cadence`, which REDS %568 found
# nothing turns. Measured today: `dated_path` red at `refs_lost=94` against a ceiling of 85, and
# every one of its three `lost_living` references sits in a file this tree's own laws forbid
# editing -- vendored `gratitude/reaper/`, an immutable `waymarks/date/README-index-` shelf, and a
# REDS fold archive. So the guard that surfaces this is a wall no lawful lap can climb.
#
# THE WALL ALREADY EXISTS AND FACES THE OTHER WAY. `tools/hooks/commit-msg` refuses a commit body
# citing a path that is not in the tree (REDS %202) -- the same claim, checked at write time. The
# session log rides in that same commit and goes unread. This scan reads the artifact the hook
# does not, and it borrows the hook's own path shape rather than inventing a second one.
#
#   sh tools/fixtures/l/log_file_claim_scan.sh          # measure and gate
#   sh tools/fixtures/l/log_file_claim_scan.sh --staged # the staged reading alone
#   sh tools/fixtures/l/log_file_claim_scan.sh --list    # every unwritten claim, one per line
#
# WHAT IS GATED, AND WHY IT IS THIS ONE. `staged_unwritten`, at **zero**. The staged reading is the
# `file` fields of the session logs THIS commit stages, judged against the working tree and the
# index together -- so a shelf staged in the same commit as the log that names it passes free,
# which is the ordinary case. It is the lap's own claim about its own work, so it can never refuse
# for a stranger's break.
#
# WHY THE STANDING COUNT IS REPORTED RATHER THAN GATED. The population grows by roughly 26 a day
# across eight ships, and every entry is testimony no lap may repair. A ceiling over it would red
# tomorrow, on every ship, for a peer's honest record -- REDS %585's fault exactly, over a
# population that cannot even be swept. So `unwritten_total` and `unwritten_today` are the
# diagnosis and the gate is the one number a lap can act on.
#
# WHAT IT DOES NOT REACH, named rather than implied.
#   - Whether the `why` clause beside a path is true. This reads existence, and stops.
#   - A path that exists and is the WRONG file. A stamp off by one second that happens to name
#     another lap's shelf resolves, and reads as kept.
#   - A `file` value that is not path-shaped -- no slash, or an extension this tree does not
#     write. Read past, on the hook's own rule, because the fault closed here is a fabricated
#     citation rather than a typo anywhere.
#   - Logs that are not staged. A lap may only answer for the artifact it is writing.
set -eu

# A meter that sorts and a meter that compares must agree about the alphabet (REDS %532).
export LC_ALL=C
tab=$(printf '\t')

_fd_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$_fd_root/rishi/bin" ] || [ ! -d "$_fd_root/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$_fd_root" = "/" ] || [ -z "$_fd_root" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  _fd_root=$(dirname "$_fd_root")
done
cd "$_fd_root"

mode=all
case "${1:-}" in
  --staged) mode=staged ;;
  --list)   mode=list ;;
  "")       ;;
  *) echo "refused: unknown argument -- $1" >&2; exit 2 ;;
esac

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

# THE PATH SHAPE IS THE HOOK'S, single-homed by citation rather than by copy of a reason. A slash
# and an extension this tree writes; everything else is read past.
path_shape='^[A-Za-z0-9._-]+/[A-Za-z0-9._/-]+\.(md|mdc|kyri|bron|rish|rye|brix|sh|json|txt)$'

# Pull the path token out of every `file` field. The value is the text after the first space, so
# the path is its first whitespace-delimited word; trailing prose punctuation is stripped, since a
# sentence may end on the path itself.
claims_of() {
  sed -n 's/^file[[:space:]][[:space:]]*\([^[:space:]][^[:space:]]*\).*/\1/p' "$1" 2>/dev/null \
    | sed 's/[.,;:]*$//' \
    | grep -E "$path_shape" || true
}

# THE INDEX IS READ BESIDE THE WORKING TREE, and it is what makes the gate usable. A lap stages its
# shelf and the log naming it in one commit; the shelf is on disk, so `-e` answers. A lap that
# stages a DELETION of a file its log still names is the case the index catches on its own.
git ls-files > "$work/tracked.txt" 2>/dev/null || : > "$work/tracked.txt"
sed 's|.*/||' "$work/tracked.txt" | sort -u > "$work/basenames.txt"

exists() {
  [ -e "$1" ] && return 0
  grep -qxF -- "$1" "$work/tracked.txt" && return 0
  return 1
}

# -- the staged reading: this commit's own logs -------------------------------------------------
git diff --cached --name-only --diff-filter=ACMR 2>/dev/null \
  | grep -E '^session-logs/.*\.(kyri|bron)$' > "$work/staged_logs.txt" || : > "$work/staged_logs.txt"
staged_logs=$(wc -l < "$work/staged_logs.txt" | tr -d ' ')

: > "$work/staged_bad.txt"
while IFS= read -r f; do
  [ -n "$f" ] || continue
  [ -f "$f" ] || continue
  claims_of "$f" | while IFS= read -r p; do
    [ -n "$p" ] || continue
    exists "$p" || printf '%s\t%s\n' "$f" "$p" >> "$work/staged_bad.txt"
  done
done < "$work/staged_logs.txt"
staged_unwritten=$(wc -l < "$work/staged_bad.txt" | tr -d ' ')

if [ "$mode" = staged ]; then
  echo "staged_logs=$staged_logs"
  echo "staged_unwritten=$staged_unwritten"
  while IFS="$(printf '\t')" read -r f p; do
    [ -n "${f:-}" ] || continue
    echo "detail: $f claims a file nobody wrote -> $p"
  done < "$work/staged_bad.txt"
  if [ "$staged_unwritten" -ne 0 ]; then
    echo "verdict=staged_claim_unwritten"
    echo "refused: a staged session log names a path that is in neither the tree nor the index -- read the name off disk rather than composing it from the lap's own stamp" >&2
    exit 1
  fi
  echo "verdict=ok"
  exit 0
fi

# -- the standing reading: every tracked log, reported ------------------------------------------
: > "$work/all_bad.txt"
grep -E '^session-logs/.*\.(kyri|bron)$' "$work/tracked.txt" > "$work/logs.txt" || : > "$work/logs.txt"
logs=$(wc -l < "$work/logs.txt" | tr -d ' ')

# ONE PASS OVER THE ROOM, not one process per log. Read file by file this cost 55s on this pier,
# and eight ships run a lap guard twice a lap, so the shape of the loop is the whole tier question.
# `xargs` batches the whole room into a handful of `sed` invocations.
: > "$work/fields.txt"
xargs -r sed -n 's/^file[[:space:]][[:space:]]*\([^[:space:]][^[:space:]]*\).*/\1/p' \
  < "$work/logs.txt" 2>/dev/null \
  | sed 's/[.,;:]*$//' \
  | grep -E "$path_shape" > "$work/fields.txt" || true
fields=$(wc -l < "$work/fields.txt" | tr -d ' ')

# UNWRITTEN means the basename exists NOWHERE, which is the class the resolver cannot recover. A
# path whose room merely folded keeps its basename, so `tools/d/dated_path_resolve.rish` answers it
# by computation and it is not counted here -- that population is `dated_path`'s to report.
# A JOIN RATHER THAN A GREP PER PATH. `sort` and `join` must agree about the alphabet or the two
# sides drift apart silently -- the collation fault REDS %532 booked when `find | sort` ran under
# one locale and `comm` under another -- so both are pinned to C above.
sort -u "$work/fields.txt" > "$work/fields_u.txt"
awk -F/ '{print $NF"\t"$0}' "$work/fields_u.txt" | sort -t"$tab" -k1,1 > "$work/by_base.txt"
join -t"$tab" -v1 -1 1 -2 1 "$work/by_base.txt" "$work/basenames.txt" 2>/dev/null \
  | cut -f2 > "$work/unwritten.txt" || : > "$work/unwritten.txt"
unwritten=$(wc -l < "$work/unwritten.txt" | tr -d ' ')

# Today's slice, by the one clock, so the growth is visible on the lap it happens rather than a
# week later. A day with no logs yet reads zero and says so.
today=$(TZ=America/New_York date +%Y%m%d)
today_hits=0
if [ -s "$work/unwritten.txt" ] && [ -d "session-logs/date/$today" ]; then
  today_hits=$(find "session-logs/date/$today" -type f -print0 2>/dev/null \
    | xargs -0 -r sed -n 's/^file[[:space:]][[:space:]]*\([^[:space:]][^[:space:]]*\).*/\1/p' 2>/dev/null \
    | sed 's/[.,;:]*$//' \
    | grep -cxFf "$work/unwritten.txt" 2>/dev/null || true)
  today_hits=${today_hits:-0}
fi

if [ "$mode" = list ]; then
  echo "-- file fields naming a basename that exists nowhere --"
  cat "$work/unwritten.txt"
  echo "-- end --"
fi

echo "logs=$logs"
echo "file_fields=$fields"
echo "unwritten_total=$unwritten"
echo "unwritten_today=$today_hits"
echo "staged_logs=$staged_logs"
echo "staged_unwritten=$staged_unwritten"

while IFS="$(printf '\t')" read -r f p; do
  [ -n "${f:-}" ] || continue
  echo "detail: $f claims a file nobody wrote -> $p"
done < "$work/staged_bad.txt"

if [ "$staged_unwritten" -ne 0 ]; then
  echo "verdict=staged_claim_unwritten"
  echo "refused: a staged session log names a path that is in neither the tree nor the index -- read the name off disk rather than composing it from the lap's own stamp" >&2
  exit 1
fi

echo "verdict=ok"
exit 0
