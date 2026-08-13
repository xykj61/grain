# tools/fixtures/portage_record_truth.awk — an independent measurement of a Portage record fixture.
#
# The Portage rung four witness cross-checks what mycelium/portage_true reports against this awk's reading of
# the same real bytes — two tools, one answer — so a crossing's carried value can never drift from a record a
# keeper can open and read by hand. It reads the `amount` line and the first eight hex characters of the
# `digest` line, and prints the pair `<amount> <digest8>`. The app parses the same record through the
# Portage's own reader and, independently of the record text, derives the amount by accepting the crossing
# against both worlds' real rebuilt ledgers and the digest from the crossing's own content seeds; this awk
# measures what a keeper reads straight off the receipt, blind to the ledgers behind it.
#
#   awk -f tools/fixtures/portage_record_truth.awk tools/fixtures/portage_record.bron
#   -> "<amount> <digest8>"

$1 == "amount" { amount = $2 }
$1 == "digest" { digest8 = substr($2, 1, 8) }
END { print amount, digest8 }
