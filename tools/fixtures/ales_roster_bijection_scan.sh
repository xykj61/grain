#!/bin/sh
# tools/fixtures/ales_roster_bijection_scan.sh -- is every Lotus witness on disk heard by the ALES choir?
#
# The ALES choir (tools/al/ales_suite_witness.rish) sings a written roster, and a written roster drifts
# from the disk beside it the moment a lap writes a new witness and forgets the line. This scan reads
# both sides and answers in one word, so the answer is a measurement rather than a memory.
#
# It exists because the lantern has now fired three times, each in a different family. REDS %81 found
# nine crypto rungs on disk with none of them registered in their suite. REDS %101 found the same shape
# in Caravan, where a printing meter stood outside the choir for two laps. REDS %219 found the widest
# form of it: 239 ales witnesses on disk and no runner anywhere naming one of them -- a whole creative
# suite proven only on the lap each rung was written. A fault caught by attention once is a story;
# caught three times it is a guard that should have been written after the first
# (.claude/rules/reds-first.md).
#
# So the bijection lives here rather than inside the choir alone, and the cheap every-lap meter
# tools/al/ales_roster_witness.rish pulls it. Singing 240 witnesses measured 233s and 303s on two clean
# passes, which is why the choir sits on the roster's `cadence` tier; asking whether the roster is whole
# costs two greps and runs every lap. It is the asking, never the singing, that catches a witness born unheard.
#
# Two directions, because a roster breaks both ways:
#
#   unheard -- a witness stands on disk and no roster line names it. Nothing runs it, and its rung is
#              proven only on the lap it was written. This is the shape all three reds wore.
#   phantom -- a roster line names a witness with no file behind it. The choir would refuse to run, and
#              the count it prints would describe a tree that no longer exists.
#
# ALES_ROSTER_FILE (default tools/al/ales_suite_witness.rish): the file whose registrations are read.
# ALES_TOOLS_DIR   (default tools): the directory the witnesses stand in, so the PASS and FAIL fixtures
#                  prove both paths without touching the living tree.
set -eu

ROSTER=${ALES_ROSTER_FILE:-tools/al/ales_suite_witness.rish}
TOOLS=${ALES_TOOLS_DIR:-tools}

if [ ! -f "$ROSTER" ]; then
  echo "ROSTER_FAIL reason=no_roster file=${ROSTER}"
  exit 1
fi

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

# The witnesses standing on disk, bare-named and sorted, the choir itself left out -- a choir need not
# register itself. TWO LEVELS, not one: `tools/` folded into letter rooms on `20260823.144100`, so every
# ales witness now stands at `tools/al/`, and a depth of one would match nothing while reporting a
# confident zero (REDS %169). The pen a control builds stays flat, which a depth of two still reaches.
find "$TOOLS" -maxdepth 2 -name 'ales_*_witness.rish' -type f \
  | sed 's:.*/::; s:\.rish$::' \
  | grep -v '^ales_suite_witness$' \
  | sort > "$work/disk"

# The names the roster registers, likewise bare and sorted -- read from the choir's CODE, never from its
# comments. This is REDS %218's rule one room over: a citation in a comment is a promise rather than a call,
# so a header naming a sibling witness would otherwise register it and a header naming one not yet written
# would read as a phantom. The elder caravan scan reads its whole file and passes only because its header
# happens to name no caravan witness; that is an accident of prose, and an accident is a thing that changes.
grep -v '^[[:space:]]*#' "$ROSTER" \
  | grep -oE 'ales_[a-z0-9_]+_witness' \
  | grep -v '^ales_suite_witness$' \
  | sort -u > "$work/reg"

n_disk=$(wc -l < "$work/disk" | tr -d ' \n')
n_reg=$(wc -l < "$work/reg" | tr -d ' \n')

# A corpus holding no witnesses at all is the REDS %97 shape -- a scan reading a real directory and
# answering zero, where the zero is the scan's own blindness rather than the tree's virtue. It refuses.
if [ "$n_disk" -eq 0 ]; then
  echo "ROSTER_FAIL reason=no_witnesses dir=${TOOLS}"
  exit 1
fi

echo "ROSTER_DISK ${n_disk}"
echo "ROSTER_REG ${n_reg}"

unheard=$(grep -Fxv -f "$work/reg" "$work/disk" | tr '\n' ' ' | sed 's/ $//' || true)
if [ -n "$unheard" ]; then
  echo "ROSTER_FAIL reason=unheard names=${unheard}"
  exit 1
fi

phantom=$(grep -Fxv -f "$work/disk" "$work/reg" | tr '\n' ' ' | sed 's/ $//' || true)
if [ -n "$phantom" ]; then
  echo "ROSTER_FAIL reason=phantom names=${phantom}"
  exit 1
fi

echo "ROSTER_OK disk=${n_disk} registered=${n_reg} roster=${ROSTER}"
