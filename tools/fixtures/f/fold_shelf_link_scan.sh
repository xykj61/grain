#!/bin/sh
# tools/fixtures/f/fold_shelf_link_scan.sh -- a link that lost its depth when its text was folded.
#
# WHY. `construction/ITINERARY.md` sits in `construction/`, so a link it writes as `](archive/X)`
# or `](../Y)` is correct from there. A hand folding that text onto `construction/archive/` moves
# it one directory down without touching the link, and both forms break: `archive/X` now needs the
# bare `X`, and `../Y` now needs `../../Y`. REDS %474 measured sixteen such links across five
# shelves and repaired them; the fault then fired again in the same lap, twice, under the hand that
# had just written the mechanism down. A property a hand cannot hold while actively thinking about
# it is a property that wants a program.
#
# WHY NO STANDING GUARD SEES IT, and this is the sharp part. Four instruments read links in this
# tree and each stops short here for its own reason, yet three of them stop for the SAME reason:
#
#   tracked_link_scan.sh    reads only "resolves here, breaks in a fresh clone" -- a link pointing
#                           at nothing at all is outside its subject -- AND reads past any file
#                           whose basename carries a one-clock stamp.
#   readme_reach_scan.sh    gates `broken_in_living` and REPORTS `broken_in_testimony`, deliberately
#                           un-ratcheted. It calls a file living when its basename carries no
#                           one-clock stamp.
#   living_docs_lint.rish   reads a roster of living pages; `construction/archive/` has zero rows on
#                           it.
#   reds_fold.sh            re-anchors correctly and proves it, for the shelves its own loom writes.
#
# So: THE ONE PROPERTY THAT MAKES A FILE A FOLD SHELF IS THE SAME PROPERTY EVERY LINK GUARD USES TO
# DECIDE IT IS TESTIMONY AND STOP GATING. The fold's output is stamped, stamped means testimony, and
# testimony is where the guards agree to stop. Measured `20260906.120905`: all 345 instances stood
# in four stamped files, and zero stood in the unstamped `REDS-*` shelves the loom writes.
#
# WHAT IS GATED, and why gating testimony is lawful HERE where it is not elsewhere. Those guards
# leave testimony alone for a good reason: a STALE reference was correct when written and broke
# because its target moved, and accrete-never-break asks that it be resolved rather than rewritten
# (`tools/d/dated_path_resolve.rish`). This reading has a different subject. A DEPTH-LOST link was
# never correct in the file it sits in -- the fold that created the file broke it in the same act.
# Nothing moved; the text moved. Repairing it restores what the text already meant, which is an
# erratum rather than a rewrite, and it is the repair REDS %474 already made by hand.
#
# The two are told apart mechanically rather than by judgment: a depth-lost link resolves under
# exactly one card-to-shelf correction, and a stale reference resolves under neither. The gate's
# subject is defined by the very property that distinguishes it, which is what makes gating safe.
#
# AMBIGUITY IS IMPOSSIBLE BY CONSTRUCTION, not absent by luck. Correction A wants a target beginning
# `archive/`; correction B wants one beginning `../`. Those prefixes are disjoint, so a target can
# match at most one and no repair ever guesses. That is why this scan carries no ambiguity counter:
# a counter that can never fire teaches a reader something false about the risk.
#
# WHAT IS READ PAST, each for a reason the tree already seats.
#   A CODE SPAN. `](../X)` inside backticks is prose ABOUT a link, and Markdown renders it
#   literally rather than as a link. `construction/archive/REDS-a-citation-in-a-comment-rows-218.md`
#   quotes two broken links as its own subject; repairing those would destroy the testimony. The
#   same shape is one of the five blessed cases in `comment_citation_control.sh`.
#   A PLACEHOLDER. `](date/YYYYMMDD/name)` is a shape built from letters, and stamp-and-name asks
#   that illustrations be built exactly this way -- illustrate with placeholders, cite only what
#   exists. Counting one as a broken reference is the fabrication that law warns about.
#   An absolute URL, and a bare `#fragment`.
#
#   shelves_scanned  -- files actually read, so a reading of nothing says so (REDS %463)
#   shelves_absent   -- listed in the index and absent from disk (mid-rebase, staged deletion).
#                       Reported: a reading that quietly got smaller is the fault %463 booked.
#   links_read       -- link targets weighed
#   fold_depth_lost  -- fails from its own directory, resolves under exactly one correction.
#                       HELD AT ZERO.
#   links_dead       -- fails, and neither correction resolves. REPORTED, never gated: this is the
#                       stale-reference class the other guards leave alone, and it is resolved with
#                       `tools/d/dated_path_resolve.rish` rather than rewritten.
#
# WHAT THIS DOES NOT REACH. The rooms that fold two levels deep -- `active-designing/date/YYYYMMDD/`
# and its four siblings -- carry the same class with a `../../../` correction. Sampled at most 400
# files per room on `20260906.120905`: active-designing 730, counsel 99, expanding-prompts 34,
# waymarks 27, so at least 890 instances stand there. That is its own campaign, named here with a
# number rather than taken in this lap.
#
# USAGE
#   sh tools/fixtures/f/fold_shelf_link_scan.sh          # census -- key=value lines
#   sh tools/fixtures/f/fold_shelf_link_scan.sh list     # every depth-lost link, with its repair
#
# Driven by tools/f/fold_shelf_link_witness.rish. Proven both ways by fold_shelf_link_control.sh.
# Run from the repository root.
set -eu

MODE="${1:-census}"
ROOM="${FOLD_SHELF_ROOM:-construction/archive}"

command -v git >/dev/null 2>&1 || { echo "verdict=no_git"; echo "refused: this scan reads the tracked tree, so it wants git" >&2; exit 2; }
git rev-parse --git-dir >/dev/null 2>&1 || { echo "verdict=no_repo"; echo "refused: not inside a git repository" >&2; exit 2; }
[ -d "$ROOM" ] || { echo "verdict=no_room"; echo "refused: $ROOM is absent, and a reading of nothing is not a reading (REDS %463)" >&2; exit 2; }

work=$(mktemp -d 2>/dev/null) || { echo "verdict=no_workspace"; echo "refused: could not make a temporary directory" >&2; exit 2; }
trap 'rm -rf "$work"' EXIT

# Tracked only: an untracked draft in the room is nobody's promise yet, and gating one would refuse
# a hand mid-fold.
git ls-files "$ROOM" 2>/dev/null | grep '\.md$' | sort -u > "$work/all_shelves" || : > "$work/all_shelves"

# A LISTED PATH IS NOT ALWAYS A READABLE ONE, and this bit for real on the lap that wrote this scan.
# `git ls-files` reads the INDEX: a path staged for deletion, a file renamed mid-rebase, and an
# unmerged path listed once per stage all appear here while the working tree holds nothing at that
# name -- and the awk below then dies with `fatal: cannot open file`. A tree standing mid-rebase is
# exactly when this reading matters most, so it must survive one. Absent paths are skipped and
# COUNTED, because a reading that quietly got smaller is the fault REDS %463 booked.
: > "$work/shelves"
shelves_absent=0
while IFS= read -r f; do
  [ -n "$f" ] || continue
  if [ -r "$f" ]; then
    printf '%s\n' "$f" >> "$work/shelves"
  else
    shelves_absent=$((shelves_absent + 1))
  fi
done < "$work/all_shelves"
shelves_scanned=$(grep -c . "$work/shelves" || true)

if [ "$shelves_scanned" -eq 0 ]; then
  echo "shelves_scanned=0"
  echo "verdict=no_shelves"
  echo "refused: $ROOM holds no tracked .md file, so this reading read nothing (REDS %463)" >&2
  exit 2
fi

# One awk pass per file emits `file<TAB>target`. Code spans go first, so a link quoted as prose is
# gone before the extractor ever sees it; then every `](...)` whose target carries no whitespace,
# no backtick and no nested `](` is emitted. A target may not contain a space, which is what keeps
# a runaway match from swallowing a sentence between two real links.
: > "$work/links"
while IFS= read -r f; do
  awk -v FNAME="$f" '
    { line = $0
      gsub(/`[^`]*`/, "", line)
      while (match(line, /\]\([^)`\]( \t]*\)/)) {
        t = substr(line, RSTART + 2, RLENGTH - 3)
        line = substr(line, RSTART + RLENGTH)
        if (t == "") continue
        print FNAME "\t" t
      }
    }
  ' "$f" >> "$work/links"
done < "$work/shelves"

links_read=0
: > "$work/lost"
: > "$work/dead"

while IFS="$(printf '\t')" read -r f t; do
  [ -n "${t:-}" ] || continue
  # A fragment names a place inside a target; the target is what has to exist.
  t=${t%%#*}
  [ -n "$t" ] || continue
  case "$t" in
    http:*|https:*|mailto:*|'//'*) continue ;;
    # Illustrations are shapes rather than citations (stamp-and-name).
    *YYYYMMDD*|*HHMMSS*|*sprig*|*'<'*|*'>'*|*'{'*) continue ;;
  esac
  d=${f%/*}
  links_read=$((links_read + 1))
  [ -e "$d/$t" ] && continue

  repair=""
  case "$t" in
    archive/*) [ -e "$d/${t#archive/}" ] && repair="${t#archive/}" ;;
    ../*)      [ -e "$d/../$t" ] && repair="../$t" ;;
  esac

  if [ -n "$repair" ]; then
    printf '%s\t%s\t%s\n' "$f" "$t" "$repair" >> "$work/lost"
  else
    printf '%s\t%s\n' "$f" "$t" >> "$work/dead"
  fi
done < "$work/links"

fold_depth_lost=$(grep -c . "$work/lost" || true)
links_dead=$(grep -c . "$work/dead" || true)

if [ "$MODE" = list ]; then
  cat "$work/lost"
  exit 0
fi

echo "shelves_scanned=$shelves_scanned"
echo "shelves_absent=$shelves_absent"
echo "links_read=$links_read"
echo "fold_depth_lost=$fold_depth_lost"
echo "links_dead=$links_dead"
awk -F"$(printf '\t')" '{print "lost: " $1 " :: " $2 " -> " $3}' "$work/lost" | head -40

if [ "$fold_depth_lost" -eq 0 ]; then
  echo "verdict=ok"
  exit 0
fi

echo "verdict=fold_depth_lost"
echo "refused: $fold_depth_lost link(s) kept the depth of the file they were folded out of -- each resolves under exactly one correction, shown by \`list\`" >&2
exit 1
