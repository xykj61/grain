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

*Rows 25–57 folded to [`archive/REDS-voice-season-rows-25-57.md`](archive/REDS-voice-season-rows-25-57.md) on `20260811.143004` — the same fold, the same discipline: the dense Voice-Season counsel arc (`20260730`–`20260801.033305`) moved to the archive, every byte kept, the living pin brought back under 24576. **Living rows 58 onward below.***

| # | What went wrong | What caught it | What it taught |
|---|---|---|---|
| 58 | `git bundle verify` answered *complete history* on a bundle with a hundred megabytes torn off the tail — the crossing lane nearly trusted a header as a proof of the pack | counsel e194 `20260801.145854` · planted truncation · clone died at `early EOF` while verify stayed green | Verify reads the header, never the pack. The manifest's content address is the load-bearing wall; a clone is the second. Both plants stand in `equinox_bundle_negative_witness`. |
| 59 | Five custody bars of the enclosure witness — host key, lane key, Documents, Downloads, Wayland — passed vacuously for their whole lives: backslash-quoted `test` guards compared literal quote characters | counsel e206 `20260801.160208` advisory sweep · planted key sailed the elder form rc=0 and bit the toothed form rc=1 | An assert that cannot fail protects nothing. After any quoting law lands, sweep every guard shape for it — row 9 taught the leak; this row teaches the vacuum. |
| 60 | One arc relearned three standing laws the hard way: anchors composed from memory died twice, three stamps were typed before the clock answered, and the backslash law bit the very witness hunting it | counsel e204b–e207c · AssertionError on remembered needles · seat stamps versus the clock line in the same output | Same law, three faces: read the needle from the file, take the clock into a variable, and let the finder's tools obey the finding first. |
| 61 | The two-grain projection first assumed `template` paths were safe to copy verbatim; the canonical committed fingerprint file `context/PUBKEYS.md` sits inside a scrub dir, and a name-scrub cannot catch a fingerprint — it projected real key material into the seed | `tools/sow_witness.rish` duty 4 (personal/key scan) went RED — `PERSONAL_BAD key material: seed/context/PUBKEYS.md` — before any push | A verdict is not a content check. Guard key material by name and by shape at the projection edge, whatever the manifest says — belt and suspenders, not either alone. |
| 62 | With the name-scrub landed, six ordinary docs (a keys README, NixOS setup guides) still embedded real `ssh-ed25519` pubkey lines; the projection copied them because their basenames looked innocent and they carried no maintainer name | the same witness, after a content guard was added — `PERSONAL_BAD embedded key material` named all six | A pubkey is identity even when the file is prose. Scan seed content for key blocks, not only key-named files; withhold and swap for placeholders on the human pass. |
| 63 | Nine session-log stamps were invented in the 04:xx–07:xx range to look continuous with the morning's logs; the live EDT clock read 18:38. Every stamp this session was fabricated, not read — a silent violation of the one-clock law | **Keaton, by eye** — not a witness. `TZ=America/New_York date` then confirmed the ~11-hour gap | Read the system clock for every stamp; never continue a plausible sequence from memory. The one machine that would have caught this — `one_clock_witness` duty 4 — checks *ahead*, not *behind*, so a backdated stamp slips it. A human caught what the apparatus was not shaped to see. |
| 64 | While landing the `?!` rune, `tame_style_check` went RED on `tools/comlink_r1_dual_bind_probe.py` (TOOLS_PY_BAD) — an authored Python probe, dated Aug 3, left in the tree after Comlink R1 itself was cut. It is a fossil the ban has flagged since it landed; the rune work never touched it | `tools/tame_style_check.rish` — run as part of the SLC Definition of Done for the touched `main.rye`, it surfaced the ambient ban the moment a full check ran | A cut feature leaves probes behind, and a style gate finds them the next time anyone runs it in full. The remediation is molt/shred, not a rune-lap patch — a `.py` fossil wants a port to Rishi or a circled shred on Keaton's word, not a quiet fix folded into unrelated work. |
| 65 | Every Mandate capability built `20260810`–`20260811` was named **`lap 1` … `lap 11`** — a bare count-up-from-zero ordinal in the identity slot — across `mandate/README.md`, `.rye` doc-comments, TASKS rows, and eleven session logs, directly contradicting the chronological-semantic labeling law seated `20260810.222755` that these very hands wrote | **Keaton, by eye**, reading `LAP 9` in a comment — not a witness. The GRAD seal (`grad_seal_witness`) guards only the three living pins (REMEMBER · ROADMAP · THREADS), so module READMEs, code comments, and new logs slipped it entirely | A capability's name is its **semantic label + date** ("object-storage backing · `20260811`"), never a bare `lap N`; an ordinal is allowed only as a *computed coordinate*, never as identity. The labeling guard must extend past the three pins to module docs and code comments, or the law holds only where a witness happens to look. This is CION's mandate and a major focus of this or the next season, no matter the sweep size. |
| 66 | Relabeling granary's `lap N` prose, I ran `sed -i` across `granary/*.rye` — but two of those (`granary/scribble_core.rye`, `granary/wov_core.rye`) are **symlinks** into `scribble/` and `linengrow/`. `sed -i` replaced each link with a regular-file copy, breaking the link and diverging the copy from its canonical home, while the real target kept its old text | `git status --porcelain` showed **`T` (typechange)** on exactly those two paths — the link-to-file conversion — before anything was committed | Never `sed -i` a path that might be a symlink; the flag rewrites the link into a standalone file and silently forks it from its source. Scope a module sweep to that module's **own** files, and treat a symlink into another module as that module's round. Check `ls -la` / a `T` in `git status` before trusting an in-place edit. |
| 67 | The rows 1–24 REDS fold (`20260810`) moved rows into an archive yet left `reds_ledger_monotone_scan.sh` reading the living pin alone and expecting it to start at row 1 — so `reds_ledger_monotone_witness` went red (`expected row 1, found 25`) the moment that fold landed and stayed red, unnoticed, for a day | running the monotone witness during **this** (25–57) fold, then `git show HEAD:work-in-progress/REDS.md` through the scan reproduced `expected row 1, found 25` at the pre-fold nib — dating the breakage to the 1–24 fold | A fold changes an invariant's **domain**: when a closed-range fold moves rows to an archive, every witness that spans "the whole ledger" must be taught the new file set in the same act. A fold is not done until the guards that read the folded thing are updated — and a witness outside the run-suite rots unseen, so run the ledger's own witnesses whenever you touch the ledger. |
| 68 | The Aurora freestanding witness (`tools/aurora_seed_freestanding_witness.rish`), committed at `ec6cfc845f`, built the boot seed with raw `zig build-exe` — yet zig does not recognize the `.rye` extension, so the build silently no-op'd (its error swallowed behind `\|\| true`) and the `e_machine == 243` check passed by reading a **stale ELF** left from an earlier `rye build`. The witness was green without ever compiling anything | the very next lap — extending the gate to all eight stages — ran `zig build-exe` on each fresh, and every stage failed `unrecognized file extension`, exposing that the seed's green had come from a pre-existing artifact rather than a live build | A build witness must guarantee it built: remove the artifact before the build so only a fresh compile can satisfy the check, and never swallow the build step behind `\|\| true` (which turns a failure into a false pass). Use the real compiler the stack uses — `rye build`, not raw `zig build-exe`; a witness that skips the tool under test proves nothing. Fixed same-round: rm-first, `rye build`, `&&`-chained `od` across all eight stages, GREEN on metal. |
| 69 | Five root dirs added by recent seasons — `assets/` (AHOY0 logo), `brix/` and `pleac/` (SOON cookbook), `journey/`, `research-silo/` — were never classified in `template-manifest.bron`, so the two-grain seed boundary silently stopped covering the whole tree; `sow_witness` duty 1 (M1 coverage) has been RED for at least a day, unnoticed | running `sow_witness` while adding the new top-level `LICENSE` to the manifest during AHOY2 — the M1 assert named all five unclassified root paths (`in tree, not in manifest`); a stash-check confirmed the red predates this round at HEAD | The seed boundary manifest must be updated in the **same act** that adds a root dir — a new top-level directory is a seed-classification decision (allow · scrub · personal · withhold), not a free addition. Kin to row 67: a coverage witness outside the routine run-suite rots unseen. `assets`/`brix`/`pleac` are plainly public (logo + code); `journey`/`research-silo` touch identity and want a scrub-vs-withhold call — deciding what enters a public force-push seed is Keaton's hand (AHOY3), so the classification waits on his word rather than a guess. |

**Rows: 69 · in the tree before the ledger: 6 · recovered by opening it: 14 · added under the reds-first law: 49** — rows 1–24 and 25–57 folded to `archive/`, living rows 58–69 above.

**Reds-first accounting for v11:** two reds found, both fixed in-round with witnesses on metal, ledger closed. The remaining journey allocation is therefore **released** rather than booked — which is the law working, not the law skipped.

**Reds-first accounting for the two-grain projection (`20260808.183836`):** two reds (61, 62), both real key-material leaks the seed witness caught before any public push, both fixed in-round by hardening the projection guard to match the witness, GREEN on metal after. Allocation **released** — the witness held the line exactly where it was built to.

---

## What the pattern says

Read down the *what caught it* column and almost nothing was caught by thinking harder. A compiler, a stopwatch, a file-type check, a guard's first run, seven witnesses at once, a pack catching its own author. **The machine caught nineteen of twenty.**

That is not a complaint about judgment; it is the argument for the whole apparatus. Witnesses exist because the author is the last person able to see their own gap, and this column is twenty lines of evidence for that claim rather than one more assertion of it.

Read down the *what it taught* column and four rules recur: **measure before claiming**, **scope before shipping**, **fixture rather than remember**, and **narrow the objection**. Those four have paid for themselves repeatedly in a single sitting.

---

*May every red find this page on the day it happens. May the lesson outlive the incident. And may the count of what we got wrong be as witnessed as the count of what we got right.*
