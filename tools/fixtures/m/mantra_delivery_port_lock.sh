#!/usr/bin/env sh
# tools/fixtures/m/mantra_delivery_port_lock.sh -- run one command holding a mantra delivery port pair.
#
# WHY. Modules under mantra/ bind two compiled-in UDP ports apiece, and a port belongs to the
# MACHINE. This pier runs eight trees whose roster passes overlap freely, so two lawful runs reach
# one pair as a matter of course.
#
# THE ROSTER IS COUNTED HERE RATHER THAN SPELLED (`20260911.145000`). This paragraph read *seven
# modules ... 38478/38479 through 38490/38491* and named *two of the seven* --
# snapshot_export_delivery and recall_tablecloth_query_delivery -- as binding the SAME pair
# 38490/38491. Every word was true when it was typed. The second sentence went stale the same
# morning: the tablecloth delivery module took the bind-to-zero handshake at `20260911.105415` and
# let 38490/38491 go. So the double claim stood in one place alone, and that place was this file. A
# sentence holding a roster is a roster a hand must re-type. Read the roster instead:
#
#   sh tools/fixtures/p/port_band_scan.sh --list
#
# which counts every `const <name>_port: u16 = <number>;` in living tracked Rye, names every number
# two modules claim, offers the free numbers inside the room's seated band, and holds this file's
# own edge band below against the ports mantra/ actually declares. Gated by
# tools/p/port_band_witness.rish.
#
# WHAT THE MODULE ALREADY DOES, so this file is never mistaken for the repair. As of `20260911`
# none of the seven sets SO_REUSEADDR: each reads the option back and asserts it zero, so a second
# reacher for a held port is refused by the kernel with `error.BindFailed`, in the network
# namespace, needing no lock to be right. Measured that day against a foreign holder of 38491: the
# repaired binary refuses and names the port on its first stderr line, where the elder one bound
# beside the holder and printed GREEN. This lock is what keeps two LAWFUL runs from meeting at all,
# so the module's refusal stays a floor nobody hits. A lock is never a substitute for a named
# refusal, and both stand.
#
# HOW WIDE IT IS, and why that is a measurement rather than a claim. The lock is taken at
# ${TMPDIR:-/tmp}. On this pier launched bare -- which is how the fleet runs, FLEET_BARE=1 -- every
# ship shares the host mount namespace, so TMPDIR is host-wide and this lock excludes the whole
# pier. Inside ai-jail a ship gets a private /tmp and a private pid table, so there it is eight
# locks and excludes two runs within ONE tree alone. Both readings are honest and they describe
# different launches; the sibling amphora/ lock records the same fact measured on metal, at
# tools/fixtures/a/amphora_vessel_port_lock.sh. The module's own BindFailed is the only exclusion
# here whose width is not a question about the launch.
#
# USAGE, from the repository root:
#   sh tools/fixtures/m/mantra_delivery_port_lock.sh <low-port> <command> [args...]
#
# The pair is named by its LOW port -- 38490 for the 38490/38491 exchange -- so two witnesses on one
# pair take one lock and two on different pairs never wait on each other. The command's own exit
# code is this script's exit code, so a caller reads the guard rather than the lock.
set -u

# Root by upward walk (seated 20260828): the letter fold moves a script a directory deeper, and
# fixed ../.. depth arithmetic is what breaks. Bounded at 8 steps, loud past the bound.
ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$ROOT/rishi/bin" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done
. "$ROOT/tools/fixtures/s/shell_portable.sh"

[ "$#" -ge 2 ] || { echo "$0: name a low port and a command -- e.g. 38490 mantra/bin/snapshot-export-delivery selftest" >&2; exit 2; }

low_port=$1
shift

# Checked at the edge: a number outside this run names a pair this lock would have to invent. The
# band is named by hand, since an edge check must answer before it reads anything, and the roster
# reading above HOLDS it -- `lock_band_uncovered` reds when a mantra module opens a pair past 38490,
# so the next module to arrive is caught by that guard. A pair's HIGH port arrives here never: the
# lock is taken on the low one, 38490 for the 38490/38491 exchange. That is why 38491 stands inside
# mantra/ and outside this range, with both readings correct.
case "$low_port" in
  ''|*[!0-9]*) echo "$0: low port must be a number -- got [$low_port]" >&2; exit 2 ;;
esac
if [ "$low_port" -lt 38478 ] || [ "$low_port" -gt 38490 ]; then
  echo "$0: $low_port is outside the mantra delivery range 38478-38490" >&2
  exit 2
fi

# Named here and checked at the edge below: one exchange takes about two seconds and the slowest of
# these witnesses builds first, so eight ships queueing want well under five minutes. Three minutes
# leaves room for a loaded pier and still refuses rather than hanging -- an expiry here means a lock
# nobody released, and saying so is more use than waiting longer.
max_lock_wait_seconds=180

port_lock="${TMPDIR:-/tmp}/grain-mantra-delivery-port-${low_port}.lock"
lock_acquire "$port_lock" "$max_lock_wait_seconds" || {
  echo "$0: mantra delivery port pair ${low_port}/$((low_port + 1)) held elsewhere for ${max_lock_wait_seconds}s -- $port_lock" >&2
  exit 1
}
trap 'lock_release "$port_lock"' EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

"$@"
