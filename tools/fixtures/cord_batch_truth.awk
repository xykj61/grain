# tools/fixtures/cord_batch_truth.awk — an independent measurement of a batched Cord dev-net fixture.
#
# The Mycelium fact-batching rung four witness cross-checks what mycelium/cord_batch_true reports against
# this awk's reading of the same real bytes — two tools, one answer — so a batched net's agreed supply can
# never drift from a record a keeper can open and add up by hand. Unlike the single-fact Cord record (where
# each `block` line carries its one fact), a `format cord-batch-v1` record carries the supply arithmetic on
# its `fact` lines: `fact <kind> <amount> <star> <body> <signer> <fsig>`. Kind 1 is an issue (adds to
# issued); kind 2 a tax and kind 3 a star reservation (each drains, adding to taxed); kind 3 also counts a
# star. Blocks are counted from the `block` lines. It prints the triple `<blocks> <supply> <stars>`, where
# supply is issued minus taxed — the Mycelium law, counted by hand. The author keys, parent hashes, and
# every signature are checked in the app, which rebuilds the Dag under add_batch (re-verifying signatures)
# and folds through the real law; this awk measures only the supply arithmetic, blind to the graph.
#
#   awk -f tools/fixtures/cord_batch_truth.awk tools/fixtures/cord_batch_dag.bron
#   -> "<blocks> <supply> <stars>"

$1 == "block" { blocks += 1 }
$1 == "fact" {
    if ($2 == 1) issued += $3
    else taxed += $3
    if ($2 == 3) stars += 1
}
END { print blocks, issued - taxed, stars }
