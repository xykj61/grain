# The guard that meets itself

**Stamp:** `20260911.204217`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Landed -- **checkable room**: every reading here is printed by
[`../tools/fixtures/p/port_runner_lock_scan.sh`](../tools/fixtures/p/port_runner_lock_scan.sh) and
gated by [`../tools/p/port_runner_lock_witness.rish`](../tools/p/port_runner_lock_witness.rish)
**Kin:** [`20260911-184959_the-roster-that-read-one-language.md`](20260911-184959_the-roster-that-read-one-language.md) -- [`20260911-174455_which-collision-is-silent.md`](20260911-174455_which-collision-is-silent.md) -- REDS %700, %717

A port is a name on the machine. This pier stands eight checkouts deep, and every one of them runs
the same roster. So the question a port census answers -- *can two modules meet on one number* --
turns out to be the smaller half of what a fleet pass actually risks.

## The reading that was missing

Yesterday's census counts the port constants our modules declare and names the numbers two modules
share. Three stand: **38495**, **38496**, **38497**, six declarations across four files. Each is a
real collision and each repair belongs to a lane.

Then read which of the six declarations a roster pass actually runs. **Only one side of one pair is
rostered.** `granary/resin_serve_delivery.rye` and `linengrow/seva_broadcast_delivery.rye` share
38496 and 38497, and neither sits on the roster. `linengrow/neth_serial_core_delivery.rye` shares
38495 with `amphora/vessel_fetch_delivery.rye`, and only the amphora side is rostered -- which
compiles that module to prove it still compiles and never runs it.

So a roster pass never runs both claimants of any double. What it runs is the **same guard, on
eight checkouts, against one machine** -- and a census that counts modules per number reports zero
for that.

## Build and run are two facts wearing one word

A guard writing `rye build <module>.rye -femit-bin=<target>` has compiled a binder and bound
nothing. Only a later `run` naming that same target binds. Measured `20260911`: **five** rostered
guards build a constant-port binder and **four** run it. Charging the fifth would charge a guard for
a fault it cannot have.

## The crossing that decides the instrument

Whether an unlocked run is loud or silent is settled by one option, which the peer paper on the
silent collision named a day earlier:

| | no `SO_REUSEADDR` | sets `SO_REUSEADDR` |
|---|---|---|
| **run under a lock** | safe | safe |
| **run unlocked** | **loud** -- the kernel refuses the second bind, the pass reds, a re-run passes | **silent** -- both sockets bind and the kernel splits the datagrams between them |

A loud collision costs a re-run. A silent one costs a fortnight, because every reading of it is
plausible -- which is exactly the bill REDS %700 paid. Two costs that far apart earn two
instruments: the loud cell is a **ratchet that only falls**, and the silent cell is a **wall at
zero**.

## What stands today

Run the scan rather than trusting these figures; only the two gated readings are held still.

```
builders=5  runners=4  runs_locked=2  runs_unlocked=4  unlocked_ceiling=4  unlocked_reusing=0
```

The two locked runs are `tools/m/mantra_snapshot_hosted.rish` and
`tools/m/mantra_udp_reuseaddr_witness.rish`, both through
`tools/fixtures/m/mantra_delivery_port_lock.sh`. The four open ones:

- `tools/co/comlink_rehearsal_wire_witness.rish` lines 31 and 41 -- `comlink/rehearsal_wire.rye`,
  base 38498
- `tools/f/fora_socket_witness.rish` lines 43 and 82 -- `constel/socket.rye`, base 38512

Both binders set no `SO_REUSEADDR`, so both collisions are loud. Line 82 is a **deliberate race**:
the witness holds one socket and reaches for it with a second, on purpose, to prove the refusal. On
one machine with eight ships that is the honest test and an unheld run at the same time.

Each repair is a choice inside another lane -- a lock, or the bind-to-zero handshake those rooms
already know -- so the four are named for their owners and left for those hands.

## What the first draft got wrong, twice, and what each cost

**Rishi spells one reference two ways.** A variable is `${bin}` inside a string and bare `bin` as an
array element, so `run ["sh" "-c" "${bin} selftest"]` and
`run ["sh" lock "38490" "sh" probe bin "38491"]` name the same binary in two forms. Reading the
interpolated form alone called `tools/m/mantra_udp_reuseaddr_witness.rish` a builder that runs
nothing -- and it runs, under a lock. That is %717's lesson one room over, arriving inside the
instrument built to answer %717.

**A sibling path is not the binary.** `tools/f/fora_socket_witness.rish` writes
`let outfile = "constel/bin/socket.out"` beside `let bin = "constel/bin/socket"`, so a bare
substring test charged ten `cat ${outfile}` lines as executions. The target must end at a character
that cannot continue a path.

Both stand as pen legs, and both bite: removing the bare-variable resolution fails
`bare_runners` and `bare_held`, and removing the boundary fails `sibling_runners` and
`sibling_unlocked`.

## What the pen proves

**38 legs** on real git repositories, each refusal planted and then lifted. A clean tree reads zero
and passes free. A build with no run charges nothing. An unlocked run counts. A binder that sets
`SO_REUSEADDR` makes the wall bite and name its verdict, and commenting that one call out returns
the wall to zero while the ratchet keeps its count -- so the two readings are proven to move apart.
The ceiling is shown from both sides: one unlocked run against a ceiling of one walks free, and the
same tree against a ceiling of zero refuses. An off-roster guard charges nothing, and seating that
very same file charges it -- so the filter is the roster rather than the file. A port of **0** is
the cure and is charged to nothing. A tree with no roster refuses by name rather than reading zero.

## What this does not reach

**Whether a collision ever happens.** This reads the shape that permits one. Whether two ships
reach the same socket in the same second is proven in company at
`tools/fixtures/m/mantra_delivery_port_control.sh`.

**The host.** `/proc/sys/net/ipv4/ip_local_reserved_ports` is empty on this pier, so every number in
the seated band is one the kernel may hand any client socket at any moment. A reservation is a
`nixos/` change, and so Keaton's.

**How wide a lock is.** Launched bare, which is how this fleet runs, `${TMPDIR:-/tmp}` is host-wide
and the lock excludes the whole pier. Inside ai-jail each ship gets a private `/tmp`, so it excludes
two runs within one tree. Both readings are honest and they describe different launches.
