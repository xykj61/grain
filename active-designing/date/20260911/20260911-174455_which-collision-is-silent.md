# Which Collision Is Silent

**Language:** EN
**Stamp:** `20260911.174455`
**Style:** Gauge, Field setting -- see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md)
**Voice:** Kyri
**Status:** Living -- **checkable room**: every figure comes from
[`../tools/fixtures/p/port_band_scan.sh`](../tools/fixtures/p/port_band_scan.sh) and
[`../tools/fixtures/a/amphora_udp_reuseaddr_scan.sh`](../tools/fixtures/a/amphora_udp_reuseaddr_scan.sh),
both rostered and both green on the lap this was written

---

## What the tree now knows, and what it still does not

`port_band_scan.sh` landed on `20260911.145641` and reads **34 constant ports across 21 files**,
holding `ports_double_claimed` at a ceiling of 3. It names the three, and REDS %715 books them:

| Port | Declared by | And by |
|---|---|---|
| 38495 | `amphora/vessel_fetch_delivery.rye` | `linengrow/neth_serial_core_delivery.rye` |
| 38496 | `granary/resin_serve_delivery.rye` | `linengrow/seva_broadcast_delivery.rye` |
| 38497 | `granary/resin_serve_delivery.rye` | `linengrow/seva_broadcast_delivery.rye` |

**All three are collisions and only two of them make a sound.** That reading takes a second fact,
and this tree already owns the instrument that supplies it.

## The kernel decides, and a probe already asks it

`amphora_udp_reuseaddr_scan.sh` runs a kernel probe on every pass. Read on this metal
`20260911`:

```
concurrent_neither_reuse=refused_EADDRINUSE
concurrent_holder_reuse_only=refused_EADDRINUSE
concurrent_both_reuse=ok
```

So two sockets reaching one address bind together **only when both set `SO_REUSEADDR`**, and the
kernel then splits arriving datagrams between them with no error on either side. Any other mix
refuses by name.

Read against the three:

| Port | The holders' option | What a meeting sounds like |
|---|---|---|
| 38495 | `neth_serial_core` sets it; `vessel_fetch` reads it back and asserts zero | refused, by name |
| 38496 | both set it | **bound twice, datagrams split, silence** |
| 38497 | both set it | **bound twice, datagrams split, silence** |

`granary/resin_serve_delivery.rye` and `linengrow/seva_broadcast_delivery.rye` share **both** ports
of one exchange and both keep the option. That is the exact shape `%712` diagnosed in mantra, where
it cost a fortnight: run alone the selftest passed, run beside itself it refused about half the
time, and 39 of 80 runs read red at load 14.

## The finding lives in the join

Each instrument is single-stranded and right to be. The name census reads declarations; the option
census reads a socket call and a kernel. Neither can answer *which collision is silent*, because
that needs both facts true at once -- and a silent split is the one that costs a fortnight, where a
refusal costs a reader one line.

Two ways to seat it, and the choice is a lane's rather than this page's:

- **A third reading in the name census.** `double_claimed_silent`, reported never gated, computed by
  asking the option question of each colliding file. It braids the two instruments, which is what
  single-stranded warns against.
- **A reading in the option census.** It already walks every `.rye` in the tree for the option and
  lists **14 peers** still setting it on a datagram socket; joining that list to the port census's
  three would be one comparison on a population it already holds.

The second looks cheaper and reads in the direction the fact actually flows -- the option is the
hazard, and a shared name is what makes it bite.

## What this does not reach

**The repair.** Three renumberings in three rooms, each a compiled-behavior change wanting its own
module's witness. `band_free` reads **98** free numbers inside the seated band, so the arithmetic is
not the hard part; whose word moves another lane's binary is.

**Whether a fourth pair is forming.** The census refuses a new declaration outside the band and
ratchets the double claims, so the class is walled going forward. The severity reading above is
about the three that stand.
