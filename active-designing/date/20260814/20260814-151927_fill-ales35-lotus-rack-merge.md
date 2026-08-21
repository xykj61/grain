# Fill ALES35 — Lotus's rack merge: two saved racks joined, sealed import

**Stamp:** `20260814.151927` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- Self-approved design read — the next agent-doable Lotus rung, purely local
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES35**
**Stands on:** [`../lotus/rack.rye`](../lotus/rack.rye) (ALES30) · [`../lotus/rack_seal.rye`](../lotus/rack_seal.rye) (ALES34) · [`../lotus/rack_sheet.rye`](../lotus/rack_sheet.rye) (ALES33)

---

## Why this rung, and why now

ALES30 gave a keeper a **rack** — a handful of named held spans. ALES33 let that rack **travel as text**, ALES34 **sealed** the text so it verifies before it is trusted. A keeper can now save a rack and load it back whole. Yet a real session is not one rack — it is stems gathered from many places: the count-in from yesterday's take, the chorus from an archived sheet, the clean bridge a bandmate sent. Loading a saved rack today **replaces** nothing and **joins** nothing; `verify_and_parse` hands back a *fresh* rack, standing alone.

The missing gesture is **merge** — bring the named slots of one rack into another, so a keeper loads an archived sheet's stems *into the session they are already working*, without losing what the live rack already holds.

**Lindy-first:** the load/import gesture is one a DAW is used ten thousand times over; a durable, well-named merge outlives any single edit. **Crux-first:** the hard-but-tractable core is **atomicity across two racks** — a merge must be all-or-nothing (a name collision or a ceiling overflow leaves the live rack *exactly* as it was), and it must never touch an existing slot's held audio. That is the one decisive move; once merge is proven, sealed import is a two-line composition of ALES34 + this rung.

This rung stays **purely local** — grafting fixed-array value structs in process. No signature, no key, no socket, no network, no funds, no device. The Kumara-signed carry and the ALES0-wire carry remain later seams on Keaton's word.

## The crux

**Merging `src` into `dst` grafts every named slot of `src` whole into `dst` — atomic and disjoint: it refuses `Duplicate` on any name already held and `RackFull` if the union exceeds the ceiling, and on any refusal `dst` is left exactly as it was; a grafted slot is byte-for-byte `src`'s held audio, disjoint from every `dst` slot, and `src` is unchanged (a read).**

Two facts make this exact:

1. **Precheck before any write.** Every fault is decided before a single slot is copied — walk `src`'s names, refuse `Duplicate` if `dst` already holds any, refuse `RackFull` if `dst.count + src.count > max_slots`. Only when every check passes do the copies run, and a plain value-struct copy cannot fail — so the writes are unconditional and the merge is all-or-nothing without a scratch rack.
2. **A slot is a disjoint value.** A `rack.Slot` embeds a whole ALES25 `Clipboard` with its own fixed buffers, so `dst.slots[dst.count] = src.slots[i]` copies the held audio byte-for-byte into `dst`'s own storage — the grafted slot depends on no `src` memory, disjoint from every neighbour by ALES30's own invariant. `src` is read only.

## Shape

A new module `lotus/rack_merge.rye`, two public functions:

- `merge(dst: *rack.Rack, src: *const rack.Rack) RackMergeError!void` — the crux above. `RackMergeError` is exactly `rack.RackError` (it forwards `Duplicate` / `RackFull`, names no new fault). Self-merge (`src` aliasing `dst`) collides on the first name and refuses `Duplicate` cleanly — safe by the same precheck.
- `verify_and_import(text: []const u8, dst: *rack.Rack) (RackSealError||RackError)!void` — the durable payoff: verify a sealed sheet through ALES34's `verify_and_parse` into a temporary rack, then `merge` it into `dst`. Integrity gate first (a corrupt sheet refuses `DigestMismatch` / `BadRecord` before it is trusted), then the atomic join. So a keeper loads a **verified** archive's stems into a live session in one call.

## What the witness proves

`tools/ales_rack_merge_witness.rish`, GREEN on metal:

1. **The crux** — merge a two-slot `src` into a two-slot `dst`; `dst` holds all four names in order, each slot's audio byte-for-byte, `src` unchanged.
2. **Disjoint graft** — a merged slot pastes identically to its source; editing `dst` after the merge never disturbs `src`.
3. **Atomic on collision** — a `src` sharing one name with `dst` refuses `Duplicate` and leaves `dst` (count and every slot's audio) exactly as it was; none of `src`'s non-colliding slots leak in.
4. **Atomic on overflow** — a union past `max_slots` refuses `RackFull`, `dst` untouched.
5. **Empty src** — a no-op that leaves `dst` unchanged.
6. **Sealed import** — `verify_and_import` loads a sealed sheet's slots into a live rack; a tampered sheet refuses `DigestMismatch` before a single slot joins, `dst` untouched.

## The road on

Once a keeper can save, seal, load, and **merge** racks, the natural next purely-local rungs are a **rack rename** (re-name a slot in place, refusing a collision) or a **sheet that carries more than one rack** (a session file). The **signed** carry (who wrote a rack, via a Kumara key) and the **wire** carry (a slot across the ALES0 audio frame) stay module seams for Keaton's word; the audio-interface hardware stays a paused research round.

*May a keeper's gathered stems join whole, and may no live slot ever be lost to a load.*
