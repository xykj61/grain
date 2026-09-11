# The roster a sentence could not hold

**Stamp:** `20260911.145641` -- **Voice:** Kyri -- **Style:** Gauge, Field
**Status:** Landed -- **Room:** checkable (every claim below is bound by `tools/p/port_band_witness.rish`)
**Lane:** PATCHOULI -- `mantra/` and `tally/`
**Kin:** REDS `20260911.145641` - REDS %700 - [`stamp-and-name`](../.claude/rules/stamp-and-name.md) - [`declared-host-config`](../.claude/rules/declared-host-config.md)

## The shape

A port is a name on the machine. This pier stands eight checkouts deep, and their roster passes
overlap almost entirely, so two lawful runs reach one compiled-in UDP port as a matter of course.
REDS %700 is what that cost before anybody said it out loud: a rostered witness read red on one cold
pass and green on a re-run over an unchanged tree, and the cause took a fortnight to name.

The repair was right. Two lock scripts serialize the runs that share a pair, and the module that
flapped took a bind-to-zero handshake so the kernel hands it a number nobody holds.

The roster those repairs depend on lived in prose. `tools/fixtures/m/mantra_delivery_port_lock.sh`
opened *seven modules under mantra/ bind 38478/38479 through 38490/38491* and named *two of the
seven* as binding the same pair. `tools/fixtures/a/amphora_vessel_port_lock.sh` opened
*amphora/vessel_fetch_delivery.rye binds UDP 38494 and 38495*. Both sentences were true the day they
were typed.

## What the repair did to the sentences

The tablecloth delivery module took the handshake at `20260911.105415` and let 38490/38491 go. So
the double claim the mantra lock named stood in one place, and that place was the lock's own header.
The amphora fetcher let 38494 go, and `linengrow/neth_serial_core_delivery.rye` declares it today --
read tree-wide the number is still declared and the sentence looks sound, and read against the room
it is a lock naming a port its module released.

**The better a lane repairs its modules, the wronger its lock headers read.** That is the finding,
and it is a shape rather than a slip: a repair that depends on a roster inherits that roster's
staleness, and nothing in the tree was counting.

## What the counting found

Measured `20260911` over 1,972 tracked Rye sources: **35 declarations across 21 files**, and
**three numbers each claimed by two modules** -- six declarations across four files.

| Number | One claimant | The other |
|---|---|---|
| 38495 | `amphora/vessel_fetch_delivery.rye` `source_port` | `linengrow/neth_serial_core_delivery.rye` `root_port` |
| 38496 | `granary/resin_serve_delivery.rye` `guest_port` | `linengrow/seva_broadcast_delivery.rye` `event_port` |
| 38497 | `granary/resin_serve_delivery.rye` `host_port` | `linengrow/seva_broadcast_delivery.rye` `root_port` |

Each is lawful for its own module and a collision for the pier. Each repair is a choice of number
inside another lane, so the three ratchet under a ceiling that only falls, and each is named for its
owner. `sh tools/fixtures/p/port_band_scan.sh --list` offers the **98** free numbers inside the band
to choose from.

## The instrument

`tools/fixtures/p/port_band_scan.sh`, under `tools/p/port_band_witness.rish`, reads every
`const <name>: u16 = <number>;` in living tracked Rye where `port` is a whole component of the
identifier. Two readings stand at zero:

- **`ports_outside_band`** -- a constant outside the seated band `38472-38600`. The floor is the
  first number this room seated; the ceiling leaves the counting-up convention room to grow. A
  module reaching for 8080 at random reds on the lap it arrives.
- **`lock_band_uncovered`** -- a lock whose numeric edge check would refuse a port its own room
  declares. The next module past a lock's band is caught here, where before it would have met a
  closed door at the lock meant to protect it.

A port of **0** is the cure, named apart and charged to nothing. `lock_claims_unbound` reports the
one stale sentence still standing, amphora's 38494. `counting_bases` prints the two bases a module
counts up from -- `comlink/rehearsal_wire.rye` at 38498, one per ship, and `constel/socket.rye` at
38512, one per seat -- so `band_free` is read beside it rather than alone.

## The fault the control caught before it shipped

The first draft compared a lock's edge band against **every** port its room declares, and a lock is
taken on the **low** port of a pair. So it reported the mantra lock as refusing 38491 -- a number
that lock is never handed, since its own usage line reads `38490 mantra/bin/snapshot-export-delivery
selftest`.

A guard reporting a fault against a correct file costs more than a guard that misses one, because
the repair it instructs breaks something sound. The comparison runs against each port that **opens**
a pair now -- a declared `p` whose `p-1` its own room does not declare, read off the declarations
rather than from a list of pairs nobody writes down. Both directions are planted:
`lock_pair_high_free` and `lock_uncovered_counted`. **46 control legs, fail=0, two mutations each
biting their own leg.**

## What this leaves whole, and the reading that says why it matters

**The host.** Read on this pier `20260911`, `/proc/sys/net/ipv4/ip_local_port_range` answers
`32768 60999` and `ip_local_reserved_ports` is **empty**. So every number in the seated band is one
the kernel may hand any client socket on this machine at any moment. The band orders our own
modules, and the host remains entirely free to hand one of them out mid-selftest.

A one-line `ip_local_reserved_ports` reservation over `38472-38600` would settle it at the kernel,
and that is a host configuration -- authored in `nixos/` and copied out
([`declared-host-config`](../.claude/rules/declared-host-config.md)) -- which makes it Keaton's
word rather than a lap's.

**Whether two modules ever actually meet.** That depends on which ships run which guard at which
second, and `tools/fixtures/m/mantra_delivery_port_control.sh` proves that half in company: measured
`20260911` at load 14, eight at once, the elder binary 39 of 80 red and the repaired binary 0 of 80,
both 0 of 120 run serially. This reading proves the shape that lets the meeting happen.

**Eleven runners drive a constant-port binary with no lock**, and all eleven stand off the roster --
which is why the flap fired in the one rostered witness alone. `%646`'s sentence one room over: an
unrostered witness runs nowhere, so a hazard it carries reaches no reader either. Naming that is
this paper's last measurement and the next lane's lap.
