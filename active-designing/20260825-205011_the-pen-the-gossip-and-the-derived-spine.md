# The pen, the gossip, and the derived spine

**Stamp:** `20260825.205011`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Mixed -- design, proposal; answers the %230 gate with a recommendation, and the seat stays Keaton's
**Kin:** [`../external-research/20260825-205011_hotstuff-and-hashgraph-read-for-the-piers.md`](../external-research/20260825-205011_hotstuff-and-hashgraph-read-for-the-piers.md) -- [`20260825-133156_three-real-mox-and-the-outer-loop.md`](20260825-133156_three-real-mox-and-the-outer-loop.md) -- REDS %230

## What today proved

Two piers wrote one tree today and every collision landed exactly where theory says it lands.
Both clones booked ledger row %226 from spines that each read perfect alone (REDS %230). Two
laps in a row, both writers prepended index rows at the same table line and met a rebase
conflict. And the pier's own repair -- keep the earlier stamp, shift the later rows, sweep the
citations -- was a derived-order algorithm executed by hand. This design names seven moves, in
rank, each with its falsifier. All of them reuse standing modules; two of them ask for a seat.

## Move 1 -- the spine derives, and this answers the %230 gate

**Recommendation: stamp-keyed rows, with the number derived at merge.** A row's immutable key is
its one-clock stamp. The %N is a view computed from the merged ledger: unshared rows sort by
stamp, earlier takes the lower number, ties break by commit hash. This is the third of the three
options the %230 row surfaced, and it is the one the repair already performed by hand. Codified,
the collision class dissolves into lawful order. The other two options decline on their own evidence.
Per-pier bands would cost the gapless 1..N spine the monotone witness proves whole. Bare
fetch-before-book shrinks a window the %230 pair already fell through while their trees *agreed*.

**The citation discipline ships in the same round, or the move is a trap.** 2,519 citations of %N
stand today (measured `20260823.173634`), 532 in immutable commit bodies. A lap cites its row **by
stamp** until the row reaches the shared spine, and only then by %N. Landing the allocator ahead of
this habit locks a stray number into testimony the first week.

**The interim discipline, until the derive tool lands:** book, then push at once to **one
anointed ordering remote**, and read its fast-forward refusal as the allocation failing -- the
refusal today's pier met is already a compare-and-set, once one remote is named the sequencer.

*Falsifiers:* two rows sharing a stamp to the second must resolve by the commit-hash tiebreak,
deterministically, on both piers; and a %N that changes after reaching the shared spine breaks
the design -- renumbering must be provably confined to unshared rows.

## Move 2 -- index tables become folds

The session-log index is a table both writers prepend at one line; two conflicts today are its
meter. The repair is the Tablecloth sentence applied to a README: **the surface is a fold over
the room**. Each log already carries stamp, title, and obs -- the row's whole content -- so one
tool regenerates the table newest-first from the room's own files, and a concurrent lap adds only
its uniquely-stamped log. Conflicts end structurally, and the fold that already orders
`session-logs/date/` shelves is the pattern on the shelf.

*Falsifier:* two regenerations of identical rooms yielding different bytes, or a row wanting
prose that lives in no log -- either means fix the fold or the log format, and hand-editing the
table again means the move failed.

## Move 3 -- the pen and its baton, named for what they already are

The three-MOX design elects a pen-holder per round through the contested-claim rule the order
already resolves. What the leader-rotation family adds is the **baton test**: a fresh pen-holder
needs one fetch and one read -- the latest signed nib, the GREEN witness line, and the living
card, landed in **one commit**. That triple is this tree's quorum certificate, and it already
exists; the same-commit git-nib rule turns out to be load-bearing safety rather than tidiness.
Taking the pen must never require interviewing the previous holder.

*Falsifier:* dry-run a pen takeover on a second pier using only `git fetch` and the card. Every
question the taker still has to ask a person or another machine is a failed test.

## Move 4 -- silence is never evidence: the stall certificate

A pier takes a stalled round only after writing a CHECKPOINTS row naming the evidence -- the last
nib, the stamp, what was tried. The checkpoint ledger already exists for exactly this shape of
record; this move points it at the constellation. A sleeping laptop is then *caught up* through
the offline-certificate rung the dev-net already proves, never routed around on quiet.

*Falsifier:* the first real mid-round sleep. A takeover on silence, or a woken sleeper and the
taker both holding the pen, means the certificate was missing or unread.

## Move 5 -- the quorum posture, chosen on purpose

Turn-taking runs crash-only two-of-three: one pier may sleep and the round still closes.
Byzantine arithmetic stays where value moves -- the till, the purse, the pledge -- and is declined
for the pen, since at three machines one person keys, the threat is a closed lid, and the roll's
own arithmetic prices every round at all-three-must-speak for zero tolerance bought. A fourth
passive voice (a key, never a machine) remains the upgrade to f=1 whenever the posture pinches.

*Falsifier:* Framework's first reboot mid-round -- a stall that catch-up does not cleanly heal
says the passive fourth key is due.

## Move 6 -- the absence policy, written down

The one governance hole the outside patterns exposed: the tree has yet to name what persists
while the maintainer is away. The policy wants three sentences seated. Standing words (the granted, bounded
kind) persist until their own bound. Agents continue indefinitely on the reversible -- prep,
witness, fossil, design. **No irreversible door ever un-gates by timeout.** The custody gates are
standing vetoes, and a veto outlives any calendar.

*Falsifier:* a week unattended. Reversible work that stalled names a missing standing word; an
irreversible act that proceeded names a violation.

## Move 7 -- the pacemaker line, stated as an invariant

Safety here is signing, fast-forward-only merges, witnesses on metal, and dated immutability --
and it must hold under **any** tenure outcome, rotation policy, stall, or takeover. Timing
machinery may change freely; history integrity never re-argues. The three-MOX wiring adopts this
as a written invariant, so a future pacemaker swap is a policy edit rather than a safety review.

*Falsifier:* any constructible sequence of tenure wins, stalls, and takeovers that yields a
force-push, a rewritten spine, or two mains claiming legitimacy. One such sequence means safety
leaked into the pacemaker.

## Two refusals, kept where they can be read

**Byzantine machinery for the pen** -- declined; Move 5 says why, and the matured lineage's own
lesson is never to tax the happy path to armor a failure this deployment does not face. **A
community clock by median** -- declined; over two or three machines a median is one clock with
extra steps, and the one-clock law is constitutional. The order of record here is already
no-hand-chooses: one clock, seals, and signed commits.

## The honest paragraph

This is three machines, one person, one keychain -- ergonomics for conflict-free concurrency,
never trust machinery. A compromised keychain or an absent maintainer is a correlated fault beyond any roster
arithmetic's sight, and this design says so in writing so a future reader believes the
constellation tolerates exactly the faults it tolerates. And the residual fork risk is the
two-remote gap itself: a derive-at-merge tool cannot renumber a merge nobody ran, so the
anointed-ordering-remote discipline in Move 1 is load-bearing until the wire lands.

## What asks for a seat, and what does not

Moves 1 and 2 want tooling rounds (the derive-at-merge allocator with its citation discipline;
the index fold) and Move 1's recommendation answers the %230 gate -- **the seat stays Keaton's**.
Moves 3, 4, 5, and 7 fold into the three-MOX design as amendments. Move 6 wants three sentences
on the living card. All of it stays short of the custody gates: the wire stays closed, and a row that has reached
the shared spine keeps its number.
