#!/bin/sh
# comlink/run_wire_lab.sh -- the one wire-lab entry body, lab named as the argument.
#
# Usage, from any directory:
#   sh comlink/run_wire_lab.sh <lab>
# where <lab> is the middle of a run_<lab>_wire_lab.sh name: device, murr,
# recall_batch, vessel_fetch, and kin. An unknown or missing lab is refused
# with the roster, read live from tools/co/ rather than spelled here.
#
# The fifteen named entry points (run_device_wire_lab.sh and kin) stay as stable
# shims delegating here -- design docs, guest headers, and the living tools/*.rish
# callers keep the paths they already promise, and each shim keeps its own one-line
# account of what its lab proves. Until 20260829 each shim carried this whole body;
# fifteen copies of one body are fifteen files that may quietly come to disagree.
#
# Why this file is .sh rather than .rish: it is the bootstrap seam. A .rish script
# needs the repo-relative rishi/bin/rishi already found, and Rishi binds a script
# no equivalent of $0, so only a POSIX shim can locate the root from its own path.
# Orchestration -- build guests, spawn QEMU, assert GREEN -- lives in
# tools/co/comlink_<lab>_wire_lab.rish, in Rishi, where it already molted.
#
# KIN, the way home: the orchestrators are tools/co/comlink_*_wire_lab.rish (each
# names the shim it replaced); their guests live beside them as .rye sources; the
# .sh-to-.rish molt rule this seam honestly stops at is named on the living card,
# construction/ITINERARY.md (an operational script molts on substantial touch).
set -eu

here="$(cd "$(dirname "$0")" && pwd)"
repo="$(cd "$here/.." && pwd)"
cd "$repo"

# invariant: the roster is read from the directory that holds the labs, so a lab
# born tomorrow appears in the refusal the day it lands, with no list to go stale.
roster() {
  for f in tools/co/comlink_*_wire_lab.rish; do
    b="${f#tools/co/comlink_}"
    echo "  ${b%_wire_lab.rish}" >&2
  done
}

lab="${1:-}"
if [ -z "$lab" ]; then
  echo "run_wire_lab.sh: name a lab. Roster:" >&2
  roster
  exit 2
fi

target="tools/co/comlink_${lab}_wire_lab.rish"
if [ ! -f "$target" ]; then
  echo "run_wire_lab.sh: no lab named '${lab}' -- expected ${target}. Roster:" >&2
  roster
  exit 2
fi

exec rishi/bin/rishi run "$target"
