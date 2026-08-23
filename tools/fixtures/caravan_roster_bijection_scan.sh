#!/bin/sh
# tools/fixtures/caravan_roster_bijection_scan.sh -- is every Caravan witness on disk heard by the choir?
#
# The Caravan choir (tools/ca/caravan_suite_witness.rish) sings a written roster, and a written roster
# drifts from the disk beside it the moment a lap writes a new witness and forgets the line. This scan
# reads both sides and answers in one word, so the answer is a measurement rather than a memory.
#
# It exists because the lantern fired twice. REDS %81 found nine crypto rungs on disk and none of them
# registered in their suite -- the guard was real and nothing pulled it. REDS %101 found the same shape
# in Caravan: the printing meter was born, proved itself GREEN on its own lap, and stood outside the
# choir for two laps because a per-rung send runs the new witness rather than the whole choir. A fault
# caught by attention once is a story; caught twice it is a guard not yet written (.claude/rules/reds-first.md).
#
# So the bijection lives here rather than inside the choir alone, and the cheap every-lap meters pull it.
# Singing 98 witnesses costs minutes; asking whether the roster is whole costs two greps -- and it is the
# asking, never the singing, that catches a witness born unheard.
#
# Two directions, because a roster breaks both ways:
#
#   unheard -- a witness stands on disk and no roster line names it. Nothing runs it, and its rung is
#              proven only on the lap it was written. This is the shape both reds wore.
#   phantom -- a roster line names a witness with no file behind it. The choir would refuse to run, and
#              the count it prints would describe a tree that no longer exists.
#
# CARAVAN_ROSTER_FILE (default tools/ca/caravan_suite_witness.rish): the file whose registrations are read.
# CARAVAN_TOOLS_DIR   (default tools): the directory the witnesses stand in, so the PASS and FAIL
#                     fixtures prove both paths without touching the living tree.
set -eu

ROSTER=${CARAVAN_ROSTER_FILE:-tools/ca/caravan_suite_witness.rish}
TOOLS=${CARAVAN_TOOLS_DIR:-tools}

if [ ! -f "$ROSTER" ]; then
  echo "ROSTER_FAIL reason=no_roster file=${ROSTER}"
  exit 1
fi

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

# The witnesses standing on disk, bare-named and sorted, the choir itself left out -- a choir need not
# register itself. TWO LEVELS, not one: `tools/` folded into letter rooms on `20260823.144100`, so
# every Caravan witness now stands at `tools/ca/`, and a depth of one matched nothing while
# reporting a confident zero (REDS %169). The pen the control builds stays flat, which a depth of
# two still reaches.
find "$TOOLS" -maxdepth 2 -name 'caravan_*_witness.rish' -type f \
  | sed 's:.*/::; s:\.rish$::' \
  | grep -v '^caravan_suite_witness$' \
  | sort > "$work/disk"

# The names the roster registers, likewise bare and sorted.
grep -oE 'caravan_[a-z0-9_]+_witness' "$ROSTER" \
  | grep -v '^caravan_suite_witness$' \
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
