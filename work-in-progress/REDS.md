# REDS — the ledger of what we got wrong

**Language:** EN
**Stamp:** living ledger (born `20260729.222000`) · refreshed `20260801.162056` (self-work arc · rows 58–60 accreted)
**Style:** Radiant (see [`../context/RADIANT_STYLE.md`](../context/RADIANT_STYLE.md))
**Voice:** Kyri
**Status:** Living pin — one row per red, oldest first
**Bound:** under `living_pin_max_bytes` (24576)
**Room:** Checkable — every row names where it was caught

*A red owned in conversation is a memory. A red recorded here is a proof. This ledger exists because a check at Voice v9 found six reds written into the tree and twenty owned out loud — so fourteen lessons were living only in a chat window that closes.*

---

## Why this file, and what belongs in it

Own-reds-immediately has been a house law for a long time, and it worked: reds were named the moment they were found, out loud, without excuse. What the law never said is **where**. So the ones that happened to land inside a witness header or a spec erratum survived, and the ones that happened in a sentence did not.

Three fields per row, because a red with fewer teaches nothing:

- **What went wrong** — stated plainly, no softening.
- **What caught it** — a compiler, a stopwatch, a guard, a second look. Never "I noticed."
- **What it taught** — the transferable rule, which is the only part that outlives the incident.

A red enters this ledger when it is found. Rows are never edited or removed; a later correction accretes as a new row pointing back.

---

## Voice Season · opened `20260729`

*Rows 1–24 folded to [`archive/REDS-voice-season-rows-1-24.md`](archive/REDS-voice-season-rows-1-24.md) on `20260810.171343` — closed-season fold under the living-pin bound; every byte kept, nothing removed.*

*Rows 25–57 folded to [`archive/REDS-voice-season-rows-25-57.md`](archive/REDS-voice-season-rows-25-57.md) on `20260811.143004` — the same fold, the same discipline: the dense Voice-Season counsel arc (`20260730`–`20260801.033305`) moved to the archive, every byte kept, the living pin brought back under 24576.*

*Rows 58–73 folded to [`archive/REDS-self-work-yield-rows-58-73.md`](archive/REDS-self-work-yield-rows-58-73.md) on `20260815.210520` — the same closed-range fold: the self-work-and-Yield arc (`20260801.145854`–`20260812.191206`) moved to the archive, every byte kept, the living pin brought back under 24576, and the monotone witness taught the new archive in the same act (REDS #67's own lesson). **Living rows 74 onward below.***

| # | What went wrong | What caught it | What it taught |
|---|---|---|---|
| 74 | Two measures of the CION guard's `guarded_sites` disagree: the LOWE molt hand-counts progress in the guard comment (44 → 57 → 61 → 67 of 79, counting every relabeled surface including `.rish` witnesses), while the automated `tools/fixtures/vols_guardlist_extract.sh` filters `\.(rye\|md\|brix)$` and silently drops every `.rish` guarded site, reporting only 44/45 | reconciling the two numbers this round (LOWE-J14r4d-iii) before claiming one — an intersection measure said 44 where the session logs said 61, so one method was undercounting by exactly the `.rish` sites | **Measure before claiming** (the ledger's own recurring rule): a progress metric read two ways must agree, or one way is lying. Booked to the J14 read-true close (the VOLS re-run), where the extractor's file-type filter widens to the extensions the survey itself counts as prose-gap sites — the automated `guarded_sites` cannot reach 79 until the extractor learns `.rish`. Guard stays GREEN over the widened set regardless; the count is the metric, not the gate. |
| 75 | Two Testament session-log stamps were typed by incrementing a guess, not by reading the clock: after r2's honest `140126` (read from `TZ=America/New_York date`), r3 was stamped `141550` and r4 `142530` — and r4 landed roughly ten minutes ahead of the wall clock, future-dating committed, already-pushed testimony | reading the real clock into a variable before the arc-fold round returned `20260813.141525`, below both fabricated stamps; `one_clock_witness` then showed `TRUE_HEAD 20260813.142530` while the live clock trailed it | **Read the clock every round** (the same law rows 60 names — *take the clock into a variable*): never increment a remembered stamp between rounds, however fast the laps run. The pushed future-stamps are dated artifacts — correcting them is a history rewrite (deep **debride**, custody gate #1, Keaton's hand), so this errata stands here rather than in a rewrite; the mono witness still passes since it tracks the newest commit as its head. |
| 76 | A **recurring authoring lantern** the HUNK39 · 40 · 42 · 43 logs each booked, fired a fifth time at HUNK49: a witness checked its GREEN line with `printf '%s' '${out}' \| grep`, and an apostrophe in the selftest prose (`cursor's`) closed the shell single-quote early, so the grep failed though the selftest was truly GREEN | the witness assertion going RED at HUNK49 while the binary plainly printed `GREEN edit-touch-view` — the shell, not the code, was the liar | **A lantern this recurrent becomes a loom** (reds-first): Rishi's native `str contains "needle"` never routes output through a shell, so an apostrophe in the haystack can never break a check. Both HUNK48/49 witnesses converted to `assert out contains "…"`, and the HUNK49 apostrophe restored to prove it on metal. The convention henceforth: check witness claims with native `contains`, never `printf … \| grep` over interpolated output. |
| 77 | A Season G crypto lap wrote **"eighteen crypto `.rye` files"** into a session log, a `session-logs/README.md` row, and commit `d2c4e8167a` — the true count is **sixteen** (fourteen primitives + two compositions, matching REMEMBER's SIXTEEN rungs). A file-count claim carried from memory of an `ls` scroll, never checked | `ls crypto/*.rye \| wc -l` returned **16** while enumerating files for the whole-suite crypto witness — the shell, not a re-read (the pattern this ledger names again and again) | **Measure before claiming, even the obvious.** A "how many files" claim is a checkable fact — ask the shell (`ls … \| wc -l`), never count from the memory of a directory listing. Fixed forward by tier: the living README corrected in place, the dated `.bron` log kept with an appended `errata` field (one-clock law), the immutable commit left as history. The formal ledger row wanted a fold — the living pin sat 141 bytes from its 24576 cap — so rows 58–73 folded to archive in the same act (REDS #67's lesson: teach the monotone witness the new archive), and this row seated after. |
| 78 | `tools/fixtures/safe_list_census.sh` greps `fascia_metric_v0`'s output for `refuse: shred\|no shred\|shred refuse` to set `SHRED_RED`, but the metric's wording had moved to **"no live shred"** — the word *live* breaks the `no shred` match — so `SHRED_RED` read `no`, the census verdict went `thin`, and `safe_list_census_witness` had been silently RED. A witness reading another tool's prose that did not follow when that prose moved (kin to #67) | running `equinox_reds_choir_witness` during the REDS-fold lap surfaced *"SAFE elder went RED"*; tracing the chain to the census showed `SHRED_RED=no` while `fascia_metric_v0` plainly prints *"no live shred"* — the shell, not a re-read | **A witness that greps another tool's prose must follow that prose when it moves** (#67 again). Widened the alternation to `no live shred` while keeping the elder phrasings, so a bench on either wording still reads the signal — census now `verdict=ok`, `SHRED_RED=yes`. Named honestly: the census's own witness still cannot reach full GREEN on this bench, since a deeper elder wants `gratitude/tigerbeetle/src` (an unclonable study clone absent here) — a **provisioning fact, not a code red**. |
| 79 | `encoding/base32.rye` decode indexed `symbols_for_rem[last_bytes]` for the final group, but that table is sized for *padded* tails only (indices 0..4). A full final group carries 0 pads and maps to `last_bytes = 5`, so `symbols_for_rem[5]` on a length-5 table panicked index-out-of-bounds the first time a 5-, 10-, or 15-byte input's last group was full. The leftover-byte tables were written for padded tails and silently misused for the whole-group case | the module's own selftest, on the first metal run: the RFC §10 vectors passed, then the 0..64-byte round-trip sweep panicked `index 5, len 5` at the decode last-group line — the compiler-inserted bounds check, not a re-read | **A lookup table sized for the partial case must be guarded before the whole case reaches it.** The full final group is the eight-symbol case, not a table entry — special-cased `nsym = if (last_bytes == 5) 8 else symbols_for_rem[last_bytes]`, GREEN on the re-run. A byte-for-byte parity sweep across *every* remainder class is what forced the full-last-group path to run at all. |

**Rows: 79 · in the tree before the ledger: 6 · recovered by opening it: 14 · added under the reds-first law: 59** — rows 1–24, 25–57, and 58–73 folded to `archive/`, living rows 74–79 above.

**Reds-first accounting for v11:** two reds found, both fixed in-round with witnesses on metal, ledger closed. The remaining journey allocation is therefore **released** rather than booked — which is the law working, not the law skipped.

**Reds-first accounting for the two-grain projection (`20260808.183836`):** two reds (61, 62), both real key-material leaks the seed witness caught before any public push, both fixed in-round by hardening the projection guard to match the witness, GREEN on metal after. Allocation **released** — the witness held the line exactly where it was built to.

**Reds-first accounting for AHOY2 (`20260811.225629`):** REDS #69 — a pre-existing seed-boundary coverage gap (five root dirs unclassified since recent seasons) surfaced while adding the top-level `LICENSE`. Classified on Keaton's word — `assets`·`brix`·`pleac` allowed (template, clean code + logo), `journey`·`research-silo` withheld (personal) — and `sow_witness` returns **SOW_WITNESS_GREEN** (M1_OK · IDENT_CLEAN · NO_PERSONAL, copied 4092 · scrubbed 780 · withheld 22). Closed with a witness on metal, same arc. Allocation **released**.

**Reds-first accounting for GISM-J5r1 (`20260812.181015`):** REDS #72 — the first real corpus the reading voice read tripped `BlockTooLarge`, exactly the Yield red Season 2 exists to surface. Found by the real read, fixed in-round by raising `max_block_text` to admit real reference-doc paragraphs with headroom (`tools/gism_j5_corpus_real_witness.rish` GREEN), the demo reading re-run GREEN. Allocation **released** — the round's own real bytes caught the bound the demo never exercised.

**Reds-first accounting for GISM-J6r1 (`20260812.185056`):** REDS #73 — the first real document carried through the owner-signed catalog refused `ContentTooLarge`, the Yield red Season 2 exists to surface. The refusal is proven on metal in-round (`tools/gism_j6_provenance_real_witness.rish` GREEN), and the chain of custody stands GREEN over a small real artifact (a waymark green-claim) the same round. Unlike #72, the fix is **not** a bound-bump — `max_resin_bytes` is structurally capped — so the allocation is **booked** toward the chunking-storage horizon (large artifacts across ordered resins, a later GISM rung), the honest cost named rather than a raise pretended.

**REDS #73 CLOSED (`20260812.191206`) — the chunking rung built:** the booked chunking-storage horizon is now a module. `mantra/spool.rye` winds a large artifact across ordered resins (each a valid bead-index over the shared `BeadStore`), the whole proving against a SHA3-256 content address, every tamper (flipped bead · corrupted resin index · truncated spool) refusing. Real front-door documents wind and unwind byte-for-byte — `SECURITY.md` (2689 B → 6 resins), `context/TWO_ROOMS.md` (6079 B → 12 resins) — the very files red #73 refused, and the honest 32 KB ceiling is reachable in full (32768 B / 64 resins / 128 beads wound and unwound whole). No bound was pretended: `max_resin_bytes` stayed capped; the fix is a storage layer above it, with `beading.max_store_beads` raised 64 → 256 additively so the ceiling is real (beading re-runs GREEN). Witness `tools/gism_spool_witness.rish` GREEN (real docs · ceiling · dedup · three tamper refusals · on-disk size cross-check), TAME + width clean. Allocation **released** — the honest fix landed, not a raise.

**REDS #74 CLOSED (`20260813`) — the extractor learned `.rish` and `.glow`:** the LOWE-J14 read-true close widened `tools/fixtures/vols_guardlist_extract.sh`'s file-type filter from `\.(rye|md|brix)$` to `\.(rye|md|brix|rish|glow)$`, the extensions the guard actually scans, so the extracted guardlist stopped silently dropping every `.rish` (and the one `.glow`) guarded site. The two measures now agree: the extracted guardlist holds all **79 of 79** VOLS prose-gap paths, and a fresh live census reads `prose_gaps=0` (every relabeled surface fell out as a site, only kept handles remain). The count was the metric, never the gate — the guard stayed GREEN over the widened set throughout. Allocation **released** — the honest fix landed. LOWE Journey 14 (Molt) closed with it.

---

## What the pattern says

Read down the *what caught it* column and almost nothing was caught by thinking harder. A compiler, a stopwatch, a file-type check, a guard's first run, seven witnesses at once, a pack catching its own author. **The machine caught nineteen of twenty.**

That is not a complaint about judgment; it is the argument for the whole apparatus. Witnesses exist because the author is the last person able to see their own gap, and this column is twenty lines of evidence for that claim rather than one more assertion of it.

Read down the *what it taught* column and four rules recur: **measure before claiming**, **scope before shipping**, **fixture rather than remember**, and **narrow the objection**. Those four have paid for themselves repeatedly in a single sitting.

---

*May every red find this page on the day it happens. May the lesson outlive the incident. And may the count of what we got wrong be as witnessed as the count of what we got right.*
