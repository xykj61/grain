# tools/fixtures/pledge_dag_truth.awk — an independent measurement of a two-phase-transfer Cord fixture.
#
# The Mycelium Pledge rung four witness cross-checks what mycelium/pledge_true reports against this awk's
# reading of the same real bytes — two tools, one answer — so the HONORED recipient of a two-phase transfer
# can never drift from an order a keeper can walk by hand. It reads each
# `block <author> <round> <kind> <amount> <star> <body> <signer> ...` line and tracks pledges by the phase
# tag its signed body carries. A kind-2 (tax) line's body ($7) is hex: its first byte is the phase tag —
# "50" = P (pledge), "48" = H (post), "56" = V (void). A pledge line seats an open pledge under its 16-byte
# id (hex chars 3..34) and records its 32-byte recipient (hex chars 35..98); a post line honors the open
# pledge of that id (naming its recipient the honored one, the first is the fingerprint); a void line
# releases it. It applies the simplest honest slice of the agreed order — pledge-state accounting in file
# order, which is round-ascending here. This slice is honest on this fixture because the genesis is first,
# every pledge is affordable, and the single post unambiguously honors the round-1 pledge before the round-3
# pledge is even seated — so the app's full commit tie-break and this file-order accounting name the same
# honored recipient. It prints the triple `<honored-recipient-hex> <posted> <open>`.
#
#   awk -f tools/fixtures/pledge_dag_truth.awk tools/fixtures/pledge_dag.bron
#   -> "<honored-recipient-hex> <posted> <open>"

$1 == "block" && $4 == 2 {                        # a two-phase phase rides a kind-2 fact
    tag = substr($7, 1, 2)
    id = substr($7, 3, 32)                        # the 16-byte pledge id, hex
    if (tag == "50") {                            # P — a pledge seats an open reservation
        seated += 1
        pto[id] = substr($7, 35, 64)              # its 32-byte recipient, hex
    } else if (tag == "48") {                     # H — a post honors an open pledge
        if ((id in pto) && (state[id] == "")) {
            state[id] = "posted"
            posted += 1
            if (honored == "") honored = pto[id]
        }
    } else if (tag == "56") {                     # V — a void releases an open pledge
        if ((id in pto) && (state[id] == "")) {
            state[id] = "voided"
            voided += 1
        }
    }
}

END {
    open = seated - posted - voided
    print honored, posted, open
}
