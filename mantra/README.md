# Mantra -- the Referential Namespace

**Language:** EN
**Last updated:** 2026-09-11
**Status:** Checkable -- referential namespace front door
**Where this sits:** home is [`../README.md`](../README.md) - a first hour in your hands is
[`../docs-geode/tutorials/the-first-hour.md`](../docs-geode/tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../SOURCE.md`](../SOURCE.md)
**Style:** Gauge, Door setting (see `../context/GAUGE_STYLE.md`)

---

Mantra is where names live. A name is **peer / bolt / revision / path**, and **recall** of a name returns the same bytes for all time -- referential transparency held as a law, verified by digest on every read. Content is a **resin** at a SHA3-256 address; history accretes and never rewrites; a **Tilak** marks each leaf's layout. The full why rests in the namespace brief at [`../active-designing/date/20260706/20260706-023912_the-referential-namespace.md`](../active-designing/date/20260706/20260706-023912_the-referential-namespace.md); the normative surface rests in the reference spec at [`../context/specs/20260707-011412_mantra-referential-namespace-reference.md`](../context/specs/20260707-011412_mantra-referential-namespace-reference.md).

The module grew as one foundation and a family of compositions. `recall_lap1.rye` holds the catalog and its laws; every file after it **imports that foundation and confines its edits to its own layer** -- a pattern that held across the entire arc, parity 159 through 185.

## The Family

| File | One line | Witness |
|------|----------|---------|
| `recall_lap1.rye` | The foundation: `BoltCatalog`, append-immutable revisions, digest-verified `recall`, in-process `syncRevision` | `tools/m/mantra_recall_lap1.rish` (+lap2, lap3) |
| `recall_sync_wire.rye` | Sync request/response payload encoding for the wire | (exercised by every wire witness) |
| `recall_sync_delivery.rye` | One-shot per-resin sync over sealed datagrams, hosted **38478/38479** | `tools/m/mantra_recall_lap3_wire.rish` |
| `resin_batch.rye` | The signed batch frame (kind `0x03`): one signature, payloads prove by digest, have-already lane | `tools/m/mantra_resin_batch.rish` |
| `beading.rye` | A resin too large for one frame beads into content-addressed beads under a `bead-index` | `tools/m/mantra_beading.rish` |
| `recall_beaded.rye` | Append and recall transparent to size; beads land as derived `{path}.bN` leaves; `hydrate_bead_store_from_catalog` | `tools/m/mantra_recall_beaded.rish` |
| `recall_batch_wire.rye` | Batch response framing + chunking (kind `0x04`) and the bounded `BatchAssembler` | (via batch witness) |
| `recall_batch_delivery.rye` | Batch sync over the wire, hosted **38480/38481**, chunked and beaded crossings; one bound socket per assembly with a silent-peer timeout | `tools/m/mantra_recall_batch_wire.rish` |
| `recall_by_mark.rye` | Read by Tilak within peer/bolt/revision; shared marks refuse without a path hint | `tools/m/mantra_recall_by_mark.rish` |
| `recall_two_way_sync.rye` (+`_delivery`, **38482/38483**) | Both directions as two symmetric `syncRevision` calls | `tools/m/mantra_recall_two_way_sync.rish` (+`_wire`) |
| `recall_catch_up.rye` (+`_delivery`, **38484/38485**) | Try the next unheld revision until one ask comes back empty | `tools/m/mantra_recall_catch_up.rish` (+`_wire`) |
| `recall_subscribe_poll.rye` (+`_delivery`, **38486/38487**) | Bounded repeat cycles over catch-up; host mirror is the same loop with a named pair list; `sleepIntervalNs` at cycle boundary | `tools/m/mantra_recall_subscribe_poll.rish` (+`_wire`, `_interval`, `_stop`) |
| `recall_tablecloth_query.rye` | Optional-field filter over the bounded catalog; every match returned in held order | `tools/m/mantra_recall_tablecloth_query.rish` |
| `snapshot_export.rye` | I2 snapshot export: batch replay - horizon bundles - hosted wire per revision group | `tools/m/mantra_snapshot_replay.rish`, `tools/m/mantra_snapshot_horizon.rish`, `tools/m/mantra_snapshot_wire.rish` |
| `snapshot_export_delivery.rye` | Snapshot export delivery: source-loop + fetcher over batch wire, hosted **38490/38491**; device **15567/15568** | `tools/m/mantra_snapshot_wire.rish` |
| `src/` | Mantra's own seed and the **Weave** aspect -- its own section below | see *The Weave* |

Device-wire labs mirror the hosted ports under `../comlink/` -- `run_recall_sync_wire_lab.sh`, `run_recall_batch_wire_lab.sh`, `run_recall_catch_up_wire_lab.sh`, `run_snapshot_export_wire_lab.sh` (sync **15561/15562**, batch **15563/15564**, catch-up **15565/15566**, snapshot **15567/15568**).

## The Weave -- the aspect Mantra was named for

Beneath the namespace sits [`src/weave.rye`](src/weave.rye), and it answers the other half of the
module's own question. Where recall keeps faith with **bytes**, the weave keeps faith with a
**document**: it holds every line a file has ever held, so that two hands editing one page join by
construction rather than by luck.

Three rules carry the whole model. A line is **named** by a pair, position and site, and **placed**
by a triple, run then site then position. Its **generation count is the tombstone** -- odd means the
line stands, even means it has gone, and zero means this side has yet to meet the line. Zero is
itself even, so an unseen position reads as gone through the very same parity test. And a **position
is permanent once given**, so a merge unions rather than renumbers. One `apply` takes one run and as many positions as it
inserts, which is what makes three inserted lines sort as one block.

| Surface | What it answers | Witness |
|---|---|---|
| `Line` - `Diff` - `Weave` | the model itself: every tracked copy declares the same fields in the same order | `tools/m/mantra_weave_model_witness.rish` |
| `apply` - `current` | an edit lands, and the document reads back in document order | `tools/m/mantra_diff_witness.rish` |
| `merge` | two weaves join: one answer in all six orders, associative, idempotent, both refusals by name | `tools/m/mantra_weave_merge_witness.rish` |
| `annotate` | what each side did at every position, in one of five readings -- `left_only`, `right_only`, `agreed`, `left_moved`, `right_moved` | `tools/m/mantra_weave_annotate_witness.rish` |
| `from_v1` - `to_v1` | the elder `mantra-weave-v1` record lifts in and writes back, every byte on disk reading the same document after | `tools/m/mantra_weave_v1_lift_witness.rish` - `tools/m/mantra_weave_v1_write_witness.rish` |
| `to_v2` - `from_v2` | the widened record carries the pair and the triple whole | `tools/m/mantra_weave_v2_witness.rish` |
| `mantra annotate <file>` | the same reading, reaching a person: every line marked two spaces, `+` or `-`, and the store left exactly as it stood | `tools/m/mantra_annotate_cli_witness.rish` |

The CLI carries that last row across. `mantra status` answers how many lines moved; `mantra
annotate <file>` answers what each line DID, reading the stored weave against the working file's
text and marking every line from the same two generation counts the merge reads. It is a reading, so
it writes nothing: the store keeps its bytes, HEAD keeps its place, and a second run prints the same
answer. A command that only reads opens through `open_for_reading`, which asks the directory whether
a repository stands here rather than asking the function that would answer by making one (the red
of `20260911.053330`).

Beside the weave, `src/` holds Mantra's own seed: `main.rye` writes the elder record on every
commit (`tools/m/mantra_cli_record_witness.rish`) and `store.rye` holds it
(`tools/m/mantra_store_witness.rish`). One guard stands over the whole room rather than over any
one surface -- `tools/m/mantra_declaration_walk_witness.rish` takes the address of every public
declaration, and that address is what forces analysis. Zig analyses lazily, so a plain build proves
one thing: the module parses. A module whose declarations stay untouched therefore keeps its green
the day a toolchain moves past it, and every `grep` reading it agrees (REDS %449).

Every Rye witness lives beside the module it proves, under `src/`, because Zig holds an import
inside the root file's own directory -- a test one room away would have to copy the module, and a
copy proves the copy. The charter is
[`../active-designing/20260905-153729_mantra-was-named-for-the-weave.md`](../active-designing/20260905-153729_mantra-was-named-for-the-weave.md).

## Building

Any file builds directly; delivery files add `-lc` for sockets:

```
rye build mantra/recall_lap1.rye -femit-bin=mantra/bin/recall-lap1
rye build mantra/recall_batch_delivery.rye -lc -femit-bin=mantra/bin/recall-batch-delivery
```

Every file keeps the width laws the parity suite checks: fixed integer widths in authored code, `usize` only at the inherited-std seam with an adjoining cast, no tabs.

---

*May every name keep faith with its bytes. May each new ring import the last and leave it standing. And may a reader arriving here find the whole family legible in one calm page.*
