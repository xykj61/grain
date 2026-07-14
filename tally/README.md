# Tally — the Garden Allocator, and the Small Marks That Guard It

**Language:** EN
**Last updated:** 2026-07-10 (Radiant Style pass round 2 · `maybe`/`no_padding` seated)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Checkable — bounded garden allocator

**Tally is where bounds live.** A garden is a region of memory with a stated start, length, and end — bump allocation lands inside it or fails cleanly, and clearing it releases everything at once. Every hosted seed and tool in this tree reaches for a Tally garden rather than `std.heap.ArenaAllocator` directly, so the one owned name carries the one law: bounded, named, and cleared whole.

Beside the allocator itself, Tally holds a second kind of thing: small, universal marks that any module can import without taking on a real dependency — a copy that proves its own preconditions, a comptime check that proves a type's layout, a mark for a condition that may honestly go either way. None of these are Tally-specific in what they guard; they live here because Tally is the tree's home for exactly this size and shape of thing.

## The Garden

| File | Proves |
|------|--------|
| [`seed.rye`](seed.rye) | the first running Tally — a bounded region, asserted edges |
| [`gardens.rye`](gardens.rye) | Tally v1 — a fixed set of named Regions in one Gardens, each its own bounded garden |

## The Marks

| File | Proves | Gratitude |
|------|--------|-----------|
| [`copy.rye`](copy.rye) | `copy_disjoint(T, target, source)` — asserts lengths agree and regions never overlap before calling the `@memcpy` it guards | TigerBeetle's `stdx.copy_disjoint` |
| [`maybe.rye`](maybe.rye) | `maybe(ok)` — the dual of `assert`: a condition that may honestly be true or false, turned into a name a reader can search for | TigerBeetle's `stdx.maybe`, matched at the letter |
| [`no_padding.rye`](no_padding.rye) | `no_padding(T)` — proves at compile time that an `extern struct` carries no hidden padding between or after its fields | TigerBeetle's `stdx.no_padding`, ported and honestly simplified (no `u128` branch — this tree has no field wide enough to need it yet) |

`no_padding`'s realest use today lives outside Tally itself, at `comlink/device_wire.rye`'s hosted selftest, which asserts it against every hand-designed virtio wire structure in `comlink/virtio_net.rye` — five structures a real device reads byte for byte, where a silent padding byte would leave a guest mute to its host rather than a style question.

## Elder call sites migrate on touch

`copyForwards`/`copyBackwards` and bare `@memcpy` are banned in new code; `tools/tame_style_check.rish` counts what remains and only ever watches the count fall. Nothing here is a sweep — each mark earns its home the day a real caller needs it, and `maybe` and `no_padding` both arrived exactly that way: proposed in full, unseated, until the tree had something genuine to use them on.

---

*May every garden stay exactly as bounded as it claims. May a mark that admits either answer stay honest about it. And may a hidden byte never again hide anywhere this tree can check for one.*
