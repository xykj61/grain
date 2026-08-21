# HUNK29 — the whole filter family joins the edit-list: hue, blur, sharpen, auto-levels, edges

**Stamp:** `20260813.181110` · **Status:** Mixed -- Self-approved design round (agent-doable, no gate) · **Voice:** Kyri · **Style:** Radiant
**Waymark:** **HUNK** (Season A, Photos-app journey; seated in [`../.claude/rules/waymark-ladders.md`](../.claude/rules/waymark-ladders.md))
**Road:** [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) — **Season A, Hardware & Right-to-Repair**
**Builds on:** [`20260813-180504_hunk-photos-saturate-edit-exploration.md`](20260813-180504_hunk-photos-saturate-edit-exploration.md) — HUNK28, the first filter joined
**Kin:** [`Lindy-first, crux-first`](../.claude/rules/lindy-first-crux.md) · [`image/photo_edits.rye`](../image/photo_edits.rye) · [`image/photos.rye`](../image/photos.rye)

---

## Why this round, now

HUNK28 seated the first filter — `saturate` — into the non-destructive edit-list, and proved the pattern: a filter recorded as an edit inherits undo/redo, cold-restart persistence, and travel-as-text for free. That rung named the rest of the family as its next intent. This round **finishes the vocabulary**: every remaining verb the Photos app can do — `hue_turn`, `blur`, `sharpen`, `stretch` (auto-levels), and `edges` — joins the grammar, so the edit-list becomes the one home for the *whole* Photos gesture set. After this rung, nothing the app does is a wound.

Reading Lindy-first, crux-first: this is a single cohesive keystone (complete the grammar), not five scattered ones, because each verb is the identical additive shape HUNK28 already proved — a variant, an `apply` arm, a `render`/`parse` line — and the value they unlock (a fully recordable, replayable, travelling edit history) arrives only when the *last* verb joins.

## The crux

> **The edit-list names every verb the Photos app can do — no gesture is destructive, every edit travels as text a person can read.**

Two field shapes cover the family, both already proven: `hue_turn` takes one `u32` `thirds` (like `rotate`'s `turns`); `blur`, `sharpen`, `stretch`, `edges` are **nullary** (like `flip_h`). No new field kind, no new error.

## The opening rung — HUNK29

`image/photo_edits.rye` grows by five variants:

- **`EditKind`** gains `hue_turn`, `blur`, `sharpen`, `stretch`, `edges`.
- **`Edit`** gains `hue_turn: struct { thirds: u32 }` and four `void` variants.
- **`apply`** gains five arms delegating to `photos.hue_turn`/`blur`/`sharpen`/`stretch`/`edges`.
- **`render_edits`** gains `"hue_turn {d}\n"` and four bare-tag lines (`"blur\n"`, etc.).
- **`parse_edits`** gains five tag arms.

One care: the current selftest uses `"sharpen 3"` as its *unknown-verb* refusal case — once `sharpen` is a real (nullary) verb, that line would instead refuse as an *extra field*. The test moves to a genuinely-unknown tag (`vignette`) so the unknown-verb path stays proven.

## The algebra it must obey

- **Composition.** An edit-list `hue_turn → blur` (and each new verb) equals the same verbs called by hand, **byte-for-byte**.
- **Travel.** A list carrying **every** verb kind renders, parses back, and `render(parse(render(x)))` is the **same fixed point**; the rebuilt list applies to the same bytes.
- **Folded refusal.** A degenerate-source `edges` in a list surfaces its own `EmptyImage` through `apply` by name — no new error.
- **Non-destructive still holds.** The source stays pure; the empty list recovers it; every earlier verb still composes.

## Where this quest goes next (named intent, not yet built)

- **A dedicated general filter round-trip witness** (`tools/hunk_edit_family_witness.rish`) proving every verb kind travels — the vocabulary made a standalone claim.
- The completed edit-list is the natural substrate for **named filter presets** (a saved list a keeper applies by name) and for the marketplace's **product thumbnails** (a stored sheet plus a bounded edit-list per view).

## Discipline this round keeps

- **Two rooms.** The crux is a green witness or it stays named intent.
- **Reuse, never re-invent.** Every filter is HUNK21–27's own verb; the grammar is HUNK11's value model; no new codec, storage, or error.
- **Bounds, widths, asserts.** `u32` fields checked at each verb's own edge; the record's line bound named at construction; positive invariants (TAME).
- **Gates stay the fence.** No funds, keys, provisioning, or network — purely additive grammar variants. No breach, no cairn.

*May every gesture the picture receives leave the picture whole, and travel on as words anyone can read.*
