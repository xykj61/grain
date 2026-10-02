# REDS -- two closed reds, a dormant witness and a trailing-comment ratchet

**Language:** EN
**Style:** Gauge, Meter setting
**Voice:** Kyri
**Status:** Shelf -- two folded rows, immutable once written
**Room:** checkable -- each row's reading was proven by its own named witness on metal
**Folded:** `20261002.173404` from [`../REDS.md`](../../REDS.md)

Two rows, folded to hold the pin under the 65,536-byte bound eight ships share, after a crushed-index
red pushed the pin past it.

**REDS (`20261002.012602`) -- an unrostered witness grepped for a middle dot an ASCII sweep had already converted to a hyphen.** *Went wrong:* `tools/gen/chapter/houseplant_glossary_witness.rish` greps `context/LEXICON.md` for the literal row header `| **fund (middle dot) star (middle dot) ship** |`, while the live file reads `| **fund - star - ship** |` -- the ASCII-first sweep (`.claude/rules/ascii-first.md`) converted the row's own middle dots to hyphens at some point after the witness was written, and nothing re-ran the witness to notice. *Caught by:* running the witness for GREEN before its first roster entry, per the-baton's ABSENCE clause, while picking an unrostered `tools/gen/chapter/` witness to roster per the copal-inner fruit. *Taught:* a witness that greps a living prose file for an exact substring is reading testimony about a sentence that is itself subject to a tree-wide style sweep; the sweep's own ratchet has no way to know a dormant witness is quoting the string it is about to convert. *Repaired:* the grep's literal now reads `| **fund - star - ship** |`, matching the current ASCII text; GREEN on metal. Rostering proceeds in the same lap. **CLOSED**.

**REDS (`20261002.054500`) -- the unnamed-assert ratchet read seven over ceiling, all trailing-comment asserts the adjacency rule cannot join.** *Went wrong:* `rune_assert_sweep_scan.sh` read `unnamed_assert=6487` against `ceiling=6480`; `rune_assert_arrival.sh` named `mantra/snapshot_projection.rye` plus two prior commits in `beading_dedup_ratio.rye` and `spool_dedup_ratio.rye`, each `// invariant:` written trailing the assert rather than on its own preceding line. *Caught by:* this lap's walk of the ITINERARY's ANY SHIP cold-run item. *Taught:* a trailing comment reads true and compiles clean, so the ratchet gap survives until a lap walks the arrival. *Repaired:* all 11 moved to a preceding line; `unnamed_assert=6480`, all three witnesses GREEN. **CLOSED**.
