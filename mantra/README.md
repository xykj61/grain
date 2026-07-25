# Mantra — the Referential Namespace

**Language:** EN
**Last updated:** 2026-07-07
**Status:** Checkable — referential namespace front door
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)

---

Mantra is where names live. A name is **peer / bolt / revision / path**, and **recall** of a name returns the same bytes for all time — referential transparency held as a law, verified by digest on every read. Content is a **resin** at a SHA3-256 address; history accretes and never rewrites; a **Tilak** marks each leaf's layout. The full why rests in the namespace brief at [`../active-designing/20260706-023912_the-referential-namespace.md`](../active-designing/20260706-023912_the-referential-namespace.md); the normative surface rests in the reference spec at [`../context/specs/20260707-011412_mantra-referential-namespace-reference.md`](../context/specs/20260707-011412_mantra-referential-namespace-reference.md).

The module grew as one foundation and a family of compositions. `recall_lap1.rye` holds the catalog and its laws; every file after it **imports that foundation and edits nothing beneath itself** — the pattern held across the entire arc, parity 159 through 185.

## The Family

| File | One line | Witness |
|------|----------|---------|
| `recall_lap1.rye` | The foundation: `BoltCatalog`, append-immutable revisions, digest-verified `recall`, in-process `syncRevision` | `tools/mantra_recall_lap1.rish` (+lap2, lap3) |
| `recall_sync_wire.rye` | Sync request/response payload encoding for the wire | (exercised by every wire witness) |
| `recall_sync_delivery.rye` | One-shot per-resin sync over sealed datagrams, hosted **38478/38479** | `tools/mantra_recall_lap3_wire.rish` |
| `resin_batch.rye` | The signed batch frame (kind `0x03`): one signature, payloads prove by digest, have-already lane | `tools/mantra_resin_batch.rish` |
| `beading.rye` | A resin too large for one frame beads into content-addressed beads under a `bead-index` | `tools/mantra_beading.rish` |
| `recall_beaded.rye` | Append and recall transparent to size; beads land as derived `{path}.bN` leaves; `hydrateBeadStoreFromCatalog` | `tools/mantra_recall_beaded.rish` |
| `recall_batch_wire.rye` | Batch response framing + chunking (kind `0x04`) and the bounded `BatchAssembler` | (via batch witness) |
| `recall_batch_delivery.rye` | Batch sync over the wire, hosted **38480/38481**, chunked and beaded crossings; one bound socket per assembly with a silent-peer timeout | `tools/mantra_recall_batch_wire.rish` |
| `recall_by_mark.rye` | Read by Tilak within peer/bolt/revision; shared marks refuse without a path hint | `tools/mantra_recall_by_mark.rish` |
| `recall_two_way_sync.rye` (+`_delivery`, **38482/38483**) | Both directions as two symmetric `syncRevision` calls | `tools/mantra_recall_two_way_sync*.rish` |
| `recall_catch_up.rye` (+`_delivery`, **38484/38485**) | Try the next unheld revision until one ask comes back empty | `tools/mantra_recall_catch_up*.rish` |
| `recall_subscribe_poll.rye` (+`_delivery`, **38486/38487**) | Bounded repeat cycles over catch-up; host mirror is the same loop with a named pair list; `sleepIntervalNs` at cycle boundary | `tools/mantra_recall_subscribe_poll*.rish` |
| `recall_tablecloth_query.rye` | Optional-field filter over the bounded catalog; every match returned in held order | `tools/mantra_recall_tablecloth_query.rish` |
| `snapshot_export.rye` | I2 lap 1–3: batch replay; lap 2 horizon bundles; lap 3 hosted wire per revision group | `tools/mantra_snapshot_replay.rish`, `tools/mantra_snapshot_horizon.rish`, `tools/mantra_snapshot_wire.rish` |
| `snapshot_export_delivery.rye` | Lap 3: source-loop + fetcher over batch wire, hosted **38490/38491**; device **15567/15568** | `tools/mantra_snapshot_wire.rish` |
| `src/` | Mantra's own seed: `main.rye`, `diff.rye`, and the Weave aspect (`weave.rye`) beneath the namespace | SLC-1 witnesses |

Device-wire labs mirror the hosted ports under `../comlink/run_*_lab.sh` (sync **15561/15562**, batch **15563/15564**, catch-up **15565/15566**, snapshot **15567/15568**).

## Building

Any file builds directly; delivery files add `-lc` for sockets:

```
rye build mantra/recall_lap1.rye -femit-bin=mantra/bin/recall-lap1
rye build mantra/recall_batch_delivery.rye -lc -femit-bin=mantra/bin/recall-batch-delivery
```

Every file keeps the width laws the parity suite checks: fixed integer widths in authored code, `usize` only at the inherited-std seam with an adjoining cast, no tabs.

---

*May every name keep faith with its bytes. May each new ring import the last and leave it standing. And may a reader arriving here find the whole family legible in one calm page.*
