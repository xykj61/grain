# Constel -- every module in this directory

**Language:** EN - **Voice:** Kyri - **Style:** Gauge, Meter setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Status:** Living roster -- **31 rows against 31 `.rye` modules**, held as one set by [`../tools/co/constel_module_roster_witness.rish`](../tools/co/constel_module_roster_witness.rish)
**Front door:** [`README.md`](README.md) - **Rung reasoning:** [`LADDER.md`](LADDER.md)

Every `.rye` file in `constel/` carries a row here, and every row names a file that stands in this
directory. A guard holds both directions at zero, so a rung that lands without a row reds on the lap
it arrives rather than going unlisted for a season. Each sentence is written from that module's own
`//!` head comment, normalized to plain ASCII.

The eleven families below follow the ladder's own order, FORA0 through FORA30. The rung reasoning --
what each one leans on and what it proves -- lives in [`LADDER.md`](LADDER.md).

---

## Naming and membership -- FORA0 to FORA1

| Module | What it does |
|---|---|
| [`name.rye`](name.rye) | FORA0: a fake-pier name that can never be a real ship -- the naming law and the name primitive. |
| [`roster.rye`](roster.rye) | FORA1: a bounded registry of fake piers, holding up to `max_piers` distinct members. |

## The greeting -- FORA2 to FORA4

| Module | What it does |
|---|---|
| [`handshake.rye`](handshake.rye) | FORA2: two fake piers greet, proven pure -- agreement before exchange. |
| [`wire.rye`](wire.rye) | FORA3: the handshake framed for a local wire, verify-before-trust across a self-describing frame. |
| [`exchange.rye`](exchange.rye) | FORA4: the handshake carried end to end across frames, two piers reaching a COMPLETE `Session`. |

## The local transport -- FORA5 to FORA6

| Module | What it does |
|---|---|
| [`channel.rye`](channel.rye) | FORA5: a bounded byte channel, one frame read at a time -- the single hard thing a real transport adds. |
| [`switchboard.rye`](switchboard.rye) | FORA6: a whole local constellation routed by name, each pier holding its own mailbox. |

## The whole sky speaks -- FORA7 to FORA8

| Module | What it does |
|---|---|
| [`gossip.rye`](gossip.rye) | FORA7: one frame reaching the whole constellation at once, the broadcast a shared fact leans on. |
| [`census.rye`](census.rye) | FORA8: announce and collect, so the caller knows who is present and who is silent. |

## Deciding -- FORA9 to FORA11

| Module | What it does |
|---|---|
| [`quorum.rye`](quorum.rye) | FORA9: from a census, decide whether a strict majority may act at all. |
| [`elect.rye`](elect.rye) | FORA10: from a quorum, elect ONE leader -- the quorum's intersection making that leader unique. |
| [`decree.rye`](decree.rye) | FORA11: from an election, commit ONE value, once. |

## The replicated log -- FORA12 to FORA15

| Module | What it does |
|---|---|
| [`log.rye`](log.rye) | FORA12: a sequence of decrees the whole sky agrees on, in order, so the ledger can never fork. |
| [`reconfig.rye`](reconfig.rye) | FORA13: change the constellation safely through JOINT CONSENSUS, a strict majority in both configs. |
| [`snapshot.rye`](snapshot.rye) | FORA14: compact the log so it can serve forever, a bounded log holding an unbounded history. |
| [`catchup.rye`](catchup.rye) | FORA15: a lagging pier brought current from a leader's snapshot plus tail. |

## Safe across re-election -- FORA16 to FORA18

| Module | What it does |
|---|---|
| [`term.rye`](term.rye) | FORA16: leadership made safe across re-election -- a monotonic term, so an old leader cannot commit. |
| [`repair.rye`](repair.rye) | FORA17: the leader heals a follower's divergent suffix by Raft's Log Matching Property. |
| [`commit.rye`](commit.rye) | FORA18: a leader commits an old-term entry only through a current-term one (Raft's Figure 8). |

## The machine and the read -- FORA19 to FORA20

| Module | What it does |
|---|---|
| [`apply.rye`](apply.rye) | FORA19: the committed log drives a state machine, each client request applied EXACTLY ONCE. |
| [`read.rye`](read.rye) | FORA20: a linearizable read that appends nothing, the read-index (Raft section 8). |

## Election safety -- FORA21 to FORA24

| Module | What it does |
|---|---|
| [`vote.rye`](vote.rye) | FORA21: a vote goes only to an up-to-date log, the election restriction (Raft section 5.4.1). |
| [`prevote.rye`](prevote.rye) | FORA22: a partitioned pier cannot disrupt a stable sky, pre-vote (Raft section 9.6). |
| [`transfer.rye`](transfer.rye) | FORA23: leadership transfers only to a caught-up successor (Raft section 3.10). |
| [`tenure.rye`](tenure.rye) | FORA24: a leader holds tenure only while a majority still answers, CheckQuorum (Raft section 6.2). |

## Membership change, and the lemma beneath it -- FORA25 to FORA28

| Module | What it does |
|---|---|
| [`learner.rye`](learner.rye) | FORA25: a new member joins as a non-voting LEARNER and is promoted only once caught up (Raft section 4.2.1). |
| [`admit.rye`](admit.rye) | FORA26: the whole add-a-member lifecycle, closed -- the learner's catch-up gate joined to the joint switch. |
| [`flexquorum.rye`](flexquorum.rye) | FORA27: flexible quorums, the truth beneath the majority lemma (Howard, Malkhi and Spiegelman 2016). |
| [`depart.rye`](depart.rye) | FORA28: the whole remove-a-member lifecycle, closed, including a leader that removes itself. |

## Fast reads and endurance -- FORA29 to FORA30

| Module | What it does |
|---|---|
| [`lease.rye`](lease.rye) | FORA29: a lease read, safe under a bounded clock (Raft section 6.4.1), falling back to the read-index. |
| [`durable.rye`](durable.rye) | FORA30: durable state -- a pier survives a restart without ever forgetting its vote. |

---

## What this roster reaches, and what it leaves to the rung

This page proves the **set**: every module has a row and every row has a module. Whether a row's
sentence still describes the code is the rung's own witness to answer, and thirty-one of them stand
in [`../tools/f/`](../tools/f/), each printing a GREEN line naming exactly what it proved. Run them
from [`LADDER.md`](LADDER.md).
