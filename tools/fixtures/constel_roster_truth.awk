# tools/fixtures/constel_roster_truth.awk — an independent measurement of a Constel roster fixture.
#
# The Constel rung four witness cross-checks what mycelium/constel_true reports against this awk's reading of
# the same real bytes — two tools, one answer — so a named dev-net constellation can never drift from a
# roster a keeper can open and read by hand. It counts the `ship` lines and reads the first eight hex
# characters of the first ship's key, printing the pair `<count> <firstkey8>`. The app derives the same pair
# INDEPENDENTLY by booting the constellation from its ship names (each key a pure function of its name),
# blind to the record text; this awk measures what a keeper reads straight off the roster.
#
#   awk -f tools/fixtures/constel_roster_truth.awk tools/fixtures/constel_roster.bron
#   -> "<count> <firstkey8>"

$1 == "ship" { count++; if (count == 1) key8 = substr($3, 1, 8) }
END { print count, key8 }
