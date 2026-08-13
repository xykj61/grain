# tools/fixtures/skate_group_truth.awk — an independent measurement of a Skate group fixture.
#
# DAHL-J10r4's witness cross-checks what skate_group_true reports against this awk's reading of the same
# real bytes — two tools, one answer — so a group's roster and its admissions can never drift from a
# record a keeper can open and count by hand. It reads the quorum from the `group` line, counts founders
# (one per `founder` line), counts votes (one per `vote` line), tallies distinct votes per candidate, and
# counts admitted candidates: a candidate whose distinct-vote tally reaches the quorum. A candidate short
# of quorum holds and is not counted among the admitted.
#
#   awk -f tools/fixtures/skate_group_truth.awk skate/fixtures/group.bron
#   -> "<founders> <votes> <admitted>"

/^group /   { quorum = $3 }
/^founder / { founders += 1 }
/^vote / {
    voter = $2; candidate = $3
    # count each (voter, candidate) pair once, so one hand never counts twice
    pair = voter "," candidate
    if (!(pair in seen_vote)) {
        seen_vote[pair] = 1
        tally[candidate] += 1
        votes += 1
    }
}
END {
    admitted = 0
    for (c in tally) {
        if (tally[c] + 0 >= quorum + 0) admitted += 1
    }
    print founders, votes, admitted
}
