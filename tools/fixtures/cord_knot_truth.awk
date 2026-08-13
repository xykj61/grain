# tools/fixtures/cord_knot_truth.awk — an independent measurement of a Knot fixture.
#
# The Mycelium checkpointing rung four witness cross-checks what mycelium/cord_knot_true reports against
# this awk's reading of the same real bytes — two tools, one answer — so a checkpointed net's sealed supply
# can never drift from a record a keeper can open and add up by hand. A `format cord-knot-v1` record carries
# the whole Knot on named lines: `issued <n>`, `taxed <n>`, one `star <hexname>` per reserved star, and
# `digest <hex>`. The supply is issued minus taxed — the Mycelium law, counted by hand; the stars are the
# `star` lines. It prints the pair `<supply> <stars>`. The digest and the sealed integrity are checked in
# the app, which parses the record and verifies the recovered Knot against its own digest; this awk measures
# only the supply arithmetic, blind to the seal.
#
#   awk -f tools/fixtures/cord_knot_truth.awk tools/fixtures/cord_knot.bron
#   -> "<supply> <stars>"

$1 == "issued" { issued = $2 }
$1 == "taxed"  { taxed = $2 }
$1 == "star"   { stars += 1 }
END { print issued - taxed, stars }
