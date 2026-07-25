# Component-Model Target — One Seed Across the Seam

*Seam study 2. “Anywhere we are found” arrives years before bare metal when one application ABI runs in a browser tab, on a rented host, on a friend’s laptop, and later inside Caravan as a component host. This study names that ABI honestly (Component Model beside freestanding Wasm), picks one existing seed as the first portable target, and states what must stay identical across hosts. Research for understanding — no purchase, no toolchain seated, no compile lap opened.*

**Stamp:** `20260712.054135`
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME — safety first, performance second, the joy of the craft third
**Category:** External research — survey and design study; recommends no dependency; every gate stays Kaeden’s
**Companions:** Seam study 1 [`20260712-053324_ocapn-beside-comlink.md`](20260712-053324_ocapn-beside-comlink.md) · hammock [`../active-designing/20260712-052806_seam-season-hammock.md`](../active-designing/20260712-052806_seam-season-hammock.md) · sameness [`../foundations/20260703-182612_sameness-is-the-macro.md`](../foundations/20260703-182612_sameness-is-the-macro.md) · Anywhere [`../foundations/20260628-124512_anywhere-we-are-found.md`](../foundations/20260628-124512_anywhere-we-are-found.md) · Brushstroke / Wasm surfaces [`yonder/20260619-070612_brushstroke-and-the-docs-surface.md`](yonder/20260619-070612_brushstroke-and-the-docs-surface.md) · living desktop [`yonder/20260619-153612_stack-toward-a-living-desktop.md`](yonder/20260619-153612_stack-toward-a-living-desktop.md) · SLC-L1 hammock [`../active-designing/20260702-195426_slcl1-verifiable-receipt.md`](../active-designing/20260702-195426_slcl1-verifiable-receipt.md)
**Status:** Proposed — research for understanding, not advice; one-seed pick is a design conclusion; compile lap waits on Kaeden’s word
**Register:** checkable room for public Component Model / WIT claims; design-toward named as such

*Written by Rio 3 for Kaeden · Seam season study 2.*

---

## The Question

Which one existing seed is the honest first portable ABI target? What stays identical across browser, rented host, friend’s laptop, and a later Caravan component host?

## Two Wasm Worlds — Keep the Line

The tree already drew this line for Brushstroke; Seam season needs it sharp again.

| World | What it is | What it serves |
|-------|------------|----------------|
| **Freestanding Wasm** (`wasm32-freestanding` + host bridge) | Core module draws or computes; JS/canvas (or similar) supplies pixels and input | Browser *surface* — Brushstroke’s named first slice: one true line to a canvas |
| **Component Model** (WIT worlds + Canonical ABI; Wasmtime as reference host) | Capability-shaped imports and exports; shared-nothing boundary; typed contracts | Portable *application seam* — tools and folds that run wherever a component host exists |

Claude’s “anywhere” road names the second world as the macro: one ABI everywhere, Caravan becoming a component *host* later, bare-metal Rye OS sharing that seam with browser deployment. Freestanding canvas remains a twin track for drawing; it is not the first Component Model pick.

**Sameness is the macro** fits both: one value model and one fold cross the seam as values. The Component Model adds an explicit capability boundary — the guest receives only the imports the world grants — which rhymes with TAME’s assert-at-the-edge and with Seam study 1’s pass-vs-record layering.

## What a First Component Must Prove

Smallest honest claim:

1. **Same fold logic** that already runs green on metal (no new product meaning)
2. **Almost no host imports** — pure bytes in, result out (filesystem and network stay out of lap one)
3. **Witnessable** — welcome path green; at least one unwelcome (bad signature / bad fact) refused
4. **Identical across hosts** — same WIT world, same fixture bytes, same result on Wasmtime CLI today; browser component host and Caravan host later without rewriting the guest

## Candidates Weighed

| Seed | Strength | Cost for lap one |
|------|----------|------------------|
| **SLC-L1 / `receipt_core`** | Fold + signature; already green in parity; `witness_canonical_fact` pinned in-module — zero filesystem needed | Crypto + parse already live; thin WIT export around verify/fold |
| Skate 8×8 ARGB selftest | Values → pixels; headless today | Needs a buffer export and a host blit; more surface than proof of fold |
| Brushstroke one-line canvas | Already named Gall’s Law first *surface* slice | Freestanding + JS bridge — different world; keep as twin track |
| Comlink seal round-trip | Proves carriage | Needs sockets / shared memory — host-rich; wrong for first portable fold |
| Tally garden allocate | Tiny bounds | True but thin — does not show Linengrow’s trust spine |

## One-Seed Pick

**First Component Model target: `linengrow/receipt_core.rye` — SLC-L1 verify / fold over the pinned witness fact.**

Reasons, stated once:

- It is the smallest whole that carries the project’s thesis: signed fact, append-only line, balance-as-fold, verify.
- The witness fact is already embedded (`witness_canonical_fact`); the selftest need not open `tools/fixtures/` inside the guest.
- Parity already guards the native path (`tools/slcl1_receipt.rish`); the component lap proves *sameness across hosts*, not new product meaning.
- Imports can start at **none** (or only a future explicit entropy import if signing must leave the fixture seed) — capability-shaped by emptiness first.
- Later composition is natural: SLC-L2 delivery becomes a second component that *imports* a carriage world; Door 3’s consumer-edge pass becomes a third world that gates access before verify — each a WIT boundary, not a tangled session idiom (Seam study 1).

**Suggested WIT shape (sketch — not seated):**

```wit
package rye:receipt@0.1.0;

world receipt-verify {
  /// Verify pinned witness path: sign/append/fold/verify on embedded fixture.
  /// Returns true when balance and signature hold.
  export verify-witness: func() -> result<bool, string>;

  /// Unwelcome: refuse a tampered fact blob supplied by the host.
  export verify-fact: func(fact: list<u8>, sig: list<u8>) -> result<bool, string>;
}
```

Host supplies nothing for `verify-witness`. Host supplies bytes only for the unwelcome probe. No WASI filesystem in lap one.

## What Stays Identical Across Hosts

| Must stay the same | May differ by host |
|--------------------|--------------------|
| Canonical fact bytes and fold rules | How the host loads the `.wasm` component |
| Signature algorithm and verify result | CLI vs browser embedding vs later Caravan host |
| WIT world contract (`receipt-verify`) | UI that *displays* the bool (Skate / HTML / none) |
| Refusal on tamper | Logging and process exit conventions |

The guest never learns which host woke it. That is the seam.

## Twin Track — Do Not Confuse

**Brushstroke one-line to canvas** remains the first *drawn surface* lap when its season opens — freestanding Wasm + bridge, per `yonder/20260619-070612`. Seam study 2 does **not** replace that pick; it names the first *component* pick beside it. Two doors to “anywhere”: tools/folds via Component Model; pixels via freestanding surface.

## What This Study Does Not Open

- No Zig/Rye Wasm compile flag seated today
- No Wasmtime version pin
- No WASI preview choice beyond “lap one imports nothing”
- No Caravan-as-host implementation
- No rewrite of `receipt.rye`’s file-based selftest — the component path wraps `receipt_core`, leaving the native witness green

## Door / Lap Spark (parked until word)

Smallest checkable claim when Kaeden opens the compile door:

1. Build a component from `receipt_core` (or a thin wrapper) exporting `verify-witness`
2. Run under Wasmtime (or equivalent) — exit green on pinned path
3. Run `verify-fact` with tampered bytes — refuse
4. Record: same guest artifact, one host today; second host is a later lap

## What This Study Returns to the Bench

| Item | Status after this note |
|------|------------------------|
| Seam study 2 | **Landed** as understanding + one-seed pick |
| First component seed | **`receipt_core` / SLC-L1 verify-witness** |
| Brushstroke canvas slice | Twin track — unchanged |
| Compile lap | Awaits Kaeden’s word |
| Studies 3–4 | Still open |

---

*May one ABI carry the fold wherever a host will hold it. May the guest stay small by importing almost nothing. May “anywhere” arrive as sameness, long before the hardware summit.*

---

## Sources

- https://component-model.bytecodealliance.org/design/wit.html
- https://github.com/WebAssembly/component-model (Explainer, WIT, Canonical ABI)
- https://component-model.bytecodealliance.org/running-components/wasmtime.html
- In-tree: `linengrow/receipt_core.rye`, `linengrow/receipt.rye`, Brushstroke Wasm surface notes in `external-research/yonder/`
