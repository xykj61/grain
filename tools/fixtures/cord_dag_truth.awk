# tools/fixtures/cord_dag_truth.awk — an independent measurement of a Cord dev-net fixture.
#
# The Mycelium Cord rung four witness cross-checks what mycelium/cord_true reports against this awk's
# reading of the same real bytes — two tools, one answer — so a fake net's agreed supply can never drift
# from a record a keeper can open and add up by hand. It reads each
# `block <author> <round> <kind> <amount> ...` line: kind 1 is an issue (adds to issued), kind 2 a tax
# and kind 3 a star reservation (each drains, adding to taxed), and kind 3 also counts a star. It prints
# the triple `<blocks> <supply> <stars>`, where supply is issued minus taxed — the Mycelium law, counted
# by hand. The author keys, the parent hashes, and every signature are checked in the app, which rebuilds
# the Dag under the Cord's own `add` (re-verifying signatures) and folds the supply through the real law;
# this awk measures the supply arithmetic a keeper counts, blind to the graph structure.
#
#   awk -f tools/fixtures/cord_dag_truth.awk tools/fixtures/cord_dag.bron
#   -> "<blocks> <supply> <stars>"

$1 == "block" {
    blocks += 1
    if ($4 == 1) issued += $5
    else taxed += $5
    if ($4 == 3) stars += 1
}
END { print blocks, issued - taxed, stars }
