#!/bin/sh
# tools/fixtures/d/dayshelf_merge_control.sh -- prove the day-shelf merge driver by doing, on real
# repositories with real rebases.
#
# WHY. A merge driver that cannot be watched merging is a claim. This control builds git
# repositories in a temporary pen, arms the driver exactly the way tools/i/install_hooks.rish arms
# it, plants one condition in each, drives a real `git rebase` or `git merge`, and reads the shelf
# that comes out. Nothing here touches the tree it is run from.
#
# USAGE
#   sh tools/fixtures/d/dayshelf_merge_control.sh
#
# Driven by tools/d/dayshelf_merge_witness.rish. Run from the repository root.

set -u

driver=$(pwd)/tools/d/dayshelf_merge.sh
[ -f "$driver" ] || { echo "control_verdict=driver_missing" >&2; exit 1; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM

shelf=session-logs/date/README-index-20260908.md
head_lines='# session-logs day index -- 20260908

Rows for `20260908`, newest first.

| Stamp | Log | What it recorded |
|---|---|---|'

row() { printf '| `%s` | [%s](20260908/%s_%s.kyri) | %s |\n' "$1" "$2" "$(echo "$1" | tr . -)" "$2" "$3"; }

# A repository carrying the shelf with one row, the driver armed, and `main` at that state.
build() {
  d=$pen/$1
  mkdir -p "$d"
  ( cd "$d" \
    && git init -q -b main . \
    && git config user.email pen@example.invalid \
    && git config user.name Pen \
    && git config merge.dayshelf.name 'day-shelf index, reseated in stamp order' \
    && mkdir -p tools/d \
    && cp "$driver" tools/d/dayshelf_merge.sh \
    && git config merge.dayshelf.driver 'sh tools/d/dayshelf_merge.sh %O %A %B %P' \
    && mkdir -p session-logs/date \
    && printf '%s merge=dayshelf\n' 'session-logs/date/README-index-*.md' > .gitattributes \
    && { printf '%s\n' "$head_lines"; row 20260908.010000 base 'the shared row'; } > "$shelf" \
    && git add -A \
    && git commit -qm 'pen: the shelf with one row' ) >/dev/null 2>&1
  echo "$d"
}

# Prepend a row the way every seat writes one: newest first, straight under the delimiter.
prepend() {
  d=$1; stamp=$2; name=$3
  ( cd "$d" \
    && awk -v r="$(row "$stamp" "$name" "a lap")" \
         '{ print } /^\|---/ && !done { print r; done = 1 }' "$shelf" > "$shelf.t" \
    && cat "$shelf.t" > "$shelf" && rm -f "$shelf.t" \
    && git add -A && git commit -qm "pen: $name" ) >/dev/null 2>&1
}

stamps_of() { sed -n 's/^| `\([0-9.]*\)`.*/\1/p' "$1/$shelf"; }
in_order() {
  s=$(stamps_of "$1")
  [ "$s" = "$(printf '%s\n' "$s" | LC_ALL=C sort -r)" ] && echo yes || echo no
}

# The shape the fault takes: two seats each prepend a row, and one rebases onto the other.
diverge_and_rebase() {
  d=$(build "$1")
  ( cd "$d" && git checkout -q -b peer && : ) >/dev/null 2>&1
  prepend "$d" "$2" theirs
  ( cd "$d" && git checkout -q main ) >/dev/null 2>&1
  prepend "$d" "$3" ours
  ( cd "$d" && git rebase -q peer ) >/dev/null 2>&1
  echo "$d"
}

# 1. Ours newer than theirs -- the ordinary case, and the one union already got right by luck.
d=$(diverge_and_rebase newer 20260908.020000 20260908.030000)
[ "$(stamps_of "$d" | wc -l | tr -d ' ')" = "3" ] && echo "newer_kept_both=yes" || echo "newer_kept_both=no"
[ "$(in_order "$d")" = yes ] && echo "newer_in_order=yes" || echo "newer_in_order=no"

# 2. Ours OLDER than theirs -- the case that comes back misordered under union, every time.
d=$(diverge_and_rebase older 20260908.030000 20260908.020000)
[ "$(stamps_of "$d" | wc -l | tr -d ' ')" = "3" ] && echo "older_kept_both=yes" || echo "older_kept_both=no"
[ "$(in_order "$d")" = yes ] && echo "older_in_order=yes" || echo "older_in_order=no"
[ "$(stamps_of "$d" | head -1)" = "20260908.030000" ] && echo "older_newest_first=yes" || echo "older_newest_first=no"

# 3. The SAME row prepended by both sides -- the shape a cherry-pick and a rebase both produce.
#    Lifted to one, since a stamp stands once on a shelf (%381).
d=$(build identical)
( cd "$d" && git checkout -q -b peer ) >/dev/null 2>&1
prepend "$d" 20260908.020000 same
( cd "$d" && git checkout -q main ) >/dev/null 2>&1
prepend "$d" 20260908.020000 same
( cd "$d" && git rebase -q peer ) >/dev/null 2>&1
[ "$(stamps_of "$d" | wc -l | tr -d ' ')" = "2" ] && echo "identical_row_lifted=yes" || echo "identical_row_lifted=no"
[ "$(grep -c 'same' "$d/$shelf")" = "1" ] && echo "identical_row_once=yes" || echo "identical_row_once=no"

# 3b. Two DIFFERENT rows wearing one stamp -- refused, because choosing which text is true is a
#     judgment about the record. tools/fixtures/i/index_shelf_repair.sh refuses the same case, and
#     two tools disagreeing about one shape is how a shelf gets quietly rewritten.
d=$(diverge_and_rebase samestamp 20260908.020000 20260908.020000)
grep -q '<<<<<<<' "$d/$shelf" && echo "divergent_stamp_conflicts=yes" || echo "divergent_stamp_conflicts=no"
grep -q 'theirs' "$d/$shelf" && echo "divergent_kept_theirs=yes" || echo "divergent_kept_theirs=no"
grep -q 'ours' "$d/$shelf" && echo "divergent_kept_ours=yes" || echo "divergent_kept_ours=no"
( cd "$d" && git rebase -q --abort ) >/dev/null 2>&1

# 4. The header survives the merge unchanged, delimiter and all.
d=$(diverge_and_rebase header 20260908.020000 20260908.030000)
grep -q '^# session-logs day index -- 20260908$' "$d/$shelf" && echo "header_kept=yes" || echo "header_kept=no"
[ "$(grep -c '^|---' "$d/$shelf")" = "1" ] && echo "delimiter_once=yes" || echo "delimiter_once=no"
[ "$(grep -c '^| Stamp' "$d/$shelf")" = "1" ] && echo "table_head_once=yes" || echo "table_head_once=no"

# 5. A rebase with three peer rows and two of ours, interleaved by stamp -- the real shape.
d=$(build interleaved)
( cd "$d" && git checkout -q -b peer ) >/dev/null 2>&1
prepend "$d" 20260908.020000 p1; prepend "$d" 20260908.040000 p2; prepend "$d" 20260908.060000 p3
( cd "$d" && git checkout -q main ) >/dev/null 2>&1
prepend "$d" 20260908.030000 o1; prepend "$d" 20260908.050000 o2
( cd "$d" && git rebase -q peer ) >/dev/null 2>&1
[ "$(stamps_of "$d" | wc -l | tr -d ' ')" = "6" ] && echo "interleaved_kept_all=yes" || echo "interleaved_kept_all=no"
[ "$(in_order "$d")" = yes ] && echo "interleaved_in_order=yes" || echo "interleaved_in_order=no"

# 6. A row carrying no readable stamp -- refused, and left as an ordinary conflict.
d=$(build unreadable)
( cd "$d" && git checkout -q -b peer ) >/dev/null 2>&1
prepend "$d" 20260908.020000 theirs
( cd "$d" && git checkout -q main \
  && awk '{ print } /^\|---/ && !done { print "| not-a-stamp | x | y |"; done = 1 }' "$shelf" > "$shelf.t" \
  && cat "$shelf.t" > "$shelf" && rm -f "$shelf.t" \
  && git add -A && git commit -qm 'pen: an unreadable row' ) >/dev/null 2>&1
( cd "$d" && git rebase -q peer ) >/dev/null 2>&1
grep -q '<<<<<<<' "$d/$shelf" && echo "unreadable_conflicts=yes" || echo "unreadable_conflicts=no"
grep -q 'not-a-stamp' "$d/$shelf" && echo "unreadable_row_kept=yes" || echo "unreadable_row_kept=no"
( cd "$d" && git rebase -q --abort ) >/dev/null 2>&1

# 7. Two headers that disagree -- refused, so a real prose edit is never dropped.
d=$(build headers)
( cd "$d" && git checkout -q -b peer \
  && sed 's/^Rows for/Rows, newest first, for/' "$shelf" > "$shelf.t" \
  && cat "$shelf.t" > "$shelf" && rm -f "$shelf.t" \
  && git add -A && git commit -qm 'pen: their header' ) >/dev/null 2>&1
( cd "$d" && git checkout -q main \
  && sed 's/^Rows for/Rows for the day of/' "$shelf" > "$shelf.t" \
  && cat "$shelf.t" > "$shelf" && rm -f "$shelf.t" \
  && git add -A && git commit -qm 'pen: our header' ) >/dev/null 2>&1
( cd "$d" && git rebase -q peer ) >/dev/null 2>&1
grep -q '<<<<<<<' "$d/$shelf" && echo "header_clash_conflicts=yes" || echo "header_clash_conflicts=no"
( cd "$d" && git rebase -q --abort ) >/dev/null 2>&1

# 8. An UNARMED clone -- `.gitattributes` names the driver and git config carries neither key.
#    Git falls back to its own text merge, so the shelf conflicts visibly rather than merging
#    wrong. This is the state every fresh clone is in before it runs install_hooks.
d=$(build unarmed)
( cd "$d" && git config --unset merge.dayshelf.driver && git config --unset merge.dayshelf.name ) >/dev/null 2>&1
( cd "$d" && git checkout -q -b peer ) >/dev/null 2>&1
prepend "$d" 20260908.020000 theirs
( cd "$d" && git checkout -q main ) >/dev/null 2>&1
prepend "$d" 20260908.030000 ours
( cd "$d" && git rebase -q peer ) >/dev/null 2>&1
grep -q '<<<<<<<' "$d/$shelf" && echo "unarmed_conflicts=yes" || echo "unarmed_conflicts=no"
( cd "$d" && git rebase -q --abort ) >/dev/null 2>&1

# 8b. A HALF-armed clone -- the name set and the command line missing. Git refuses the rebase
#     outright with `lacks command line` rather than merging by some other rule. Loud either way:
#     the two ways a clone can be unready both stop, and neither reorders a shelf in silence.
d=$(build halfarmed)
( cd "$d" && git config --unset merge.dayshelf.driver ) >/dev/null 2>&1
( cd "$d" && git checkout -q -b peer ) >/dev/null 2>&1
prepend "$d" 20260908.020000 theirs
( cd "$d" && git checkout -q main ) >/dev/null 2>&1
prepend "$d" 20260908.030000 ours
out=$( cd "$d" && git rebase peer 2>&1 )
echo "$out" | grep -q 'lacks command line' && echo "half_armed_fatal=yes" || echo "half_armed_fatal=no"
[ "$(stamps_of "$d" | wc -l | tr -d ' ')" = "2" ] && echo "half_armed_no_merge=yes" || echo "half_armed_no_merge=no"
( cd "$d" && git rebase -q --abort ) >/dev/null 2>&1

# 9. The union driver on the same divergence, for comparison -- this is the fault, reproduced.
d=$(build union)
( cd "$d" && printf '%s merge=union\n' 'session-logs/date/README-index-*.md' > .gitattributes \
  && git add -A && git commit -qm 'pen: union instead' ) >/dev/null 2>&1
( cd "$d" && git checkout -q -b peer ) >/dev/null 2>&1
prepend "$d" 20260908.020000 theirs
( cd "$d" && git checkout -q main ) >/dev/null 2>&1
prepend "$d" 20260908.030000 ours
( cd "$d" && git rebase -q peer ) >/dev/null 2>&1
[ "$(in_order "$d")" = no ] && echo "union_misorders=yes" || echo "union_misorders=no"
[ "$(stamps_of "$d" | head -1)" = "20260908.020000" ] && echo "union_puts_older_first=yes" || echo "union_puts_older_first=no"

# 10. A merge rather than a rebase reaches the same driver.
d=$(build merged)
( cd "$d" && git checkout -q -b peer ) >/dev/null 2>&1
prepend "$d" 20260908.030000 theirs
( cd "$d" && git checkout -q main ) >/dev/null 2>&1
prepend "$d" 20260908.020000 ours
( cd "$d" && git merge -q --no-edit peer ) >/dev/null 2>&1
[ "$(in_order "$d")" = yes ] && echo "merge_in_order=yes" || echo "merge_in_order=no"
[ "$(stamps_of "$d" | wc -l | tr -d ' ')" = "3" ] && echo "merge_kept_both=yes" || echo "merge_kept_both=no"

echo "control_verdict=ok"
