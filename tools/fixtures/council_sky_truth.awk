# tools/fixtures/council_sky_truth.awk — an independent measurement of a council fixture.
#
# DAHL-J11r4's witness cross-checks what council_sky_true reports against this awk's reading of the same
# real bytes — two tools, one answer — so a council's shape and its decisions can never drift from a
# record a keeper can open and count by hand. It reads the seated size from the `council` line (field 6),
# computes the majority quorum (int(size/2)+1), counts ballots (one per distinct seat,proposal), tallies
# yes and no per proposal, and counts decided proposals: a proposal whose yes-tally OR no-tally reaches
# the quorum. Because the body is odd, at most one side ever reaches it, so a decided proposal is decided
# one way. A proposal short of quorum on both sides holds open and is not counted.
#
#   awk -f tools/fixtures/council_sky_truth.awk skate/fixtures/council.bron
#   -> "<size> <ballots> <decided>"

/^council / { size = $6; quorum = int(size / 2) + 1 }
/^ballot / {
    seat = $2; prop = $3; yea = $4
    # count each (seat, proposal) once, so one seat never counts twice
    pair = seat "," prop
    if (!(pair in seen)) {
        seen[pair] = 1
        ballots += 1
        props[prop] = 1
        if (yea + 0 == 1) yes[prop] += 1
        else no[prop] += 1
    }
}
END {
    decided = 0
    for (p in props) {
        if (yes[p] + 0 >= quorum + 0 || no[p] + 0 >= quorum + 0) decided += 1
    }
    print size, ballots, decided
}
