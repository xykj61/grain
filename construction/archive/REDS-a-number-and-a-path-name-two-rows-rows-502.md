# REDS %502 -- a number and a path naming two different rows

*Folded from the living pin [`../REDS.md`](../REDS.md) on `20260906.143706`, in the round that booked
it, because the pin stood **9 bytes** under the 40,960 it declares -- the same nine bytes the round
before found, and the second lap running where a red could be written down only by folding it
straight back out. The row is CLOSED and folds by the pin's own law.*

*This is the fourth firing of one shape in a single day, and the last three were repairs of the one
before. `%495` names the sweep that broke it; this row names what was missing the whole time, which
is any instrument that reads a citation's two halves together. A lantern that fires twice becomes a
loom, and this one fired four times.*

*The reading that would have caught all four costs one `git grep` and a second of awk. What made it
worth the round is not the four -- those are repaired -- but the three of them that RESOLVE: a
citation that opens a real shelf holding somebody else's row is green to every guard the tree has,
forever, and a reader following it simply arrives somewhere the sentence never meant.*


**REDS %502 (`20260906.143706`) -- a citation names one row as a number and another as a path, and every link guard in the tree reads only whether the path opens.** *What went wrong:* four citations went out on `20260906` whose two halves named different rows. `construction/ITINERARY.md` line 52 published `%492` beside a path reading `rows-494` when an unanchored `replace` over the whole card matched a peer's line first; the repair then moved this ship's own number to `%494` and left its path reading `rows-492`; and the round's own shelf carried `%360` beside `rows-439-441` for a row that lives on the pin, and `%484` beside `rows-480` for a shelf that exists and is the wrong one. *What caught it:* `readme_reach` on the next lap's cold open, which named exactly ONE of the four. *What it taught:* **existence and agreement are two questions, and only one of them had an instrument.** Three of the four OPEN a real shelf holding somebody else's row, so they resolve, never red, and misdirect a reader with no expiry; `tracked_link` asks existence the same way, and `reds_row_present` asks whether the ledger HOLDS a row without ever asking who cites it. *Repaired:* all four repointed. *Gated:* `tools/r/reds_citation_witness.rish` over `tools/fixtures/r/reds_citation_scan.sh`, `tier lap`, reading the two shapes that are promises to a reader -- an anchor text that IS the number, and a shelf word whose sentence just named a row -- with one line of lookback and never past the link. A nearest-preceding-`%N` window over 1,001 living documents called **32** honest sentences wrong, which is why the form is narrow, and the narrowing is itself proven: a `%N` after the link and one two lines above it are both welcomed. **Replayed against `b441f97b2`**, this tree as it stood when the defect was published, it reads `numbered_disagree=3` and names every site. Control **23 cases over 12 real repositories**, every refusal planted and then lifted -- and it bit the scan's own counting before it shipped: `grep -c ''` prints 0 and exits 1 on an empty file, so the `|| echo 0` beside it yielded two lines, the integer test errored, and a correctly-empty corpus read `refused_no_citation` rather than `refused_no_corpus`. *Fourth firing of one shape in one day, every one from this seat.* **CLOSED** on `reds_citation` GREEN.
