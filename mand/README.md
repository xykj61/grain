# Mand -- M kernel vane: authority - scope - audit - retention - erasure

**Language:** EN  
**Last updated:** 2026-09-07  
**Status:** Seated -- ring-1 - ring-2 - ring-3 GREEN (test-only reach)  
**Where this sits:** home is [`../README.md`](../README.md) - a first hour in your hands is
[`../docs-geode/tutorials/the-first-hour.md`](../docs-geode/tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../SOURCE.md`](../SOURCE.md)
**Graduation:** Early vane-home ruling `20260725.120701` -- kernel concern out of product host  
**Style:** Gauge (see `../context/GAUGE_STYLE.md`)

## What this room is

Mand names custody at the kernel seam. Three questions belong to it, and each has a ring:
who may see a record, how long that record is kept, and when the key that unlocks it
may be destroyed. Linengrow hosts product commerce; Mand owns the rings beneath it.

The three questions arrive in that order for a reason. A system answers *who may see* on
every read, so ring 1 is one capability check, and that check is its whole body. A system answers
*how long* on a clock, so ring 2 keeps a standing rather than a decision -- KEEP, ELIGIBLE,
HELD -- and lets the clock move it. A system answers *when the key goes* exactly once, so
ring 3 writes the removal fact before it destroys anything, which is what makes an erasure
auditable after the bytes it erased are gone.

The rings reward a denial that leaves a trace. A custody layer answering yes or no alone
is cheap to write and hard to audit, since one bare denial covers three separate
situations: an unknown subject, an ungranted resource, and rights that fall short. Mand
asks its capability table for the reason, and ring 1 records the grant, so a later reader
can tell which of the three actually happened.

## What this room borrows, and how

Two modules here belong to other rooms and are reached by symlink rather than by copy:

| Link | Reaches | Why it is shared |
|---|---|---|
| `capabilities.rye` | `../caravan/capabilities.rye` | the bounded capability table, Caravan's own |
| `tally_copy.rye` | `../tally/copy.rye` | `copy_disjoint`, Tally's own |

Zig holds an import inside the root file's own directory, so a module reached by a bare
name is a directory relationship the language enforces. A symlink satisfies that rule
while keeping exactly one copy of the source in the tree, so the two rooms move together
by construction. `tools/co/copy_lag_witness.rish` measures the distance between a shared
file and a second copy of it.

## The rings

| Ring | Seam | Witness |
|------|------|---------|
| **1** | Grant or refuse see at one capability check | `tools/m/mand_ring1_witness.rish` |
| **2** | Retention standing KEEP - ELIGIBLE - HELD | `tools/m/mand_ring2_witness.rish` |
| **3** | Destroy keys; record removal fact first (test-only) | `tools/m/mand_ring3_witness.rish` |

```sh
rishi/bin/rishi run tools/m/mand_ring1_witness.rish
rishi/bin/rishi run tools/m/mand_ring2_witness.rish
rishi/bin/rishi run tools/m/mand_ring3_witness.rish
```

Ring 3 stays test-only on purpose. A verb that destroys a key earns its reach one witness
at a time, and the reach it has today is the reach a witness has proven.

Counsel: [`../counsel/date/20260725/20260725-001200_forgetting-without-breaking.md`](../counsel/date/20260725/20260725-001200_forgetting-without-breaking.md) - claim [`../waymarks/date/20260725/20260725-120701_mand-home-ring3.md`](../waymarks/date/20260725/20260725-120701_mand-home-ring3.md)
