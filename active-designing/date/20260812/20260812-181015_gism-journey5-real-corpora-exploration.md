# GISM Journey 5 — Real Corpora (Season 2, Yield): exploration

**Stamp:** `20260812.181015` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Waymark:** **GISM** (`harvest-season-equinox-1-yield`, already seated — `.claude/rules/waymark-ladders.md`)
**Itinerary journey:** Season 2 — Yield · **Journey 5 — Real corpora**
**Status:** Mixed -- Self-approved design round — opens Season 2 of the 1,024-round itinerary
**Kin:** [`20260812-171050_the-1024-round-itinerary.md`](20260812-171050_the-1024-round-itinerary.md) · [`../.claude/rules/reds-first.md`](../.claude/rules/reds-first.md) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md) · [`../work-in-progress/REDS.md`](../work-in-progress/REDS.md)

---

## Where the road stands

Season 1 — The World (TACT) — carried every agent-doable journey to its edge: Ship-Pilot whole (J1), Publishing and Commerce complete to their custody gates (J2, J4), Grainphone waiting on served hardware (J3). The remaining TACT rungs all reach a keeper's-hand gate — a served Pond, a funds rail, a Kumara instance. So the next durable crux on the *whole* 1,024-round road is the first journey of Season 2, **Yield**.

Yield's durable promise is plain: *every module the tree built stands on real data, not a demo catalog.* Journey 5 takes the first bite — the voices that read (Scribble, Ember, the graph reader) have only ever read **hand-tuned demo literals**: `reading_query.rye`'s `pinned_doc`, a markdown slice written to sit comfortably inside every Scribble bound. A demo literal proves the wiring; it never proves the reader survives contact with a document a person actually wrote.

## The crux

**A voice reads a real tree document end to end, and every bound the real bytes exceed is booked as a red and closed on metal.**

Real data is the honest adversary a demo literal is written to avoid. The measurements already prove the collision, before a line of new code:

| Bound (`scribble/scribble_core.rye`) | Demo `pinned_doc` | A real tree doc |
|---|---|---|
| `max_doc_bytes` = 8192 | ~180 B — trivially inside | `README.md` is **16764 B** — more than double |
| `max_block_text` = 512 | one short line per block | a run of consecutive bullet lines joins into one paragraph block far past 512 |
| `max_blocks` = 32 | 9 blocks | a real reference doc carries many more |
| `max_headings` = 16 | 3 headings | a real doc's outline overruns |

The demo was tuned to fit; the real bytes will not. That is not a failure to prevent — it is the **Yield red the journey exists to surface**. A bound that was only ever exercised by a literal written to respect it has never truly been proven; the first real corpus is what proves or breaks it.

## The honest substrate — no network crosses

A real corpus does **not** mean a network fetch. That seam is the held gate (BUHR J5's real-network-fetch rung waits on the maintainer's word), and it stays held here. Instead the round binds a real tree file at **compile time** with `@embedFile` — the idiom already lived-with in `mandate/store.rye` (`@embedFile("dim.profile.bron")`). Compile-time embedding gives real bytes with a demo's determinism: reproducible, no runtime filesystem, no network, the same reading every build. The corpus is real; the reading stays a pure fold over known bytes.

## The four rounds (filled, not invented)

- **GISM-J5r1 — the first real read, reds booked.** Carry the reading voice (`reading_query`'s Lantern-contracted Scribble read) onto a **real embedded tree document** in place of `pinned_doc`. Let the real bytes surface whichever bound they exceed, book each as a REDS row, and close the round on a witness GREEN over the real corpus — raising the demo-tuned bound honestly (named reason, `// invariant:` on the new limit) where the real data earns it. The keystone: *the reading voice stands on a document a person actually wrote.*
- **GISM-J5r2 — more voices, same real corpus.** Carry Ember (corpus catalog) and the graph reader onto real embedded corpora too, so every reading voice that answered over a demo now answers over real bytes; book the reds each real corpus surfaces.
- **GISM-J5r3 — a corpus set, not a single file.** Prove the reader over a small **set** of real tree documents (a manifest of embedded corpora), so the voices read the tree's own writing as a body, not one lucky file — the bounds proven against the largest real member.
- **GISM-J5r4 — the reading is true to the bytes.** Close the journey by binding the reading to the corpus it claims: a witness that the outline, fence-count, and word-count a voice reports match what the real document actually contains, so a voice can never drift from the corpus a reader can open and check.

Each round is one keystone, witnessed on metal, sent as its own signed increment. The serve/network seams stay the maintainer's hand; everything here is agent-doable.

## What this round retires — nothing

`reading_query.rye` and its demo `pinned_doc` stay their own GREEN binary; the real-corpus reader stands **beside** it, additive, double-seated exactly as every BUHR rung stood beside the last. The demo literal keeps proving the wiring in isolation; the real corpus proves the reader survives real data. Accrete, never break.

---

*May the first real bytes find every bound honestly, may each red they raise be booked the moment it shows, and may the voices read the tree's own writing as truly as a keeper reads it over their shoulder.*
