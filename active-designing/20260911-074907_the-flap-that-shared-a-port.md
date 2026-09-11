# The flap that shared a port

**Stamp:** `20260911.074907` - **Voice:** Kyri - **Style:** Gauge, Field setting
**Status:** Landed -- the counter and its proof stand; the repair below is named and unbuilt
**Room:** checkable -- every claim here is a reading, and the closing experiment reproduces on demand
**Kin:** REDS `%700` - [`../.claude/rules/the-baton.md`](../.claude/rules/the-baton.md) (*one writer per checkout*)
**Instrument:** [`../tools/fixtures/m/mantra_query_wire_flap_scan.sh`](../tools/fixtures/m/mantra_query_wire_flap_scan.sh)
**Proof:** [`../tools/m/mantra_query_wire_flap_witness.rish`](../tools/m/mantra_query_wire_flap_witness.rish) over [`../tools/fixtures/m/mantra_query_wire_flap_control.sh`](../tools/fixtures/m/mantra_query_wire_flap_control.sh)

## What the row asked for

REDS `%700` recorded a rostered guard answering red on one cold roster pass and green on a re-run
minutes later over a tree that had not moved. Its third field named the wound exactly: **a guard
that answers differently on one tree proves nothing, and every instrument in this room reads one
run.** It named its own suspicion in the same breath -- two `rye build` calls writing into fixed
tree paths -- and it was careful to mark that suspicion as inference. *The cause is inference,
never observation.*

The row named two repairs: a repeat count under load, and the two builds moved into a pen. This
page is what the first one found, and why the second one is aimed at the wrong thing.

## The count

`tools/fixtures/m/mantra_query_wire_flap_scan.sh` runs one guard N times over one tree and reports
`green`, `red`, `flap`, and -- for every red -- the guard's own refusal sentence. Read
`20260911.074500`, 24 runs, on a tree whose digest was `09a4435b9733` at both ends:

| Reading | Value |
|---|---|
| `green` | 18 |
| `red` | 6 |
| `flap` | yes |
| load, one-minute average | 13.33 at open, 20.53 at peak |
| every red's observed load | 17.42 to 18.87 |

**The figure is free**, and it is a rate rather than a constant: it was taken on one pier on one
afternoon while seven peer ships ran their own roster passes, and a quiet pier will read lower.
Run the scan rather than citing the six.

## What the reds said, once they could speak

The previous lap on this guard (`20260910.203444`) gave its five bindings their targets' own
sentences, on the reasoning that a refusal naming only its leg number leaves the next lap exactly
where the row already stands. That repair waited here for its first harvest. The six reds carried
three distinct failures, every one of them from the **delivery selftest**:

```
error: RecvFailed
error: BadKind
thread 3740744 panic: reached unreachable code
```

Three failures in a receive path is a different subject from two builds sharing a filename.

## The lap before this one is what made counting possible

`20260911.003518` caught this same guard in the act: the delivery selftest sat **29 minutes** in
`__skb_wait_for_more_packets`, two voluntary context switches, one socket. `recv_wire` called
`recvfrom` with the kernel's default deadline, which for a datagram socket is forever, so one stray
packet left the host waiting for the rest of the day. That lap gave the receive a **5s** bound from a named constant, matching the sibling
modules that had carried one for chapters, and wrote the sentence this page continues: *a red and a
hang are one defect -- lose the datagram and the host hangs, win the race and it passes.*

**A 24-run count exists because of that bound.** Twenty-four runs of an unbounded receive would
have parked on the first stray datagram, ending the count at one. The elder lap turned an
unmeasurable hang into a five-second named refusal, which is the whole precondition for a rate. It
asked the right question in its own last clause -- *lose the datagram* -- and this page answers the
half it left open: **where the datagram went.**

## The mechanism, observed rather than inferred

`mantra/recall_tablecloth_query_delivery.rye` names two localhost UDP ports as constants:

```
const client_port: u16 = 38490;
const host_port: u16 = 38491;
```

and `open_socket` sets `SO_REUSEADDR`, whose comment says plainly why: *SO_REUSEADDR is what lets a
bounded run rebind its own port.* That is right for one run in one tree, and it is what removes the
wall on a pier carrying eight. A port number is a **machine-wide** name, so eight trees hold
one pair between them rather than eight, and `SO_REUSEADDR` lets the second binder succeed where a
refusal would otherwise stand. The kernel then hands each arriving datagram to one of the contending sockets, and every
observed failure follows from that one fact:

- the reply a client waited for reaches the **other** process, so its bounded receive times out --
  `RecvFailed`
- a stranger's datagram reaches this decoder, whose first byte is the wrong kind for this stage --
  `BadKind`
- a well-formed reply to somebody **else's** request reaches a branch the module proved impossible
  -- `reached unreachable code`

**Reproduced on the first attempt**, which is what moves this from inference to observation. Two
copies of the built selftest, started together in one tree:

```sh
mantra/bin/recall-tablecloth-query-delivery selftest &
mantra/bin/recall-tablecloth-query-delivery selftest &
wait
```

One answered `GREEN` and exited 0. The other refused with `error: RecvFailed`, raised at
`recv_wire`, reached through `run_client_query -> exchange -> fill_pool -> run_pool_trial`. The
experiment costs five seconds, runs in a bare shell, and reproduces at whatever load stands.

## The assumption was written down, and the fleet falsified it

`comlink/README.md` carries a **Port Map** -- eleven capabilities, each with a hosted pair and a
device pair -- and closes it with the sentence that makes the whole scheme work:

> Ports repeat across unrelated laps by design -- each witness binds, uses, and releases its own
> pair within one bounded run, and Comlink's laps never run concurrently against the same address.

That is a correct and carefully reasoned design, and it rests on one condition stated in its own
last clause: **laps never run concurrently.** It was true when one tree ran one roster pass. It is
false on a pier carrying eight checkouts that each run the roster, because concurrency here is a
property of the **machine** rather than of any tree. That sentence was true on the day it was written,
and the fleet grew around it.

So the duplicate is deliberate. The Port Map records **38490 / 38491 twice** -- once as *Snapshot device*
and once as *Tablecloth query* -- and the table is right to, under its own stated rule. Both rows
are rostered guards: `mantra_snapshot_hosted` builds `mantra/snapshot_export_delivery.rye`, and
`mantra_tablecloth_query_wire` builds `mantra/recall_tablecloth_query_delivery.rye`. The roster
runs its guards one at a time, so the two never meet inside one pass -- and across eight passes on
one machine they meet constantly, each speaking a protocol the other cannot parse. That is the
cleanest possible account of `BadKind`: a snapshot-export datagram arriving at a tablecloth-query
decoder, whose first byte is a kind it was never built to hold.

**Renumbering therefore leaves the fault standing**, and saying so saves the next lap an afternoon.
A distinct pair for every capability would still leave two ships running *the same* guard on the
same pair, which is how six of these reds were made. The shared name is the port itself.

**The census, measured `20260911.075500`:** nine modules under `mantra/` and `comlink/` name fixed
`u16` port constants -- eight distinct hosted pairs across 38472 to 38498, one pair claimed twice.
Every one carries the same exposure; the tablecloth query is only where it was caught.

## Why the suspected cause could not have been it

The build paths are per tree, `mantra/bin/` is gitignored, and the standing runner runs its guards
one at a time -- so two writers meet on that filename only when a hand runs the guard beside a
roster pass. Moving those builds into a pen is ordinary hygiene, and it leaves this fault standing. **The
shared resource lives on the machine, outside every repository.** That is what made it invisible to every reading the
row could take: a tree-shaped question cannot see a machine-shaped name, and eight checkouts that
share nothing in git still share a port table, a home directory, and a 20 GB build cache.

This is the shape `%291` already seated one level down. One writer per checkout is a rule about
trees. A fixed port is the same rule wanting a second sentence about **machines**.

## The repair, named and unbuilt

A run wants a port it **owns** rather than one it borrows. Three doors stand, and choosing among
them is a lap rather than a line:

1. **A pid-keyed offset.** Cheap and local, and it wants a named range plus an argument about what
   happens when the range meets a real service or wraps onto a sibling's pair.
2. **Bind port zero and learn the assignment.** The kernel hands out a free port, and the host must
   then tell the client where it landed, which touches the exchange every delivery module performs.
3. **Drop `SO_REUSEADDR`.** One line per module, and it converts three mysterious faults into one
   honest `BindFailed`. It repairs the **diagnosis** rather than the contention -- the guard still
   reds under a concurrent peer -- and it is the cheapest thing worth doing first, because a
   refusal that names itself can be counted where a flap cannot.

Whichever lands, `comlink/README.md`'s closing sentence wants rewriting in the same commit: it is
the assumption, and it is the part that went false.

**One more instrument is named rather than built:** the Port Map is a table a person reads, and
a reader is its only checker against the constants it describes. A duplicate entered it and stood.
That is `crushed_index`'s own lesson one room over -- *a count typed in prose is read by nothing* --
and a scan deriving the map from the sources would have named this pair the day it landed.

## What this page does not reach

Whether the other twenty-odd guards that build into fixed tree paths carry a fault of their own --
they were read past here rather than cleared. Whether the **device** ports, 15561 upward, carry the
same exposure under QEMU; the Port Map shows `15561-15563` shared between two rows, and every reading
here stopped at the hosted pairs. And the flap rate on a quiet pier, which the scan will answer for whoever asks
it there -- the six above are one afternoon's testimony under seven peer passes, a rate that moves with the pier.
