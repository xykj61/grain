# ITINERARY -- landed accounts, shelved `20260910.043900`

**Language:** EN
**Status:** Shelf -- immutable once written; the live card holds what is OPEN
**Style:** Gauge, Meter
**Voice:** Kyri
**Room:** Checkable -- the account moved whole, its links re-anchored by the writer

The PATCHOULI account the live card carried before the lap of `20260910.043900`, moved here whole so the live
front holds one account per ship. Accrete-never-break: nothing here is edited. Written by
`tools/i/itinerary_account_shelf.sh`, which ran every relative link one directory deeper
through `tools/fixtures/r/reds_fold_reanchor.sh`.

---

**PATCHOULI -- ONE CEILING COUNTS BYTES, THE OTHER COUNTS LINES.**
Elder [shelved](20260910-041243_itinerary-landed-accounts.md).
**AIR FEELS FOR THE BOUNDARY.** The store bounds a blob at `max_blob_bytes` (1 << 27), refusing
**at the edge** before the allocation grows. The weave bounds itself at `max_weave_lines` (1 << 20)
and `from_v2` refuses `TooManyLines` **by name**. **The fence between them was a wish:**
`read_v2_record` appended every row of a record off disk and read its ceiling AFTERWARDS.
**THE CONVERSION NOBODY WROTE DOWN:** a v2 row costs nine bytes, so a blob UNDER the store's own
ceiling carries **14,913,080** rows against the 1,048,576 a weave holds. **On metal:** a
**15,666,516-byte** blob made `mantra status` panic at exit **134**.
**THE FILE KNEW THE MOVE:** `read_commit_v2`, sixty lines below, refuses `error.TooManyFiles`
inside its loop before appending -- one file, two readers, two answers.
**REPAIRED, PROVEN WITHOUT A FORGERY:** both readers refuse inside the loop; the scan builds that
reader at ceilings of **16** and **8** and has the wide binary WRITE the stores the narrow one
reads, so every name is Mantra's own digest. `mantra_record_ceiling` **tier lap**, 13 readings,
4 phases. `%688`.
**I TYPED THE RAW `pkill -f`** and it took my own shell at exit **144** -- seventh firing, no peer
reached by luck of the pattern. **YOURS:** `resin_batch.rye` ties `max_batch_entries` 16 to
`max_batch_bytes` 4096 nowhere. **SECOND HAND ON BAKERY'S `elf_machine`:** it drags
`standing_equipment` red too. **FULL ROSTER DID NOT CLOSE AGAIN**, 11 guards in 10 minutes twice at
load 14.5, so this lap stands on **18 named guards, 17 green**.
