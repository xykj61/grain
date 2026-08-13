# tools/fixtures/puddle_fleet_truth.awk — an independent measurement of a Puddle fleet fixture.
#
# The Puddle rung four witness cross-checks what mycelium/puddle_true reports against this awk's reading of
# the same real bytes — two tools, one answer — so a fleet's shape can never drift from a record a keeper
# can open and count by hand. It reads each `host <pk-hex> <capacity>` line (counting hosts and summing the
# capacity column) and each `world <id>` line (counting worlds), and prints the triple
# `<hosts> <worlds> <total-capacity>`. The host keys are checked in the app, which parses the record
# through the Puddle's own reader and berths every world; this awk measures the roster shape a keeper
# counts, blind to the placement.
#
#   awk -f tools/fixtures/puddle_fleet_truth.awk tools/fixtures/puddle_fleet.bron
#   -> "<hosts> <worlds> <total-capacity>"

$1 == "host" {
    hosts += 1
    capacity += $3
}
$1 == "world" {
    worlds += 1
}
END { print hosts, worlds, capacity }
