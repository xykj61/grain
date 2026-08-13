# tools/fixtures/purse_dag_truth.awk — an independent measurement of a per-account double-spend Cord fixture.
#
# The Mycelium Purse rung four witness cross-checks what mycelium/purse_true reports against this awk's
# reading of the same real bytes — two tools, one answer — so the SPENT-OUT holder of a contested purse
# can never drift from an order a keeper can walk by hand. It reads each
# `block <author> <round> <kind> <amount> <star> <body> <signer> ...` line and keeps a per-account balance
# keyed by the hex fields the record already carries. A kind-1 (issue) line credits its `body` recipient
# ($7). A kind-2 (tax) line moves `amount` ($5) from its `signer` ($8) to its `body` recipient ($7) when the
# signer's running balance can pay it (a winning move, counted in `moved`); otherwise the signer's purse is
# spent and the transfer comes up short, naming that signer the spent-out loser (a lawful no-op — the first
# short is the fingerprint). It applies the simplest honest slice of the agreed order — per-account balance
# accounting in file order, which is round-ascending here. This slice is honest on this fixture because the
# genesis is first, the round-1 transfer is affordable, the uncontested onward move touches a different
# account, and the only transfer that comes short is the round-2 one — so the app's full commit tie-break and
# this file-order accounting name the same loser. It prints the triple `<loser-signer-hex> <moved> <short>`.
#
#   awk -f tools/fixtures/purse_dag_truth.awk tools/fixtures/purse_dag.bron
#   -> "<loser-signer-hex> <moved> <short>"

$1 == "block" && $4 == 1 {                       # an issue credits its recipient account
    balance[$7] += $5 + 0
}

$1 == "block" && $4 == 2 {                       # a transfer moves coins from the signer's purse
    from = $8
    to = $7
    amount = $5 + 0
    if (amount <= balance[from]) {                # the signer's purse can still pay this transfer
        balance[from] -= amount
        balance[to] += amount
        moved += 1
    } else {                                      # the signer's purse is spent — this transfer comes up short
        short += 1
        if (loser == "") loser = from
    }
}

END { print loser, moved, short }
