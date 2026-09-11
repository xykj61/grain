# REDS -- the claim, and the run behind it

**Language:** EN
**Style:** Gauge, Meter setting
**Voice:** Kyri
**Status:** Shelf -- two folded rows, immutable once written
**Room:** checkable -- two ledger rows, each repair proven on metal
**Folded:** `20260911.055020` from [`../REDS.md`](../REDS.md)

Two rows folded the hour the second was written, to give the pin back the headroom eight ships
share. Upstream stood at **40,945 bytes of 40,960** when this lap came to book, so fifteen bytes
were all that remained and no row of any size could land. These two were the pin's only **BOOKED**
rows; every other row reads OPEN and stays where a reader looks for live work.

They teach one thing from two rooms. **A claim about behavior is worth exactly the run behind it.**
`%705` names a census that declared a population for a behavior nobody had run, its own control
planting the specimen the prose had imagined. `%707` names two commands that only read and yet
created a repository wherever they were mistyped -- standing since the CLI was born, under six
guards, because every one of them ran inside a pen that had already been initialized. Neither fault
could be seen by reading; both appeared the moment somebody ran the thing in the one place that
would show it.


**REDS %705 (`20260911.014147`) -- a census named a population for a behavior nobody had run, and its own control planted the specimen the prose imagined.** *What went wrong:* `tools/fixtures/g/gitlink_dependent_scan.sh` counted every tracked runner naming an OPTIONAL gitlink on a working line with no roster row, called that population `optional_unrostable`, and printed of each member *reds when an optional submodule is absent*. The reading is purely static, so nothing had ever run one. Measured `20260911` with `gratitude/tigerbeetle` empty: **38 of 38 exit 0**, each printing its own honest SKIP, the whole population in **768 ms**. Not one reds. The count counted a SHAPE and the sentence claimed a BEHAVIOR, and they are different populations. *What caught it:* an earth lap running two members of the list before reading the argument about them. **A pen alone could never have caught it:** the control's CASE 3 plants `assert clone.ok else "...ABSENT"`, written from the header's own sentence rather than from a file on disk, so the only hard-asserting specimen anywhere was the one the claim built for itself. *What it taught:* **a plant drawn from a claim is the claim wearing evidence** -- a control's specimens must be drawn from the tree the reading is aimed at, or the pen and the prose agree while both are wrong about the population. *Repaired:* the reading is `optional_unrostered`, which is what it counts; a `probe` mode RUNS each optional dependent whose gitlinks stand empty and classifies it `probe_green` / `probe_red` / `probe_unread` -- unread rather than guessed, since observing absence by deleting a clone is the one move a meter may never make; and `probe_red` is gated at **zero**, which turns `%646`'s 5-in-40 sample into a wall. **37 control legs, fail=0**, three mutations bitten. *Landed `20260911.033000` from `stash@{0}`, where the whole lap stood parked; renumbered from the `%702` it booked, which `xy` had since published.* **BOOKED.**

**REDS %707 (`20260911.053330`) -- the two commands that only read were the two that created a repository.** *What went wrong:* `Store.open` in `mantra/src/store.rye` creates `.mantra/` and `.mantra/blobs/` when they are absent, which is right for `init` and `add`; every other command opened through that same door. Measured on metal from the built binary: `mantra status b.txt` in a directory holding no repository answered by CREATING one, reported the file's every line as added, and left `.mantra/` standing; `mantra log` did the same and printed an empty chain. A mistyped directory gained a repository, and a command that only reads changed the world. *What caught it:* a water lap tasting the new `mantra annotate` up close -- its own refusal leg in a pen expected exit 1 for a directory holding no store, and read exit 0 with a `.mantra/` where none had been. The rota's cardinal seat is `foundations/20260823-222019_what-brix-infuse-is.md`, whose claim is that running a thing twice does what running it once did; this failed on the first run. *What it taught:* **a door that creates is the wrong door for a reading, and one `open` served both.** The question *is a repository here?* was being put to the function that answers by making one. `open_for_reading` in `mantra/src/main.rye` probes with `openDir` first and refuses by name in the command's own words; `annotate`, `status` and `log` walk through it. *Standing:* gated by `tools/m/mantra_annotate_cli_witness.rish` -- `no_store_code=1`, with the control proving the leg from the other side. **BOOKED.**
