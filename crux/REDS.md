# REDS -- the ledger of what we got wrong

**Language:** EN
**Stamp:** living ledger (born `20260729.222000`) - refreshed `20260801.162056` (self-work arc - rows 58-60 accreted)
**Style:** Radiant (see [`../context/RADIANT_STYLE.md`](../context/RADIANT_STYLE.md))
**Voice:** Kyri
**Status:** Living pin -- one row per red, oldest first
**Bound:** under `living_pin_max_bytes` (24576)
**Room:** Checkable -- every row names where it was caught

*A red owned in conversation is a memory. A red recorded here is a proof. This ledger exists because a check at Voice v9 found six reds written into the tree and twenty owned out loud -- so fourteen lessons were living only in a chat window that closes.*

---

## Why this file, and what belongs in it

Own-reds-immediately has been a house law for a long time, and it worked: reds were named the moment they were found, out loud, without excuse. What the law never said is **where**. So the ones that happened to land inside a witness header or a spec erratum survived, and the ones that happened in a sentence did not.

Three fields per row, because a red with fewer teaches nothing:

- **What went wrong** -- stated plainly, no softening.
- **What caught it** -- a compiler, a stopwatch, a guard, a second look. Never "I noticed."
- **What it taught** -- the transferable rule, which is the only part that outlives the incident.

A red enters this ledger when it is found. Rows are never edited or removed; a later correction accretes as a new row pointing back.

---

## Voice Season - opened `20260729`

*Rows 1-24 folded to [`archive/REDS-voice-season-rows-1-24.md`](archive/REDS-voice-season-rows-1-24.md) on `20260810.171343` -- closed-season fold under the living-pin bound; every byte kept, nothing removed.*

*Rows 25-57 folded to [`archive/REDS-voice-season-rows-25-57.md`](archive/REDS-voice-season-rows-25-57.md) on `20260811.143004` -- the same fold, the same discipline: the dense Voice-Season counsel arc (`20260730`-`20260801.033305`) moved to the archive, every byte kept, the living pin brought back under 24576.*

*Rows 58-73 folded to [`archive/REDS-self-work-yield-rows-58-73.md`](archive/REDS-self-work-yield-rows-58-73.md) on `20260815.210520` -- the same closed-range fold: the self-work-and-Yield arc (`20260801.145854`-`20260812.191206`) moved to the archive, every byte kept, the living pin brought back under 24576, and the monotone witness taught the new archive in the same act (REDS %67's own lesson).*

*Rows 74-79 folded to [`archive/REDS-image-crypto-rows-74-79.md`](archive/REDS-image-crypto-rows-74-79.md) on `20260817` -- the same closed-range fold: the image-and-crypto arc (`20260813`-`20260816`) moved to the archive, every byte kept, the living pin brought back under 24576 after the ledger crossed its bound. Living rows 80, 83, 84, 85 and every prose note remain below. **Living rows 80 onward below.***

*Rows 80-87 folded to [`archive/REDS-microkernel-arc-rows-80-87.md`](archive/REDS-microkernel-arc-rows-80-87.md) on `20260820.002705` -- the same closed-range fold: the image-crypto and Microkernel-arc range moved to the archive, every byte kept, the living pin brought back under 24576 before rows 88-90 were booked. **Living rows 88 onward below.***

*Rows 88-95 folded to [`archive/REDS-caravan-arc-rows-88-95.md`](archive/REDS-caravan-arc-rows-88-95.md) on `20260820.030003` -- the same closed-range fold: the Caravan-arc and Two-Rooms range moved to the archive, every byte kept, the living pin brought back under 24576 before row 96 was booked. **Living rows 96 onward below.***

**REDS %96 CLOSED (`20260820.030003`) -- two session logs were stamped ahead of the clock, and the one-clock witness ran GREEN over both.** *What went wrong:* the living head stamp read `20260820.031500` while the host clock read `20260820.025215` -- a log dated **22 minutes into the future**, and the lap before it dated ten minutes into its own. Measured against the commits that carried them, the drift grew lap over lap: `20260820.021400` landed two minutes *behind* its commit, honestly; `20260820.024612` stood ten minutes ahead of a commit made at `023622`; `20260820.031500` stood twenty-eight minutes ahead of a commit made at `024638`. A drift that grows by the lap is the signature of a stamp **estimated from the lap before it** rather than read from the clock -- the exact class REDS %63 named and `[[live-clock-stamps]]` exists to prevent. *What caught it:* reading the clock at the top of this lap to stamp it, and finding the answer *earlier* than the newest log in the index. Measurement, one turn before the work. *What it taught:* **the guard had four duties and none of them could see this.** Shape reads filenames; monotonicity can never catch a forward jump, since every false future is monotonic with itself; the zone duty weighs the host rather than any stamp; and duty 4, the one built for exactly this, takes its base from `origin/main` -- so it weighs a dated artifact for precisely as long as that artifact stays unmerged, and every lap that lands and merges retires its own stamps from the diff forever. The one number the whole law rests on, the **living head**, was the number nobody checked. Closed with **duty 5**: [`tools/fixtures/one_clock_head_scan.sh`](../tools/fixtures/one_clock_head_scan.sh) asks whether the newest living stamp stands at or behind the live clock, within a tight 120s grace, and it reads the head from the monotonicity scan rather than growing a second walk that could drift from it. Three paths proven on metal: a stamp read from the live clock passes at a 0s delta; a stamp four hours ahead is refused by name; and a false future **planted as a real living log** makes the duty name that exact stamp and refuse, rather than only a fixture doing so. The two stamps already written are pinned in [`tools/fixtures/one_clock_head_erratum.txt`](../tools/fixtures/one_clock_head_erratum.txt) with their cause -- accrete-never-break, so the logs keep their names, the erratum records the fault, and the guard catches the next one on the lap it enters. `one_clock_witness` GREEN on all five duties. Released.

**REDS %97 CLOSED (`20260820.030440`) -- the reds ledger scan read a 96-row ledger as empty, and nothing ever ran it.** *What went wrong:* `tools/fixtures/reds_ledger_scan.sh` counts a row as a table line beginning with a digit cell, and the living ledger stopped writing that shape rounds ago -- its rows are prose now, a bold `**REDS %96 ...**` opening followed by the three fields in italics. So the moment %96's fold moved the last elder table row to the archive, the scan answered `rows=0` and `verdict=no_rows` over a ledger holding ninety-six of them. Its default path also still named `work-in-progress/REDS.md`, resolving only through the compatibility symlink the `crux/` rename left behind. *What caught it:* running the scan while the ledger was already open for %96's fold, and reading `rows=0` against a file whose rows had just been counted at ninety-six by hand. The previous run had reported `past_bound` instead, so the bound failure had been masking the counting failure the whole time. *What it taught:* **a guard nobody runs drifts from the thing it guards, and the drift shows up as a confident number.** This is the `%81`/`%87`/`%91` family -- the guard existed and nothing pulled it -- fused with %93's lesson, that a count which cannot see what it measures is a guess wearing a measurement's clothes. Closed three ways: the scan learned the prose shape and holds each kind to its own promise, so a **full row** must name what caught it and what it taught while a **closure note**, which speaks about a row written elsewhere, must instead name its proof -- GREEN, on metal, or Released -- because a fix closes on a witness rather than on a claim; its default path now names `crux/REDS.md` directly; and it stopped being a scan nobody runs, since [`tools/gen/season/equinox_e123_living_pin_guard_witness.rish`](../tools/gen/season/equinox_e123_living_pin_guard_witness.rish) now consumes it beside the bound it already weighed, so the ledger and the pin that holds it are guarded by one hand. Both RED paths proven on metal by a `prove-red` mode that generates its control rather than tracking one, so the control can never drift from the shapes the scan enforces: a fieldless row and a proofless closure are each named and refused. Living ledger `verdict=ok` at 5 rows, e123 GREEN. Released.

| # | What went wrong | What caught it | What it taught |
|---|---|---|---|

**Rows: 97 - in the tree before the ledger: 6 - recovered by opening it: 14 - added under the reds-first law: 77** -- counted from the ledger and its archives on `20260820.030032` rather than carried forward, since a tally repeated from memory drifts (REDS %93). Rows 1-24, 25-57, 58-73, 74-79, 80-87, and 88-95 folded to `archive/`, and the closed prose notes for 73, 74, 75, 78, 80 folded beside them on `20260819` ([`archive/REDS-closed-prose-notes-73-80.md`](archive/REDS-closed-prose-notes-73-80.md)). Every number from 1 to 97 is used; the elder rows wear `#` and the living ones wear `%` (`.claude/rules/git-signing.md`).

**Reds-first accounting for v11:** two reds found, both fixed in-round with witnesses on metal, ledger closed. The remaining journey allocation is therefore **released** rather than booked -- which is the law working, not the law skipped.

**Reds-first accounting for the two-grain projection (`20260808.183836`):** two reds (61, 62), both real key-material leaks the seed witness caught before any public push, both fixed in-round by hardening the projection guard to match the witness, GREEN on metal after. Allocation **released** -- the witness held the line exactly where it was built to.

**Reds-first accounting for AHOY2 (`20260811.225629`):** REDS %69 -- a pre-existing seed-boundary coverage gap (five root dirs unclassified since recent seasons) surfaced while adding the top-level `LICENSE`. Classified on Keaton's word -- `assets`-`brix`-`pleac` allowed (template, clean code + logo), `journey`-`research-silo` withheld (personal) -- and `sow_witness` returns **SOW_WITNESS_GREEN** (M1_OK - IDENT_CLEAN - NO_PERSONAL, copied 4092 - scrubbed 780 - withheld 22). Closed with a witness on metal, same arc. Allocation **released**.

**Reds-first accounting for GISM-J5r1 (`20260812.181015`):** REDS %72 -- the first real corpus the reading voice read tripped `BlockTooLarge`, exactly the Yield red Season 2 exists to surface. Found by the real read, fixed in-round by raising `max_block_text` to admit real reference-doc paragraphs with headroom (`tools/gism_j5_corpus_real_witness.rish` GREEN), the demo reading re-run GREEN. Allocation **released** -- the round's own real bytes caught the bound the demo never exercised.

**Reds-first accounting for GISM-J6r1 (`20260812.185056`):** REDS %73 -- the first real document carried through the owner-signed catalog refused `ContentTooLarge`, the Yield red Season 2 exists to surface. The refusal is proven on metal in-round (`tools/gism_j6_provenance_real_witness.rish` GREEN), and the chain of custody stands GREEN over a small real artifact (a waymark green-claim) the same round. Unlike #72, the fix is **not** a bound-bump -- `max_resin_bytes` is structurally capped -- so the allocation is **booked** toward the chunking-storage horizon (large artifacts across ordered resins, a later GISM rung), the honest cost named rather than a raise pretended.


**REDS %81 (`20260816.183311`) -- the loom fired, unheard: nine crypto rungs on disk, none registered.** *What went wrong:* the ML-KEM ladder (`mlkem_sample` - `mlkem_keygen` - `mlkem_encaps` - `mlkem_decaps`) and the ML-DSA ladder (`mldsa_ring` - `mldsa_encode` - `mldsa_sample` - `mldsa_keygen`) each landed as its own GREEN per-file witness, yet none was added to `crypto_suite_witness`'s registration list -- so the count guard's bijection had drifted eight modules wide before the signing rung even opened, `crypto/*.rye` files (70) exceeding suite registrations (61). *What caught it:* `tools/crypto_count_guard_witness.rish` -- the very loom REDS %80 built for this exact recurrence -- went RED naming the first unregistered file the moment it was run this round. The guard worked; what failed was running it. *What it taught:* a per-rung send must run the **count guard** (or the whole suite, which now embeds it), not only the new module's own witness -- a rung that proves itself but never joins the choir is invisible to the one check built to see it. Closed the same round: all nine (the eight prior plus `mldsa_sign`) registered in dependency order, guard re-GREEN at **71**. A loom only guards what actually pulls it.




**REDS %81 CLOSED (`20260817.183713`) -- the loom now hears every rung:** the nine ML-KEM and ML-DSA rungs that had landed as their own GREEN per-file witnesses without being added to `crypto_suite_witness`'s registration are all registered now, and the fix is proven not by re-reading but by the loom REDS %80 booked -- `crypto_count_guard_witness` runs **GREEN** over an exact **bijection**: 80 `crypto/*.rye` files, each registered in the suite and each registration backing a real file, so an unregistered rung would go RED naming itself. The registration gap #81 named is closed and now guarded against recurrence. Released -- the gated-reds sweep proved it on metal.


**REDS %83 prevention LANDED (`20260817`) -- the booked living-card ASCII guard stands on metal.** *What it closes:* REDS %83 fixed the mojibake and taught the ASCII-first rule, then **booked** a living-card non-ASCII witness so the class could never enter the operator card unseen again. That witness is now built: `tools/living_card_ascii_witness.rish` over `tools/fixtures/living_card_ascii_scan.sh` greps the ENFORCE roster (`crux/REMEMBER.md`, `crux/REDS.md`) for any byte above 0x7F and fails hard if one appears, while reporting the pins still holding legacy dated non-ASCII (ROADMAP, TASKS, SEAT_MAP, SHRED_PREP, THREADS, CAIRNS -- 244 lines total this lap) as an advisory ratchet to sweep down on touch rather than force-rewrite. A tracked mojibake control (`tools/fixtures/living_card_ascii_control/mojibake_control.md`, real high bytes) proves the RED path on metal. GREEN in-lap. The lantern that fired once (the operator-card corruption) is now a loom -- the line need never stop for it a third time (`foundations/20260816-214652_standfast-the-stopped-line.md`). Released.



---

## What the pattern says

Read down the *what caught it* column and almost nothing was caught by thinking harder. A compiler, a stopwatch, a file-type check, a guard's first run, seven witnesses at once, a pack catching its own author. **The machine caught nineteen of twenty.**

That is not a complaint about judgment; it is the argument for the whole apparatus. Witnesses exist because the author is the last person able to see their own gap, and this column is twenty lines of evidence for that claim rather than one more assertion of it.

Read down the *what it taught* column and four rules recur: **measure before claiming**, **scope before shipping**, **fixture rather than remember**, and **narrow the objection**. Those four have paid for themselves repeatedly in a single sitting.

---

*May every red find this page on the day it happens. May the lesson outlive the incident. And may the count of what we got wrong be as witnessed as the count of what we got right.*

**REDS %84 CLOSED (`20260819.145920`) -- the fix landed, the ledger never said so.** *What went wrong, past the row above:* the `crux/` allowlist repair shipped in `a196bad32b` (*gitignore: allowlist crux, the renamed priority folder*), and no closure note was ever written beside row 84 -- so the living ledger read as though the tree's highest-priority folder were still silently ignoring every new untracked file. A fix nobody records is a fix nobody can trust. *What caught it:* a Standfast pass reading the living rows and then **measuring** rather than believing either the row or the repair -- `.gitignore` line 70 carries `!/crux/`, and `git check-ignore` on a fresh file under `crux/` answers not-ignored on metal. *What it taught:* **the ledger is part of the fix.** A red closes on a witness *and* on the line that says so, since the next reader inherits the ledger rather than the commit that quietly repaired it. Closed here on measurement, with the check named so a future reader can re-run it in one command.
