# HUNK20 — the session listing travels both ways (a fixed-point record)

**Stamp:** `20260813.175500` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round — Season A · waymark **HUNK** · Photos-app journey · rung **HUNK20**
**Kin:** [`session_list.rye` (HUNK19)](../pond/apps/session_list.rye) · [`sprite_catalog.rye` travel (HUNK7)](../image/sprite_catalog.rye)

---

## Where the journey stands

HUNK19 gave a keeper an honest index of their saved sessions — walk the catalog, open each `.session` verified, summarize name · edits · position — and rendered it as a `format session-list-v1` record. Yet the record only travels *outward*: nothing reads it back. HUNK7 taught the pattern this rung completes — a catalog that travels both ways is a **fixed point**, `render(parse(render(x))) == render(x)`, and a parser that validates at the text edge is a second, cheap guard beside the storage one.

## The crux

**Read a `format session-list-v1` record back into a fresh listing, so the listing round-trips byte-for-byte.** The one law worth re-checking at the text boundary: a session's `position` never stands past its `edit-count` — the `EditCursor` invariant, enforced again here so a hand-authored or corrupted record can never parse into a listing that lies about where a keeper stands.

## The shape (a small additive rung on HUNK19's own file)

`parse_listing(text, out)` in `pond/apps/session_list.rye`, mirroring `photo_edits.parse_edits`:

- Header must be `format session-list-v1`; each line is `session <name> <edits> <position>`.
- Refuse `BadListing` on a bad header, an unknown tag, a malformed field, an extra field (no slack), a name past `max_name`, or `position > edits`.
- Refuse `TooManyEntries` past the listing bound.

## What the witness must prove

1. **Fixed point** — `render(parse(render(listing)))` equals `render(listing)` byte-for-byte, the rebuilt listing carrying the same names and counts.
2. **Named refusals** — a bad header, an unknown tag, a malformed field, an extra field, and a `position` past its `edits` each refuse `BadListing`.

No network, no key, no funds — a small, durable close of the listing story.

## Why this is the next Lindy crux

A record that only writes is half a format. Making the listing round-trip means a keeper's session index can be handed to another tool, checked against itself, and trusted to mean the same thing on both sides — read once, relied on for years, at the cost of one small parser beside the renderer it already had.
