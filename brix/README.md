# Brix — the composition layer (and `infuse`)

**Language:** EN
**Status:** Living — `infuse` seated `20260811.185148` (SOON j2)
**Voice:** Kyri

Brix is Grain's **composition language** — it declares systems and evaluates to **Bron** (plain key-value data, one field per line). A `.brix` descriptor names a shape: scalar keys and a repeatable `field` list (see `../context/baton-museum/*.brix`, `../tools/gen/season/recursion_block.brix`, the root `../.brix`).

## `infuse` — deep merge/override (`infuse.rye`, landed `20260811`)

[`infuse.rye`](infuse.rye) merges an **override** descriptor onto a **base** one — Grain's own answer to `infuse.nix` (studied clean-room; the code is ours). Because a Brix descriptor is flat Bron, infuse.nix's deep recursive merge reduces to a **per-key override**:

- an override key's value(s) **replace** the base's for that key,
- base-only keys **pass through in place** (the base's order is kept, the override value sitting at the base key's first slot),
- override-only keys **append** after, in override order.

It is **zero-copy** — parsed keys and values slice the two source buffers; only the merged descriptor is written fresh — and **bounded** (`max_pairs` · `max_key` · `max_line` · `max_out`), refusing a too-small output rather than truncating.

```
rye build brix/infuse.rye -femit-bin=tools/.build/brix_infuse
tools/.build/brix_infuse selftest
rishi/bin/rishi run tools/b/brix_infuse_witness.rish
```

Proven by `prove_infuse`: a scalar overridden, a base-only key kept, a repeated `field` list replaced, an empty override an identity over the base, and a too-small output refused.

## Horizon

A **nested-descriptor deep merge** — recursive, where nested records merge rather than replace — waits on Brix growing nesting beyond flat Bron. Until then, per-key override is the faithful and complete infuse for the flat namespace.

---

*Compose by declaring; override by infusing; keep every bound named.*
