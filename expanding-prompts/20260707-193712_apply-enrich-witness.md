# Cursor Apply-Prompt — enrich_strengthening_docs Witness

**Stamp:** `20260707.193712 UDT` · **Parent:** `def6e69` · **Voice:** Rio 3
**Bundle:** `20260707-193712_enrich-strengthening-docs-witness.zip`

The third and final tools/enrich safety-net piece, given the full scoped sitting the prior two rounds deferred. Every dependency this file touches was read in full before any fixture was written; the fixture itself was wrong once, caught, and corrected before landing here.

## What Lands

- `tools/enrich_strengthening_docs.rish` — checksums `strengthening-compiler/0000_STRENGTHENING_LEXICON.md` and confirms `work-in-progress/992_strengthening_width_crosswalk.md`'s existence before/after; runs the real tool twice against a fixture via `VEGANREYKLAH2_ROOT`; asserts the first run's three outputs and the second run's idempotency.
- `tools/fixtures/enrich_strengthening_docs_fixture/` — a minimal, checked-in fixture: `rye/lib/std/mem.zig`, one pass doc referencing `` `std.mem.eql` `` (backtick-wrapped — plain prose is not recognized by the real extraction functions), one `tools/parity.rish` stub.
- `tools/parity.rish` — one new stanza after `tame_usize_audit`.
- Counsel and session log filed.

## Bench Note

Building the real tool required `RYE_LIB` set to a real Zig standard library — `rye/lib/std/` itself is a metal-only asset, the same class of exclusion as `.git` and `rye/bin/`, not carried in zip extractions. Your metal already has the real `rye/lib/`, so this should need no attention there; noted here only because it cost real debugging time on this bench and is worth knowing if a future round hits the same wrapper error.

## Steps

1. Tree at `def6e69`; unzip at root.
2. `rishi/bin/rishi run tools/enrich_strengthening_docs.rish` — expect GREEN.
3. Full parity from bare — suite gains 1 witness over 195; pin the real count on metal.

## What This Closes

The tools/enrich safety net named across three rounds is complete — all three pieces witnessed and GREEN. The `snake_case` season it was built to protect can open whenever wanted, with nothing structural in the way.

---

*May the third piece of a promise arrive exactly as whole as the first two.*
