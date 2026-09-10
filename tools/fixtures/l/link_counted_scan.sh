#!/bin/sh
# tools/fixtures/l/link_counted_scan.sh -- a count of tracked paths is not a count of things.
#
# WHY. `git ls-files` lists a symlink and its target as two separate entries, and this tree links
# a module into every room that imports it by bare name, because Zig refuses an import that escapes
# the root file's directory. So `mantra/recall_lap1.rye` also stands at `comlink/recall_lap1.rye`,
# `linengrow/recall_lap1.rye`, and `pond/apps/mantra/recall_lap1.rye` -- one module, four tracked
# paths. Measured `20260910.004524`: **230 of 1,964** tracked `.rye` paths are symlinks (11.7%), and
# **4 of amphora's 11** (36%).
#
# WHAT IT COST, on this tree, before this scan existed:
#   - `README.md` published **1964** Rye modules where 1,734 exist -- a 13.3% overstatement on the
#     front door, in the exact number a reader divides the witness count by.
#   - two equinox scans asserted `amphora/*.rye >= 9` against a population of **7** distinct
#     sources. The floor was calibrated on the inflated reading, so repairing the count made the
#     guard refuse. A threshold set against an inflated number refuses the truth.
#
# WHY A GUARD RATHER THAN A HABIT. The cure is already written twice in this tree, with the reason
# spelled out in a comment each time: `tools/fixtures/r/rye_comment_ascii_scan.sh:227` and
# `tools/fixtures/r/rye_spoken_ascii_scan.sh:168` both carry `[ -L "$f" ] && continue`. A lantern
# that fires twice becomes a loom (`.claude/rules/reds-first.md`); this is the loom.
#
# THE READING. A tracked runner counts paths when one line reaches `git ls-files`, names a glob,
# and pipes into `wc -l`. It counts THINGS instead when it takes `git ls-files -s` and drops
# mode 120000, which is the idiom `exec_bit_scan.sh` and `empty_document_scan.sh` already use.
#
# WHAT IS NOT COUNTED, and why each is read past rather than waived:
#   - a glob no symlink answers. The reading asks git, per line, whether that glob actually reaches
#     a tracked symlink today -- so a count over `*.md` is honest arithmetic rather than a latent
#     fault, and it becomes a finding on the lap a link lands under it.
#   - `vendor/`, `gratitude/`, `seed/` -- borrowed and projected trees (read scope).
#   - a line already carrying `ls-files -s`, which is the cure.
#   - THIS FILE and its control, which must spell the defective form to describe and to plant it.
#
# USAGE
#   sh tools/fixtures/l/link_counted_scan.sh          # counts
#   sh tools/fixtures/l/link_counted_scan.sh list     # one line per site, with the two numbers
#
# BOUNDS: one `git grep` over tracked runners; at most 64 reported sites; one `git ls-files` per
# distinct glob, memoized, so a repeated glob is asked once.
#
# Proven by tools/l/link_counted_witness.rish over tools/fixtures/l/link_counted_control.sh.
set -eu

root=${LINK_COUNTED_ROOT:-$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)}
cd "$root"

MODE=${1:-count}
MAX_REPORT=64

work=$(mktemp -d "${TMPDIR:-/tmp}/link-counted.XXXXXX")
trap 'rm -rf "$work"' EXIT INT TERM

# A runner is a tracked `.sh` or `.rish`. The two self-referential files are read past by name.
git grep -nE "git ls-files[^|]*'[^']*\*[^']*'[^|]*\|[^|]*wc -l" -- '*.sh' '*.rish' 2>/dev/null \
  | grep -vE '^(vendor|gratitude|seed)/' \
  | grep -vE '^tools/fixtures/l/link_counted_(scan|control)\.sh:' \
  | grep -vE 'ls-files -s' \
  > "$work/candidates.txt" || true

: > "$work/sites.txt"
: > "$work/memo.txt"

# paths_for GLOB -> "paths links", memoized so a glob repeated across files is asked once
paths_for() {
  g=$1
  # a glob holds no space, so "GLOB paths links" is unambiguous and keeps this file free of a
  # literal tab -- which would read as a non-printable byte to any hand grepping for one.
  hit=$(grep -F "$g " "$work/memo.txt" 2>/dev/null | head -1 || true)
  if [ -n "$hit" ]; then printf '%s' "$hit" | cut -d" " -f2,3; return; fi
  p=$(git ls-files -s -- "$g" 2>/dev/null | wc -l | tr -d ' ')
  l=$(git ls-files -s -- "$g" 2>/dev/null | awk '$1 == "120000"' | wc -l | tr -d ' ')
  printf '%s %s %s\n' "$g" "$p" "$l" >> "$work/memo.txt"
  printf '%s %s' "$p" "$l"
}

while IFS= read -r line; do
  [ -n "$line" ] || continue
  file=$(printf '%s' "$line" | cut -d: -f1)
  # the first single-quoted token holding a `*` is the glob this line counts
  glob=$(printf '%s' "$line" | sed -n "s/.*git ls-files[^']*'\([^']*\*[^']*\)'.*/\1/p" | head -1)
  [ -n "$glob" ] || continue
  set -- $(paths_for "$glob")
  paths=${1:-0}; links=${2:-0}
  [ "$links" -gt 0 ] 2>/dev/null || continue
  printf '%s %s %s %s\n' "$file" "$glob" "$paths" "$links" >> "$work/sites.txt"
done < "$work/candidates.txt"

sites=$(wc -l < "$work/sites.txt" | tr -d ' ')
files=$(cut -d" " -f1 "$work/sites.txt" | sort -u | wc -l | tr -d ' ')

if [ "$MODE" = list ]; then
  head -"$MAX_REPORT" "$work/sites.txt" | while read -r f g p l; do
    printf 'link_counted: %s counts %s -- %s tracked paths, %s of them symlinks onto a path already counted\n' \
      "$f" "$g" "$p" "$l"
  done
fi

echo "candidate_lines=$(wc -l < "$work/candidates.txt" | tr -d ' ')"
echo "link_counted_sites=$sites"
echo "files_affected=$files"
if [ "$sites" -eq 0 ]; then echo "verdict=ok"; else echo "verdict=link_counted"; fi
