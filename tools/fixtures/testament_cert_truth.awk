# tools/fixtures/testament_cert_truth.awk — an independent measurement of a Testament certificate fixture.
#
# The Testament rung four witness cross-checks what mycelium/testament_true reports against this awk's reading
# of the same real bytes — two tools, one answer — so a named constellation's certificate can never drift
# from the one a keeper can open and read by hand. It counts the `ship` lines (the roster size) and reads the
# first eight hex characters of the `head` line (the reading the certificate seals), printing the pair
# `<ship_count> <head8>`. The app derives the same pair INDEPENDENTLY — the ship count by booting the roster
# from its names, the head by rebuilding the demo Dag and computing its true order-head — blind to the record
# text; this awk measures what a keeper reads straight off the certificate.
#
#   awk -f tools/fixtures/testament_cert_truth.awk tools/fixtures/testament_cert.bron
#   -> "<ship_count> <head8>"

$1 == "ship" { ships++ }
$1 == "head" { head8 = substr($2, 1, 8) }
END { print ships, head8 }
