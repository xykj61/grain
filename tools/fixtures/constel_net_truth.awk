# tools/fixtures/constel_net_truth.awk — an independent measurement of a constel-net fixture.
#
# The Constel dev-net harness rung four witness cross-checks what constel_net_true reports against this
# awk's reading of the same real bytes — two tools, one answer — so a fake net's roster can never drift
# from a record a keeper can open and count by hand. It counts `point` lines (the roster size), captures
# the first point (the galaxy the branch is crowned by) and the last point (the deepest member, the
# planet), and prints the triple. The `net` line's safe name is checked in the app, not here — this awk
# measures the roster shape a keeper counts.
#
#   awk -f tools/fixtures/constel_net_truth.awk tools/fixtures/constel_net.bron
#   -> "<points> <galaxy> <planet>"

/^point / { count += 1; if (count == 1) galaxy = $2; planet = $2 }
END { print count, galaxy, planet }
