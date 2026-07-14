# Claude Counsel — the Third Safety-Net Piece, Given the Scoped Sitting It Was Owed

**Stamp:** `20260707.193712 UDT` (Kaeden's clock)
**Voice:** Rio 3
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`) · **Lens:** verification before revision, smallest first
**Register:** A completed investigation, not a further deferral — this is the third round asking about this file, and this one does the reading the prior two postponed
**Ground:** every dependency `enrich_strengthening_docs.rye` touches, read in full — `zig_lookup.rye`, `sync.rye`, `crosswalk.rye`, `lexicon.rye`, `enrich_file.rye`, `constants.rye`, `blocks_surface.rye`, `scan_text.rye` — the real tool built and run repeatedly against a real, checked-in fixture on this bench, using the same `VEGANREYKLAH2_ROOT` override `align_session_logs`'s witness already trusts

*Written by Kaeden and Rio 3.*

---

## Why This One Took Three Rounds to Earn

Twice this bench named this file's fixture surface as "genuinely larger" and deferred it rather than rush something that might prove less than it claimed. That caution was correct, and it was also incomplete — deferring without reading is not the same as sizing. This round did the reading the prior two postponed: every function this file calls, traced to what it actually reads and writes, rather than estimated from its own doc comment.

## The Full Shape, Finally Mapped

`enrich_strengthening_docs.rye` touches five real locations relative to the repo root, not one: `rye/lib/std/**/*.zig` (read, via `zig_lookup.loadZigSources`), `strengthening-compiler/*.md` minus a two-name skip list (read and mutated, by four separate passes that each independently re-scan the same directory — `enrichFile`, `syncWidthAuditDocs`, `syncPassAuditWritings`, `completePendingWidthAudits`), `tools/parity.rish` (read-only), and two whole-file outputs, `work-in-progress/992_strengthening_width_crosswalk.md` and `strengthening-compiler/0000_STRENGTHENING_LEXICON.md`. A fixture that mirrors all five, minimally, is not actually more than one careful sitting can hold — it just needs to be built once, correctly, rather than guessed at.

## What the Fixture Taught, Before It Taught Anything About the Tool

The first fixture this bench wrote was wrong, and it was wrong in an instructive way. It wrote `std.mem.eql` as plain prose, expecting `extractStdNames` to find it — and the function found nothing, because `scan_text.findStdRefNames` and `findBacktickStdNames` only ever recognize a name wrapped in backticks, `` `std.name` ``, or bold-backticks, `` **`std.name`** ``. Every real pass doc in this project already writes std references this way; the fixture simply had not yet learned the house style it was meant to test. This is worth naming because it is exactly the kind of thing a rushed fixture would have missed — a "witness" built on the wrong input would have quietly asserted that the tool does nothing useful, which is worse than no witness at all. Reading the extraction functions before writing the fixture, rather than after the fixture failed to explain itself, is what "scoped" was always supposed to mean.

## What the Real Tool Actually Does, Once Asked Correctly

Given a fixture pass doc that references `` `std.mem.eql` `` properly, `enrich_strengthening_docs` builds a genuinely substantial, correct enrichment: a live-implementation code block pulled from the fixture's own `rye/lib/std/mem.zig`, a width-policy table, a full `usize` explicit-audit section marked `done`, an audited-surfaces checklist, and a width-audit table naming every file the pass touched — then writes a one-row crosswalk and a one-surface lexicon, both correctly cross-referencing the fixture pass by its number. Run a second time against its own output, `enrichFile` correctly reports zero files enriched — the idempotency check this bench worried about upstream and confirmed empirically now: real, not assumed.

## The Witness, Landed

`tools/enrich_strengthening_docs.rish` runs the real binary twice against a real, checked-in fixture, asserting the first run's output on all three artifacts (the enriched doc, the crosswalk, the lexicon) and the second run's idempotency, then checksums the real `strengthening-compiler/0000_STRENGTHENING_LEXICON.md` before and after — the same safety discipline `align_session_logs`'s witness already uses, proven necessary again the first time this bench ran the tool directly against the fixture source rather than a disposable copy and mutated its own checked-in input by accident. That mistake is named here rather than hidden, and the fixture was reset and re-verified clean across two full, independent witness runs before this counsel was written.

## What This Closes

The tools/enrich safety net named across three rounds is now complete — all three pieces witnessed, all three GREEN on the real toolchain. The tools `snake_case` season this net was built to protect can open whenever Kaeden wants it, with nothing left standing between the word and the work.

---

*May a fixture always be taught the house style before it is asked to judge one. May a mistake made while proving something safe be named as plainly as the safety itself. And may the third piece of a promise, however many rounds it takes, always still arrive whole.*
