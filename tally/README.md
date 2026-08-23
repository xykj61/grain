# Tally — the Garden Allocator, and the Small Marks That Guard It

**Language:** EN
**Last updated:** 2026-07-28 (Tensegral Arc IV r11 — canon Who calls Tally map · `tally_caller_map_witness`)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Checkable — bounded garden allocator · small marks · Kumara · Bud

**Tally is where bounds live.** A garden is a region of memory with a stated start, length, and end — bump allocation lands inside it or fails cleanly, and clearing it releases everything at once. Every hosted seed and tool in this tree reaches for a Tally garden rather than `std.heap.ArenaAllocator` directly, so the one owned name carries the one law: bounded, named, and cleared whole.

Beside the allocator itself, Tally holds a second kind of thing: small, universal marks that any module can import without taking on a real dependency — a copy that proves its own preconditions, a comptime check that proves a type's layout, a mark for a condition that may honestly go either way. None of these are Tally-specific in what they guard; they live here because Tally is the tree's home for exactly this size and shape of thing.

## The Garden

| File | Proves |
|------|--------|
| [`seed.rye`](seed.rye) | the first running Tally — a bounded region, asserted edges |
| [`gardens.rye`](gardens.rye) | Tally v1 — a fixed set of named Regions in one Gardens, each its own bounded garden |
| Bounds | `max_gardens = 8` · `max_name_len = 32` — pinned on metal by [`../tools/t/tally_gardens_witness.rish`](../tools/t/tally_gardens_witness.rish) (Tensegral r10) |

## The Marks

| File | Proves | Gratitude |
|------|--------|-----------|
| [`copy.rye`](copy.rye) | `copy_disjoint(T, target, source)` — asserts lengths agree and regions never overlap before calling the `@memcpy` it guards | TigerBeetle's `stdx.copy_disjoint` |
| [`maybe.rye`](maybe.rye) | `maybe(ok)` — the dual of `assert`: a condition that may honestly be true or false, turned into a name a reader can search for | TigerBeetle's `stdx.maybe`, matched at the letter |
| [`no_padding.rye`](no_padding.rye) | `no_padding(T)` — proves at compile time that an `extern struct` carries no hidden padding between or after its fields | TigerBeetle's `stdx.no_padding`, ported and honestly simplified (no `u128` branch — this tree has no field wide enough to need it yet) |
| [`parse_int.rye`](parse_int.rye) | Bounded integer parse mark — refuse overflow and trailing junk at the door | Hosted callers (caravan · linengrow · …) |
| [`kumara.rye`](kumara.rye) | Ed25519 identity mark — personal-server public face without private halves in-tree | Urbit point-identity spirit · saga key pane |
| [`bud.rye`](bud.rye) | Pedersen commitment mark (Bud) | Disclosure / SLCL4 family |
| [`pedersen.rye`](pedersen.rye) | Deprecated re-export → `bud.rye` | Name kept for elder import paths |

`no_padding`'s realest use today lives outside Tally itself, at `comlink/device_wire.rye`'s hosted selftest, which asserts it against every hand-designed virtio wire structure in `comlink/virtio_net.rye` — five structures a real device reads byte for byte, where a silent padding byte would leave a guest mute to its host. That is a correctness stake, well beyond style.

## Who calls Tally

**Canon seam map** (Tensegral r11). Callers reach marks through their own symlinks or imports — not copies. Tally itself imports **`std` only**. Witness: [`../tools/t/tally_caller_map_witness.rish`](../tools/t/tally_caller_map_witness.rish). Saga shelf points here rather than keeping a second table.

| Consumer family | Typical marks (symlink / import) |
|-----------------|----------------------------------|
| `linengrow/` (mala · wov · disclosure) | `kumara` · `tally_copy` · `parse_int` · `bud` |
| `caravan/` · `mantra/` · `comlink/` · `brushstroke/` | `tally_copy` · `parse_int` · `no_padding` (comlink wire) |
| `rishi/` · `glow/` · `aurora/` · `amphora/` · `granary/` · `mand/` · `mandi/` · `pond/apps/*` | marks as each surface needs |
| `tools/rye/kumara.rye` | Kumara seed path |

Other season shelves cite this section; they do not duplicate the rows.

## Elder call sites migrate on touch

`copyForwards`/`copyBackwards` and bare `@memcpy` are banned in new code; `tools/t/tame_style_check.rish` counts what remains and only ever watches the count fall. Nothing here is a sweep — each mark earns its home the day a real caller needs it, and `maybe` and `no_padding` both arrived exactly that way: proposed in full, unseated, until the tree had something genuine to use them on.

---

*May every garden stay exactly as bounded as it claims. May a mark that admits either answer stay honest about it. And may a hidden byte never again hide anywhere this tree can check for one.*
