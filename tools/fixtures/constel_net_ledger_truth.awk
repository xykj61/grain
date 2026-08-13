# tools/fixtures/constel_net_ledger_truth.awk — an independent measurement of a constel-ledger fixture.
#
# The Constel dev-net ledger rung four witness cross-checks what constel_net_ledger_true reports against
# this awk's reading of the same real bytes — two tools, one answer — so a fake net's supply can never
# drift from a record a keeper can open and add up by hand. It reads each `fact <kind> <amount> ...`
# line: kind 1 is an issue (adds to issued), kind 2 a tax and kind 3 a star reservation (each drains,
# adding to taxed), and kind 3 also counts a reservation. It prints the triple
# `<facts> <supply> <reservations>`, where supply is issued minus taxed — the Mycelium law, counted by
# hand. The `net` line's safe name and the `sovereign` line's key are checked in the app (which re-folds
# and re-verifies the signatures); this awk measures the supply arithmetic a keeper counts.
#
#   awk -f tools/fixtures/constel_net_ledger_truth.awk tools/fixtures/constel_net_ledger.bron
#   -> "<facts> <supply> <reservations>"

$1 == "fact" {
    facts += 1
    if ($2 == 1) issued += $3
    else taxed += $3
    if ($2 == 3) reserves += 1
}
END { print facts, issued - taxed, reserves }
