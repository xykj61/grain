# DREY9 — the desk serves a wanted recording *(exploration)*

**Stamp:** `20260814.065650` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Design capture — self-approved round, agent-doable crux
**Waymark:** DREY · Season A (Hardware & Right-to-Repair) · Mikrophone firmware journey · rung **DREY9**
**Kin:** [`../mikrophone/manifest.rye`](../mikrophone/manifest.rye) (DREY8) · [`../mikrophone/catalog.rye`](../mikrophone/catalog.rye) (DREY7) · [`../mikrophone/wire.rye`](../mikrophone/wire.rye) (DREY1)

---

## Where the journey stands

DREY7 gave the desk a content-addressed catalog; DREY8 let it advertise its
holdings as a bounded, verify-before-trust manifest, so a far hand computes exactly
which recordings it lacks (`wanted`). The have/want conversation is half a sync: a
far hand now knows *what to ask for*. It cannot yet be *answered*.

## The crux, Lindy-first

The decisive move that closes the local sync loop is **serve** — the desk produces,
for an address a far hand asked for, exactly the wire frame that carries that
recording. It is the want-response to DREY8's have-advertisement, and together
catalog · manifest · serve form a complete, purely local content-addressed sync:
advertise holdings → compute wanted → serve each wanted → deposit verify-before-keep.

DREY9 stays **purely local** — `serve` yields the frame *bytes*; it moves them over
no transport. Producing a frame from a held recording crosses no gate. Serving those
bytes over a real network to a real far hand reaches the **Comlink-served custody
gate** (Season 1, Journey 2) and waits for the maintainer's word. This rung proves
the answer is correct and content-preserving before any wire is ever strung.

## The shape

`mikrophone/serve.rye` — the desk answers a want by re-framing a held recording.

- **`serve(catalog, address, out_frame) -> !void`** — if the catalog holds the
  address, re-frame its proven payload into `out_frame` as a wire frame; if not,
  refuse `NotHeld` before a byte is written. The re-framing rebuilds a committed
  session from the held payload and calls `wire.frame`, reusing the one proven
  framing path rather than inventing a second.
- **Content-preserving** — because the frame's Sha256 is computed over the identical
  payload bytes, the served frame's content address equals the address asked for. A
  far hand that deposits the served frame into its own catalog lands it under the
  same address — the sync converges.

## The invariants this rung proves

1. **Serve answers only what is held** — a `serve` of an address the catalog holds
   yields a frame; a `serve` of an absent address refuses `NotHeld`.
2. **The answer is content-preserving** — `wire.deframe` of the served frame equals
   the desk's own payload for that address, and `catalog.address_of` of it equals the
   address served. The address a hand asks for is the address it receives.
3. **The whole local loop converges** — a far hand holding a subset, given the desk's
   manifest, computes its `wanted` set, receives each wanted address served, deposits
   each verify-before-keep, and ends holding exactly what the desk holds — no more, no
   fewer, every address matching.
4. **A tampered served frame still refuses** — the far hand's `deposit` is
   verify-before-trust, so a frame corrupted in the answer refuses `DigestMismatch`
   and lands nothing.

## What stays out of scope (Comlink-served gate · custody gate #2)

No disk, no network, no key signs, no funds. `serve` produces bytes in memory; a real
transport to a real far hand is the gated rung. The content address is an integrity
identity, not a signature — an *authenticated* serve (proving *who* served) is a
later, gated rung beyond this one. Real hardware stays custody gate #2. Proven pure
in Rye before metal, as every DREY rung before it.

---

*May the desk answer only what it truly holds, hand back exactly the recording that
was asked for, and let two hands meet holding the same whole — no byte crossing that
a keeper did not need, none arriving that cannot be proven.*
