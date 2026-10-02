# PATCHOULI -- mantra-commit's header molts to a stamp, one family of %765

**Status:** Archive -- shelved under the-writer-sheds, `20261001.233015`
**Shelved from:** `construction/ITINERARY.md`, Patchouli's live account

**PATCHOULI -- ONE MORE HEADER FAMILY TAKES THE MOLT %765 NAMED.** `%765` counted 111 version
strings across 42 record families and found only `mantra-weave` moved from a counted header
(`-v1`/`-v2`/`-v3`) to a chronological one, per `context/specs/rye-versioning-style.md`'s own
ruling that a record version is a compatibility contract rather than a census number. Patchouli's
own lane held a second live family: `mantra/src/main.rye`'s `serialize_commit` wrote
`mantra-commit-v2`, the header every fresh commit blob still carries today. That header now reads
`mantra-commit-20261001.233015`; the row format is unchanged, so the elder reader
`read_commit_v2` serves the new header too, reached through a second dispatch line rather than a
new function. `mantra-commit-v2` and `mantra-commit-v1` both keep opening forever -- elder headers
keep their names, and a store written yesterday reads exactly as it did.

Two fixtures named the elder header as a literal and needed the same molt: `tools/m/mantra_multifile_witness.rish`'s
own `commit_header=` assertion and `tools/fixtures/m/mantra_multifile_control.sh`'s `clean_ok`
reading. Both now read the chronological header; the elder-dispatch legs (`no_elder_read`,
`drops_v1_read`) are untouched, since they test the `-v1` reader rather than the write path.
`mantra_multifile_witness.rish` GREEN on metal (nine readings, six control phases, five breaks
caught); `mantra_cli_record_witness.rish`, `mantra_document_roundtrip_witness.rish`, and
`mantra_idempotent_add_witness.rish` re-run GREEN beside it, unaffected. `main.rye` builds clean
standalone. `tame_style_check` carries one pre-existing red in `mantra/beading_dedup_ratio.rye`
(`copyForwards`), untouched by this lap and not of this family.

**YOURS:** forty families of `%765` remain outside this lane -- `amphora-v1`, `portrait-v2`,
`mcp-call-v1`, and the rest -- each wants its own owning ship's lap, one family at a time, the same
way this one and `mantra-weave` went. `%807` stays OPEN for Keaton's ruling, past this lane's own
door.
