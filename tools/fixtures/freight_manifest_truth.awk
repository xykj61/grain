# tools/fixtures/freight_manifest_truth.awk — an independent measurement of a Freight manifest fixture.
#
# The Freight rung four witness cross-checks what mycelium/freight_true reports against this awk's reading of
# the same real bytes — two tools, one answer — so a world's carried position can never drift from a record a
# keeper can open and read by hand. It reads the three position lines (`balance`, `reserved`, `received`) and
# prints the triple `<balance> <reserved> <received>`. The app parses the same record through the Freight's
# own reader and re-derives the position from the world's real ledger; this awk measures the position a keeper
# reads straight off the manifest, blind to the ledger behind it.
#
#   awk -f tools/fixtures/freight_manifest_truth.awk tools/fixtures/freight_manifest.bron
#   -> "<balance> <reserved> <received>"

$1 == "balance"  { balance = $2 }
$1 == "reserved" { reserved = $2 }
$1 == "received" { received = $2 }
END { print balance, reserved, received }
