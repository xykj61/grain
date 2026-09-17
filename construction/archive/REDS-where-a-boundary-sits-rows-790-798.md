# REDS -- where a boundary sits

**Language:** EN
**Style:** Gauge, Meter setting
**Voice:** Kyri
**Status:** Shelf -- two folded rows, immutable once written
**Room:** checkable -- ledger rows, each repair proven by a control on real files
**Folded:** `20260916.231943` from [`../REDS.md`](../REDS.md)

Two rows about a boundary drawn in the wrong place, one too loose and one too tight.

`%790` finds a directory of memo records with no ceiling and no eviction -- a store nobody bounded,
growing because bounding it was nobody's named part. `%798` finds the opposite fault in a wall built
hours earlier: a guard over a numbered list refused a sentence that had merely wrapped onto a
number, so honest writing read as damage.

Read together they price the two ways a bound goes wrong. A missing bound costs slowly and in
silence, and is found by somebody measuring rather than by anything refusing. A bound drawn tighter
than the practice it governs costs immediately and loudly -- and is the more dangerous of the two,
because a guard that reds on ordinary work is a guard somebody turns off, after which the tree has
neither the wall nor the honesty of admitting it lost one.

Both were repaired on the lap that found them. The pairing is kept because the second fault arrives
most often on the lap that fixes the first, when a hand that has just watched something go unbounded
reaches for a wall one notch tighter than the writing can bear.


**REDS %790 (`20260916.214325`) -- the build key's two memo families each stand free, and the directory holding them is nobody's part.** *What went wrong:* `rye/src/main.rye` writes one Kyri record beside the `rye` binary per distinct subject it has ever memoized -- `rye-key-cache.<digest>.kyri` for a single large input file, `rye-key-library.<digest>.kyri` for a library tree -- and nothing ever removes one. A record is reached by the digest of its subject's path, so a new path means a new file rather than a replaced one, and a control run that builds inside ten throwaway pens leaves two dozen records naming roots that are deleted the moment the pen closes. Measured here at `20260916.214325`, straight after one `ryekey_witness` run: **56 records, 5 live, 51 naming a path that no longer exists** -- 91 percent dead, 11,744 bytes. Cheap in bytes and unbounded in entries: the count rises with every witness run and falls never. *What caught it:* a hand reading `ls rye/bin/rye-key-library.*.kyri` while timing a receipt, and then counting rather than glancing -- `for f in ...; do [ -e "$(grep -m1 '^root \|^path ' "$f" | cut -d' ' -f2-)" ] ...`. No instrument saw it: `rye/bin/` is gitignored at `.gitignore:155`, so every tracked-file meter, the room bound, and the census tools are blind to the room by construction, and the memo's own witness proves each record's readings and never asks how many records there are. *What it taught:* **TAME's bound-everything reflex reaches a collection even when no single member allocates.** Both memo families are single-stranded and were designed that way on purpose -- the landing paper's own close argues for two prefixes rather than one, so neither family can evict the other. That argument is right and it is about the RECORDS; the SET they live in was never anybody's one thing, so it named no maximum and grew. The wider class is a memo keyed by a path in a directory a guard cannot see: an untracked room is outside every meter this tree owns, so its only bound is the one its writer states. The cure is a lap -- a named ceiling, and an eviction taking the oldest record past it -- and it is booked rather than built, because this lap was a replay closing at its own witness.

**REDS %798 (`20260916.234536`) -- a wall built against a damaged list refused a sentence that merely wrapped onto a number.** *What went wrong:* `tools/fixtures/i/itinerary_list_scan.sh`, seated hours earlier to hold every ordered run in the rostered living pins at 1..N, opens a run on any line whose first characters are a digit run and a period. A peer measurement line on `construction/ITINERARY.md` wraps onto `32. Warm floor 32 / 12 / 11.`, so the guard read a one-item run reading 32 and answered `broken_runs=1` on a card GitHub renders exactly as its author meant. *What caught it:* the hot scoped endurance run of this lap, on a red that was not this ship's own -- and a reading of the card's own bytes at the named line, which is what told a damaged list from a wrapped sentence. *What it taught:* **a guard over a markup shape owes the markup's own rule.** CommonMark lets an ordered list interrupt a paragraph only when its first item reads 1, and that rule exists precisely so a sentence wrapping onto a number stays a sentence. A guard reading the shape without the rule refuses ordinary writing, which is a guard somebody turns off -- and this one reached the whole fleet at lap tier within an hour of landing. *Repaired (`20260916.234536`):* a run may OPEN on a line whose predecessor is ordinary text only when the item reads 1; any other number there is paragraph continuation and ends an open run like any foreign line. **The one exception is the shape the guard exists for**: a run at the same indent that ended within the last two lines means the number stands directly after a broken list rather than inside a paragraph, which is `%789` itself -- item 7 replaced by a foreign line, item 8 following. Without that window the CommonMark rule alone would free the founding shape, and the mutation proving it is in the pen. The reading fell from 14 runs and 62 items to 13 and 61, which is the single false run leaving and nothing else moving. **Proven:** pen **36 legs, 0 failing**, four mutations bitten -- the unwind, the ascending check, the two-line window, and the interrupt rule itself -- with both real firings still replayed out of history and each firing's parent welcomed beside it. Five new legs quoted by name in the witness. **CLOSED**
