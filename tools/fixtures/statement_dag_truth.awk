# tools/fixtures/statement_dag_truth.awk — an independent measurement of one account's own line.
#
# The Mycelium Statement rung four witness cross-checks what mycelium/statement_true reports against this
# awk's reading of the same real bytes — two tools, one answer — so an account's own line (WHERE DO I STAND?)
# can never drift from an order a keeper can walk by hand. It reads the Lapse's own fixture, a per-account
# deadline-clock ledger, keeping a running balance · reserved · received per account keyed by the hex fields
# the record already carries.
#
# It reads each `block <author> <round> <kind> <amount> <star> <body> <signer> ...` line. The CHOSEN account
# is the one genesis funds: the recipient ($7) of the first kind-1 (issue) fact — exactly how the app chooses
# it (the account whose received equals what genesis issued), so neither tool picks a favorite by a constant.
#
# A kind-1 (issue) line credits its `body` recipient ($7) `amount` ($5): balance and received both rise. A
# kind-2 (tax) line's body ($7) is hex whose first byte is a phase tag — "50" = P (pledge), "48" = H (post),
# "56" = V (void); a pledge body is tag(1) id(16) deadline(8, little-endian u64) recipient(32): hex chars
# 1..2 tag, 3..34 id, 35..50 deadline, 51..114 recipient. The signer ($8) is the pledger. A pledge RESERVES
# `amount` from the signer (balance down, reserved up). BEFORE applying each fact, the clock ticks: every
# still-open pledge whose deadline the running file position has reached (deadline <= pos) LAPSES — its coins
# come home to the pledger (balance up, reserved down), exactly as mycelium/lapse.rye's fold ticks the clock.
# A post on a still-open pledge pays the recipient (signer's reserved down, recipient balance and received up);
# a void on a still-open pledge brings the coins home (signer's reserved down, balance up).
#
# It applies the simplest honest slice of the agreed order — per-account deadline-clock accounting in file
# order, which is round-ascending here. This slice is honest on this fixture because the genesis is first,
# every pledge opens affordably, and the order is unambiguous by round — so the app's full resolve and this
# file-order accounting name the same position. It prints `<chosen-account-hex> <balance> <reserved> <received>`.
#
#   awk -f tools/fixtures/statement_dag_truth.awk tools/fixtures/lapse_dag.bron
#   -> "<chosen-account-hex> <balance> <reserved> <received>"

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
    # Tick the clock before the fact lands: lapse every open pledge the running position has reached, its
    # coins coming home to the pledger who reserved them.
    for (id in pstate)
        if (pstate[id] == "open" && pdeadline[id] <= pos) {
            pstate[id] = "lapsed"
            balance[pfrom[id]] += pamt[id]
            reserved[pfrom[id]] -= pamt[id]
        }

    if ($4 == 1) {                                # an issue credits its recipient account
        balance[$7] += $5 + 0
        received[$7] += $5 + 0
        if (chosen == "") chosen = $7             # the genesis-funded account — the one whose line we read
    } else if ($4 == 2) {                         # a deadline phase rides a kind-2 fact
        tag = substr($7, 1, 2)
        id = substr($7, 3, 32)                    # the 16-byte pledge id, hex
        signer = $8                               # the pledger — the account whose coins the phase moves
        amt = $5 + 0
        if (tag == "50") {                        # P — a pledge reserves coins from the signer under a deadline
            pstate[id] = "open"
            pdeadline[id] = le64(substr($7, 35, 16))
            pto[id] = substr($7, 51, 64)          # its 32-byte intended recipient, hex
            pfrom[id] = signer
            pamt[id] = amt
            balance[signer] -= amt
            reserved[signer] += amt
        } else if (tag == "48") {                 # H — a post honors an open pledge, paying the recipient
            if ((id in pstate) && (pstate[id] == "open")) {
                pstate[id] = "posted"
                reserved[pfrom[id]] -= amt
                balance[pto[id]] += amt
                received[pto[id]] += amt
            }
        } else if (tag == "56") {                 # V — a void releases an open pledge, coins home to the pledger
            if ((id in pstate) && (pstate[id] == "open")) {
                pstate[id] = "voided"
                reserved[pfrom[id]] -= amt
                balance[pfrom[id]] += amt
            }
        }
    }
    pos += 1
}

END { print chosen, balance[chosen], reserved[chosen], received[chosen] }
