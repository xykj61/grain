# PATCHOULI -- the seam's wiring landed, proven on metal

**Status:** Archive -- shelved under the-writer-sheds, `20261001.183106`
**Shelved from:** `construction/ITINERARY.md`, Patchouli's prior live account

**PATCHOULI -- THE SEAM'S WIRING LANDED, PROVEN ON METAL.** The chart at
[`active-designing/date/20260921/20260921-071008_the-weave-meets-tablecloth-by-content.md`](../../../../active-designing/date/20260921/20260921-071008_the-weave-meets-tablecloth-by-content.md)
named a reading and a gap. `mantra/weave_tablecloth_seam_witness.rye` had already answered the
reading -- `Weave.current()`'s output and the catalogue's own `digest_hex` agree on the same bytes,
under the same SHA3-256 -- and named the WIRING as what remained: nothing called `current()`,
joined its lines, and handed the result to `append_leaf` in one motion. This lap wired it.

`mantra/src/weave_tablecloth.rye` adds two public functions. `render_current` joins a weave's
present lines by `\n`, the exact inverse of `diff.split_lines`. `render_to_leaf` renders and
appends to a `BoltCatalog` in one call, so a caller never holds rendered bytes without a leaf to
show for them. Its error set is `recall_lap1.RecallError || std.mem.Allocator.Error` -- the two
families a wiring call can raise, and no third kind, since `current()` raises only the allocator's.

Four claims proven on metal in `mantra/src/weave_tablecloth_witness.rye`:
1. The render is the exact bytes a lifted three-line weave was lifted from.
2. The appended leaf's digest matches an independently computed SHA3-256 -- checked against the
   witness's own hash rather than the module's arithmetic about itself.
3. A second call, after an edit, grows the catalogue by exactly one leaf again, under a different
   digest -- the postcondition holds across repeated calls rather than only the first.
4. A revision the catalogue's own ordering rule refuses crosses the wiring as `RevisionOutOfOrder`
   by name, rather than being caught, renamed, or silenced.

**The symlink the import needed, and why it is shaped that way.** `mantra/src/` holds
`weave.rye`; `recall_lap1.rye` and `tally/copy.rye` live one and two directories up. Proven on this
lap against the vendored toolchain: Zig refuses an import string that lexically escapes the root
file's directory -- the refusal reads the IMPORT STRING, not the resolved path. So
`mantra/src/recall_lap1.rye` and `mantra/src/tally_copy.rye` are same-directory symlinks to their
real homes, the same pattern the directory already carries for `tally_receipt_refusal.rye` and
`parse_int.rye`.

**A real fault, caught by the control rather than argued.**
`tools/fixtures/m/mantra_weave_tablecloth_control.sh` copies the module into a throwaway pen and
breaks it three ways: a space joins lines instead of `\n` (breaks claims 1 and 2), a swallowed
`append_leaf` error (caught by the module's own postcondition assert), and the same swallow with
that assert also deleted (caught by the witness's own claim-4 assert instead, proving the module's
postcondition is not the only line of defense). Building the pen surfaced a real bug: the module's
own docstring had quoted a failed import attempt literally --
`` @import("../recall_lap1.rye") `` -- as illustration, and `rye`'s bridge walk finds a module's
dependencies by scanning raw source text for the six characters that open an import, rather than
by parsing, so it cannot tell a real import from one spelled out in a comment. The quoted example
resolved to a real file in the actual tree by directory-math coincidence (`mantra/src/../recall_lap1.rye`
normalizes to the file's real home) and reddened only in the pen, where the two directories are not
nested the same way. The docstring now describes the attempt in words rather than in the trigger
shape. Control verdict: `ok`, four legs, the clean leg GREEN and all three breaks caught.

Registered as `mantra_weave_tablecloth` in `construction/standing-equipment.kyri`, tier lap, guard
`tools/m/mantra_weave_tablecloth_witness.rish`. GREEN on metal, both the witness's own four claims
and the control's four legs.

**YOURS:** `mantra/weave_tablecloth_seam_witness.rye` itself stands unregistered in
`standing-equipment.kyri` -- a pre-existing gap this lap found while reading the seam and did not
close, staying narrow to its own claimed paths.
