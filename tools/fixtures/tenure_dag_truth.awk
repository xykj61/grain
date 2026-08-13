# tools/fixtures/tenure_dag_truth.awk — an independent measurement of a contested Cord dev-net fixture.
#
# The Mycelium Tenure rung four witness cross-checks what mycelium/tenure_true reports against this awk's
# reading of the same real bytes — two tools, one answer — so the WINNER of a contested name can never
# drift from an order a keeper can walk by hand. It reads each
# `block <author> <round> <kind> <amount> <star> <body> <signer> ...` line; a kind-3 line is a star
# reservation. It applies the simplest honest slice of the Cord's agreed order — earlier round wins — to
# the contested name "bandun" (hex 62616e64756e), naming the signer of the lowest-round reservation of
# that name as its holder, blind to the app's fold and commit machinery. It also counts the held names
# (distinct reserved stars) and the reservations (all kind-3 lines). It prints the triple
# `<winner-signer-hex> <held> <reservations>`. The app applies the FULL agreed-order tie-break; on this
# fixture the two rounds differ, so both name the same holder — that is the cross-check.
#
#   awk -f tools/fixtures/tenure_dag_truth.awk tools/fixtures/tenure_dag.bron
#   -> "<winner-signer-hex> <held> <reservations>"

$1 == "block" && $4 == 3 {
    reservations += 1
    star = $6
    if (!(star in seen)) { seen[star] = 1; held += 1 }
    if (star == "62616e64756e") {           # "bandun" — the contested name
        if (bround == "" || ($3 + 0) < bround) { bround = $3 + 0; winner = $8 }
    }
}
END { print winner, held, reservations }
