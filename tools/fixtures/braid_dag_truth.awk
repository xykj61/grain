# tools/fixtures/braid_dag_truth.awk — an independent measurement of a linked-chain Cord fixture.
#
# The Mycelium Braid rung four witness cross-checks what mycelium/braid_true reports against this awk's
# reading of the same real bytes — two tools, one answer — so the ALL-OR-NOTHING verdict of a linked chain
# can never drift from an order a keeper can walk by hand. It reads each
# `block <author> <round> <kind> <amount> <star> <body> <signer> ...` line. A kind-1 (issue) line credits its
# body ($7, a 32-byte recipient key in hex) with its amount ($5). A kind-2 (tax) line is a braid link: its
# body ($7) is hex whose first byte is "4c" (the tag 'L'), then a 16-byte braid id (hex chars 3..34), a
# 1-byte sequence (chars 35..36), a 1-byte last flag (chars 37..38), and a 32-byte recipient (chars 39..102);
# the link's sender is the fact signer ($8) and its amount is $5.
#
# It seeds every account's balance from the genesis credits, gathers each braid's links by id and sequence,
# and when a braid closes (its last link seen) SIMULATES the chain atomically in file order (round-ascending
# here): walking the links in sequence, each sender must afford its transfer reading its balance forward
# through the chain's own earlier moves; if every link affords the chain COMMITS, if any cannot the whole
# chain REJECTS and no coin moves. This is the same atom the Braid's agreed-order resolution evaluates, and it
# is honest on this fixture because the genesis credits come first and the chain's links are round-ascending,
# so file order equals the agreed order. It prints the triple `<terminal-recipient-hex> <committed> <rejected>`.
#
#   awk -f tools/fixtures/braid_dag_truth.awk tools/fixtures/braid_dag.bron
#   -> "<terminal-recipient-hex> <committed> <rejected>"

function hexval(s,   i, c, v) {
    v = 0
    for (i = 1; i <= length(s); i++) {
        c = index("0123456789abcdef", substr(s, i, 1)) - 1
        v = v * 16 + c
    }
    return v
}

$1 == "block" && $4 == 1 {                        # a genesis credit funds one account
    bal[$7] += $5
}

$1 == "block" && $4 == 2 {                        # a braid link rides a kind-2 fact
    if (substr($7, 1, 2) != "4c") next            # the tag 'L' — anything else is not a link
    id = substr($7, 3, 32)                         # the 16-byte braid id, hex
    seq = hexval(substr($7, 35, 2))               # the 1-byte sequence
    last = hexval(substr($7, 37, 2))              # the 1-byte last flag
    lto[id, seq] = substr($7, 39, 64)             # the 32-byte recipient, hex
    lfrom[id, seq] = $8                            # the sender is the fact signer
    lamt[id, seq] = $5                             # the transfer amount
    ids[id] = 1
    if (last == 1) {                              # the final link closes the chain
        closed[id] = 1
        nlinks[id] = seq + 1
        term[id] = lto[id, seq]
    }
}

END {
    committed = 0
    rejected = 0
    termhex = ""
    for (id in ids) {
        if (!(id in closed)) continue             # an unclosed chain settles nothing
        n = nlinks[id]
        split("", d)                              # a fresh delta scratch per chain
        affords = 1
        for (s = 0; s < n; s++) {
            f = lfrom[id, s]
            t = lto[id, s]
            a = lamt[id, s]
            if (bal[f] + d[f] < a) { affords = 0; break }
            d[f] -= a
            d[t] += a
        }
        if (affords) committed += 1
        else rejected += 1
        termhex = term[id]
    }
    print termhex, committed, rejected
}
