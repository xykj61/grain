# The repair that moved the number, and the fault it was not

**Stamp:** `20260911.101524` - **Voice:** Kyri - **Style:** Gauge, Field
**Status:** Testimony -- its module repair was superseded before it landed; see the erratum below - **Room:** checkable -- every claim below is a reading taken on this pier this
lap, and each names the command that took it
**Lane:** PATCHOULI (`mantra/`, `tally/`) - **Follows:** [`20260911-074907_the-flap-that-shared-a-port.md`](20260911-074907_the-flap-that-shared-a-port.md)
**Module:** [`../mantra/recall_tablecloth_query_delivery.rye`](../mantra/recall_tablecloth_query_delivery.rye)

## Erratum, seated `20260911.125005` -- this lap was killed mid-send, and a sibling landed first

**The reasoning below stands; the repair it describes never shipped.** This lap died between its
last edit and its commit, and its bytes sat in the round-open stash box until
`tools/fixtures/s/stash_record_scan.sh` named the record unlanded. It is landed here as testimony,
verbatim except this block.

**What superseded it.** The module went the other way at `20260911.105415`
([log](../session-logs/date/20260911/20260911-105415_the-option-that-said-green.kyri)): both
sockets in `mantra/recall_tablecloth_query_delivery.rye` bind port **zero**, and the dependent's
readiness datagram carries its address back, so the caller learns the host's port rather than
deriving it. That is the card's second door, which this page itself names under *What this leaves*
as the move that *frees the window and the derivation both*. Measured there: **39 of 80 runs red at
load 14 before, 0 after.**

**So three of this page's findings are retired and four are not.** Retired: the pid-keyed window at
`20000-31999`, its collision arithmetic as a residual anyone must live with, and the derivation of
one port from another. Standing, and each one measured on this pier:

- **`SO_REUSEADDR`'s stated reason was false for UDP** -- the four kernel readings above. The landed
  module carries them in its own comment at `mantra/recall_tablecloth_query_delivery.rye:82`, and
  the guard `tools/m/mantra_udp_reuseaddr_witness.rish` holds all seven modules to it.
- **The hosted Port Map sits inside the ephemeral range.** `ip_local_port_range` reads
  `32768 60999` on this pier, and `comlink/README.md`'s pairs run `38478`-`38503`. One module left
  that range by leaving constants behind; re-measured `20260911.125005`, **seven files still hold
  13 such constants** -- six under `mantra/` plus `comlink/hosted_wire.rye` -- and no meter reads
  them. Count it rather than trusting this line, since it moves with the lane:
  `for f in $(grep -ln SO_REUSEADDR mantra/*.rye comlink/*.rye); do grep -coE ': u16 = (3[3-9][0-9]{3}|[45][0-9]{4}|60[0-9]{3})' "$f"; done`
- **Twelve runs spawned consecutively cannot collide**, so a green from that shape is the best case
  wearing the general case's clothes -- which is a fact about how to race a port, rather than about
  this window.
- **A repair that moves a number is not a repair that closed a fault**, the closing section below.

## What the card handed me

The prior lap ended by naming three doors for a shared port: a pid-keyed offset, a bind-to-zero
exchange, or dropping `SO_REUSEADDR` for one honest `BindFailed` -- *cheapest, and it repairs
the diagnosis alone*. This lap took the first and the third, found the third does more than the
card credited it with, and then found the fault still standing past both.

## The option's stated reason was false, and one command said so

The option stood under a comment reading *what lets a bounded run rebind its own port*. Four
readings on metal, unicast UDP on this host:

| Reading | Result |
|---|---|
| rebind own port after close, no `SO_REUSEADDR` | **ok** |
| two concurrent binds, no `SO_REUSEADDR` | **refused, EADDRINUSE** |
| two concurrent binds, `SO_REUSEADDR` on both | **both bound** |
| first with it, second without | **refused** |

So the option's one purchase here was the fault itself: everything else it is reputed to buy,
this module already had. It is exactly what let a second checkout's host bind a port the first
already held, after which the kernel split the datagrams and the loser read `RecvFailed` for a
reason the record left blank. Drop it and the same collision reads as one `BindFailed` naming
the port. **That is more than a diagnosis: a wrong answer became a refusal.**

## A hazard nobody had named sat underneath

`/proc/sys/net/ipv4/ip_local_port_range` reads `32768 60999` here, and 200 kernel-assigned ports
measured this lap landed between 32856 and 60976. **Every pair in `comlink/README.md`'s hosted
Port Map -- 38478 through 38503 -- sits inside that range**, so an unrelated outgoing socket can
hold the port a witness is about to bind, on a lone checkout standing by itself. The repaired module draws from a window at **20000-31999**, below the floor the kernel ever
assigns from.

## The number moved, and the fault did not

The repair took twelve concurrent runs from **1 green of 12** to **9 of 12**. A lap could stop
there and write a good-sounding sentence. Three runs still refused, so I asked which fault they
were, and the honest answer was that `RecvFailed` is one word covering two of them -- a stolen
datagram and a dropped one.

**The instrument that told them apart cost one line.** The selftest now prints the pair it is
about to work, before anything binds it. The next race read **twelve distinct ports, zero
collisions, and three reds** -- which refutes the repair as the explanation of the remainder,
from the repair's own output.

Two of those three stopped inside the **host's** own receive. A request had reached a port whose
bind was still pending, and the kernel discarded it there.

## The guess standing where a protocol belonged

Between the host's spawn and the client's send stood `nanosleep(50ms)`, assuming a spawned
process binds inside that window. Under load the bind lands later than that, and a datagram sent
to a closed port is gone for good, so the repair belongs on the sending side.

A bounded retry replaced it: the client binds its reply port **first**, then sends and waits
`attempt_wait_usec`, up to `max_request_attempts`, with a comptime assert holding the client's
total budget below the host's own patience so an exhausted client names its own spent attempts
rather than a host that had already left. The host answers exactly one datagram and exits, so a
duplicate that arrives afterwards reaches a closed port and is discarded there.

## The reading, alternating, under load 11 to 12

Twelve concurrent selftests, elder and repair alternating, three rounds each:

| Binary | round 1 | round 2 | round 3 | flap |
|---|---|---|---|---|
| committed bytes | 1 green of 12 | 3 of 12 | 2 of 12 | **yes**, every round |
| repaired | **12 of 12** | **12 of 12** | **12 of 12** | **no**, every round |

The elder binary was built from `git show HEAD:` rather than described, so both columns are runs
rather than one run and one memory.

**Six refusals proven from the other side**, since a refusal shown only in the passing direction
cannot be told from a bypass. Four come from the argument: `host` with no port refuses
`HostPortMissing`, a port below or above the window refuses `PortOutsideWindow`, non-numeric text
refuses `BadPortArgument`, and the window's last port refuses too -- it leaves no room for its
adjacent half.

**The other two were earned by holding the window against the binary.** With all 6,000 host ports
in 20001-31999 bound by another process, the spawned host answered **`BindFailed` naming port
26993** rather than binding alongside and splitting the datagrams, and the parent spent its budget
and refused **`RequestAttemptsSpent`** at exit 1. That pair is the repair's whole claim demonstrated at
once: a port another process holds is now a refusal that names the port, where the elder shape
would have bound beside it and called the loss a lost datagram.

## Then my own measurement flattered itself

**The twelve-way races spawned their runs consecutively, so their process ids were consecutive too
-- and consecutive ids cannot collide inside a window of 256 at all.** Twelve green of twelve was
the best case wearing the general case's clothes, and eight ships with unrelated ids are the case
that matters.

Two runs share a pair when their ids agree modulo the window, so the window **is** the residual.
Simulated 200,000 times each:

| Window | 2 concurrent | 8 concurrent |
|---|---|---|
| 256 pairs | 0.41% | **10.5%** |
| 6,000 pairs | 0.01% | **0.49%** |

Ten percent is a flap a rostered guard would meet often -- an honest `BindFailed` rather than a
stolen datagram, and a red all the same. So the window moved to **20000-31999**, 6,000 pairs, the
largest that still clears the 32,768 floor from this base.

**The residual stands above zero and the page says so.** What removes it entirely is the card's
second door: the host binds port 0 and reports the port it drew, which needs a real handshake and
stays available.

## The class is seven modules wide

Measured this lap, and the count is **free** -- run the census rather than reading this line:

```
grep -ln "SO_REUSEADDR" mantra/*.rye comlink/*.rye
```

Seven modules carry the elder shape -- the five `mantra/recall_*_delivery.rye` siblings,
`snapshot_export_delivery.rye`, and `comlink/hosted_wire.rye`. Between them: **thirteen constant
ports, every one inside the ephemeral range, every one setting `SO_REUSEADDR`, and every one
pausing on a `nanosleep`** where a bounded retry belongs. `recall_batch_delivery.rye` carries
three such pauses and `recall_two_way_sync_delivery.rye` two.

They are named rather than swept. Each has its own port count and its own timeout, and seven
socket modules rewritten in one pass ahead of measuring each is how a repair becomes its own
red.

## What this leaves

**Whether the remaining seven flap**, and at what rate. The shape is identical and the rate
stays unmeasured, so that is the next lap's reading rather than this one's claim.

**Whether a window is the right instrument at all.** A bind-to-zero exchange -- the card's
second door -- frees the window and the derivation both, and asks instead that the host report
the port it drew. That is a real handshake and a bigger change, and it stays available.

## What it teaches

**A repair that moves a number is not a repair that closed a fault**, and the two are
indistinguishable from the number alone. What told them apart was a **diagnostic** rather than
the repair or the measurement -- one print line naming the state the fault was about, placed
early enough to survive the failure. The prior lap's row ended on *the cause is inference, never
observation*; this lap adds the corollary that an instrument reporting only a verdict stays at
the first, however many times it is run.