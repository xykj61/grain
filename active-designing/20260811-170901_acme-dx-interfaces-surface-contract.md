# Acme DX — Interfaces Surface Contract (Design Season, Equinox 3)

**Language:** EN
**Stamp:** `20260811.170901`
**Status:** Design contract — the third of the Acme DX design season's four deliverables ([`../expanding-prompts/20260811-145659_acme-dx-design-season.md`](../expanding-prompts/20260811-145659_acme-dx-design-season.md)). Distilled from the interface the standing modules already keep; enforced today by checkers named below.
**Voice:** Kyri · **Style:** Radiant · **Audience:** an Acme Corporation employee on day two, building a module of their own
**Begins where Equinox 2 ends:** the newcomer has built one module by copying a reference ([`20260811-163927_acme-dx-first-hour-witness-contract.md`](20260811-163927_acme-dx-first-hour-witness-contract.md)); now they learn the interface every Grain module keeps, so their own module composes with the tree.

---

## What this contract pins

A Grain module presents three surfaces to the rest of the tree: an **API** other code calls, a **CLI** a person or a witness runs, and a **witness** that proves what the module claims. This contract names the shape of all three — the names, the bounds, the TAME shape a module must keep — drawn from what the standing modules already do, so a developer's day-two module is legible to every reader and gate on its first commit. Each rule below is something the tree *already* enforces; the citations are load-bearing.

## Surface 1 — the API a module presents

A module's public face is four kinds of declaration, in this order, each `pub`:

- **A version stamp** — `pub const <name>_version = "<one-clock stamp>";` (e.g. `store_version = "20260810.031234"`). Chronological identity, never a bare ordinal (labeling law).
- **Named bounds** — `pub const max_<thing>: u32 = <n>;` for every capacity, dimension, and result count (`max_records`, `max_dim`, `max_k`). Every collection, allocation, and pipeline names its maximum here, and the code enforces it at the edge with a `// invariant:` assert.
- **Error sets** — `pub const <Name>Error = error{ … };` — named errors a verb returns, never a bare `catch unreachable` at an honest failure.
- **Types, then verbs** — `pub const <Type> = struct { … };` then `pub fn <verb>(…) <Error>!<T>`. Verbs are **snake_case** and named by what they do (`upsert`, `remove`, `query`, `snapshot`, `restore`). A read borrows with `*const` and copies nothing (`query(store: *const Store, …)`), so zero-copy is the default the signature declares.

*Worked reference:* [`../mandate/store.rye`](../mandate/store.rye) — `store_version`, `max_dim`/`max_records`/`max_k`, `StoreError`/`DimError`, `Store`/`Match`/`QueryResult`, then `upsert`/`remove`/`query`. The whole shape reads top-to-bottom as: *this is how big it may grow, this is what can go wrong, this is what it holds, this is what you may ask it.*

## Surface 2 — the CLI a person or witness runs

Every module that builds to a binary answers one verb without fail:

```
<binary> selftest    →    prints a GREEN: line on success, nonzero exit on failure
```

The dispatch is a plain argv check in `main` — cited from `mandate/kumara.rye`:

```zig
if (args.len >= 2) {
    if (std.mem.eql(u8, args[1], "selftest")) return run_selftest(io);
}
```

Further verbs (a demo, a metal smoke) are added the same way — one `std.mem.eql(u8, args[1], "<verb>")` branch each (`sessiontest`, `metalsmoke`). A module's CLI is the list of verbs its `main` dispatches; `selftest` is the one every module owes.

## Surface 3 — the witness that proves the module

A module is not done because it builds; it is done because a witness proves a claim about it. A witness is a `.rish` that builds the module, runs a verb, and asserts — cited from [`../tools/mandate_store_witness.rish`](../tools/mandate_store_witness.rish):

```
let st = run ["mandate/bin/store" "selftest"]
assert st.ok else "…must exit 0"
assert (st.err contains "GREEN") else "…must report GREEN"
assert (st.err contains "<a named claim the module printed>") else "…"
```

The shape is fixed: **check `.ok`/`.code` before trusting output**, assert the **`GREEN:`** line, then assert each **named claim** the module makes — so the witness proves facts, not merely that a program ran. (`std.debug.print` writes to stderr, so a witness reads `st.err`.)

## The value model, and naming

- **One value model** — string, integer, bool, list, record, composed side by side, never tangled into one clever type.
- **Explicit widths** — `u32` for in-memory counts bounded by a named constant, `u64` for wire-persistent sizes and timestamps; `usize` only at the inherited-std seam, cast at the edge.
- **Names** — `snake_case` functions and files; a capability named by its **semantic label + stamp**, never a bare `lap N` (labeling law); a new module named for clarity, fun, and safety (the comlink tendency); the landed edge is a **nib**, never a *tip*.

## What already enforces this — so the contract is not just prose

- **`tame_style_check`** gates the bans (compound asserts, `usize` in authored API, `@memcpy` application sites) and prints the ratchets.
- **`rune_assert_sweep`** gates that the asserting cores keep their asserts.
- **The labeling guard** (`cion_module_labeling_witness`) keeps a capability's name semantic, never a bare ordinal.
- **The witness pattern itself** is the module's own proof.

A developer whose day-two module reads like `store.rye` — four-kind public API, a `selftest` verb, a witness asserting named claims — passes these gates by *being* the shape, not by remembering it.

## Definition of done for this equinox

- The three surfaces (API · CLI · witness) are each named with a **worked reference in the tree** (`store.rye`, `kumara.rye`'s dispatch, `mandate_store_witness.rish`), not invented here.
- Every rule cites the **checker that already enforces it**, so the contract is a map of live gates, not a wish.
- A developer can read this and know exactly what shape their own module owes before they write its first line.
- **Conformance witnessed `20260811.180851`** — `tools/interfaces_conformance_witness.rish` proves the reference module (`manual/tutorials/greet.rye`) keeps this shape, so the exemplar a newcomer copies cannot drift from the contract.

The final design equinox — **operations** — begins where this ends: the developer can build a module the tree accepts; next they learn to run, serve, and observe it in earnest.

---

*May a developer's own module be legible to every reader and gate on its first commit, because it keeps the shape the tree already trusts.*
