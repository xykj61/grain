# Comlink -- the Sealed Wire, Hosted and on Real Virtio

**Language:** EN
**Last updated:** 2026-07-10 (Tablecloth query device **15575**/**15576**; Granary device **15573**/**15574**; hosted resin **38496**/**38497**)
**Style:** Gauge (see `../context/GAUGE_STYLE.md`)
**Status:** Checkable -- sealed datagram wire

**Comlink carries a sealed datagram, and the format never forks.** `wire_format.rye` defines one offset layout and one seal/open pair, and every rung above it -- a hosted UDP socket on localhost, or a real virtio-net link between two freestanding guests on QEMU virt -- reads and writes exactly the same bytes. A fact that crosses this wire arrives whole or not at all; nothing here retries a partial frame.

## The Core

| File | Proves |
|------|--------|
| [`wire_format.rye`](wire_format.rye) | the sealed datagram layout every rung shares -- offsets and crypto identical across shared memory, hosted UDP, and virtio-net |
| [`hosted_wire.rye`](hosted_wire.rye) | the same sealed datagram crosses a real localhost UDP socket |
| [`virtio_net.rye`](virtio_net.rye) | virtio-net MMIO types and the freestanding driver seed -- shared by hosted descriptor validation and real guests on QEMU virt |
| [`device_wire.rye`](device_wire.rye) | descriptor algebra proven on a fixture, then the same crossing proven on a real virtio link between two guests |
| [`turn_route.rye`](turn_route.rye) | routing reads the **turn** tilak (`../kumara/tilak.rye`): a peer's rotation record is verified, the freshest supersedes, a replay is kept out, a forgery refused -- the seam that hands the wire the networking key to seal with |
| [`handshake_turn.rye`](handshake_turn.rye) | the live handshake -- the introduction gate (`discovery/introduce.rye`) admits a peer and the rotation gate (`turn_route.rye`) keys the wire, in one breath; identity and rotation gate **independently**, so a valid introduction still routes only to a verified freshest key. `handshake_wire` **closes the loop**: the peer's turn arrives on the wire in the descriptor bytes (`turn_to_bytes`), doubly held -- the introducer signed the descriptor, the turn carries the peer's own signature |
| [`topology.rye`](topology.rye) | the **d12-d60 fractal address space** -- twelve galaxies to a universe, five stars to a galaxy (its d5), twelve planets to a star (its d12), a galaxy leading a d60 of sixty; a point number decodes to a place, a place's sponsor climbs planet->star->galaxy (the `sponsor` tilak's own parent link), and two places share a route counted in honest hops -- within a galaxy, one bridge across. The number spaces **nest inclusively** like Azimuth (`20260810`): a galaxy is also a star and a planet (720/universe, sponsor by mod), wearing each lower role as an outfit. **The geometry is a loadable `Sky`**: the seated d12-d60 is `compass_sky`, and a differently-shaped `council_sky` (15-3-9, a d27 of 27, 405/universe inclusive) round-trips by the same law -- a community may load its own shape, toward Pond loading a sky like a game |

`device_wire.rye`'s hosted selftest is the fast path -- no QEMU, and it is where `virtio_net.rye`'s five hand-designed wire structures (`VirtioNetHdr`, `VqDesc`, `VqAvail`, `VqUsedElem`, `VqUsed`) get proved padding-free at compile time via Tally's `no_padding`, before anything freestanding ever runs. A stale camelCase-era call site (`negotiateFeatures` where `virtio_net.rye` had already migrated to `negotiate_features`) sat undetected here for one full season, because nothing in the parity suite ever built this file's own hosted binary -- only the freestanding lab downstream of it. Both the rename and the gap now stand closed: [`counsel/20260707-053212_tigerbeetle-alignment-study.md`](../external-research/20260707-053212_tigerbeetle-alignment-study.md) named the discipline, and this season's bench found where it had not yet reached.

## The Guest Fleet

Every Mantra and Linengrow wire capability that crosses onto real virtio carries a matched pair of freestanding guests -- one transmitting, one receiving -- named for the capability they prove: `pattern`, `sealed`, `receipt`, `sync`, `batch`, `2way`, `catchup` (with revision-numbered variants `_r2`/`_r3` as the catch-up protocol grew a second and third rung), `snapshot`, the full `open_asks` ladder (`application`, `acceptance`, `escrow_hold`, `escrow_release`, `completion`, `consent`, plus `poster` and the bare `open_asks` request pair), Amphora `vessel_fetch_*`, and Granary `granary_resin_*`. Each guest is small and single-purpose by design -- a guest proves one crossing, not a general-purpose client.

## Port Map

| Capability | Hosted | Device |
|------------|--------|--------|
| Recall sync | 38478 / 38479 | 15561 / 15562 |
| Recall batch | 38480 / 38481 | 15563 / 15564 |
| Two-way sync | 38482 / 38483 | -- |
| Catch-up | 38484 / 38485 | -- |
| Subscribe poll | 38486 / 38487 | 15565 / 15566 |
| Open Asks (OA-L5) | 38488 / 38489 | 15561-15563 |
| Snapshot device | 38490 / 38491 | 15567 / 15568 |
| MALA M2 / M2b | 38492 / 38493 | 15569 / 15570 |
| Amphora vessel fetch | 38494 / 38495 | 15571 / 15572 |
| Granary resin serve | 38496 / 38497 | 15573 / 15574 |
| Tablecloth query (hosted + device) | 38490 / 38491 | 15575 / 15576 |

Ports repeat across unrelated laps by design -- each witness binds, uses, and releases its own pair within one bounded run, and Comlink's laps never run concurrently against the same address.

---

*May a sealed datagram always mean the same bytes, whichever rung carries it. May every guest prove exactly the one crossing it was built for. And may a hosted check always exist beside a freestanding one, so nothing waits a whole season to be found.*
