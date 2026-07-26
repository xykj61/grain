# Sixteen Hot Files

**Language:** EN
**Stamp:** `20260726.025120`
**Voice:** Quin
**Status:** Counsel — propose-never-seat; Checkable — every count below was recomputed by counsel from the census manifest and the tree at nib `0cdf4af9e8`
**Ground:** P through T1 landed · SOURCE Part One and Part Two banners stand · *Create* seated in the Lexicon · router head in place · README alphabetical · link witness GREEN with an honest baseline of **2544** dangling · census written, moving nothing · **T2 is Keaton** · F came back **RED** on signed-Kumara
**Answers:** [`counsel/replies/20260726-022043_re-cheap-hour-stop-missing-014013.md`](replies/20260726-022043_re-cheap-hour-stop-missing-014013.md) · the T1 census · the F red
**Files this create carries:** this memo · `20260726-014013_which-gate-belongs-to-which-lap.md` (re-attached; see the last section)
**Counsel model this sitting:** Claude Opus 5 1M Max

*Written together by Keaton and Quin.*

---

## The Number That Changes the Plan

The census heuristic proposed 133 files staying hot. Counsel recomputed the split behind that number, and it separates cleanly into two very different populations.

| Bucket | Count | What it means |
|---|---:|---|
| **Live-named** — REMEMBER, TASKS, ROADMAP, or an open counsel names it | **16** | genuinely hot; a hand is on it now |
| **Canonical-but-cold** — inbound references ≥ 3, nothing live names it | **117** | load-bearing vocabulary; cited, unworked |
| **Deferred** — neither | **247** | the yonder motion |

Sixteen. That is what *active* actually means in this tree right now, and it is the number worth holding in mind, because it says the room could be readable in one glance rather than merely shorter.

The 117 are the interesting problem, and the census heuristic was right to refuse to move them while conflating two tests. Inbound-reference density measures how load-bearing a page is; live-naming measures heat. A brief that twenty-three files cite is not deferred, so `yonder/` — which means *forward, dormant, may return* — would be the wrong word for it even though every link would still resolve. Yet leaving 117 unworked pages one level deep keeps the room from meaning what its name promises.

## The Ruling: Move the 247 Now, Compress the 117 Later

**Take the 247 tonight.** They need no new name, no new room, and no decision beyond Keaton's strike list. That is a sixty-five percent reduction in one motion, and it is the whole of the value available without a naming round.

**Leave the 117 exactly where they are, pending their own season.** And here the tree supplies its own answer again, the way `ORGANIZING.md` did last sitting. The seated docs-compression pattern — raw beneath, compress above, keeper honest — is precisely the instrument for a canonical-but-cold brief. A page that twenty-three files reach for wants a compressed `docs/` shelf page carrying its conclusions, after which the brief itself becomes genuinely deferred and moves to `yonder/` like anything else. So the 117 resolve **by compression rather than by relocation**, which uses a law already seated rather than inventing a room and a name. That is a writing season rather than a round, and it should be scoped after the motion, not during it.

The far side, stated honestly in two numbers: **382 down to 133** at the end of this motion, and **133 down to roughly 16** at the end of the compression season. Publishing both, with the second marked as a season rather than a promise, keeps the arithmetic true.

Keaton's T2 pass remains exactly what it was — strike from the 247 anything that must stay hot, and the strike list is the seating word for T3.

## The Gate Is Toothless, and Here Is the Fix

This is the sharpest finding of the lap, and it wants correcting before a single file moves.

`link_witness` walks the tree and reports **2544** dangling relative links today, passing only under an allow-baseline flag. That flag is honest — an existing debt should not block a new instrument — yet it makes the witness unable to do the job the breach's fourth promise assigns it. Under a count-or-baseline gate, a motion could add five hundred fresh dangling links and still come back green. A gate that cannot fail on the thing it was built for is worse than no gate, because it spends the run and buys false confidence.

The fix is the same shape as the additive-heading proof from the last create, and it costs almost nothing: **compare sets, not counts, and do it per round.** Capture the dangling set before the round. Capture it after. Assert the after-set is a **subset** of the before-set — no new dangling link anywhere in the tree, whatever the standing baseline is. A moved file that took its references with it produces an after-set no larger than the before. A moved file that stranded a link shows up immediately, by name, and the round rolls back.

That is a strict improvement over both the absolute count and the baseline flag, and it makes the breach genuinely witnessed on both sides rather than nominally so.

## The 2544 Are Not 2544 Problems

Counsel proposes the second finding be treated as a survey rather than a backlog. Two thousand five hundred dangling links across a tree this size almost certainly trace to a handful of systematic causes rather than to thousands of independent mistakes. The candidates worth bucketing first: links into the untracked elder `old/` and `vere/` trees, which exist on disk and in history yet resolve nowhere in a fresh clone; links into `archive/` and `yonder/` written before those moves happened; depth-relative paths broken by an earlier relocation; and module renames whose inbound references were never turned, of which this season alone produced several.

So the ask is a **bucketed report** — the top causes ranked by count, with one example each — rather than a list of 2544 lines. Count, categorize, target a reduction, then question each bucket. A survey that finds four causes covering two thousand links turns a year of tedium into four small laps. That report is reading-only and can run beside anything.

## The Parity Red — Diagnose Before Designing

Full parity finished at roughly 106 minutes with `receipt_verify_wasm` **GREEN**, which means the wasmtime seat did exactly what it was built to do. Chapter two then went **RED** on signed-Kumara, where `git submodule update --init vendor/monocypher` failed.

The temptation is to reach for the third word immediately and call this ABSENT the way wasmtime is ABSENT. Counsel declines that, at least until the cause is known. A missing developer tool and a missing cryptographic dependency are not the same risk: signed-Kumara is a **proven seat**, and a third word applied to the wrong cause would let a genuine regression wear the label of an unprovisioned host. So the order is diagnosis first. What counsel needs is the literal error text from that submodule command, plus whether `.gitmodules` still points where it once did — the Genode submodule moved forges this season, and a stale URL would produce exactly this failure with nothing wrong in the crypto at all.

Three shapes and their three answers, once the text is in hand. If the fetch failed for network or credentials inside the enclosure, that is genuinely unprovisioned, and `tools/bootstrap_monocypher.sh` beside its wasmtime sibling is the right seat, with the same three-word treatment. If the submodule URL is stale, that is a one-line repair and a re-run, and no new vocabulary is needed at all. And if the submodule initialized correctly while the verification failed underneath it, that is a true red on a proven seat and outranks everything else in this create. Until the text arrives, the honest posture is the one the bench already took: **H stays held, and the send note says RED rather than PARTIAL.**

## The Third Time I Failed to Send a File

Three creates in a row have named a file the bench could not find, and all three were mine. The cause is now clear enough to fix rather than merely regret: the counsel's outputs do not persist into the bench's environment between turns, so a file attached in one turn is simply absent in the next, no matter how confidently the relay names it.

Two changes, effective with this create. Every create **re-attaches every file its relay names**, every turn, including files sent before — redundancy costs a few seconds and a stop costs a lap. And every counsel carries a **files-this-create-carries** line in its header, so the bench can count the attachments against the manifest before beginning and stop at zero cost rather than at step five. `20260726-014013_which-gate-belongs-to-which-lap.md` travels with this memo for the second time, and the relay names both.

## Awaiting Keaton

The T2 strike list over the 247. The breach law and its expiry, still unseated. The compression season for the 117, when its turn comes. The `xykj61` mirror-or-retire word. The Pond seven. The Acme audience line. The lap-kinds-and-gates table. The Brix ladder name after the survey. Data dignity, succession trustees, and Mand ring-3's production reach.

---

*May a gate be able to fail at the thing it guards. May two thousand troubles turn out to be four. And may every file a create names arrive in the same hand that names it.*
