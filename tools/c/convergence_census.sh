#!/bin/sh
# convergence_census.sh -- how much of what this tree WRITES is proven to converge.
#
# WHY. `foundations/20260823-222019_what-brix-infuse-is.md` states the tree's own claim about change:
#
#     declaration + world  ->  infusion  ->  world'
#     infusion(world')     ->  world'          idempotent
#
# The second line is the whole promise: running a change twice does what running it once did. A tool
# that fails it corrupts on the second run, and the second run is exactly what an unattended loop
# does at three in the morning.
#
# Measured `20260908.005904` after the control exclusion: **4 tools transform a document handed to
# them**, and one of the four names idempotence
# inside a control's own assertion. Three hundred and twenty files mention the word in prose. So the
# promise is kept where a hand happened to remember, and nothing counts where it was not.
#
# A STATIC PATTERN FINDS CANDIDATES; ONLY THE PROVER CLASSIFIES (`20260908.010852`). This reading is
# named `candidates` rather than `writers` because four refinements in three laps proved a grep
# cannot tell a document writer from a library or a scan. The denominator ran 392 (every pen write),
# 1200 (the census reading its own bound), 30 (controls counted), 7 (controls excluded) -- and of
# that seven, THREE were still not writers: two shared libraries emitting lists and one scan that
# reads a remote. A fifth pattern was the wrong answer. `tools/c/convergence_prove.sh` classifies by
# RUNNING, and its `inert` verdict is what exposed each of these in turn.
#
# So read this number as an upper bound on what might need proving, and the prover's verdicts as the
# finding. Measured `20260908.010852`, exactly one candidate is a document writer and it converges.
#
#   sh tools/c/convergence_census.sh          # the counts
#   sh tools/c/convergence_census.sh list     # writing tools with no convergence assertion
#
# WHAT COUNTS AS PROVEN, deliberately narrow: a control or witness beside the tool that ASSERTS the
# second run's result -- `second run`, `idempotent`, `twice`, `again` -- inside a check rather than a
# comment. Prose about idempotence is a claim; an assertion is a proof, and this census exists
# because the tree had 35 times more of the first than the second.
#
# REPORTED, NEVER GATED, and for a reason this tree has met four times now: a tool that legitimately
# runs once -- a one-shot projection, a publisher -- has nothing to converge, and a gate cannot tell
# it from a tool that simply never checked. The number is the finding; the ceiling is a later word.
#
# BOUNDS: at most 6000 tools read, at most 200 reported. The first bound was 1200 and the tree holds
# more than that, so the census reported `tools_read=1200` -- its own bound wearing the costume of a
# measurement, and one writer where thirty stand. A bound that silently truncates the population is
# worse than no bound, because the reading still looks like a reading. 6000 is above the corpus with
# room to grow, and the count is printed so the day it becomes a ceiling is visible.
set -eu

root=${CONV_ROOT:-$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)}
cd "$root"

MODE=${1:-count}
MAX_TOOLS=6000
MAX_REPORT=200

work=$(mktemp -d "${TMPDIR:-/tmp}/conv-census.XXXXXX")
trap 'rm -rf "$work"' EXIT INT TERM

git ls-files 'tools/*' 2>/dev/null | grep -E '\.(sh|rish)$' | grep -v '/date/' | head -"$MAX_TOOLS" > "$work/all.txt"
# A CORPUS OF ZERO IS A RED, NEVER A READING (REDS %170).
[ -s "$work/all.txt" ] || { echo "refused: no tracked tools -- every count below would read zero" >&2; exit 2; }

writers=0; proven=0; unproven=0
: > "$work/unproven.txt"
while IFS= read -r f; do
  [ -f "$f" ] || continue
  # A WRITER HERE MUTATES THE TRACKED TREE, not its own pen. Nearly every tool redirects into a
  # temporary directory, and a pen has nothing to converge -- it is thrown away. Counting those gave
  # 392 files and a meaningless denominator; counting only writes whose target is a tree path or a
  # per-file variable gives 30, which is a population a reader can check by hand. The exclusion list
  # names the temp variables this tree actually uses.
  grep -hoE '(sed -i[^"]*"[^"]+"|(cat|printf)[^|>]*> *"[^"]+")' "$f" 2>/dev/null \
    | grep -vE '\$(work|pen|tmp|TMP|out|d)\b' \
    | grep -qE '\$(f|file|path|p|target|dst)\b|construction/|session-logs/|\.claude/' || continue
  # A CONTROL WRITES INTO ITS OWN PEN AND HAS NOTHING TO CONVERGE, and counting them was this
  # census's third wrong denominator (`20260908.005904`). 23 of the 27 it first called unproven were
  # `*_control.sh` files whose writes target a throwaway directory they created and delete. The
  # prover found this empirically rather than by argument: handed a document sample, all 23 answered
  # `inert` -- the sample exercised no path, because a control is not a document writer. The real
  # population is FOUR. A denominator wrong by a factor of seven makes a fraction that reads like a
  # finding and is a description of the naming convention instead.
  case "$f" in *_control.sh) continue ;; esac
  writers=$((writers + 1))
  base=${f##*/}; stem=${base%.*}
  # Its own siblings: the control and witness that stand beside it by name.
  if git ls-files 'tools/*' 2>/dev/null | grep -F "$stem" \
       | xargs -r grep -lEi '(idempotent|second run|run twice|runs twice|again finds nothing)' 2>/dev/null \
       | head -1 | grep -q .; then
    proven=$((proven + 1))
  else
    unproven=$((unproven + 1))
    printf '%s\n' "$f" >> "$work/unproven.txt"
  fi
done < "$work/all.txt"

if [ "$MODE" = list ]; then
  head -"$MAX_REPORT" "$work/unproven.txt" | sed 's/^/unproven: /'
fi

echo "tools_read=$(grep -c . "$work/all.txt")"
echo "candidates=$writers"
echo "candidates_proven=$proven"
echo "candidates_unproven=$unproven"
