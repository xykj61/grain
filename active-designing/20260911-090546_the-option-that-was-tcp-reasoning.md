# The option that was TCP reasoning on a UDP socket

**Stamp:** `20260911.090546` - **Status:** Landed - **Room:** checkable - **Voice:** Kyri
**Style:** Gauge, Field setting
**Lane:** mantra - **Row:** REDS %700, second repair
**Witness:** [`../tools/m/mantra_udp_reuseaddr_witness.rish`](../tools/m/mantra_udp_reuseaddr_witness.rish)
**Scan:** [`../tools/fixtures/m/mantra_udp_reuseaddr_scan.sh`](../tools/fixtures/m/mantra_udp_reuseaddr_scan.sh)
**Control:** [`../tools/fixtures/m/mantra_udp_reuseaddr_control.sh`](../tools/fixtures/m/mantra_udp_reuseaddr_control.sh)
**Elder:** [`20260911-074907_the-flap-that-shared-a-port.md`](20260911-074907_the-flap-that-shared-a-port.md)

## The sentence that was true somewhere else

Seven mantra delivery modules opened every UDP socket this way, each carrying the same comment:

```
// invariant: SO_REUSEADDR is what lets a bounded run rebind its own port, so a setsockopt
// that fails says so rather than handing back a socket whose next bind will refuse for a
// reason nothing recorded -- a discarded return is how REDS %282's open leg hid for a lap.
if (c.setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &yes, @sizeOf(c_int)) < 0) {
```

The comment is careful, it names a row, and it says why. It is also about a different protocol. A
closed TCP socket sits in TIME_WAIT holding its port, and `SO_REUSEADDR` is what lets a restart
rebind through it. UDP has no TIME_WAIT. A closed UDP port is free at once, so the option earned
its keep somewhere else entirely.

What it bought instead is the opposite of what the sentence promises. Two UDP sockets that both set
it may hold one address and port together, and the kernel then hands each arriving datagram to one
of them, with no error on either side. The option turns a collision into a silence.

## Why silence was expensive here

Every port in these modules is compiled in -- `38478` through `38491`, seven pairs. A port belongs
to the machine rather than to a checkout, and this pier runs eight trees whose roster passes overlap
freely. So two runs reach for one pair, both succeed, and the loser reads a peer's traffic as
`BadKind` or waits out its timeout as `RecvFailed`.

That is a refusal naming a receive path for a fault that happened at bind, and it is why REDS %700
stood open for a fortnight with its cause recorded as inference. The elder paper of this morning
observed the collision directly -- two delivery selftests started together, one GREEN and one
`RecvFailed` on the first try -- and named three doors out. This is the third and cheapest of them,
and it repairs the diagnosis rather than the collision.

## Measured, eight concurrent selftests, one build from each side

`mantra/snapshot_export_delivery.rye` built twice, once from `bc2069b417` and once with the option
removed, then eight copies of `selftest` started together and their refusals counted. Read
`20260911.085000` on this pier at ordinary load.

| Reading | With `SO_REUSEADDR` | Without it |
|---|---|---|
| `RecvFailed` | **12** | 0 |
| `Truncated` | **2** | 0 |
| `BindFailed` | 0 | **13** |
| runs finishing green | 0 of 8 | 1 of 8 |

**The green rate barely moves, and moving it was never the claim.** A collision two ships apart is
still a collision; eight processes wanting one port pair still leaves seven disappointed. What
changes is that the kernel names it -- in the namespace the port actually lives in, at the moment it
happens, needing no lock to be right.

Fourteen refusals blaming a receive path became thirteen blaming the bind. Every refusal in the
repaired column names the bind.

## What the repair is

The `setsockopt` is gone from all seven modules. In its place each one reads the option back and
asserts it off:

```
var reuse: c_int = 0;
var reuse_len: c.socklen_t = @sizeOf(c_int);
if (c.getsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &reuse, &reuse_len) < 0) {
    _ = c.close(fd);
    return error.GetSockOptFailed;
}
// invariant: this socket carries no address reuse, so a second bind to a port this one holds
// refuses by name rather than quietly splitting one port's datagrams between two readers.
assert(reuse == 0);
```

**The read-back earns its two lines.** Deleting a line proves the line is gone. `getsockopt` proves
the socket the kernel actually handed over carries what the file claims about it, which is the
different and stronger statement.

The shape is borrowed, and the lender is one lane over. `amphora/vessel_fetch_delivery.rye` made
exactly this repair on
`20260906` under REDS `20260906.154105`, with a kernel probe proving the four binds it rests on --
and that probe was re-run on this metal this morning, answering the same four ways:
close-then-rebind without the option succeeds, two concurrent binds without it refuse the second
`EADDRINUSE`, two concurrent binds with it both succeed, and a holder with it refuses a newcomer
without it.

## How the lane found its own defect

Amphora's scan carries a third reading it holds as a report rather than a gate:

> `tree_dgram_reuseaddr` -- the same shape in Rye modules OUTSIDE amphora that open `SOCK_DGRAM`
> and never `SOCK_STREAM`. REPORTED, never gated: each of those files belongs to another lane, and
> a guard that reds a lane over a peer's module is a guard that lane turns off.

That reading named these seven files, by path, for five days. A guard with no authority to refuse
still told the truth where someone would eventually read it, which is the whole argument for
reporting a number a gate has no right to hold.

## The gate, and why it reads the index

`tools/fixtures/m/mantra_udp_reuseaddr_scan.sh` holds `source_reuseaddr_sites` at **zero** across
**7** dgram modules, all **7** reading the option back, and reports the **12** peer modules outside
this lane by name without gating one of them.

Its corpus is `git ls-files`, and that choice is the morning's other lesson. A `find` walk reads
`.lap/` too -- gitignored, one per checkout, and holding drafts of these very modules on this ship
today. BAKERY closed that exact defect in `dated_path` a few hours before this lap was written.

**The two instruments now disagree by exactly one, and the difference is the ghost.** After this
repair, amphora's `find`-walking scan reads **13** peer files and this lane's index-reading scan
reads **12**. The thirteenth is `.lap/elder_delivery.rye`, a scratch draft no clone but this one
holds. Eight ships answering one meter differently for a reason none of them can see is precisely
what a reported number is worst at surfacing, since no gate ever reds on a wrong one.

**The repair was attempted and withdrawn**, and that is the honest part. Moving amphora's peer
walker to the index breaks four legs of amphora's own control, whose pens are plain directories
rather than repositories -- so an index oracle reads nothing in them. Repairing the control is a
third frame, past the depth-2 bound, and it belongs to the lane that owns both files. It is
handed over measured rather than half-migrated, since a scan on the index beside a control on
the disk serves a reader less well than either alone.

## Proven

Thirty control legs on real git repositories in a throwaway pen -- every refusal planted and then
lifted, every welcome asserted as hard as every refusal. The legs that earn their place:

- a planted `setsockopt` refuses **and names the file**, and lifting it returns the welcome;
- the ban may be **taught in a comment** where it is kept, without tripping the count;
- a peer lane's module is reported and **never** gates;
- a `SOCK_STREAM` module carrying the option is held out of the dgram corpus;
- an **untracked** module is invisible, and **staging that same file** makes it visible -- which is
  what proves the leg above rather than merely asserting it;
- an empty corpus refuses with `no_corpus` rather than reading clean (REDS %460);
- a tree with no index refuses with `no_index` rather than guessing from a walk.

**Four mutations of the scan, all bitten:** raising the gate to 99 fells 3 legs, returning the
walker to `find` fells 3, loosening the corpus floor fells 2, and counting comments fells 4.
Each returns the control to 30 of 30 when lifted.

All seven repaired modules build, selftest and demo GREEN. `mantra_snapshot_hosted` and
`mantra_recall_tablecloth_query_wire` -- the two rostered guards over the two modules that shared
`38490/38491` -- are GREEN.

## Door two was already done, and standing in a stash

The lap that found this had a red of its own waiting. `stash_record` read `records_unlanded=1`, and
the record was a lap of **this same lane** killed mid-send at `20260911.071505` -- whose log said
`status GREEN` and named every witness, which is that field earning its seating for the second time
in one morning.

That lap had built **door two** for `mantra/recall_tablecloth_query_delivery.rye`: both sockets bind
port zero, the caller hands its kernel-chosen port to the dependent in argv, the dependent answers
one ready byte, and the host reads the caller's address off that datagram. Both compiled-in
constants leave together. Its own falsifier had already fired against a half-measure -- repairing
the client side alone read **38 of 40 red** under four-way concurrency where the elder read 17 --
and its note is the sentence to keep: *half a shared name is not a fix.*

**The two repairs compose, and they are not the same repair.** Door two removes the collision; door
three names whatever collision remains. Landing door two and then dropping `SO_REUSEADDR` from the
now-ephemeral module leaves `tools/fixtures/m/mantra_delivery_port_control.sh` reading **0 red of 16**
clean against **7 red of 8** for a pen mutant pinned back to `38490`. The witness is GREEN with its
concurrency leg.

So this lap landed the killed lap's work first, unedited, and applied its own sweep on top. The
ordering is the point: reds first, and a proven repair standing in a stash outranks a fresh one.

## And the counter built last lap took its own reading

`tools/fixtures/m/mantra_query_wire_flap_scan.sh` exists because REDS %700's third field said the
ledger has no shape for a fault whose *what went wrong* is sometimes nothing at all. It runs one
rostered guard many times on one unchanged tree and counts. Last lap, over
`mantra_recall_tablecloth_query_wire`, it read **18 green, 6 red, `flap=yes`** across 24 runs, every
red between load 17 and 19.

Run again over the same guard with both repairs standing: **12 green, 0 red, `flap=no`**, at loads
spanning **14.15 to 18.33** -- inside the band the elder reds fell in, rather than beside it.

**What that reading does not prove is a cured race.** Twelve runs with no refusal is one afternoon's
evidence under one pier's load, which is testimony and belongs in a session log rather than in a
gate. A rate gated here would red on a quiet day for no fault of the tree. What it does say is that
the instrument built for exactly this question, which said `yes` yesterday, says `no` today.

## What this does not reach

**The collision, in the other six modules.** Door two now stands in one of seven. The remaining six
carry compiled-in pairs and door three's named refusal, which tells a reader what happened without
letting two trees run at once. Extending door two is mechanical and follows the landed pattern.

**The wider allocation.** The killed lap's own closing line names it: **37 port constants across 22
files**, five of them shared by two modules each, and eight trees sharing every one. A meter over
that allocation is a lap of its own.

**Twelve peer dgram modules** in `comlink/`, `granary/` and `linengrow/` carry the same option under
the same comment. Each belongs to another lane, and each is named by two scans now.

**Four unrostered wire-lab witnesses** in this lane -- `recall_batch`, `recall_catch_up`,
`recall_subscribe_poll`, `recall_two_way_sync` -- refuse at their device leg. Measured from both
sides of this change and from a tree with it stashed: **identical**, so the redness is older than
this repair. They are the welded-witness class REDS %646 already books, where a QEMU leg that cannot
run here makes a whole row unrostable and its hosted asserts go unheard.
