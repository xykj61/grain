# The two functions

*The event, the picture, and the ceiling, copied from the file a witness still reads.*

**Language:** EN
**Style:** Bhakta at the Door setting, with Radiant warmth
**Guide:** [`../../context/BHAKTA_STYLE.md`](../../context/BHAKTA_STYLE.md)
**Voices:** Kyri and Kyli, jointly
**Written:** `20261007.114657`
**Status:** Living -- the span scan below was the check
**Room:** checkable -- each fence is a line range in `mantra/src/weave.rye`
**Where this sits:** home is [`../../README.md`](../../README.md) - the short telling is [`the-list-and-the-picture.md`](the-list-and-the-picture.md) - the plan is [`../../expanding-prompts/20261007-114657_the-two-functions-and-the-span.md`](../../expanding-prompts/20261007-114657_the-two-functions-and-the-span.md)

---

## Kyli -- the huddle

The list and the picture have two doors in one file. Kyri will show you the lines. A small check reads those same lines back from the file, so a later edit cannot leave this page quoting a line that has moved.

## Kyri -- the ceiling

The list has a ceiling. `max_weave_lines` is `1 << 20`, which is 1,048,576 lines. This is line 142 of `mantra/src/weave.rye`, read `20261007.114657`.

```142:142:mantra/src/weave.rye
pub const max_weave_lines: u32 = 1 << 20;
```

## Kyri -- the event

The event is `apply`. It takes one `Diff`. This is line 1376.

```1376:1376:mantra/src/weave.rye
    pub fn apply(self: *Weave, allocator: std.mem.Allocator, diff: Diff) !void {
```

## Kyri -- the picture

The picture is `current`. It returns the lines that stand. This is line 1690.

```1690:1690:mantra/src/weave.rye
    pub fn current(self: *const Weave, allocator: std.mem.Allocator) ![]const Line {
```

A line stands when its generation is odd. This is line 1703.

```1703:1703:mantra/src/weave.rye
            if (line.gen % 2 == 1) { // odd = present
```

## Kyri -- the two names

Mantra's own door, [`../../mantra/README.md`](../../mantra/README.md), says Mantra is where names live. The words "fold head" live on the lineage page [`../../external-research/grain-lineage-silo/the-state-at-center.md`](../../external-research/grain-lineage-silo/the-state-at-center.md). Say both once. The silo names the center. The function you can open is `current`.

## The check

From the root of the tree:

```
sh tools/fixtures/d/docs_geode_span_scan.sh docs-geode/tutorials/the-two-functions.md
```

Each fence above is `start:end:path`. The scan reads those lines from the source and compares them to the fence. When they match, it prints `verdict=ok`. When a line moves, it prints `mismatch` and the range.

At `20261007.114657` that command printed `spans=4`, `mismatch=0`, `verdict=ok`.

---

*May the fence stay equal to the line it names.*
