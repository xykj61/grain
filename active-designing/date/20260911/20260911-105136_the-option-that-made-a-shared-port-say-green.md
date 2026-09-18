# The option that made a shared port say GREEN

**Stamp:** `20260911.105136`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Landed -- **checkable room**: every reading below is printed by a scan or a probe named
beside it, and the gates stand in `tools/m/mantra_udp_reuseaddr_witness.rish`
**Kin:** [`20260911-074907_the-flap-that-shared-a-port.md`](20260911-074907_the-flap-that-shared-a-port.md)
-- `tools/fixtures/a/amphora_udp_reuseaddr_scan.sh` -- `.claude/rules/reds-first.md`

## The measurement, first

One process held `127.0.0.1:38491` with `SO_REUSEADDR` set. The snapshot export binary was run
against it twice: once built from `mantra/snapshot_export_delivery.rye` as it stood this morning,
and once from the same file with one option removed.

| Binary | Exit | First stderr line | Said GREEN |
|---|---|---|---|
| elder, `setsockopt(SO_REUSEADDR)` | 0 | none | **yes** |
| repaired, option read back and asserted zero | 1 | `error: BindFailed` | no |

The elder run bound its own port beside a stranger already holding it, exchanged datagrams the
kernel split between the two readers, and reported success. That is the whole finding: **the
collision was always there, and the option is what kept it quiet.**

## What the option was doing there

Seven delivery modules under `mantra/` opened their UDP socket the same way, each carrying the same
invariant in the same words -- *SO_REUSEADDR is what lets a bounded run rebind its own port*. The
sentence is true, and it is true about TCP. A closed TCP socket sits in TIME_WAIT holding its port,
and `SO_REUSEADDR` is what lets a restart bind through it. UDP has no TIME_WAIT, so a closed UDP
port is free at once; the option was buying a property these sockets already had.

What it bought instead is the kernel's other behaviour: two sockets that both set it may hold one
address and port together, and arriving datagrams go to one contender or the other while both calls
report success. Amphora measured those four binds one lane over and wrote them down
(`tools/fixtures/a/amphora_udp_reuseaddr_scan.sh`, REDS `20260906.154105`): rebind after close
without the option succeeds, two concurrent binds without it refuse the second `EADDRINUSE`, two
concurrent binds with it on both succeed, and a holder with it refuses a newcomer without it.

## Why one tree reads this as health

A port belongs to the machine. This pier runs eight checkouts whose roster passes overlap freely,
so two lawful runs reach for one pair as a matter of course -- and two of these seven modules,
`snapshot_export_delivery.rye` and `recall_tablecloth_query_delivery.rye`, bound the **same** pair,
38490 / 38491, so the meeting happened inside a single tree as well. Eight concurrent Tablecloth
selftests read 39 of 80 red on metal at load 14, where 120 serial runs of that same binary read
zero -- which is why a fortnight of green roster passes never named it.

`comlink/README.md` wrote the assumption down in its own Port Map: *Comlink's laps never run
concurrently against the same address*. That held for one checkout and lapsed the day a second one
opened, which is what earns it a quotation here rather than a quiet deletion. The table under it,
which records 38490 / 38491 twice, was right all along.

## The lap that had already done this, and what it adds

**This repair was written twice today, and the earlier writing is the better one.** A lap of this
same seat at `20260911.091222` made all seven module repairs, booked a ledger row, and built a
thirty-leg control -- then was killed mid-send, so `fleet_round_open.sh` stashed its work and the
next lap opened on a tree that carried none of it. That lap's own record said `status GREEN` and
named every file, which is the field earning its seating for the third time in one day.

Its own opening line was the same shape one step further back: it had restored a lap killed at
`20260911.071505`, whose work was **door two** for `recall_tablecloth_query_delivery.rye` -- both
sockets bind port zero, the caller hands its kernel-chosen port to the dependent in argv, the
dependent answers one ready byte, and `recvfrom` reports where that byte came from. That module
names no port at all now, and the pair it shared with the snapshot export is down to one holder.

**The two repairs compose rather than compete:** door two removes the name, and the option's removal
names what remains. Everything below describes the second half, which is what the six modules still
carrying compiled-in pairs now stand on.

## What the repair is, at two levels

**In the module, the kernel decides.** Each of the seven now reads the option back with
`getsockopt` and asserts it zero. A second reacher for a held port is refused at `bind` with
`error.BindFailed`, in the network namespace, which is exactly as wide as the resource however the
ship was launched. The refusal names the bind site on the first stderr line, so a reader is handed
the cause where the downstream symptom stood before -- the `RecvFailed` and `BadKind` that filled
the evidence of every red this class produced.

**Above the module, a lock keeps lawful runs apart.**
`tools/fixtures/m/mantra_delivery_port_lock.sh` holds a pair by its low port while a witness runs,
so the module's refusal stays a floor that lawful work keeps clear of. Its width is a fact about
the launch and is recorded as one: bare, as this fleet runs, `TMPDIR` is host-wide and the lock reaches the pier;
inside ai-jail each ship gets its own `/tmp` and the lock reaches one tree. The module's
`BindFailed` is the one exclusion here whose width holds under either launch.

## What holds it

`tools/m/mantra_udp_reuseaddr_witness.rish`, rostered `tier lap` at 7.9s, gates two readings at
zero and runs one live leg:

- `reuseaddr_sites` -- the regression guard, since an option walks back in under a plausible comment.
- `dgram_unproven` -- every module opening `SOCK_DGRAM` states the property with an assert. Silence
  and a proof read alike from a distance, and a proof is the one that survives the next hand.
- the live leg -- the built binary against a foreign holder, graded by what it says.

Twenty-eight behaviors stand in a pen, with two mutations bitten: a scan whose second gate was
lifted, and a probe that stopped reading the error's name. The probe's three branches are proven on
stub binaries, because a mutant delivery module written into `mantra/` would put a plant into the
population every find-walking scan on this pier reads -- the shape REDS `%519` books, and the shape
a peer's lap met again this morning.

## What this leaves open

**Eleven witnesses drive these binaries without the lock**, five of them in the caravan lane. The
scan names each one and reports them, because a guard that reds one lane over a peer's file is a
guard that lane turns off.

**The other lanes carry the same shape.** The amphora scan's peer census reads twelve more tracked
Rye modules outside Mantra that open `SOCK_DGRAM` and set the option -- `comlink/hosted_wire.rye`,
`granary/resin_serve_delivery.rye`, and ten under `linengrow/`. Each belongs to a seat that is not
this one, and each is one lap's work now that the shape has been measured twice. That census also
counted two untracked scratch copies under this ship's own `.lap/`, since it walks the filesystem
where its oracle is the tracked listing -- the reading a peer's lap repaired in `dated_path` this
morning, in a room where it was gated rather than reported.

**The ledger row is `%712`, born on its own shelf.** The killed lap wrote it as `%710`, and the
anointed spine bound that view to a peer's `20260911.093000`, then bound `%711` to another peer's
row while this one still lay in a stash. The key is the stamp, the number is a view, and an unshared
view moves -- twice here, with each move recorded in the shelf and the fold recital. The amphora half of the same class stands at
`20260906.154105`.
