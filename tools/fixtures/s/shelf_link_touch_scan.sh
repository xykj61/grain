#!/bin/sh
# tools/fixtures/s/shelf_link_touch_scan.sh -- a round that writes a day-shelf row proves the row opens.
#
# WHAT THIS IS FOR. A session log is born on its day's shelf -- session-logs/date/YYYYMMDD/ -- and
# its row is prepended to session-logs/date/README-index-YYYYMMDD.md, which sits one directory
# ABOVE the log. So a row written `](YYYYMMDD-HHMMSS_sprig.kyri)` resolves to
# session-logs/date/YYYYMMDD-HHMMSS_sprig.kyri, which is nowhere. The right spelling carries the
# day room: `](YYYYMMDD/YYYYMMDD-HHMMSS_sprig.kyri)`. The illustration is built from PLACEHOLDERS
# rather than from a real-looking stamp, because a stamp-shaped example reads as a real citation to
# every reader and to the dated-path census (stamp-and-name: illustrate with placeholders, cite
# only what exists). Five rooms fold this way -- session-logs,
# counsel, active-designing, expanding-prompts, waymarks -- and every one of them has the same
# one-directory offset between a shelf and the files it lists.
#
# WHY IT READS AT COMMIT TIME. The reading already existed and it was too slow to teach the habit.
# `readme_reach` gates broken links inside living files at zero, and `reds_fold` runs the same scan
# as its third duty, so one bad row reds two rostered guards -- 45 minutes after it was written, by
# which time the next hand has written its own. On 20260830 FOURTEEN rows of this shape stood on
# one shelf from four hands in one evening, and eleven of the same shape had been repaired by hand
# the lap before (REDS %383). The repair rate matched the writing rate exactly, which is the
# definition of a lantern rather than a loom. This is the loom: the same question, asked at the
# moment the row can still be fixed for free.
#
# TWO READINGS, AND WHY NEITHER ANSWERS FOR THE OTHER. `readme_reach` is whole and slow: it crawls
# from README.md, reaches every document a newcomer can walk to, and gates every broken link in a
# living file. This is partial and instant: it reads only the shelves THIS COMMIT stages, off the
# index. The two cannot disagree about the gated class, and that agreement is proven rather than
# asserted -- tools/fixtures/s/shelf_link_touch_control.sh plants the fault in a pen, drives BOTH
# scans over it, and requires both to refuse and then both to pass once it is repaired.
#
# WHAT IS GATED, hard, at zero: a link in a staged shelf whose target is a BARE BASENAME carrying a
# one-clock stamp and which the commit does not carry. That class has exactly one right answer --
# the shelf's own day room -- so a wall may refuse it without guessing, and this scan names the
# repair when the basename stands there. Measured over all 95 shelves on 20260830: ZERO.
#
# WHAT IS REPORTED AND NEVER GATED: every other broken relative link in a staged shelf. Forty-one
# stand today, all of them `../yonder/<stamped>.md` rows in fourteen CLOSED active-designing
# shelves, and a stale dated reference is RESOLVED rather than rewritten by seated law
# (tools/d/dated_path_resolve.rish). Gating them would refuse an unrelated commit for touching an
# immutable shelf, and a wall that reds on ordinary work is a wall somebody turns off.
#
#   sh tools/fixtures/s/shelf_link_touch_scan.sh              # what this commit ships
#   sh tools/fixtures/s/shelf_link_touch_scan.sh head         # what HEAD shipped
#   sh tools/fixtures/s/shelf_link_touch_scan.sh worktree     # every shelf, off disk
#   sh tools/fixtures/s/shelf_link_touch_scan.sh prove-red    # the planted refusal
#
# WHAT IT READS, and why off the index rather than off disk. `git cat-file -p :<path>` is the row
# this commit will actually carry, and `git cat-file -e :<target>` asks whether the index holds the
# file it names -- which is the whole question, since a round that stages the row and forgets the
# log would read green off a worktree that still holds both.
#
# WHAT IS NOT PROVEN. That the row's words describe the log it links, that the log is worth
# reading, or that the row is in the right order. This proves the door opens.
#
# Gated by tools/s/shelf_link_touch_witness.rish; proven both ways by
# tools/fixtures/s/shelf_link_touch_control.sh on real git repositories in a throwaway pen.
set -u

MODE=staged
# A collection names its maximum (TAME). One hundred and twenty shelves stand today across five
# rooms; 1,024 is far above every shelf set this tree has held and far below a runaway read.
MAX_SHELVES=1024
# Bounded PER SHELF rather than across the run, because the promise is per shelf and a whole-tree
# read is the sum of many honest ones. The widest shelf standing on 20260830 is the pre-20260721
# roll-up at 777 links; 4,096 is the next power of two well above it.
MAX_LINKS_PER_SHELF=4096

while [ $# -gt 0 ]; do
  case "$1" in
    staged|head|worktree|prove-red) MODE=$1 ;;
    *) echo "detail=RED_unknown_argument"; echo "detail_argument=$1"; echo "verdict=misread"; exit 1 ;;
  esac
  shift
done

echo "mode=$MODE"

if [ "$MODE" = prove-red ]; then
  # The planted refusal: one row of the exact shape, so the RED path is exercised without waiting
  # for a real shelf to carry one. The shape is spelled here rather than the LAW -- the law is the
  # one-directory offset, and it lives in the scan body above this line.
  echo "shelf_broken=session-logs/date/README-index-20260830.md"
  echo "detail=RED_shelf_row_link_absent"
  echo "detail_shelf=session-logs/date/README-index-20260830.md"
  echo "detail_target=20260830-224714_the-fold-writes-its-own-trail.kyri"
  echo "detail_repair=20260830/20260830-224714_the-fold-writes-its-own-trail.kyri"
  echo "bare_stamped_absent=1"
  echo "verdict=misread"
  exit 1
fi

# The shelf set. In worktree mode every TRACKED shelf is read; otherwise only the ones this commit
# or HEAD names, since a wall weighs the round's own work.
#
# WHY `git ls-files` RATHER THAN `find`, in worktree mode. A find over the working tree reaches
# `seed/`, the gitignored projection of the public template, and reads 82 broken links belonging to
# a repository this tree deliberately does not walk (read scope: seed/ is a closed stack). The
# tracked set is the same store every other reading here measures, and it excludes the projection
# by construction rather than by an exclusion list somebody has to keep current.
SHELVES=""
case "$MODE" in
  staged)   SHELVES=$(git diff --cached --name-only 2>/dev/null || true) ;;
  head)     SHELVES=$(git diff-tree --no-commit-id --name-only -r HEAD 2>/dev/null || true) ;;
  worktree) SHELVES=$(git ls-files 2>/dev/null || true) ;;
esac

# A shelf is a day index inside a room's own date/ fold. The pattern is spelled once, here, and
# it reaches the roll-up shelves too -- session-logs/date/README-index-through-20260721.md holds
# 777 rows of exactly this shape, and a shelf that lists logs is a shelf whether its own name
# carries one day or many.
SHELVES=$(printf '%s\n' "$SHELVES" | grep -E '(^|/)date/README-index-[A-Za-z0-9-]+\.md$' || true)

# Lexical normalization -- a link resolves by TEXT rather than by the filesystem, because the whole
# reading is about a target that may not exist. `.` drops, `..` pops, and a pop past the root marks
# the path as escaping the tree, which readme_reach reads as broken by the same rule.
norm() {
  _n_out=""
  _n_escaped=no
  _n_old=$IFS
  # Save the caller's glob flag rather than forcing it off and on: word splitting on IFS also
  # expands pathnames, and a target holding a bracket or a star would otherwise become whatever
  # the working directory happens to hold.
  case "$-" in *f*) _n_glob=off ;; *) _n_glob=on ;; esac
  set -f
  IFS=/
  for _n_c in $1; do
    case "$_n_c" in
      ''|.) continue ;;
      ..)
        case "$_n_out" in
          '')  _n_escaped=yes ;;
          */*) _n_out=${_n_out%/*} ;;
          *)   _n_out="" ;;
        esac ;;
      *)
        if [ -z "$_n_out" ]; then _n_out=$_n_c; else _n_out="$_n_out/$_n_c"; fi ;;
    esac
  done
  IFS=$_n_old
  [ "$_n_glob" = off ] || set +f
  [ "$_n_escaped" = no ] || return 1
  printf '%s\n' "$_n_out"
}

# Does the commit this round makes actually carry that path? The store follows the mode, for the
# same reason the row's own bytes do.
carries() {
  case "$MODE" in
    staged)   git cat-file -e ":$1" 2>/dev/null ;;
    head)     git cat-file -e "HEAD:$1" 2>/dev/null ;;
    worktree) [ -e "$1" ] ;;
  esac
}

SHELF_COUNT=0
LINKS=0
BARE_ABSENT=0
OTHER_BROKEN=0
REPORT=""

for shelf in $SHELVES; do
  SHELF_COUNT=$((SHELF_COUNT + 1))
  if [ "$SHELF_COUNT" -gt "$MAX_SHELVES" ]; then
    echo "detail=RED_shelves_past_bound"
    echo "detail_max=$MAX_SHELVES"
    echo "verdict=misread"
    exit 1
  fi

  case "$MODE" in
    staged)   body=$(git cat-file -p ":$shelf" 2>/dev/null || true) ;;
    head)     body=$(git cat-file -p "HEAD:$shelf" 2>/dev/null || true) ;;
    worktree) body=$(cat "$shelf" 2>/dev/null || true) ;;
  esac

  # A shelf the round DELETED carries no rows to read. Absence is the fold's reading, not this one's.
  if [ -z "$body" ]; then
    REPORT="$REPORT
shelf_absent=$shelf"
    continue
  fi

  dir=$(dirname "$shelf")

  # Every markdown link target on the page. `grep -o` is POSIX and portable; `grep -P` is the GNU
  # spelling this tree gates (shell_dialect), so the pattern stays inside an ERE.
  targets=$(printf '%s\n' "$body" | grep -oE '\]\([^)[:space:]]+' | sed 's|^](||' || true)

  SHELF_LINKS=0
  for raw in $targets; do
    LINKS=$((LINKS + 1))
    SHELF_LINKS=$((SHELF_LINKS + 1))
    if [ "$SHELF_LINKS" -gt "$MAX_LINKS_PER_SHELF" ]; then
      echo "detail=RED_links_past_bound"
      echo "detail_shelf=$shelf"
      echo "detail_max=$MAX_LINKS_PER_SHELF"
      echo "verdict=misread"
      exit 1
    fi

    target=${raw%%#*}
    [ -n "$target" ] || continue
    case "$target" in
      http://*|https://*|mailto:*|/*) continue ;;
    esac

    if landed=$(norm "$dir/$target"); then
      carries "$landed" && continue
    fi

    # The gated class: a bare basename carrying a one-clock stamp. It can only ever have meant the
    # shelf's own day room, so the repair is a pure function and a wall may name it.
    case "$target" in
      */*) ;;
      *)
        if printf '%s' "$target" | grep -qE '^[0-9]{8}-[0-9]{6}[_.]'; then
          day=${target%%-*}
          repair="$day/$target"
          BARE_ABSENT=$((BARE_ABSENT + 1))
          REPORT="$REPORT
shelf_broken=$shelf
detail=RED_shelf_row_link_absent
detail_shelf=$shelf
detail_target=$target
detail_repair=$repair"
          if carries "$dir/$repair"; then
            REPORT="$REPORT
detail_repair_exists=yes"
          else
            REPORT="$REPORT
detail_repair_exists=no"
          fi
          continue
        fi ;;
    esac

    OTHER_BROKEN=$((OTHER_BROKEN + 1))
    REPORT="$REPORT
shelf_link_resolve=$shelf -> $target"
  done
done

printf '%s\n' "$REPORT" | sed '/^$/d'
echo "shelves_read=$SHELF_COUNT"
echo "links_read=$LINKS"
echo "bare_stamped_absent=$BARE_ABSENT"
echo "other_broken_reported=$OTHER_BROKEN"

if [ "$BARE_ABSENT" -gt 0 ]; then
  echo "verdict=misread"
  exit 1
fi

echo "story=the_row_opens_the_log_it_names"
echo "verdict=ok"
