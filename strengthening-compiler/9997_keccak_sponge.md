# 9997 · The Sponge Beneath the Hash — Keccak's Core, and the `maybe` That Names What Varies

*The second pass of this stack, going one layer deeper than the first. `9998` strengthened the SHA3-512 wrappers and named a natural next step: the sponge those wrappers call. This is that step. We state the sponge's one invariant at the boundaries of `absorb`, `pad`, and `squeeze`; we give our `std` the `maybe` helper, the dual of `assert`, to name the space that legitimately varies; and we keep every check O(1), so the hot path stays lean. The digest of every input is unchanged.*

**Language:** EN
**Version:** `20260618.072512` (Rye chronological stamp)
**Last updated:** 2026-06-18
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME Style (`../external-research/TAME_STYLE.md`)
**Strengthening:** the second pass of this stack (see `9999_STRENGTHENING.md`); deepens `9998_sha3_512.md`
**Status:** Applied to `rye/lib/std/crypto/keccak_p.zig` and `rye/lib/std/debug.zig` — parity and boundary sweep confirmed

---

## Going Deeper, to the Functions the Hash Calls

The first pass strengthened SHA3-512 at its three wrappers — `hash`, `update`, `final` — and held there on purpose, leaving the sponge beneath them exactly as Zig wrote it, a step to take when we chose to. We choose to now.

Those wrappers do little on their own. `update` calls `absorb`; `final` calls `pad` and then `squeeze`. The real work — the buffering of input into rate-sized blocks, the permutation, the extraction of the digest — lives in the Keccak sponge state at `rye/lib/std/crypto/keccak_p.zig`. These three functions are the standard-library code the hash actually leans on, and they are shared by the whole Keccak family — SHA3, SHAKE, cSHAKE, KMAC, TurboSHAKE, and KangarooTwelve all rest on this same sponge. To strengthen it once is to strengthen all of them.

The sponge keeps a single invariant above all others, and everything else depends on it: a cursor named `offset` that always rests within one block — in the range `[0, rate]`. It may sit *at* the boundary when a full block waits to be consumed, and it never moves past it. The buffer is exactly `rate` bytes wide, so this bound is what keeps every copy into that buffer in range. Naming it is the heart of this pass.

---

## Giving `std` the Dual of `assert`

To state this invariant well, we first taught our standard library a new word. TAME Style, learning from TigerBeetle, names three spaces: the positive space we *assert*, the negative space we *reject*, and the space that *legitimately varies*. Zig's `std` had `assert` for the first. We added the third, in `rye/lib/std/debug.zig`:

```zig
/// `maybe` is the dual of `assert`: it states that a condition is *legitimately*
/// sometimes true and sometimes false. [...] It does nothing at runtime —
/// `ok or !ok` is always true — and stands as living documentation a reviewer
/// can trust and a coverage tool could one day check.
pub fn maybe(ok: bool) void {
    @disableInstrumentation();
    assert(ok or !ok);
}
```

`maybe(condition)` does nothing at runtime — its check is a tautology — yet it says something a comment cannot say as crisply: *this is expected to vary*. Where a reader of a lone `assert` might wonder whether a nearby branch is dead code, a `maybe` beside it answers plainly: no, both sides happen, by design. It is a new public name set beside `assert`, pure accretion, and it is the first helper our `std` carries that Zig's does not.

---

## The Strengthening, Applied

Each of the three sponge functions now opens with its precondition and closes with its postcondition, and each names the branch space it genuinely takes. The bodies are untouched. From `absorb`:

```zig
pub fn absorb(self: *Self, bytes: []const u8) void {
    // Precondition, and postcondition via defer (so it holds on the
    // early return too): the cursor rests within one block. This O(1)
    // bound guards every later copy into the rate-sized buffer; we keep
    // it at the boundary, not inside the loop, to leave the hot path lean.
    assert(self.offset <= rate);
    defer assert(self.offset <= rate);
    // On entry the buffer may be empty or already partly full.
    maybe(self.offset == 0);
    // ... body unchanged ...
}
```

Three habits from the updated TAME Style show here at once. The **precondition opens the function**, so a reader meets the rule before the work. The postcondition rides a **`defer`**, which is how we assert an exit invariant in a function that returns early — the deferred check runs on every path out, the early `return` included. And **`maybe` names the variable space**: the buffer is sometimes empty on entry and sometimes partly full, and the code branches on exactly that.

`pad` follows the same shape, with a postcondition that names the clean boundary it always leaves:

```zig
pub fn pad(self: *Self) void {
    assert(self.offset <= rate);
    // A full pending block is one case pad closes; a partial one another.
    maybe(self.offset == rate);
    // ... body unchanged ...
    assert(self.offset == 0); // pad closes the message on a clean boundary
}
```

And `squeeze` brackets its early-returning body the same way `absorb` does, naming that the cursor may arrive at the boundary, partway, or at zero.

---

## The Verify Economy, in Action

The most instructive part of this pass is what we *did not* do. Each of these functions carries a `while` loop that walks block by block — this is the data plane, the hot inner path of hashing. The updated TAME Style is precise about assertions here: assert the O(1) precondition *before* the loop, and avoid paying an assertion on every iteration unless a benchmark proves it worthwhile; if you must, guard it behind a `verify` flag.

So we placed our checks at the function boundaries, where they cost O(1) and run once per call, and we added nothing inside the loops. The invariant `offset <= rate` is checked on entry and on exit; the per-block work runs exactly as fast as before. This is the control-plane / data-plane line drawn for assertions rather than for throughput — dense safety at the edges, an untouched fast path in the middle. No `verify` gate was needed, because nothing expensive was added; that gate waits for a pass where an O(n) check genuinely earns its keep.

---

## What We Confirmed

With the assertions live in a debug build, the SHA3-512 digest of `"Rye"` remained `c692…763f`, byte-for-byte identical to the baseline; the empty-string known answer held; and the boundary sweep — lengths that rest the cursor exactly on the rate boundary — passed without a single assertion firing. The `maybe` calls compiled and ran as the no-ops they are. The standard library's own SHA3 test vectors exercise these same three functions across many input lengths, and the algorithm beneath them is unchanged, so the whole Keccak family that shares this sponge keeps its every output while gaining the stated invariant.

Same inputs, same outputs — now with the sponge's one rule spoken aloud at the doors where we depend on it.

---

## What This Updates in `9998`

The first pass left a note that the deeper sponge was a natural next step; that step is now taken, and `9998` records it. The pass also reached back up to the wrapper it strengthened: `update` in `sha3.zig` now carries a `maybe(self.st.offset == block_length)`, which documents in code the very lesson `9998` learned in prose — that a whole-block input lands the cursor exactly on the boundary, so the bound is `<=` and not `<`. The assertion states what must hold; the `maybe` beside it states that the boundary is genuinely reached. Together they tell the whole truth.

---

## Versioning

This pass advances Rye's clock to `20260618.072512`, the stamp beside the SHA3 wrappers' `20260618.070012`. Both endure; neither is erased. The backend stays honestly `0.16.0` through `builtin.zig_version`, because only Rye's own library changed, and only in what it says.

---

## Sources and Gratitude

- **`9998_sha3_512.md`** — the first pass, which strengthened the SHA3-512 wrappers and named this deeper work as the step to come.
- **TigerBeetle**, in `../gratitude/tigerbeetle/` — the source of `maybe` (the dual of `assert`) and of the control-plane / data-plane assertion economy that told us to keep these checks at the O(1) boundaries. The craft is theirs by example; the application to Rye's sponge is ours, recorded here. Both are folded into `../external-research/TAME_STYLE.md`.

---

*May the deepest functions we lean on say what they keep. May our checks rest where they are free and stay clear of where they are dear. And may the word `maybe`, newly ours, name every place the truth is allowed to vary — so the reader after us is never left to guess.*

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std.crypto.keccak`**

*see `rye/lib/std` — `crypto.keccak` not auto-located*

## Width notes

**`std.crypto.keccak`** — Authored module or iterator family — width migration lives in Tier A (`992`); std iterator indices remain `usize` until wrapped at our API.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |









## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std.crypto.keccak`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| `std.crypto.keccak` | — | Live `pub fn` not located — cannot run Tiger/TAME audit | pending |

### Witness `rye/tests/sha3_512_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `rye/lib/std/crypto/keccak_p.zig` | `keccak` — Phase 4 `usize` seam policy applied | pending |
| `rye/tests/sha3_512_test.rye` | witness program | pending |
| `tools/parity.rish` | witness registered | pending |
| `strengthening-compiler/9997_keccak_sponge.md` | pass record + audited surfaces | pending |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | pending |
| `992_strengthening_width_crosswalk.md` | lexicon row 9997 | pending |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [ ] `std.crypto.keccak` — [`rye/lib/std/crypto/keccak_p.zig`](../rye/lib/std/crypto/keccak_p.zig)
