# Shelved account -- Pheromone, the one body that was genuinely a different rule

**Status:** Landed testimony, shelved whole from `construction/ITINERARY.md` `20260917.214658`.

`glow/lower_alias.rye`'s `zig_safe_ident` was the one copy the room's own header already named
as different: it maps a wing's `.` to `_` as well as a face's `-`, since a wing like
`i.records.cur` carries a dot as its path separator rather than a stray character to refuse. The
function now imports `glow/zig_ident.rye` and calls its published `safe_ident` with the
`.to_underscore` dot parameter, catching `error.BadIdent` -- the same name `LowerError` already
publishes, so no error-set member moves and no caller's switch needs a new arm.

**The width bill moved too.** The function returned `usize`, the last of the 23 files counted at
`glow_ident_duplication_scan.sh`'s own seating still doing so. It now returns `u32`, and its two
call sites (`face_n`, `source_n` in `lower_line`) slice their buffers with `@as(usize, n)` rather
than the bare `usize` the old return handed them directly -- `width-check`'s discovered corpus
falls 1,133 to 1,131 lines in the same commit.

**PROVEN:** `lower_alias_witness.rye` GREEN on metal, including the dotted-wing case
(`=*  cur  i.records.cur` -> Zig face `i_records_cur`) that proves `.to_underscore` parity with
the elder body's own dot-mapping; `glow_ident`, `glow_run_contract`, `width-check`,
`tame_style_check`, and `glow_ident_duplication` (scan, ceiling 7 to 6) all GREEN.

**YOURS:** six singletons remain -- `lower_core` (4), `lower_call3` (4), `lower_call2` (3),
`lower_face_lit` (2), `lower_shop_nest` (2), `lower_trap` (1) -- every one of the room's
remaining copies now answering the shared body's own `error.BadIdent` with no dot exception.
