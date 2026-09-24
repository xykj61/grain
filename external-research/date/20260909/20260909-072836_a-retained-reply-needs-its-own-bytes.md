# A Retained Reply Needs Its Own Bytes

**Stamp:** 20260909.072836
**Language:** EN
**Style:** Gauge, Field setting
**Voice:** Kyri
**Status:** Living, mixed -- the local experiment is checkable; the caller trial is proposed.
**Scope:** In-memory query response ownership at Git nib `7d229f82f9`, read and run on 2026-09-09.
**Grant:** [The table-store reading](../active-development/20260907-074815_two-grants-a-molt-lane-and-a-table-store.md).

What must stay alive after a query returns? A result count and a reply length describe how much
came back. The caller also needs to know which memory holds that answer, and when that memory
may serve another request. This study turns the [completion contract](../active-designing/20260909-062114_a-request-ends-before-its-budget-is-reused.md)
into a small retention experiment using the current scan and wire adapter.

## What the source owns

**Observation.** The [query](../comlink/recall_tablecloth_query.rye) returns names whose text fields
refer to arrays inside the catalog. The [wire adapter](../comlink/recall_tablecloth_query_wire.rye)
keeps those references in `build_response`. Its encoder copies text into the supplied byte
buffer. Its decoder returns text slices referring to the supplied encoded buffer. The revision
field is copied as an integer in both response paths. These source readings are pinned to the
scope nib above.

**External context.** The Zig language reference describes a slice as a pointer with a length
and asks APIs to explain pointer ownership and lifetime. Read on 2026-09-09, this supplies the
language concept; the experiment below supplies the evidence for these Rye modules.
[Zig language reference, lifetime and ownership](https://ziglang.org/documentation/0.15.1/#Lifetime-and-Ownership).

**Inference.** Copying the response record copies its text references. A successful return
therefore leaves a lifetime obligation with the caller. Copying encoded bytes can satisfy that
obligation when the destination remains alive and unchanged for every reader.

## A controlled reuse

**Observation.** On the Linux pier on 2026-09-09, the repository compiler built the probe below
against the existing modules. The experiment keeps all buffers alive in one function, uses one
catalog entry and one writer, and changes equal-length text. It performs no network operation.
The catalog edit is a deliberate harness mutation, outside the append-only catalog API; it tests
aliasing rather than claiming that a normal append rewrites an earlier leaf.

| Within this experiment | Observed result on 2026-09-09 |
|---|---|
| Encode one name with peer `p`, bolt `b`, revision `1`, path `old` | 14 encoded bytes |
| Reserve a separate maximum reply buffer | 340 reserved bytes; 14 bytes copied |
| Change catalog path to `new`, before encoding again | Built response reads `new`; decoded first frame reads `old` |
| Encode again into the first frame | Earlier decoded response reads `new` |
| Read a shallow copy of that response record | Path reads `new`; its pointer equals the first decoder's pointer |
| Read the response decoded from the separate copy | Path stays `old`; its pointer differs |

Every table result comes from a named `require` check in the probe. All **10 checks** pass with
exit status **0**. The program uses a **340-byte array** because that is the adapter's declared
maximum payload at the scope nib. Only its initialized **14-byte prefix** is decoded. The probe
also keeps the original frame and response records alive, so 340 bytes is the extra buffer
reservation, rather than the total memory used by the experiment.

**Observation.** The alias control changes the retained response's decoder input from
`owned_frame` to `frame`. It exits with status **1** and names `owned frame retains old answer`.
The mutation control writes `old` back into the catalog instead of `new`. It exits with status
**1** and names `built response borrows catalog`. These two controls test the dependency on
separate storage and the dependency on an actual source change.

**Inference.** This is a bounded reuse case, with every access inside live storage. It establishes
neither a use-after-free nor a deployed service fault. The test shows why a capacity check and a
completion flag alone cannot establish that a retained answer remains unchanged.

## Reproduce it

From the repository root, save the Rye block below as
`session-output/reply-retention-probe/retention_probe.rye`. Prepare local import links, then build
and run it. A changed source receives a fresh result rather than inheriting this receipt.

```sh
mkdir -p session-output/reply-retention-probe
for entry in "$PWD"/comlink/*; do
  target="session-output/reply-retention-probe/${entry##*/}"
  if [ ! -e "$target" ] && [ ! -L "$target" ]; then
    ln -s "$entry" "$target"
  fi
done
env RYE_ZIG=vendor/zig-toolchain/zig rye/bin/rye build \
  session-output/reply-retention-probe/retention_probe.rye \
  -femit-bin=session-output/reply-retention-probe/retention-probe
session-output/reply-retention-probe/retention-probe
```

```rye
const std = @import("std");
const ns = @import("recall_lap1.rye");
const qw = @import("recall_tablecloth_query_wire.rye");
fn require(ok: bool, label: []const u8) !void {
    if (!ok) {
        std.debug.print("REFUSED: {s}\n", .{label});
        return error.CheckFailed;
    }
}
pub fn main() !void {
    var cat: ns.BoltCatalog = .empty();
    try cat.append_leaf("p", "b", 1, "old", "data", "plain-text");
    var response: qw.QueryWireResponse = undefined;
    try qw.build_response(&cat, .{}, &response);
    var frame: [qw.max_wire_payload]u8 = undefined;
    const n = try qw.encode_response(response, &frame);
    try require(n == 14, "frame length");
    var decoded: qw.QueryWireResponse = undefined;
    try qw.decode_response(frame[0..n], &decoded);
    const shallow = decoded;
    var owned_frame: [qw.max_wire_payload]u8 = undefined;
    @memcpy(owned_frame[0..n], frame[0..n]);
    var owned: qw.QueryWireResponse = undefined;
    try qw.decode_response(owned_frame[0..n], &owned);
    try require(std.mem.eql(u8, decoded.hits[0].path, "old"), "initial decode");
    @memcpy(cat.leaves[0].path[0..3], "new");
    try require(std.mem.eql(u8, response.hits[0].path, "new"), "built response borrows catalog");
    try require(std.mem.eql(u8, decoded.hits[0].path, "old"), "encoded frame isolates catalog");
    const m = try qw.encode_response(response, &frame);
    try require(m == n, "equal length overwrite");
    try require(std.mem.eql(u8, decoded.hits[0].path, "new"), "decode borrows frame");
    try require(std.mem.eql(u8, shallow.hits[0].path, "new"), "struct copy still borrows frame");
    try require(std.mem.eql(u8, owned.hits[0].path, "old"), "owned frame retains old answer");
    try require(decoded.hits[0].path.ptr == shallow.hits[0].path.ptr, "shallow pointers agree");
    try require(decoded.hits[0].path.ptr != owned.hits[0].path.ptr, "owned pointer is separate");
    std.debug.print("GREEN: checks=10 frame_bytes={d} reserved_copy_bytes={d} struct_copy_borrows=yes owned_copy_retains=yes\n", .{n, owned_frame.len});
}
```

For the alias control, change only `decode_response(owned_frame[0..n], &owned)` to
`decode_response(frame[0..n], &owned)`. For the mutation control, change only the catalog's
`@memcpy` source from `"new"` to `"old"`. Build each from a fresh copy of the unaltered probe.
Both must refuse with the labels reported above.

## What Bakery can build from this

**Proposed trial.** Keep the current scan. For each admitted request, declare whether its answer
is consumed while borrowing storage or retained in caller-owned bytes. Bakery owns the caller
implementation; Patchouli reviews the Tally reservation seam. Carry the ownership transfer into
the existing completion contract before releasing the request's reservation.

A compact owned representation may keep the encoded bytes and decode views only while that
buffer is stable. A deep copy of each name is another valid design. Either choice must charge
all retained storage to the caller's bound. Copying a frame without also redirecting its decoded
views leaves those views attached to the old frame, which the alias control demonstrates.

The trial should retain one successful answer, reuse the request scratch for another answer,
and prove the first answer unchanged. It should separately check refusal, deadline exhaustion,
and late replies against a reused request identity. This probe supplies the successful-answer
memory case; the caller still needs the other completion cases and agreed workload budgets.

**Horizon:** the next caller retention trial, before planning a new store.
**Assumptions:** finite reply buffers, one owner per reservation, explicit transfer, and stable
owned storage until all readers finish. Concurrent writers require their own synchronization.
**Falsifier:** a retained answer changing after scratch reuse overturns the proposed ownership
contract. Any failed unaltered probe check at the scope nib overturns this local receipt.
**Confidence:** high in the measured aliasing case; the caller contract remains unimplemented.
Elapsed time, energy, concurrency safety, and durable recovery remain outside this experiment.

The storage decision still follows the grant: if the existing scan meets the caller's agreed
budgets, reuse closes the new-store question. Retention is a caller obligation under either choice.
