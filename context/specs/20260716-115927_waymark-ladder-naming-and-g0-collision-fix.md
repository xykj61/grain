# Waymark -- a Word-Drawn Ladder Mark, and the Genode/GrapheneOS G0 Fix

**Language:** EN
**Version:** `20260716.115927` - corrected `20260716.124840` (hash family fixed to this tree's own SHA3-512; the derived word changed from a first, wrong SHA-2 draw)
**Style:** Gauge (see `../GAUGE_STYLE.md`)
**Voice:** Quin
**Status:** Living -- seats a new naming convention and applies it once, today, to a real collision. Register: checkable -- the derivation is a real witness (`tools/waymark_derive.rish`), GREEN on this metal. Word-list pin refreshed `20260724.151327` (Option C fixture twin + digest).

Radiant pass `20260725.040728`

---

## The Collision, Named Plainly

Two ladders in this tree independently reached for the same short code:

- The **Genode/seL4 proven-seat guest ladder** (`docs/PROVEN_SEAT.md`) names its rungs **G0** (environment, TCG boot), **G0-complete** (kvm path), **G1** (digest-grade), with real tooling behind each: `tools/proven_seat_g0.rish`, `tools/proven_seat_g1.rish`, and a dozen siblings, all GREEN, all cross-referenced from `work-in-progress/ROADMAP.md` and `TASKS.md`.
- The **GrapheneOS/Pixel mobile-emulation ladder** (`two-dev-environments-and-mobile-emulation.md`, opened `20260715.163500`) names its own rungs **G0** (stock AOSP/Android emulator), **G1** (Seva in the AVD), **G2** (real GrapheneOS build), **G3** (physical device) -- a wholly unrelated ladder that happens to share the letter G, because "Genode" and "GrapheneOS" both start with it.

The prior session already spotted this and named it honestly without yet fixing it: *"That machinery belongs to a wholly unrelated Genode/seL4 proven-seat guest ladder that happens to reuse the same G0-G3 numbering as the GrapheneOS/Pixel ladder -- a real naming collision, kept straight rather than conflated"* (`session-logs/20260716-110152_framework-ubuntu-host-arrives-slc-green.bron`). This document closes that open thread.

## Why `{letter}{number}` Runs Out Faster Than It Looks

Twenty-six letters sounds like room enough, yet the real failure mode is not exhaustion -- it is **convergent intuition**. Two namers (human or agent) each independently reach for their own ladder's own first letter, because that is the obvious, load-bearing choice every time: Genode -> G, GrapheneOS -> G, and this tree already holds **Granary**, **Glow**, and **Dimeroll** too -- every one of them a plausible future collision with the same letter, for the same reason. The scheme does not fail because 26 is small; it fails because "pick the first letter of the thing you're naming" is a *shared* heuristic, and shared heuristics collide precisely where they feel most natural.

## What3words and `flw.txt` -- Borrowed Ideas, Never Borrowed Code

What3words solves an adjacent problem (uniquely addressing every 3x3m square on Earth) with one idea worth borrowing in spirit only, per this tree's own clean-room discipline (`.cursor/rules/gratitude-licenses.mdc`): **a stable function from a name to a word (or words) needs no central coordination to stay collision-free** -- nobody has to check a shared ledger of "words already taken," because the mapping itself is deterministic. No what3words code, word list, or proprietary algorithm is used here, or ever vendored into this tree; only that one idea.

The actual word list began as one this tree already held: `old/doc/spec/flw.txt`, part of the vendored `urbit/urbit` tree (MIT, per `gratitude-licenses.mdc`'s own listing), a plain list of valid four-letter English words -- **5,526 of them**, once de-duplicated and confirmed as clean `[A-Z]{4}` entries. **Runtime pin (Option C, `20260724.151327`):** [`../../tools/fixtures/flw-four-letter.txt`](../../tools/fixtures/flw-four-letter.txt) -- a whole-file twin with a short attribution header above `# body unmodified below`; extract skips the header. Naming-grade pins in `tools/waymark_derive.rish`: count `5526` and SHA3-512 of the extracted word list. Sameness witness: `tools/waymark_derive_witness.rish`. A word list is a collection of facts, not creative expression, so drawing individual words from it for our own naming needs (exactly as this fork already did by hand for `Sala`, `Pool`, `Ojjo`, `Quin`, `Rhyz`) is the same permissive-study, clean-room-authored pattern the whole Lexicon already stands on.

## Waymark, Defined

**Waymark** -- a four-letter word, deterministically drawn from `flw.txt`'s own word list, that marks which ladder a numbered rung belongs to. Where a **lap** is an SLC-sized whole and a **rung** is one step on a ladder, a **waymark** is the ladder's own name-tag, replacing the bare capital letter that used to sit in front of every rung number (`G0` -> `HAWM0`).

**The draw, exactly** (witnessed, re-runnable: `tools/waymark_derive.rish`):

1. Take the ladder's own canonical, descriptive, lowercase-hyphenated name as the input (never its abbreviation -- abbreviations are exactly what collided).
2. Hash the input string with **SHA3-512** (`openssl dgst -sha3-512`, this tree's own ratified host oracle -- [`20260703-191112_resins-and-hash-tiers.md`](20260703-191112_resins-and-hash-tiers.md)); take the first 8 hex digits. A waymark is a naming-grade, durable identity -- the same "must mean one thing for as long as the work endures" promise that spec's own Canonical tier names for Aurora stage names -- so it draws from SHA3-512, never plain SHA-2 (`sha256sum`, a different algorithm family entirely despite the similar name) and never the Working-tier SHA3-256 reserved for high-volume store units like Amber resins.
3. Convert to decimal, modulo the word-list size (5,526), plus one -- the index.
4. Look up that index in the sorted, de-duplicated word list.
5. Assert the drawn word is not already a seated four-letter name in `context/LEXICON.md` (`BRIX`, `BRON`, `POND`, `MUR`, `SEVA`, `MONA`, `POOL`, `QUIN`, `RIYO`, `REYA`, `TREY`, `TERA`, `TRIZ`, `OJJO`, `GLOW`, `RHYZ`, `PEAL` -- plus retired `MALA`; the only entries of that same length). A collision here is vanishingly unlikely at 1-in-5,526 odds, and the script fails loudly rather than silently if it ever happens; the fix is to salt the input (append `-2`) and redraw.

**A named correction, honestly kept:** the first pass of this script (`115927`) reached for plain `sha256sum` out of habit and drew `FITS` before anything downstream of it was written down as settled. Caught within the hour (`124840`) against this tree's own already-ratified two-tier SHA3 policy, which names an exact host oracle for exactly this kind of naming-grade hash and was simply not consulted the first time. The fix changed one line in the script and, with it, the drawn word -- `HAWM` is the real, current, correct waymark; `FITS` never shipped past this same day's own living docs and is not a second valid answer sitting beside it.

**URL-safe and path-safe by construction, not by care** -- every entry in `flw.txt`'s four-letter block is plain `[A-Z]{4}`, so a waymark can never contain a character that needs escaping in a filename, a URL, or a rung label. This is the same structural-guarantee shape already used for placeholder ship names (`.cursor/rules/placeholder-ship-names.mdc`): safety that holds because the input space cannot produce the unsafe case, not because someone remembered to check.

## Applying It -- the GrapheneOS/Pixel Ladder Becomes `HAWM0`-`HAWM3`

Run today, on this metal:

```
input:  grapheneos-pixel-mobile-emulation
sha3-512(8): 854b9a74 -> decimal 2236324468 -> index 2003 of 5526
GREEN: waymark derived -- HAWM
```

**The GrapheneOS/Pixel ladder yields, not the Genode one** -- three honest reasons, not a coin flip:

1. **Cheapest to move.** The GrapheneOS ladder is checked-and-honestly-blocked/horizon with zero rung-named files (no `grapheneos_g0.rish` exists anywhere); the Genode ladder has a dozen tracked, GREEN-witnessed files (`proven_seat_g0.rish`, `proven_seat_g0_complete.rish`, `proven_seat_g0_complete_jailed.rish`, `proven_seat_g1*.rish`, ...) plus `docs/PROVEN_SEAT.md`'s own rung table. References are promises (`.cursor/rules/collaboration.mdc`); the ladder with almost none outstanding pays the smaller price.
2. **It is the newer, colliding entrant.** The Genode ladder's G0 dates to `20260712`; the GrapheneOS ladder's G0 was named five days later (`20260715.163500`), by an agent session that -- Keaton's own words -- "was auto agent named without seeing the conflict." The later arrival yields to the incumbent.
3. **Nothing dated needs rewriting.** Every historical session log that already said "G0" meaning the GrapheneOS rung keeps saying exactly that, unedited (accrete-never-break); only the **living** spec and the **current** TASKS bullets -- the ones that speak as *now* -- take the new mark going forward.

**Rung table, renamed** (full detail stays in `two-dev-environments-and-mobile-emulation.md`):

| Old mark | New mark | What it is |
|---|---|---|
| G0 | **HAWM0** | Stock AOSP/Android Emulator, HVF/KVM-accelerated |
| G1 | **HAWM1** | Glow userland (Seva broadcaster) inside the AVD |
| G2 | **HAWM2** | Real GrapheneOS build, emulator target (Linux/KVM host) |
| G3 | **HAWM3** | Physical Pixel, GrapheneOS flashed |

## What Stays Exactly As It Was

- The **Genode/seL4 proven-seat ladder** keeps bare `G0`, `G0-complete`, `G1` -- every file name, every witness, every cross-reference, untouched. It was here first, it is heavily cited, and nothing about it collides with anything once the GrapheneOS ladder moves.
- Every **dated, historical** log, hammock, and counsel note keeps its own original "G0" prose exactly as written, the same discipline that already keeps old *tip* readable beside new *nib* (`.cursor/rules/vocabulary-nib.mdc`).
- `work-in-progress/ROADMAP.md` never named the GrapheneOS ladder's rungs directly (its own "G0-G3" mentions are all the Genode ladder), so it needed no edit at all.

## Using Waymark for the Next Ladder

Open `tools/waymark_derive.rish`, change the one `input_name` line to the new ladder's own canonical name, run it (`rishi/bin/rishi run tools/waymark_derive.rish`), and read the printed word off a GREEN close. If the closing assert ever goes RED -- the draw landed on an already-seated name, at roughly 1-in-5,526 odds -- append `-2` to the input and redraw. No ledger to check, no coordination with anyone else naming a ladder the same week; the function itself keeps the promise. Re-running the script with a *already-seated* placeholder input trips the exclude list by design; use a fresh input for the next ladder. Collection sameness: `rishi/bin/rishi run tools/waymark_derive_witness.rish`.

## Genre law -- fixtures, inherited trees, gratitude

Seated `20260724.151327` with the Option C flw pin, for all future cases:

| Kind | Home |
|------|------|
| Authored fixtures the bench asserts | `tools/fixtures/` |
| Inherited trees kept for study | sibling clones (not the working pier) |
| A single inherited data file the bench asserts | fixtures twin with attribution header + digest pin |
| Gratitude shelf | reading library only -- never a runtime dependency |

## Related

- `docs/PROVEN_SEAT.md` -- the incumbent Genode/seL4 ladder, unchanged.
- `two-dev-environments-and-mobile-emulation.md` -- the living twin this fix edits directly.
- `session-logs/20260716-110152_framework-ubuntu-host-arrives-slc-green.bron` -- where the collision was first spotted and named, not yet fixed.
- `context/LEXICON.md` -- the Waymark entry seated alongside Lap and Bench.
- `.cursor/rules/gratitude-licenses.mdc` - `.cursor/rules/placeholder-ship-names.mdc` -- the two disciplines this scheme leans on (clean-room study; structural safety by construction).
- `20260703-191112_resins-and-hash-tiers.md` -- the ratified two-tier SHA3 policy this scheme's own hash step follows (Canonical/SHA3-512, not Working/SHA3-256 or plain SHA-2).
- `tools/waymark_derive.rish` -- the operator derive script.
- `tools/waymark_derive_witness.rish` -- naming-grade word list + seated-draw sameness.
- `tools/fixtures/flw-four-letter.txt` -- runtime word-list pin (elder path named in its header).
- Counsel ask `counsel/20260724-150246_flw-corpus-shelf-and-vere-old.md` - reply `counsel/replies/20260724-151327_re-flw-corpus-shelf-option-c.md`.

---

*May every ladder find its own word without a meeting to schedule for it, and may the letter G rest easy, freed from having to mean three different things at once.*
