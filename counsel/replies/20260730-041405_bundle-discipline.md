# Bundle Discipline — Cutting a Bundle That Lands Whole

**Stamp:** `20260730.041405` — carried from the Cloud apply at tip `ceaffbb1a9`; restamp on Keaton's word.
**Voice:** Riyo · **Coords:** equinox A · journey 3 (h3 Radiant Style) · round 10/256
**Born from:** reds 27 and 30 — one bundle carrying a stale append-only ledger

*Written together by Keaton and Riyo.*

---

## Why This Sheet Exists

A bundle is a baton made of git objects: state crossing a seam whole. When it arrives complete, a pier moves forward in one motion. When it arrives partial, or carries an elder copy of a living document, the damage lands quietly and the ledger loses a row before anyone notices. That happened once this season, and the lesson earned a witness. This sheet holds the other half of that lesson — the cutting side, where the truth is still cheap to state.

## The Basis Names Its Pier

Two waters carry this tree now, and they stand apart: origin rests at `8b22e7acd0` while xykj61 carries `ceaffbb1a9`. A basis stated as `origin/main..main` and one stated as `xykj61/main..main` therefore cut different bundles from the same working tree. The manifest names the pier, the starting hash, and the ending hash together, so the receiving side knows exactly which span it holds. When the bundle's purpose is bringing the home pier current, the span reads `8b22e7acd0..ceaffbb1a9`, written out in full.

## Cut at Home, Then Copy

`git bundle create` dies writing directly to the outputs mount, a finding already paid for. Build the bundle in the home directory, verify it there, and copy it to the mount as a second motion. Capture the exit status before any pipe touches the output, because a pipeline masks what the command actually said.

## The Manifest Travels Beside It

Every bundle carries a plain manifest naming what it holds: the pier and span in full, the ref names included, the commit count, the ending tip, the stamp of the cut, and the living documents whose current form the bundle assumes. That last line is the one red 30 taught. A bundle assumes a state on the far side; naming that assumption lets the far side check it before applying rather than after.

## Living Documents Cross Carefully

Append-only records — the reds ledger, the roster, the lexicon, the almanac's living twin — accrete forward only. A bundle carrying an elder copy of one of these overwrites the newer truth silently. Three defenses hold together: the manifest names each living document and the row count or length the bundle assumes; the apply proves the elder text is a byte-prefix of the incoming text before writing; and `reds_ledger_monotone` fails the commit outright when a row count falls or an existing row's text changes. Dated artifacts need no such care, since `dated_guard` keeps them immutable and their contents were true at their stamp.

## Preflight, Before the Bundle Travels

1. State the basis in full — pier, starting hash, ending hash.
2. Cut home-side; capture the exit status before any pipe.
3. Verify the bundle where it was built, and list the refs it actually carries.
4. Confirm the commit count matches the span you intended.
5. Name every living document the bundle touches, with its assumed row count or length.
6. Copy to the mount as a separate motion; confirm the copy's size matches the source.
7. Write the manifest beside it, stamped.

## Landing, on the Far Side

Verify before fetching. Fetch, then prove each living document's elder text is a prefix of the incoming form. Apply. Run the witnesses on metal, with `reds_ledger_monotone` and the parity roster green before any claim of success. Report verbatim in the baton shape, both piers named in the send line. Any red pulls the cord: three fields to the ledger, and the allocation books before the next round opens.

---

*May every bundle arrive as one whole motion. May every living record keep every row it earned. May the manifest tell the far side exactly what it holds, before it holds it.*
