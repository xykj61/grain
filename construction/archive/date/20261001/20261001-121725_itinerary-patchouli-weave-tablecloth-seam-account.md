# ITINERARY -- the weave-Tablecloth seam falsifier, pressed and shelved

**Stamp:** `20261001.121725` -- cut whole from `construction/ITINERARY.md` on landing, born on its
own shelf so the card's byte bound stays unbreached. Dated testimony; every word as the lap wrote
it.

**PATCHOULI -- THE WEAVE-TABLECLOTH SEAM FALSIFIER PRESSED ON METAL, AND IT FIRES.**

`active-designing/date/20260921/20260921-071008_the-weave-meets-tablecloth-by-content.md` charted
one concrete step: does the weave's `current()` output already carry a stable content address
(a resin), and does anything in the tree already compute and recognize it? Pressed, rather than
reasoned from the source alone: `tools/m/mantra_weave_tablecloth_seam_witness.rish` drives the
tree's own built Mantra CLI through one `init` and one `add` in a throwaway pen, reads the
SHA3-256 of the added document's own bytes (`current()`'s resin at that point in the history,
since one clean add leaves no prior generation to render around), and checks it against every
blob the store writes, by name and by content.

**Neither matches.** `mantra/src/main.rye`'s `serialize_weave` writes a header line
(`mantra-weave-20260916.101910`), a counters line, and one `gen\tpos\tsite\trun\tord\ttext\n` row
per weave line -- that record, not the plain concatenated document text, is what
`mantra/src/store.rye`'s `write_blob` hashes and names. So the design page's own charted question
is answered on metal: **the seam is a build, not a naming exercise.** The gap is measured rather
than assumed, and the design page carries the reading inline.

**PROVEN:** `tools/fixtures/m/mantra_weave_tablecloth_seam_scan.sh` builds the CLI, runs the two
commands, and prints `built=yes blob_count=2 resin_matches_blob_name=no
resin_matches_blob_content=no verdict=ok`. The witness asserts both source mechanisms it leans on
still stand (`serialize_weave`'s record header, `store.rye`'s hash-at-write) before pressing the
scan, so a later rewrite of either mechanism reds the witness rather than silently drifting past
what it claims.

**ONE NOTE ON TOOLING.** `sha256sum` computes SHA-256, a different algorithm from the store's
SHA3-256 -- using it here would have reported a false negative for the wrong reason. The scan
reaches for `sha3sum`, then `openssl dgst -sha3-256`, then `python3`'s `hashlib.sha3_256`, in that
order, and refuses cleanly if none is present rather than silently hashing with the wrong
algorithm.

**CLAIMED AND CLOSED.** `patchouli-weave-tablecloth-seam-falsifier` opened at `20261001.121229`,
closed on landing. `mantra_weave_tablecloth_seam` is rostered in
`construction/standing-equipment.kyri` at `tier lap`.

**YOURS:** the next step the design page now names is a small function -- render `current()`,
concatenate the line texts, hash that -- rather than a design question. Choosing to build it, and
which door the weave walks through more broadly, stays Keaton's word.
