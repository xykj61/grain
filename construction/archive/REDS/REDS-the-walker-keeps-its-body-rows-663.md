# The walker keeps its body -- recovered record

**Language:** EN
**Style:** Gauge, Meter
**Voice:** Kyri
**Status:** Recovered shelf -- checkable; historical report followed by its recovery correction
**Recovery:** `20260909.055623`

The record below was parked with its scan and control in Pheromone's September 6 stash.
Its stamp stays its identity. Its unpublished number is allocated after fetching xy.
The living pin has 173 bytes of room, so this closed record is born on its shelf.

---

**REDS %663 (`20260906.204454`) -- a census that gates 123 promises credited a witness for walking nothing, because it matched the walker's two halves independently across the file and its own header claimed they were one construct.** *What went wrong:* `tools/fixtures/r/rye_witness_walker_scan.sh` decided `walked` by asking whether a file held **both** an `@typeInfo(IDENT)` on a line saying `decls` **and** an `@field(IDENT` anywhere at all. Those are two ordinary things for a witness to write and never the same statement: a declaration-COUNT assert, `@typeInfo(m).@"struct".decls.len != 2`, plus one `@field(m, "max_thing")` down in `main`, walks not a single body and read `walked=1`. The header said the opposite in words -- *"Both halves are required. The loop alone names the type; `@field` is what forces each body through analysis"* -- so the check read as tight to every reader of the comment and to none of the code. Its ratchet has **no slack**, so the sixteen tracked pairs a false credit would hide are exactly the ones nobody would look for. *What caught it:* the air rota's own instruction, read this lap -- *press on a claimed boundary and see whether the hand goes through* -- applied to the guard my own last lap had leaned on. Planted in a throwaway repository against the elder scan on metal: `walked=1 unwalked=0` for a witness carrying no walker, and again for an `@field` sitting after the loop's closing brace on the same line. *What it taught:* **two conditions checked independently are not the conjunction their comment describes**, and a header that states the coupling makes the gap unreadable rather than obvious -- the docs-and-implementation seam, inside one file, three comment lines from the code it misdescribes. It is `%504`'s shape one turn in: there a claim predicate read only executable callers; here a walk predicate read only presence. *Repaired:* the loop body is found by **brace depth**, walked one character at a time, and a `@field` counts only at a position where depth stands above zero. All **66** witnesses the elder scan credited keep their credit, measured before the change shipped, and `unwalked` holds at **56** with the ceiling untouched -- a repair to a latent false credit should move no reading, and this one moved none. `rye_witness_walker_control.sh` goes **37 -> 45 behaviors**: `halves_apart` refused and then lifted by joining the halves, `field_after_close` refused, `one_line_walker` welcomed, each proven to bite the elder scan first. **CLOSED.**

## Recovery correction -- `20260909.055623`

The parked brace-depth repair passes its original coupling cases, but still credits
count blocks, fixed-field reads, a different capture, and a field after a one-line loop.
The recovered implementation recognizes the declaration-loop header, follows its body,
and requires the same module and captured declaration name at the field read.
Strings, character literals, and comments are masked before matching braces.
This is a source-shape census; compilation and module witnesses still prove behavior.

The expanded control passes 79 checks. The published scan fails 18 of those checks.
The live reading stays at 126 subjects: 70 walked, 56 unwalked, zero unreached.
The unwalked ceiling stays 56. A 128 KiB source-read bound passes at its exact edge
and refuses one byte above it. Test repositories stay in this checkout, and a Git
search ceiling keeps the repository-free case from finding the parent checkout.
All 16 stashes remain. The original parked implementation remains available there.
