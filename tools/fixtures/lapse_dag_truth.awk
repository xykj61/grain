# tools/fixtures/lapse_dag_truth.awk — an independent measurement of a deadline-clock Cord fixture.
#
# The Mycelium Lapse rung four witness cross-checks what mycelium/lapse_true reports against this awk's
# reading of the same real bytes — two tools, one answer — so the LAPSED recipient of a reservation the
# order let expire can never drift from an order a keeper can walk by hand. It reads each
# `block <author> <round> <kind> <amount> <star> <body> <signer> ...` line and tracks pledges by the phase
# tag its signed body carries, and by the DEADLINE that body names. A kind-2 (tax) line's body ($7) is hex:
# its first byte is the phase tag — "50" = P (pledge), "48" = H (post), "56" = V (void). A pledge body is
# tag(1) id(16) deadline(8, little-endian u64) recipient(32): hex chars 1..2 tag, 3..34 id, 35..50 deadline,
# 51..114 recipient.
#
# The clock is the running position of each block in file order (0-based). BEFORE applying the fact at a
# block, this awk lapses every still-open pledge whose deadline the running position has reached
# (deadline <= pos), exactly as mycelium/lapse.rye's fold ticks the clock before it applies each fact — so a
# post the order places at or past the deadline finds the pledge already lapsed. It applies the simplest
# honest slice of the agreed order — deadline-clock accounting in file order, which is round-ascending here.
# This slice is honest on this fixture because the genesis is first, every pledge opens affordably, and the
# order is unambiguous by round — so the app's full commit tie-break and this file-order accounting name the
# same lapsed recipient. It prints the triple `<lapsed-recipient-hex> <lapsed> <open>`.
#
#   awk -f tools/fixtures/lapse_dag_truth.awk tools/fixtures/lapse_dag.bron
#   -> "<lapsed-recipient-hex> <lapsed> <open>"

BEGIN {
    for (i = 0; i < 16; i++) hx[substr("0123456789abcdef", i + 1, 1)] = i
    pos = 0
}

# Little-endian u64 from a 16-hex-char field — the deadline as it rides the pledge body.
function le64(s,   v, b, i) {
    v = 0
    for (i = 0; i < 8; i++) {
        b = hx[substr(s, i * 2 + 1, 1)] * 16 + hx[substr(s, i * 2 + 2, 1)]
        v = v + b * (256 ^ i)
    }
    return v
}

$1 == "block" {
    # Tick the clock before the fact lands: lapse every open pledge the running position has reached.
    for (id in pstate)
        if (pstate[id] == "open" && pdeadline[id] <= pos) {
            pstate[id] = "lapsed"
            lapsed += 1
            if (lapsed_to == "") lapsed_to = pto[id]
        }

    if ($4 == 2) {                                # a deadline phase rides a kind-2 fact
        tag = substr($7, 1, 2)
        id = substr($7, 3, 32)                    # the 16-byte pledge id, hex
        if (tag == "50") {                        # P — a pledge seats an open reservation under a deadline
            seated += 1
            pstate[id] = "open"
            pdeadline[id] = le64(substr($7, 35, 16))
            pto[id] = substr($7, 51, 64)          # its 32-byte intended recipient, hex
        } else if (tag == "48") {                 # H — a post honors an open pledge (a no-op once lapsed)
            if ((id in pstate) && (pstate[id] == "open")) {
                pstate[id] = "posted"
                posted += 1
            }
        } else if (tag == "56") {                 # V — a void releases an open pledge
            if ((id in pstate) && (pstate[id] == "open")) {
                pstate[id] = "voided"
                voided += 1
            }
        }
    }
    pos += 1
}

END {
    open = seated - posted - voided - lapsed
    print lapsed_to, lapsed, open
}
