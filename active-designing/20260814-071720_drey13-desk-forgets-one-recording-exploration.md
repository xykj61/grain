# DREY13 — the desk forgets one recording on purpose

**Stamp:** `20260814.071720` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Exploration — self-approved design round for the next Mikrophone rung
**Season A** (Hardware & Right-to-Repair) · **waymark DREY** · Mikrophone firmware journey · rung **DREY13**
**Kin:** [`../mikrophone/README.md`](../mikrophone/README.md) · [`20260814-070309_drey10-redact-a-span-before-the-keep-exploration.md`](20260814-070309_drey10-redact-a-span-before-the-keep-exploration.md) · [`20260814-064900_drey7-content-addressed-desk-catalog-exploration.md`](20260814-064900_drey7-content-addressed-desk-catalog-exploration.md)

---

## The gap this closes

The founding promise reads *"What forgets, protects,"* and the journey has proven it on the **device** in two shapes already: `session.power_down` forgets the whole working buffer with no residue (DREY0), and `redact` lets a keeper strike one span on purpose, the struck bytes as gone as a powered-down buffer (DREY10). Both halves — forget-whole and forget-one — stand on the device side.

The **desk** side carries only one of those halves. `catalog.clear` (DREY7) forgets the whole content-addressed store, zeroing every byte. Yet a desk that can only forget everything cannot honor a keeper who wishes to strike **one** recording — the civic microphone captured a name that must leave the desk, or a keeper exercises a plain right to be forgotten for a single artifact while the rest of the day's work stands. Today the only honest answer is `clear` the whole desk and re-deposit everything else, which is neither bounded work nor a real forgetting of just the one.

DREY13 closes that asymmetry: **the desk forgets one recording by its content address, with the same no-residue proof `redact` earns on the device.** After it, the promise is symmetric — forget-whole and forget-one, on both hands.

## The shape — `forget(catalog, address)`

The catalog (DREY7) is a packed byte store with a bounded index of entries `{address, off, len}`, deposited in first-deposit order, so the store is contiguous and each entry's offset strictly rises. Forgetting one entry mirrors `redact` exactly, one level up — from a working buffer of samples to a packed store of recordings:

1. **Find, or refuse by name.** `index_of(address)` gives the entry, or `forget` refuses **`NotHeld`** before a byte moves — a miss is a miss, never a guess, exactly as `fetch` already promises.
2. **Close the gap.** Shift the tail (every store byte after the struck recording, out to `used`) down over the removed span with a plain bounded loop — front to back, disjoint by construction, never a bare memcpy.
3. **Zero the vacated region.** Every byte from the new `used` out to the old `used` becomes zero, so no residue of the struck recording — or of the tail at its old positions — survives a full scan. This is the residue-free proof, the same zeroing `power_down` and `redact` earn.
4. **Repair the index.** Drop the entry, shift the later entries down one slot, and decrement each of their offsets by the removed length (they all lay past the gap, so each moves down by exactly that much). Clear the now-unused last slot to a fresh entry so no stale address lingers. Decrement the count.

Because the store is packed in entry order, the removed span is exactly one contiguous region and every following entry moves by the same amount — no fragmentation, no free-list, no unbounded bookkeeping.

## Invariants it asserts

- The count drops by **exactly one**; the used length drops by **exactly** the removed recording's length — never more, never less.
- The address is **no longer held** after the call (`!holds`), and re-depositing the same bytes lands fresh — proof the bound was truly released, not merely hidden.
- **No residue:** every byte from the new used length out to the old used length is zero (a bounded scan, the desk's echo of `redact`'s `freed_all_zero`).
- Every **surviving** recording still fetches back byte-for-byte under its own address, and the manifest (`address_at`) enumerates the survivors in their kept order.

## What the selftest proves

1. Forgetting the **middle** of three recordings leaves the other two fetchable byte-for-byte, drops the count to two, and leaves no residue in the vacated store region.
2. Forgetting an address the desk **never held** refuses `NotHeld`, the catalog standing exactly as it was.
3. **Forget then re-deposit** — after forgetting, the address is absent; depositing the same bytes again lands fresh and the count rises, proving `forget` released the entry bound.
4. Forgetting the **only** recording empties the desk and leaves the whole store provably zero — `forget` reaching the same floor as `clear`, one recording at a time.
5. A **no-residue** proof against distinctive bytes: a recording of a single repeated byte, forgotten, leaves that byte nowhere in the whole store out to `max_bytes`.
6. The **byte budget is released** — a store filled to a bound admits a new recording once one is forgotten, so forgetting frees real space rather than merely dropping an index row.

## Boundaries kept

`forget` touches only the catalog's own store and index — no disk, no network, no key signs, no funds. Real hardware, a real desk, a real disk stay **custody gate #2**; serving or syncing over a real transport stays the **Comlink-served gate** (Season 1, Journey 2). This rung is pure Rye on the bench, bounded, invariant-asserted, refusing by name — the desk's forgetting made as readable, all the way down, as the device's.

---

*May the desk forget exactly what a keeper asks it to forget, and hold, untouched, everything else they chose to keep.*
