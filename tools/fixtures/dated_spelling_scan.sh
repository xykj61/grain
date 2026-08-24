#!/bin/sh
# tools/fixtures/dated_spelling_scan.sh -- one shape for a dated name, spelled the same way in
# every tool that tests for one.
#
# WHY. This tree's dated/living test is `YYYYMMDD-HHMMSS` followed by the sprig or, when there is
# no sprig, by the extension. The session-logs law makes the sprig OPTIONAL -- it is added only
# when two logs share a second -- and 237 tracked logs carry none. A pattern requiring the
# underscore therefore reads every one of them as living, which is the wrong answer in whichever
# direction the tool then moves: a repointer opens testimony for writing, a bound meter
# undercounts a room, a census cannot see the reference, and the guard that protects dated
# artifacts from being rewritten does not protect them.
#
# It has been found three times. First in the canonical seam and the repointer's write set
# (REDS %175, closed). Then in eight more scans, which that row named and left open. Then in
# eleven further sites across seven files, which nobody had named at all -- the remainder was
# itself counted from memory, which is the same fault one level up. A lantern that fires twice
# becomes a loom, and this is the loom.
#
# WHAT IS GATED, hard, at zero. Any living tracked tool holding a one-clock stamp shape followed
# immediately by a bare underscore, in any of the three spellings this tree writes stamps in:
#
#     [0-9]{8}-[0-9]{6}_                                     the interval form
#     2026[0-9]{4}-[0-9]{6}_                                 the year-anchored form
#     [0-9][0-9]...-[0-9][0-9]..._                           the eight-fold explicit form
#
# The repair in every case is the same: write the separator as a class or an option -- `[_.]`,
# `(_|\.)`, or `(_<sprig>)?\.` -- so both spellings of a dated name answer alike.
#
# WHAT PASSES FREE, and each for its own reason.
#
#   Dated testimony. A file whose own basename carries a one-clock stamp keeps every word it
#   wrote, so a dated log quoting an elder pattern is a record rather than a rule.
#
#   The instrument. This scan, its control, and its witness plant the narrow pattern in order to
#   prove the refusal, and a guard that bit its own proof would have no proof. They are named by
#   BASENAME rather than by path, because an exemption tied to an address moves out from under
#   itself the first time a room folds (REDS %157).
#
#   A stamp with no underscore after it at all. `date +%Y%m%d-%H%M%S`, a printf template, a
#   filename in prose -- none of them is a classification test, and none is measured here.
#
# WHAT THIS DOES NOT REACH, said plainly. A test written in code rather than in a pattern -- the
# resolver splitting a basename on "_" and measuring the head, for one -- is invisible to a grep,
# and the honest answer is that this guard reads patterns and stops there. The resolver's own
# reading is proven instead by tools/d/dated_path_witness.rish, on a real sprigless case.
#
# USAGE
#   sh tools/fixtures/dated_spelling_scan.sh              # report on this tree
#   sh tools/fixtures/dated_spelling_scan.sh list         # every narrow site, one per line
#
# NOT tools/fixtures/dated_pattern_scan.sh, which stands beside it and does a different job:
# that one proves the shared classifier tools/fixtures/dated_classify.rish agrees with the law at
# context/specs/living-vs-dated.md, on two planted controls, with a prove-red mode. Its own header
# carries the sentence this name was chosen under -- when two roofs carry one name, either they
# agree or the name is doing two jobs. This scan reads how every tool SPELLS the shape; that one
# reads whether one classifier answers correctly. Two jobs, two names.
#
# Driven by tools/d/dated_spelling_witness.rish. Run from the repository root.

set -u

verb=${1:-report}

work=$(mktemp -d) || exit 1
trap 'rm -rf "$work"' EXIT

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "verdict=not_a_git_tree"
  echo "refused: this scan reads the tracked corpus and there is no git tree here" >&2
  exit 1
fi

# The corpus: tracked sources a tool actually runs. A pattern living anywhere else is prose.
git ls-files '*.sh' '*.rish' '*.rye' '*.awk' '*.jq' '*.py' '*.brix' 'tools/hooks/*' 2>/dev/null \
  > "$work/tracked.txt" || : > "$work/tracked.txt"

# invariant: a basename carrying a one-clock stamp is testimony -- either separator, since a rule
# that could not read its own subject would be the very fault this scan exists to catch.
grep -vE '(^|/)[0-9]{8}-[0-9]{6}[_.]' "$work/tracked.txt" > "$work/living.txt" || : > "$work/living.txt"

# The instrument, by basename. These three plant the narrow pattern to prove the refusal.
: > "$work/field.txt"
while IFS= read -r f; do
  case "${f##*/}" in
    dated_spelling_scan.sh|dated_spelling_control.sh|dated_spelling_witness.rish) continue ;;
  esac
  printf '%s\n' "$f" >> "$work/field.txt"
done < "$work/living.txt"

echo "files_considered=$(wc -l < "$work/field.txt" | tr -d ' ')"

# THE READING. A stamp shape, then a bare underscore. Written as one alternation so the three
# spellings can never drift apart into three different opinions about the same shape.
# The escaped braces are LITERAL text (a tool writing `[0-9]{8}`); the bare braces are ERE
# intervals (the same class written out eight times). Both spellings appear in this tree, and
# reading only the first is how the eight-fold form went free the first time this was written.
NARROW='(\[0-9\]\{8\}|2026\[0-9\]\{4\}|(\[0-9\]){8})-(\[0-9\]\{6\}|(\[0-9\]){6})_'

: > "$work/hits.txt"
while IFS= read -r f; do
  [ -f "$f" ] || continue
  grep -nE "$NARROW" "$f" 2>/dev/null | sed "s|^|$f:|" >> "$work/hits.txt" || true
done < "$work/field.txt"

narrow=$(wc -l < "$work/hits.txt" | tr -d ' ')

if [ "$verb" = "list" ]; then
  cat "$work/hits.txt"
  exit 0
fi

echo "narrow_dated_patterns=$narrow"

if [ "$narrow" -ne 0 ]; then
  sed 's|^|detail: |' "$work/hits.txt"
  echo "verdict=a_dated_pattern_requires_the_sprig"
  exit 4
fi

echo "verdict=one_shape_everywhere"
exit 0
