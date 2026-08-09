# Discovery Walk — The Round-Trip Shape on One Bench

**Stamp:** `20260730.104053` · door 13 **GREEN** under j4 h4 Accrete-never-break  
**Language:** EN · **Voice:** Riyo · **Style:** Radiant  
**Lane:** edu discovery walk · `edu/` law · witness `tools/edu_discovery_walk_witness.rish`  
**Companion pattern:** [`../../docs-geode/sangha/01-descriptor-exchange.md`](../../docs-geode/sangha/01-descriptor-exchange.md)

*Written together by Keaton and Riyo.*

---

## What you will see

Five green lines, in order. First a peer describes itself inside a bound. Then a table claims and reaches. Gossip fans out under a ceiling and refuses a bad shape whole. Introduce checks identity at the kumara seam and turns a stranger away as loudly as it welcomes a friend. Last, the myc fold turns signed facts into a supply number every reader can recompute alone.

That composition is the **round-trip shape**: find neighbors, carry values, arrive with identity, agree by arithmetic. You run it all on one bench today.

## What this walk does not claim

The elder **wire both-sides** round-trip — two lanes across a real spawn/wait-for wire, tables converging from each side independently — is not yet metal on this page. That lab stays queued (Build queue seat 6). This walk teaches the parts that already print GREEN. Honesty first; theater never.

## Before you start

From the Grain root (`~/grain` on this Framework pier):

```
export RYE_ZIG=vendor/zig-toolchain/zig
```

You need the Rye toolchain at `rye/bin/rye` and a Zig 0.16 under that `RYE_ZIG` path.

## The walk — five commands

### 1. Descriptor — say who you are, not too much

```
env RYE_ZIG=vendor/zig-toolchain/zig rye/bin/rye run comlink/discovery/descriptor_test.rye
```

Expect: `GREEN: discovery descriptor — bound 512 welcome and refuse`  
Bound: `discovery_descriptor_max_bytes` **512**.

### 2. Table — claim and reach both ways

```
env RYE_ZIG=vendor/zig-toolchain/zig rye/bin/rye run comlink/discovery/table.rye
```

Expect: `GREEN: discovery table — Check shape · max_peers 256 · claim↔reach · stack LIFO · bound bitten`  
Bounds: peers **256** · staleness **4096**.

### 3. Gossip — travel under a fan-out ceiling

```
env RYE_ZIG=vendor/zig-toolchain/zig rye/bin/rye run comlink/discovery/gossip.rye
```

Expect: `GREEN: discovery gossip — Check shape · fanout 8 · refuse whole · never trim`  
Bound: fanout **8**. Malformed arrival refuses whole — never a quiet trim.

### 4. Introduce — identity at the seam · negative space loud

```
env RYE_ZIG=vendor/zig-toolchain/zig rye/bin/rye run comlink/discovery/introduce.rye
```

Expect: `GREEN: discovery introduce — Check shape · hops_max 2 · kumara seam · negative space loud`  
Bound: hops **2**. A stranger with the wrong shape is turned away; the far table stays clean. That refuse is the walk's negative-space bite.

### 5. Fold — agree on a number without trusting a holder

```
env RYE_ZIG=vendor/zig-toolchain/zig rye/bin/rye run mycelium/fold.rye
```

Expect: `GREEN: myc fold — Check shape · supply=872 · stars=1 · purity · refuse whole`  
Law: supply = issued − taxed at every prefix. Overdraw and unknown kinds refuse whole.

## One-shot witness

When you want the bench to re-run the whole walk and assert every GREEN line:

```
rishi/bin/rishi run tools/edu_discovery_walk_witness.rish
```

Expect: `GREEN: edu discovery walk — five steps · quartet + fold · no wire pier claimed`

## Bounds you inherited (not invented here)

| Bound | Value | Home |
| --- | --- | --- |
| descriptor max | **512** | `recursion_block.brix` |
| max peers | **256** | same |
| gossip fanout | **8** | same |
| staleness seconds | **4096** | same |
| introduce hops | **2** | same |

## Where to read next

- Sangha pattern one — descriptor exchange (shipping crystal)  
- Sangha pattern three — the five primitives reference  
- Elder wire round-trip — still a future door; do not invent it from this page  

---

*May every command you paste already know how to say GREEN. May the wire wait for its own metal. May the first walk leave you wanting a second.*
