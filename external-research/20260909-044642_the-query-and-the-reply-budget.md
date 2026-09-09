# The Query and the Reply Budget

**Stamp:** 20260909.044642
**Language:** EN
**Style:** Gauge, Field setting
**Voice:** Kyri
**Status:** Living, mixed -- local boundary experiment; the storage decision stays proposed.
**Scope:** Tablecloth's in-memory filter and reply encoder at Git nib `17c942e736`, read and run on 2026-09-09.
**Kin:** [The corrected store reading](20260909-035800_the-bounds-a-store-promises.md).

Which limit does a new index need to change? The query's caller gives a more useful answer than
the word database. This experiment follows one existing caller through its result array and
serialized reply. It measures counts and bytes, with elapsed time and durable storage outside scope.

## The caller and its separate budgets

**Observation.** The hosted [query delivery](../mantra/recall_tablecloth_query_delivery.rye)
decodes a request, builds a response, encodes it, and seals it for Comlink. This is an existing
source-level caller. The experiment below invokes the filter and encoder directly; it sends no
network traffic and makes no claim about a deployed application workload.

**Observation.** The filter reads a [namespace catalog](../comlink/recall_lap1.rye) whose capacity
is **16 leaf bindings**. The [query](../comlink/recall_tablecloth_query.rye) returns matching names
in catalog order. The [wire adapter](../comlink/recall_tablecloth_query_wire.rye) supplies an array
of **8 names** and uses a reply buffer of **340 bytes**. These declarations were read on
2026-09-09 at the nib above; each unit describes its own resource.

**Observation.** The [artifact catalog](../brushstroke/tablecloth.rye) declares a separate capacity of
**32 artifacts**, read on 2026-09-09 at the same nib. This describes a different surface.

**Inference.** That artifact count cannot supply the namespace query's bound. Likewise, a maximum hit count cannot
supply the byte budget for names of varying lengths.

## What ran

**Observation.** On the Linux pier on 2026-09-09, the repository's Rye compiler built the probe
below against the existing modules. The positive run passed, and two altered inputs made the
probe refuse. The experiment uses fresh memory and fixed input strings, with one writer and
no concurrent catalog mutation.

| Input, within this experiment | Observed result | Unit and source |
|---|---|---|
| Nine matching leaves, full local result array | Query returns 9 | names, probe assertion |
| Same nine leaves, wire response builder | `Overflow` | named error, probe assertion |
| One maximum-width name | 121 | encoded bytes, probe assertion |
| Two maximum-width names | 240 | encoded bytes, probe assertion |
| Three maximum-width names | `Overflow` | named error in 340-byte buffer |
| Eight one-byte peer/bolt/path names | 82 | encoded bytes, probe assertion |
| Three names adjusted to fill the byte budget | 340 | encoded bytes, probe assertion |
| Same names with one extra path byte | `Overflow` | named error at 341 required bytes |

**Inference.** For the valid source widths in this run, one maximum-width hit occupies
**119 bytes**: 16 peer bytes, 32 bolt bytes, 64 path bytes, 3 length bytes, and 4 revision bytes.
The response header adds **2 bytes**. Thus three such names need **359 bytes**, which exceeds
the **340-byte** reply buffer. These are arithmetic results from the encoder layout on
2026-09-09, rather than a network measurement.

**Observation.** The hit control replaces the broad query at the expected refusal with a query
for one revision. The call succeeds, and the probe exits with `ExpectedHitOverflow`.
The byte control replaces the three-name encoding call with the two-name call. It succeeds,
and the probe exits with `ExpectedByteOverflow`. Both controls exit with status **1**;
the unchanged probe exits with status **0**. These controls show the claimed refusals were
actually asked for, rather than credited to a harness that accepts every answer.

## Reproduce the boundary experiment

The source imports the current tree; a changed source earns a new receipt. From the repository
root, create an ignored pen and link the module directory's entries into it. Save the Rye block
below as `session-output/tablecloth-reply-probe/reply_probe.rye`, then build and run it.
The symlinks let the compiler resolve the same local imports without altering tracked modules.

```sh
mkdir -p session-output/tablecloth-reply-probe
for entry in "$PWD"/comlink/*; do
  target="session-output/tablecloth-reply-probe/${entry##*/}"
  if [ ! -e "$target" ] && [ ! -L "$target" ]; then
    ln -s "$entry" "$target"
  fi
done
env RYE_ZIG=vendor/zig-toolchain/zig rye/bin/rye build \
  session-output/tablecloth-reply-probe/reply_probe.rye \
  -femit-bin=session-output/tablecloth-reply-probe/reply-probe
session-output/tablecloth-reply-probe/reply-probe
```

```rye
const std = @import("std");
const ns = @import("recall_lap1.rye");
const qw = @import("recall_tablecloth_query_wire.rye");
const tcq = @import("recall_tablecloth_query.rye");
const assert = std.debug.assert;
pub fn main() !void {
    var cat: ns.BoltCatalog = .empty();
    const peer = "p" ** 16;
    const bolt = "b" ** 32;
    const path = "x" ** 64;
    var rev: u32 = 1;
    while (rev <= 9) : (rev += 1) try cat.append_leaf(peer, bolt, rev, path, "data", "plain-text");
    var names: [ns.max_bindings]ns.Name = undefined;
    const count = try tcq.query_tablecloth(&cat, .{}, &names);
    assert(count == 9);
    var response: qw.QueryWireResponse = undefined;
    if (qw.build_response(&cat, .{}, &response)) |_| return error.ExpectedHitOverflow else |err| assert(err == error.Overflow);
    try qw.build_response(&cat, .{ .revision = 1 }, &response);
    assert(response.hit_count == 1);
    var payload: [qw.max_wire_payload]u8 = undefined;
    const one_bytes = try qw.encode_response(response, &payload);
    assert(one_bytes == 121);
    var two: qw.QueryWireResponse = .{ .hit_count = 2, .hits = undefined };
    two.hits[0] = response.hits[0];
    two.hits[1] = response.hits[0];
    two.hits[1].revision = 2;
    const two_bytes = try qw.encode_response(two, &payload);
    assert(two_bytes == 240);
    var three = two;
    three.hit_count = 3;
    three.hits[2] = two.hits[1];
    three.hits[2].revision = 3;
    if (qw.encode_response(three, &payload)) |_| return error.ExpectedByteOverflow else |err| assert(err == error.Overflow);
    var exact = three;
    exact.hits[2].path = path[0..45];
    const exact_bytes = try qw.encode_response(exact, &payload);
    assert(exact_bytes == qw.max_wire_payload);
    var over = exact;
    over.hits[2].path = path[0..46];
    if (qw.encode_response(over, &payload)) |_| return error.ExpectedOneByteOverflow else |err| assert(err == error.Overflow);
    var short: qw.QueryWireResponse = .{ .hit_count = qw.max_wire_hits, .hits = undefined };
    for (0..qw.max_wire_hits) |i| short.hits[i] = .{ .peer = "p", .bolt = "b", .revision = @intCast(i), .path = "x" };
    const eight_bytes = try qw.encode_response(short, &payload);
    assert(eight_bytes == 82);
    std.debug.print("GREEN: scan_hits={d} hit_overflow=refused one_bytes={d} two_bytes={d} three_byte_overflow=refused eight_short_bytes={d} exact_bytes={d} one_byte_overflow=refused\n", .{count, one_bytes, two_bytes, eight_bytes, exact_bytes});
}
```

For the hit control, change only the `build_response` call expecting overflow to use
`.{ .revision = 1 }` instead of `.{}`. For the byte control, change only the encoding call
expecting overflow from `three` to `two`. Build each from a fresh copy of the probe.

## What crosses into design

**Inference.** An index may reduce entries visited. It leaves the number and width of matching
names unchanged. These refusal cases therefore provide no evidence for replacing the store.
The present scan already supplies the matching operation in this bounded example.

**Proposal.** Carry search work, result count, result bytes, and completion status as separate
parts of a caller's contract. Keep the current scan as the reference operation for an index trial.
Measure mutation cost and rebuild cost alongside any read improvement. The
[design essay](../active-designing/20260909-044642_a-query-budget-reaches-its-caller.md) carries that distinction into Grain's own vocabulary.

**Horizon:** the next caller-budget experiment, before a new storage implementation is scheduled.
**Assumptions:** finite catalogs, fixed query shapes, one writer, and a declared reply format.
**Falsifier:** any failed probe assertion at the named source nib overturns the recorded boundary.
For the proposed store decision, a scan that meets every agreed caller budget closes the
new-store plan. A scan that exceeds a search budget reopens the index choice, even if its reply fits.
**Confidence:** high in this recorded boundary result; no conclusion about latency, energy,
crash recovery, or which future storage engine wins.

The comparative sources and thanks remain in the corrected reading linked at the door.
This note adds a local experiment, with every storage choice still answerable to its caller.
