#!/bin/sh
# tools/d/dayshelf_merge.sh -- merge two day-shelf indexes by reseating their rows in stamp order.
#
# WHY THIS DRIVER. A day-shelf index takes one PREPENDED row from every seat, so any two clones
# that both landed a lap edit the same line. `.gitattributes` answered that with git's built-in
# `merge=union`, which keeps both sides' lines and concatenates them in hunk order -- and hunk
# order is not stamp order. Every rebase therefore auto-merges the shelf into whatever sequence
# the replay produced, and the newest-first ordering the shelf promises has to be restored by
# hand. REDS %440 fired eleven times across four laps that way, then three more times in one lap,
# and a peer shipped the same hand repair in the same hour. The disorder is not a habit anyone can
# drop: it regenerates on every pull, for every ship.
#
# WHAT IT DOES. Git calls this with %O (base) %A (ours) %B (theirs) %P (path). The driver splits
# each side at the table's delimiter row, unions the row lines, lifts a row that stands twice byte
# for byte, sorts the survivors descending by stamp, and writes header plus reseated rows back to
# %A. That is a permutation of the deduplicated union -- the same lines, a different order -- which
# is the same property `tools/fixtures/i/index_shelf_repair.sh` proves about its own output.
#
# WHAT IT REFUSES RATHER THAN GUESSES, each falling back to `git merge-file` so the shape lands as
# an ordinary conflict a hand resolves:
#   Two DIFFERENT rows wearing one stamp. Choosing which text is true is a judgment about the
#     record, and the repair tool one room over refuses the same case for the same reason.
#   A side with no delimiter row -- nothing below it is a table.
#   A row whose stamp does not read `YYYYMMDD.HHMMSS`. The sort is exact only while the stamp is
#     fixed-width and first; a row shaped otherwise would sort by its title.
#   More rows than `max_rows`, or two headers that differ.
# A driver that is clever about input it does not recognize is a driver that loses somebody's work.
#
# WHAT IT DOES NOT DO. It never consults the base for deletions, so a row deleted on one side and
# kept on the other comes back -- exactly what `merge=union` already did, carried forward
# deliberately rather than fixed here. Removing a shelf row is a hand's deliberate act (%381), and
# a merge is the wrong place to perform one.
#
# ARMED, NEVER ASSUMED. `.gitattributes` names `merge=dayshelf`; the driver command itself lives
# in this clone's git config, which no clone inherits. `tools/i/install_hooks.rish` arms it, the
# same way it arms `core.hooksPath`. On a clone that never ran that command git falls back to the
# ordinary text merge, so the shelf conflicts visibly rather than merging wrong --
# `tools/d/dayshelf_merge_witness.rish` reads the config back and reds when it is unarmed.
#
# USAGE (git calls this; a hand runs it only through the control)
#   sh tools/d/dayshelf_merge.sh <base> <ours> <theirs> <path>
#
# Purely local: no key, no signature, no network, no funds, no device.

set -u

base=${1:-}; ours=${2:-}; theirs=${3:-}; path=${4:-shelf}

[ -f "$ours" ] && [ -f "$theirs" ] || exit 2
# Git hands an empty path for %O when a file was added on both sides; `git merge-file` still needs
# three readable files, so an absent base reads as empty rather than as a reason to fail.
[ -f "$base" ] || base=/dev/null

# Bound: a day shelf holds one row per lap, and the busiest day this tree has recorded ran 134.
# Four thousand is far above any real day and far below anything that would strain a sort.
max_rows=4096

fallback() {
  # The honest refusal: hand the three files to git's own three-way merge and carry its verdict.
  # A conflict a hand resolves costs one edit; a wrong silent merge costs somebody's row.
  echo "dayshelf: $path -- $1; falling back to the ordinary text merge" >&2
  git merge-file -L ours -L base -L theirs "$ours" "$base" "$theirs"
  exit $?
}

split_head() { sed -n '1,/^|---/p' "$1"; }
split_rows() { sed -n '/^|---/,$p' "$1" | sed '1d'; }

head_a=$(split_head "$ours")
head_b=$(split_head "$theirs")

printf '%s\n' "$head_a" | grep -q '^|---' || fallback "ours carries no table delimiter"
printf '%s\n' "$head_b" | grep -q '^|---' || fallback "theirs carries no table delimiter"
[ "$head_a" = "$head_b" ] || fallback "the two headers disagree"

rows=$( { split_rows "$ours"; split_rows "$theirs"; } | grep -v '^[[:space:]]*$' )

if [ -n "$rows" ]; then
  count=$(printf '%s\n' "$rows" | wc -l | tr -d ' ')
  [ "$count" -le "$max_rows" ] || fallback "$count rows is past the $max_rows bound"

  # Every row must read as one self-contained line keyed by its own stamp. A row that does not is
  # the case this driver has no answer for, so it says so rather than sorting it somewhere.
  bad=$(printf '%s\n' "$rows" | grep -cv '^| `[0-9]\{8\}\.[0-9]\{6\}` |' || true)
  [ "$bad" = "0" ] || fallback "$bad row(s) carry no readable stamp"

  # Two different rows under one stamp is the case with no safe answer here, so it is counted
  # before anything is written and hands the file back to git whole.
  divergent=$(printf '%s\n' "$rows" | LC_ALL=C sort -u \
    | awk '{ print substr($0, 4, 15) }' | LC_ALL=C sort | uniq -d | wc -l | tr -d ' ')
  [ "$divergent" = "0" ] || fallback "$divergent stamp(s) carry two different rows"

  reseated=$(printf '%s\n' "$rows" \
    | awk '{ if (!($0 in seen)) { seen[$0] = 1; print substr($0, 4, 15) "\t" $0 } }' \
    | LC_ALL=C sort -r -k1,1 \
    | cut -f2-)
else
  reseated=""
fi

tmp=$ours.dayshelf.$$
printf '%s\n' "$head_a" > "$tmp"
[ -n "$reseated" ] && printf '%s\n' "$reseated" >> "$tmp"
cat "$tmp" > "$ours"
rm -f "$tmp"

exit 0
