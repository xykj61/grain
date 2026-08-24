#!/bin/sh
# tools/fixtures/living_pin_max_bytes.sh -- the seated bound, read once, from the law that states it.
#
# WHAT THIS IS FOR. Six meters in this tree measure a living pin against `living_pin_max_bytes`,
# and until this lap five of them carried their own copy of the number. A constant written down
# five times is a constant that can quietly disagree with itself, and the disagreement surfaces
# as one guard passing a page another guard refuses -- with both of them correct about the number
# they happen to hold. This script is the one reading. Every meter calls it and none spells it.
#
# USAGE. From any caller, whatever its working directory:
#
#   MAX_BYTES=$(sh "$(dirname "$0")/living_pin_max_bytes.sh")                       # the general bound
#   MAX_BYTES=$(sh "$(dirname "$0")/living_pin_max_bytes.sh session-logs/README.md) # that page's bound
#
# ONE READING, TWO NUMBERS. A page may carry its own bound where the general one would refuse it for
# doing its job. The law states an exception as `living_pin_max_bytes[<path>] = <n>` beside the
# general assignment, and this script answers per page so no meter spells either number and no
# second reading exists to disagree with the first. Asked about a page the law names no exception
# for, it answers the general bound, which is what every caller wants by default.
#
# The path resolves from this file's own location rather than from the caller's cwd, so a scan
# that later cd's into a pen still reads the real tree's law.
#
# WHY IT REFUSES RATHER THAN GUESSING. A meter whose bound silently defaults is a meter that
# reports green over an unmeasured tree. If the law is missing or its line unreadable, this exits
# non-zero with the reason named on stderr, and `set -eu` in the caller carries the refusal up.
#
# THE HISTORY. REDS %197 seated `declared_ceiling` reading this number from the law rather than
# copying it a fourth time, and named three scripts still holding their own. Measured on the next
# lap, the tree held five (REDS %199) -- the count was a memory. This script exists so the number
# has one home and the count has none.
#
# Law: context/specs/20260724-132812_pin-and-ledger-living-pin-max-bytes.md
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
LAW="$ROOT/context/specs/20260724-132812_pin-and-ledger-living-pin-max-bytes.md"

if [ ! -f "$LAW" ]; then
  echo "living_pin_max_bytes: the seated bound law is missing at $LAW" >&2
  exit 1
fi

# The law states the number once, in a plain assignment line the spec owns, of the shape
#   living_pin_max_bytes = <n>  // ~6k tokens: a pin an agent reads in one breath
# and this script writes no copy of <n>, which is the whole point of it existing.
# `grep -a` so the answer is the same whichever grep is installed (REDS %198).
PAGE=${1:-}

VALUE=""
if [ -n "$PAGE" ]; then
  # An exception is anchored on the whole bracketed path, so `a/README.md` can never answer for
  # `b/a/README.md` and a partial match can never stand in for a stated one.
  VALUE=$(grep -aF -m1 "living_pin_max_bytes[$PAGE]" "$LAW" \
    | sed -n 's/.*=[[:space:]]*\([0-9][0-9]*\).*/\1/p' | head -1)
fi

if [ -z "$VALUE" ]; then
  VALUE=$(grep -a -m1 '^living_pin_max_bytes[[:space:]]*=' "$LAW" \
    | sed -n 's/.*=[[:space:]]*\([0-9][0-9]*\).*/\1/p' | head -1)
fi

if [ -z "$VALUE" ]; then
  echo "living_pin_max_bytes: the law at $LAW states no readable number" >&2
  exit 1
fi

printf '%s\n' "$VALUE"
