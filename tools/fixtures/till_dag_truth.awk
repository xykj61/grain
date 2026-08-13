# tools/fixtures/till_dag_truth.awk — an independent measurement of a double-spend Cord dev-net fixture.
#
# The Mycelium Till rung four witness cross-checks what mycelium/till_true reports against this awk's
# reading of the same real bytes — two tools, one answer — so the SPENT-OUT draw of a contested treasury
# can never drift from an order a keeper can walk by hand. It reads each
# `block <author> <round> <kind> <amount> <star> <body> <signer> ...` line: a kind-1 line issues into the
# treasury, a kind-2 (tax) or kind-3 (reserve) line draws from it. It applies the simplest honest slice of
# the Cord's agreed order — supply accounting in file order, which is round-ascending here — subtracting
# each draw that the running supply can still pay (a winning draw) and naming the signer of the first draw
# the treasury can no longer pay as the spent-out loser (a lawful no-op). This slice is honest on this
# fixture because the genesis is first, the two round-1 draws (100 + 700) both fit whatever their order, and
# the only draw that comes short is the round-2 draw — so the app's full commit tie-break and this file-order
# accounting name the same loser. It prints the triple `<loser-signer-hex> <drew> <short>`.
#
#   awk -f tools/fixtures/till_dag_truth.awk tools/fixtures/till_dag.bron
#   -> "<loser-signer-hex> <drew> <short>"

$1 == "block" && $4 == 1 {                       # an issue funds the treasury
    supply += $5 + 0
}

$1 == "block" && ($4 == 2 || $4 == 3) {          # a tax or reservation draws from it
    amount = $5 + 0
    if (amount <= supply) {                       # the agreed order can still pay this draw
        supply -= amount
        drew += 1
    } else {                                      # the treasury is spent — this draw comes up short
        short += 1
        if (loser == "") loser = $8
    }
}

END { print loser, drew, short }
