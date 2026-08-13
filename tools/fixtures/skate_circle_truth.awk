# tools/fixtures/skate_circle_truth.awk — an independent measurement of a Skate circle fixture.
#
# DAHL-J9r4's witness cross-checks what skate_circle_true reports against this awk's reading of the
# same real bytes — two tools, one answer — so a circle's membership and its mutual links can never
# drift from a record a keeper can open and count by hand. It counts members (one per `member` line),
# counts link requests (one per `link` line), and counts mutual links: an unordered pair {a,b} where
# both `link a b` and `link b a` appear. A one-sided request (only one direction present) is a hold,
# not a mutual link, and is not counted among them.
#
#   awk -f tools/fixtures/skate_circle_truth.awk skate/fixtures/circle.bron
#   -> "<members> <links> <mutual_links>"

/^member / { members += 1 }
/^link /   { from = $2; to = $3; seen[from "," to] = 1; links += 1 }
END {
    mutual = 0
    for (pair in seen) {
        split(pair, ft, ",")
        a = ft[1]; b = ft[2]
        # count each mutual pair once, when a < b, so {a,b} is not double-counted
        if ((b "," a) in seen && (a + 0) < (b + 0)) mutual += 1
    }
    print members, links, mutual
}
