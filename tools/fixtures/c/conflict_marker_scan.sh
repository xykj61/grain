#!/bin/sh
# tools/fixtures/c/conflict_marker_scan.sh -- a tracked file carrying an unresolved conflict marker.
#
# WHY. On `20260906` `construction/ITINERARY.md` stood on the anointed remote holding
# `<<<<<<< HEAD` and `>>>>>>> 8b22606c4` around its Landed row, published and unnoticed through
# three commits. That file is the living operator card: every ship in the fleet reads it WHOLE at
# the open of every lap, and the standing block it carries is what steers an unattended round.
#
# NOTHING IN THE TREE LOOKED, and the reason is that every instrument reads a file for something
# else. `tools/hooks/commit-msg` reads the message rather than the diff. `tracked_link_scan.sh`
# reads links. `standing_equipment_scan.sh` reads the roster. `living_pin_max_bytes.sh` reads
# length -- and a conflict marker makes a pin LONGER, so the one meter pointed at that file read
# the damage as ordinary growth. A marker is not a broken link, a stale claim, or an unmet bound;
# it is bytes git wrote and a hand never came back for, and it needed its own reading.
#
# WHAT IT READS. Every tracked file, for a line beginning `<<<<<<< ` or `>>>>>>> ` -- the two
# LABELLED markers, which carry a branch name or a commit hash after the sigil and can appear by
# accident in almost nothing. The bare `=======` divider is deliberately NOT gated: it is also the
# Markdown setext underline for a heading, and this tree writes it in prose. A divider is counted
# only when it stands between a labelled pair, and it is reported rather than gated.
#
# WHAT IT EXCLUDES, and why by NAME rather than by shape. A file that TEACHES the marker -- this
# scan, its control, and the witness above them -- would otherwise accuse itself, which is the
# fault `%463` named when a census began crediting every path it mentioned. Excluding by name keeps
# the exclusion countable and reviewable; excluding by shape (say, "inside a fenced block") would
# be a door, and the control proves a marker inside a fence is still bitten.
#
# `vendor/` is third-party source held unmodified, so a marker there is theirs to resolve.
#
#   files_scanned   -- tracked files actually read, so a reading of nothing says so (REDS %463)
#   marked_files    -- files carrying a labelled marker. HELD AT ZERO.
#   dividers        -- bare `=======` lines standing between a labelled pair. Reported.
#
# USAGE
#   sh tools/fixtures/c/conflict_marker_scan.sh          # census -- key=value lines
#   sh tools/fixtures/c/conflict_marker_scan.sh list     # every marked file:line, one per line
#
# Driven by tools/c/conflict_marker_witness.rish. Proven both ways by conflict_marker_control.sh.
# Run from the repository root.
set -eu

MODE="${1:-census}"

# Named on purpose, one per line, so the roster of self-accusing files is countable. A file added
# here is a file this reading cannot protect, which is the trade being made in the open.
EXCLUDED="tools/fixtures/c/conflict_marker_scan.sh
tools/fixtures/c/conflict_marker_control.sh
tools/c/conflict_marker_witness.rish"

command -v git >/dev/null 2>&1 || { echo "verdict=no_git"; echo "refused: this scan reads the tracked tree, so it wants git" >&2; exit 2; }
git rev-parse --git-dir >/dev/null 2>&1 || { echo "verdict=no_repo"; echo "refused: not inside a git repository" >&2; exit 2; }

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

printf '%s\n' "$EXCLUDED" | sed '/^$/d' | sort -u > "$work/excluded"

# `git ls-files` lists an UNMERGED path once per stage, so a tree standing mid-rebase reports the
# same file three times; `sort -u` is what keeps the count and the hit list honest there. That state
# is exactly when this reading matters most, so it is the state it must count correctly.
git ls-files 2>/dev/null | sort -u > "$work/all" || : > "$work/all"
# `vendor/` is provisioned rather than authored, and a submodule lists as one entry with no bytes of
# its own, so both fall out here rather than inside the walk.
grep -v '^vendor/' "$work/all" | grep -vxF -f "$work/excluded" > "$work/files" || : > "$work/files"
files_scanned=$(grep -c . "$work/files" || true)

# ONE `git grep` RATHER THAN A LOOP, and the difference is the tier. Reading 15,668 tracked files
# one `grep` process at a time measured 61 seconds on this pier -- a cost that would push this onto
# the cadence clock, where a marker could stand published for four laps. The same reading through
# `git grep` measures about a second, which is what buys `tier lap` and an answer at every open.
# Pathspec exclusions rather than an argument list: handing `git grep` all 15,681 paths worked on
# this pier and is one large tree away from ARG_MAX, which would fail as *fewer hits* rather than as
# an error -- the worst way for a guard to break.
: > "$work/hits"
set -- -nE '^(<<<<<<< |>>>>>>> )' -- ':(exclude)vendor/*'
while IFS= read -r x; do
  [ -n "$x" ] || continue
  set -- "$@" ":(exclude)$x"
done < "$work/excluded"
git grep "$@" > "$work/raw" 2>/dev/null || : > "$work/raw"
sort -u "$work/raw" > "$work/hits"

marked_files=$(cut -d: -f1 "$work/hits" 2>/dev/null | sort -u | grep -c . || true)
hits=$(grep -c . "$work/hits" || true)

# A divider is counted only where it stands inside a labelled pair, so ordinary setext prose is left
# entirely alone. Reported rather than gated: the labelled markers already decide.
dividers=0
if [ "$marked_files" -gt 0 ]; then
  dividers=$(cut -d: -f1 "$work/hits" | sort -u | while IFS= read -r f; do
    awk '/^<<<<<<< /{inblk=1} inblk && /^=======$/{n++} /^>>>>>>> /{inblk=0} END{print n+0}' "$f"
  done | awk '{s+=$1} END{print s+0}')
fi

if [ "$MODE" = list ]; then
  cat "$work/hits"
  exit 0
fi

echo "files_scanned=$files_scanned"
echo "files_excluded=$(grep -c . "$work/excluded" || true)"
echo "marker_lines=$hits"
echo "marked_files=$marked_files"
echo "dividers=$dividers"
cut -d: -f1,2 "$work/hits" 2>/dev/null | sort -u | while IFS= read -r hit; do
  echo "marked: $hit"
done

if [ "$marked_files" -eq 0 ]; then
  echo "verdict=ok"
  exit 0
fi

echo "verdict=conflict_marker"
echo "refused: $marked_files tracked file(s) carry an unresolved conflict marker -- resolve the file and commit it" >&2
exit 1
