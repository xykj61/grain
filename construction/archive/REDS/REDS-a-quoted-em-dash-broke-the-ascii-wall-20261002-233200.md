# REDS shelf -- a quoted em dash broke the ASCII wall a second time

**Language:** EN

**Status:** Archive -- one closed, stamp-cited REDS row shed from `construction/REDS.md` under
the writer-sheds rule, to clear headroom for a fresh row while the pin stood over its own byte
bound (`.claude/rules/the-writer-sheds.md`). The row carries no shared `%N` -- it stayed local,
cited by stamp per [`derived-spine`](../../../.claude/rules/derived-spine.md) rule 4 -- and is not
matched by `tools/fixtures/r/reds_fold.sh` (which matches only `**REDS %<N> `), so this shelf was
written by hand, following the same shape the earlier shelf used for exactly this case
([`REDS-a-quoted-em-dash-broke-the-ascii-wall-20261002-225049.md`](REDS-a-quoted-em-dash-broke-the-ascii-wall-20261002-225049.md)).
The row carried no relative link, so no re-anchoring was needed. The row below is quoted
byte-for-byte -- `tools/l/living_card_ascii_witness.rish`'s own ENFORCE roster names only
`construction/ITINERARY.md` and `construction/REDS.md`, so a dated archive shelf reads past it
exactly as `.claude/rules/ascii-first.md` already names for every other folded testimony.

---

*Row `20261002.233200` folded here on `20261003`, **CLOSED** -- the pin stood over its own byte
bound and this was the row's own fold point, named one position over in the row it describes.*

**REDS (`20261002.233200`) -- a dated source's own live em dash, quoted verbatim into a REDS row, broke the living-card ASCII wall for the row's whole life on the pin.** *What went wrong:* row `20261002.225049` quoted `tools/gen/chapter/prin_scope.rish`'s own `say` lines character for character, including two em dashes that file still carries live today. `tools/l/living_card_ascii_witness.rish` reads `construction/REDS.md` for any byte above 0x7F and halts hard on one, since `.claude/rules/ascii-first.md` enforces this pin at zero non-ASCII with no ratchet -- unlike the advisory pins, which are reported rather than refused. The row landed on this pier's own commit `abe69b9cac` (a prior lap's push, unrelated to the row's own author) and the guard read RED the next time it ran. *Caught by:* `sh tools/fixtures/a/ascii_document_scan.sh`, run as a routine post-send check rather than because anything in this lap's own work touched `construction/`; `rishi/bin/rishi run tools/l/living_card_ascii_witness.rish` confirmed RED on metal with `detail=non_ascii_in_enforced_pin detail_path=construction/REDS.md`. *What it taught:* a ledger row that quotes a live source verbatim inherits that source's own byte content, and a source this tree has not yet swept to ASCII (`prin_scope.rish` is on the ADVISORY roster, not ENFORCE) can carry a non-ASCII byte straight into a pin that permits none -- the two rules were each correct on their own ground and still produced a RED where they met. *Repaired:* the row was the pin's only **CLOSED** row and stood at the capacity scan's own fold point regardless, so it folded by hand -- stamp-cited, unmatched by `tools/fixtures/r/reds_fold.sh` since it carried no shared `%N` -- to [`REDS-a-quoted-em-dash-broke-the-ascii-wall-20261002-225049.md`](REDS-a-quoted-em-dash-broke-the-ascii-wall-20261002-225049.md) (re-anchored one directory shallower than its construction/REDS.md original, since both shelves now sit beside each other under construction/archive/REDS/), byte-for-byte, since `living_card_ascii_witness.rish`'s ENFORCE roster reads only the two living pins and a dated archive shelf stands outside it. `living_card_ascii_witness.rish` GREEN afterward. **Standing, for a future lap or Keaton's word:** whether a REDS row quoting a live source should sweep that quote to ASCII at write time, rather than relying on the quoted file itself being clean, is not decided here. **CLOSED**.*
