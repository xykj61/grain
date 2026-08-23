# Pattern One — The Descriptor Exchange

**Language:** EN · **Voice:** Kyri · **Style:** Radiant  
**Stamp:** `20260730.034319` · Build Journey · equinox A · journey 2 (h2 Aparigraha) · quest Do  
**Home:** `docs-geode/sangha/01-descriptor-exchange.md`  
**Witness basis:** discovery quartet GREEN on Cloud bench at stamp (descriptor · table · gossip · introduce)

---

## Context

A peer that wants neighbors says exactly who it is, and stops there. The **descriptor exchange** — how Glow peers announce themselves and learn each other — carries a bounded self-description that travels, fans out under a named ceiling, lands in a bounded table, ages out on the one clock, and may arrive through a star introducer at a named hop depth. Mycelium stays untouched: discovery finds peers rather than ordering them.

## Forces

- **Welcome vs refuse.** A payload that fits the bound is welcome; one that does not is refused whole — never trimmed quiet.
- **Travel vs clutch.** Gossip carries values across the table rather than inventing peers or stretching past fan-out.
- **Arrival vs stranger.** Introduce checks identity at the kumara seam; negative space is as loud as welcome.
- **Claim vs reach.** Every claimed peer slot is reachable, and every reach matches a claim — both ways, or the table is lying.

## The fold

Four compositions, one exchange:

1. **Descriptor** (`comlink/discovery/descriptor.rye`) — length-prefixed bytes inside `discovery_descriptor_max_bytes` **512**. Key, transport hints, freshness, lineage — nothing more.
2. **Table** (`comlink/discovery/table.rye`) — peer slots over Tally stack + Region. Ceiling `discovery_max_peers` **256**. Age-out `discovery_staleness_max_seconds` **4096**. Free-list is LIFO; claim↔reach both ways.
3. **Gossip** (`comlink/discovery/gossip.rye`) — exchange fold at `discovery_gossip_fanout` **8**. A malformed arrival turns away whole, kept intact rather than trimmed.
4. **Introduce** (`comlink/discovery/introduce.rye`) — star-as-introducer seam. `discovery_introduce_hops_max` **2**. Identity sealed through kumara; wrong shape turned away.

Bounds live in `tools/gen/season/recursion_block.brix` (v27 · explicit_bounds). Builds inherit them; they do not invent ceilings.

## The witness

Run on a bench with `RYE_ZIG` pointed at a Zig 0.16 toolchain:

```
rye/bin/rye run comlink/discovery/descriptor_test.rye
rye/bin/rye run comlink/discovery/table.rye
rye/bin/rye run comlink/discovery/gossip.rye
rye/bin/rye run comlink/discovery/introduce.rye
```

Each prints a GREEN Check line when the shape holds. This page ships only because those lines ran — page zero's law, honored.

---

*May every peer arrive carrying only what Aparigraha allows. May the table stay honest both ways. May the crystal keep what the metal already blessed.*
