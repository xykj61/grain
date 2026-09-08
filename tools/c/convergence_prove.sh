#!/bin/sh
# convergence_prove.sh -- run a writer twice on a copy and see whether the second run changes anything.
#
# WHY ONE PROVER RATHER THAN TWENTY-SEVEN CASES. `tools/c/convergence_census.sh` measured 30 tools
# writing to the tracked tree with 3 proving they converge, and the obvious repair was to hand-write
# a convergence case into each of the other 27 controls. That is the same fault the census found,
# performed once per tool: a rule kept where a hand remembered. **22 of the 27 share one invocation
# shape** -- a single file path as the first argument -- so one prover RUNS for all of them.
#
# CORRECTED `20260908.005904`, and the correction came from this prover's own `inert` verdict. Run
# across all 27 with one generic markdown sample the readings were **24 inert, 2 refused, 1
# converges**. Inert is the honest answer: a prover without a sample that TRIGGERS the tool proves
# nothing. Twenty-three of the twenty-seven were `*_control.sh` files writing only into their own
# pens, with nothing to converge -- so the census excludes controls now and its population is FOUR.
# One prover still serves them all; what it needs per tool is a SAMPLE, not a hand-written case.
#
# WHAT IT PROVES, and it is narrow on purpose: given a tool and a sample file, running the tool twice
# leaves the file byte-identical to what one run left. `infusion(world') -> world'`, which
# `foundations/20260823-222019_what-brix-infuse-is.md` states as this tree's own claim about change.
#
#   sh tools/c/convergence_prove.sh <tool> <sample-file>
#
# It works on a COPY in a throwaway pen, never on the tree, so a non-converging tool is discovered
# without a tracked file paying for the discovery.
#
# THREE VERDICTS, and the third is the one that matters most:
#   converges     -- the second run changed nothing. The claim holds for this sample.
#   diverges      -- the second run changed the file. A red, and the diff is printed.
#   inert         -- the FIRST run changed nothing either, so the sample exercised no path and the
#                    reading proves nothing. A sample that triggers no work is the quiet way a
#                    convergence proof lies, and it is reported rather than counted as a pass.
#
# BOUNDS: one tool, one sample, two runs, one pen.
set -eu

TOOL=${1:-}
SAMPLE=${2:-}
[ -n "$TOOL" ] && [ -n "$SAMPLE" ] || { echo "usage: convergence_prove.sh <tool> <sample-file>" >&2; exit 2; }
[ -f "$TOOL" ] || { echo "refused: no tool at $TOOL" >&2; exit 2; }
[ -f "$SAMPLE" ] || { echo "refused: no sample at $SAMPLE" >&2; exit 2; }

pen=$(mktemp -d "${TMPDIR:-/tmp}/conv-prove.XXXXXX")
trap 'rm -rf "$pen"' EXIT INT TERM

cp "$SAMPLE" "$pen/subject"
cp "$SAMPLE" "$pen/original"

# THE TOOL'S OWN EXIT STATUS IS READ, NEVER SWALLOWED. A tool that refused has not converged; it has
# not run, and calling that a pass is the shape `instrument_refusal` gates at zero.
if ! sh "$TOOL" "$pen/subject" >"$pen/out1" 2>&1; then
  echo "tool=$TOOL"
  echo "verdict=refused"
  echo "detail: the first run exited non-zero -- no convergence claim can be made"
  sed 's/^/  /' "$pen/out1" | head -5
  exit 1
fi
cp "$pen/subject" "$pen/after_one"

if cmp -s "$pen/original" "$pen/after_one"; then
  echo "tool=$TOOL"
  echo "sample=$SAMPLE"
  echo "verdict=inert"
  echo "detail: the first run changed nothing, so this sample exercises no path -- the reading proves nothing"
  exit 0
fi

if ! sh "$TOOL" "$pen/subject" >"$pen/out2" 2>&1; then
  echo "tool=$TOOL"
  echo "verdict=refused_on_second"
  echo "detail: the tool ran once and then refused its own output -- the sharpest kind of divergence"
  exit 1
fi

echo "tool=$TOOL"
echo "sample=$SAMPLE"
if cmp -s "$pen/after_one" "$pen/subject"; then
  echo "verdict=converges"
else
  echo "verdict=diverges"
  echo "detail: the second run changed the file -- running it twice does not do what running it once did"
  diff "$pen/after_one" "$pen/subject" | head -8 | sed 's/^/  /'
  exit 1
fi
