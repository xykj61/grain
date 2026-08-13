# HUNK28 — the filter family joins the edit-list: `saturate` records as a non-destructive edit

**Stamp:** `20260813.180504` · **Status:** Self-approved design round (agent-doable, no gate) · **Voice:** Kyri · **Style:** Radiant
**Waymark:** **HUNK** (Season A, Photos-app journey; seated in [`../.claude/rules/waymark-ladders.md`](../.claude/rules/waymark-ladders.md))
**Road:** [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) — **Season A, Hardware & Right-to-Repair**
**Builds on:** [`20260813-155719_hunk-photo-edits-non-destructive-exploration.md`](20260813-155719_hunk-photo-edits-non-destructive-exploration.md) — the non-destructive edit-list (HUNK11)
**Kin:** [`Lindy-first, crux-first`](../.claude/rules/lindy-first-crux.md) · [`image/photo_edits.rye`](../image/photo_edits.rye) · [`image/photos.rye`](../image/photos.rye) (`saturate`, HUNK21)

---

## Why this round, now

Two halves of the Photos app grew apart. HUNK11 built the **non-destructive edit-list** — verbs recorded *as data*, replayed over an untouched source, undoable (HUNK16), session-persistable (HUNK18), travelling as a `format photo-edits-v1` record a person can read. Beside it, HUNK21–HUNK27 grew a whole **filter family** — saturate, hue-turn, bilinear resample, convolve, auto-levels, edges — each a pure verb over an open image.

Yet the edit-list grammar still names only the *six original* verbs: crop, flip_h, flip_v, rotate, scale, adjust. Every filter the app learned since is a wound the moment a keeper applies it — it overwrites, rather than riding alongside as replayable data. Reading the road **Lindy-first, crux-first**, the durable, fully agent-doable, ungated crux is not a twenty-eighth filter — it is to **close that gap**, so a filter is a first-class non-destructive edit like a crop.

This is the higher-Lindy move: once the edit-list carries a filter, that filter inherits undo/redo, cold-restart persistence, and travel-as-text *for free* — the machinery the whole quest already built. One rung, and the two halves are one.

## The crux

> **A tone filter is recorded, replayed, and travelled exactly like a crop — the edit-list is the one home for every verb the app can do, destructive of nothing.**

`saturate` is the right first filter to seat, because it is the paired twin of `adjust` already in the grammar: light and saturation are the two tone sliders every Photos app puts side by side. It takes the same `num`/`den` ratio shape `adjust` already parses, so it joins the value model without inventing a new field kind — the cleanest possible proof that the pattern generalizes.

## The opening rung — HUNK28

`image/photo_edits.rye` grows by one variant, no new failure mode:

- **`EditKind`** gains `saturate`; **`Edit`** gains `saturate: struct { num: u32, den: u32 }`.
- **`apply`** gains one arm: `.saturate => |s| try photos.saturate(allocator, &cur, s.num, s.den)` — a filter's own refusal (`BadSaturation`, `EmptyImage`) surfaces by its own name through the fold, exactly as an out-of-bounds crop surfaces `OutOfBounds`. The edit-list adds no failure mode; it sequences a proven one.
- **`render_edits`** gains `"saturate {d} {d}\n"` — 21 bytes at the ceiling `saturate 65536 65536`, well inside the 48-byte per-line bound.
- **`parse_edits`** gains a `saturate` arm reading two `u32` fields with `no_slack`, so the record round-trips.

## The algebra it must obey

The selftest proves the join by facts it cannot escape:

- **Composition.** An edit-list `crop → saturate` equals `photos.crop` then `photos.saturate` called by hand, **byte-for-byte** — a filter replays like any verb.
- **Travel.** A list carrying `saturate` renders, parses back, and `render(parse(render(x)))` stays the **same fixed point**; the rebuilt list applies to the same bytes.
- **Its own refusal folds through.** A list holding `saturate <n> 0` (a zero denominator) refuses **`BadSaturation`** through `apply` — the verb's own name, not a new one.
- **Non-destructive still holds.** The source stays pure; the empty list still recovers it byte-for-byte; every earlier verb still composes.

## Where this quest goes next (named intent, not yet built)

- **HUNK29 — `hue_turn` joins** (one `u32` `thirds` field), then the **nullary filters** (`blur`, `sharpen`, `stretch`, `edges`) join together — each a `void` variant like `flip_h`. After these, the edit-list carries the *whole* Photos vocabulary.
- **A general filter round-trip witness** proving every verb kind travels once the family is complete.

## Discipline this round keeps

- **Two rooms.** The crux is a green witness or it stays named intent — HUNK29+ above is intent, not settled fact.
- **Reuse, never re-invent.** The filter is HUNK21's `photos.saturate`; the grammar is HUNK11's own value model; no new codec, no new storage, no new error.
- **Bounds, widths, asserts.** `u32` fields checked at the verb's own edge; the record's line bound named at construction; positive invariants (TAME).
- **Gates stay the fence.** No funds, keys, provisioning, or network — a purely additive grammar variant. No breach, no cairn.

*May the light and the color travel side by side, and may no edit ever wound the picture it means to help.*
