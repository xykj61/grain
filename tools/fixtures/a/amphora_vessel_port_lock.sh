#!/usr/bin/env sh
# tools/fixtures/a/amphora_vessel_port_lock.sh -- run one command holding the vessel port pair.
#
# WHY. amphora/vessel_fetch_delivery.rye binds UDP 38494 and 38495, and those two numbers are
# compiled in. A port belongs to the machine rather than to a checkout, and this pier runs eight
# trees whose roster passes overlap freely, so two runs reach for the same pair. SO_REUSEADDR lets
# both bind, which means the collision is silent: a fetcher's request lands at the wrong source,
# and the answer it waits for never comes. Measured 20260906 before the module was bounded, two
# witnesses started together stalled past ten minutes where each alone finishes in two seconds.
#
# HOW WIDE THIS LOCK IS, MEASURED IN THE CONFIGURATION THAT IS RUNNING. The header above read
# *the lock is taken at a HOST path, on purpose ... a lock under eight roots is eight locks and no
# mutual exclusion at all*, and chose TMPDIR to escape those eight roots. Whether TMPDIR escapes
# them is a fact about how the ship was LAUNCHED, so it is measured here rather than assumed.
#
# ON THIS PIER, `20260906.175330`, TMPDIR IS HOST-WIDE and this lock does the job it claims. Five
# fleet loops and eight trees stood live. Every fleet process shared one mount namespace
# (`mnt:[4026531832]`, the host's initial one); this tree read a peer ship's
# `/tmp/grass-cold-open.txt` while that ship was writing it, and read
# `/home/keeper/grain-grass/README.md` besides. The roster agreed from its own side, skipping
# `agent_jail_enclosure` with `wants=jail_nesting here=absent`.
#
# A JAILED SHIP GIVES THE OPPOSITE ANSWER, and that reading is real too. Measured inside the
# enclosure the same day: a private mount namespace, `/tmp` the ship's own tmpfs, and a private PID
# table, so the `kill -0` testing a lock owner's liveness reads another ship's number. There this
# file is eight locks -- the shape it was written to avoid. Both readings are honest and they
# describe different launches, so the elder line *the lock reaches one tree, not the pier* is true
# jailed and false bare, and it was written as though the launch were settled. That is this row's
# own subject one level up: an environment claim is one command from being a measurement, and
# WHICH CONFIGURATION IS RUNNING is part of the claim. REDS `20260906.154105`.
#
# WHAT IT STILL DOES, under either launch. It excludes two runs WITHIN one tree, which is what its
# own measurement above actually proved -- two `chunkdemo` runs started together, necessarily in
# one checkout. That is a real job and this file does it.
#
# WHAT COVERS THE PIER UNDER EITHER LAUNCH. `amphora/vessel_fetch_delivery.rye` no longer sets
# SO_REUSEADDR, so a second reacher for a held port is refused by the kernel with
# `error.BindFailed`. That refusal is taken in the NETWORK namespace, which reads
# `net:[4026531833]` both inside the enclosure and outside it -- the same inode, because ai-jail is
# Landlock, and Landlock is a filesystem LSM that never touches networking. So it is exactly as
# wide as the resource however the ship started, and it is the only mutual exclusion here whose
# width is not a question about the launch.
#
# WHAT THIS IS NOT. It is not the repair -- the repair is in the module, which now binds before it
# sends, holds one socket across an exchange, and bounds every receive with a named error. This is
# what keeps two lawful runs from meeting at all, so the module's bound stays a floor nobody hits.
# A lock is never a substitute for a bounded wait, and both stand.
#
# USAGE, from the repository root:
#   sh tools/fixtures/a/amphora_vessel_port_lock.sh <command> [args...]
#
# The command's own exit code is this script's exit code, so a caller reads the guard rather than
# the lock. A wait that runs out refuses by name and exits 1 -- eight ships needing three seconds
# apiece cannot spend 120, so an expiry here means a lock nobody released, and saying so is more
# use than waiting longer.
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

[ "$#" -ge 1 ] || { echo "$0: name a command to run under the vessel port lock" >&2; exit 2; }

# Named here and checked at the edge below: the exchange itself takes about two seconds, and eight
# ships queueing on it want well under a minute. Two minutes leaves room for a loaded pier and
# still refuses rather than hanging.
max_lock_wait_seconds=120

port_lock="${TMPDIR:-/tmp}/grain-amphora-vessel-port-38494.lock"
lock_acquire "$port_lock" "$max_lock_wait_seconds" || {
  echo "$0: vessel port pair 38494/38495 held elsewhere for ${max_lock_wait_seconds}s -- $port_lock" >&2
  exit 1
}
trap 'lock_release "$port_lock"' EXIT

"$@"
