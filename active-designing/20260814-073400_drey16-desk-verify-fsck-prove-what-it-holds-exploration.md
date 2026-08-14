# DREY16 — the desk verify: the fsck that proves what it holds

**Stamp:** `20260814.073400` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Landed — witness `tools/drey_verify_witness.rish` GREEN
**Season A** (Hardware & Right-to-Repair) · **waymark DREY** · Mikrophone firmware journey · **rung DREY16**
**Kin:** [`../mikrophone/catalog.rye`](../mikrophone/catalog.rye) (DREY7, the content-addressed store)

---

## Why this rung

The catalog (DREY7) deframes verify-before-trust at deposit, keys each recording by the Sha256 the wire carried, and **thereafter trusts its stored bytes**. That trust is well-placed at the moment of deposit — yet a store is bytes, and bytes drift: a flipped bit from failing memory, a truncated write, a corruption no re-deposit ever notices because the index still *claims* to hold the recording. Until this rung, the desk could only assume its holdings were sound; it had no way to *prove* it.

By Lindy-first, crux-first, a store that can prove its own integrity is high on the durable ladder — it is the founding promise (*prove what you hold*) turned on the desk's own storage, and it is the natural companion to every rung that already refuses by name. Silent corruption is exactly the failure that has no name until something checks for it. `verify` gives it one: `IntegrityFault`.

## The shape — `verify(catalog) !u32`

The desk's `fsck`, and it needs nothing new — only the one rule the deposit already used:

1. **Walk every held recording** in kept order, bounded by the count.
2. **Re-derive** each recording's content address from the bytes the store holds *now*, through the same `catalog.address_of` the deposit keyed it by. Checking by the exact rule it was keyed by is what makes equality mean integrity.
3. **Compare** the re-derived address to the keyed address (`address_at(i)`). Equal → sound; unequal → `IntegrityFault` by name, at the first drifted recording.

It returns the count verified sound (the whole count on success), and it **mutates nothing** — a keeper can run it as often as they like without disturbing what it proves.

## Invariants it asserts

- The walk is bounded by the count, itself bounded by `max_entries`.
- On success, every held recording verified sound — the count returned equals the whole count.
- A held address always fetches its stored bytes back (a `null` fetch is itself an integrity fault).

## What the selftest proves

1. **A whole desk verifies sound** — three recordings, `verify` returns three, the count untouched, a second verify agrees (read-only).
2. **An empty desk verifies trivially** — nothing to check, sound by definition.
3. **A re-deposit stays sound** — depositing the same bytes twice keeps one entry, still proven.
4. **A single flipped store byte is caught by name** — corrupting one byte of the packed store (the store is the catalog's own field) makes `verify` refuse `IntegrityFault`; flipping it back returns the desk to sound, proof the check tracks the bytes exactly and not a latched flag.

## Boundaries kept

`verify` reads only the catalog's own store and index, over public APIs, mutating nothing. It proves the bytes are unchanged — never *who* wrote them; the content address is an integrity identity, not a signature (a Kumara-signed chain of custody is a later, gated rung on the Yield road, Season 2 Journey 6). No disk, no network, no key signs, no funds — custody gate #2 untouched.

## Where this sits

With `verify`, the desk half of the Mikrophone is not only complete in function (store · sync · forget) but able to **prove its own soundness** — the same discipline the wire earns for a frame in flight (`deframe` verify-before-trust), now earned for a recording at rest. A capture is bounded, kept on purpose, carried only when committed, received only once proven, forgotten with no residue, synced to the union, and — now — provably unchanged for as long as the desk holds it.

---

*May every recording a desk keeps stay exactly the bytes a keeper chose, and may the desk always be able to prove it.*
