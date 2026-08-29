#!/usr/bin/env sh
# enclosure_gate.sh -- the one door a launcher enters its enclosure through.
#
# WHAT THIS IS FOR. Every launcher that honours the ENCLOSURE selector asks the same
# question at start: which enclosure may this launch enter? This script is that question's
# one answer. It reads ENCLOSURE (default ai-jail), admits `pond` only after
# tools/p/pond_exit_bron_master_seal.sh --require returns zero -- the custody boundary
# for the season flip, a detached signature against the cold master fingerprint alone --
# refuses any other value, and prints the admitted value on stdout. A launcher calls:
#
#   ENCLOSURE="$(ENCLOSURE="${ENCLOSURE:-}" sh "$REPO_ROOT/tools/e/enclosure_gate.sh")" || exit 1
#
# The explicit ENCLOSURE= prefix matters: enclosure.conf may set the selector without
# exporting it, and a subshell that cannot see the selector would admit ai-jail while the
# hand asked for pond -- a silent downgrade this line makes impossible.
#
# WHY ONE DOOR. This gate stood written three times -- tools/ag/agent-jail.sh,
# tools/cu/cursor-jail.sh, tools/l/launch-zed.sh.example -- sharing zero literal lines
# with drift already begun: two carried a dead EXIT_BRON assignment the seal sets for
# itself, one did not (read by tools/fixtures/p/pond_seal_gate_scan.sh, 20260829). One
# door means the scan gates one admission site, and retiring ai-jail becomes one
# deletion here when Pond lands, rather than three edits that may disagree.
#
# WHY POSIX SH. The launch layer runs on a fresh clone before anything is built, so the
# door speaks the one language every host already has. The .sh-to-.rish molt rule reaches
# operational tools a hand runs inside a working tree; the bootstrap-and-custody layer
# stays sh by that same rule's own reason -- strict, capable tools EARLY means tools that
# exist at second zero.
#
# ACCRETE-ONLY. Admitting is all this does. The selector stays ai-jail until the
# switchover round lands behind its audit; this door flips nothing.
#
# KIN, the way home: the seal it reaches is tools/p/pond_exit_bron_master_seal.sh;
# the guard that reads it is tools/fixtures/p/pond_seal_gate_scan.sh under
# tools/p/pond_seal_gate_witness.rish; the quest it serves is
# expanding-prompts/20260826-033051_pond-completes-the-enclosure.md (Pond retires
# ai-jail); the custody law is the gates block of construction/ITINERARY.md.
set -eu

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

ENCLOSURE="${ENCLOSURE:-ai-jail}"

# invariant: pond counts only behind the master seal -- its OK/REFUSE prose goes to
# stderr so stdout stays the one admitted word a caller captures.
if [ "$ENCLOSURE" = "pond" ]; then
  if ! sh "${REPO_ROOT}/tools/p/pond_exit_bron_master_seal.sh" --require >&2; then
    exit 1
  fi
elif [ "$ENCLOSURE" != "ai-jail" ]; then
  echo "REFUSE: ENCLOSURE must be ai-jail or pond (got: ${ENCLOSURE})" >&2
  exit 1
fi

printf '%s\n' "$ENCLOSURE"
