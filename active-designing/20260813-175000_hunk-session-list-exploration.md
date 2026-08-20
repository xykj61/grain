# HUNK19 — a keeper lists their saved editing sessions (an honest index)

**Stamp:** `20260813.175000` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round — Season A (Hardware & Right-to-Repair) · waymark **HUNK** · Photos-app journey · rung **HUNK19**
**Kin:** [`session_store.rye` (HUNK18)](../pond/apps/session_store.rye) · [`tablecloth.rye`](../pond/apps/tablecloth.rye) · [`mcp_resource_list.rye`](../pond/apps/mcp_resource_list.rye)

---

## Where the journey stands

HUNK18 made an editing session a content-addressed artifact — a keeper stores a session and reopens it from cold, undo and redo intact. Yet a keeper who has stored several sessions has no way to *see what they have*: the catalog holds them, but nothing surfaces the list. This is the small, durable finish the persistence story asks for — store, reopen, and now **list**.

## The crux

**Walk the catalog and advertise every saved session as an honest summary — name, edit-count, and live position — each read from a verified reopen.** The honesty guarantee, borrowed from the tree's own `mcp_resource_list` pattern: a listing never names a session it cannot honestly reopen. If a stored session is tampered, the reopen refuses `DigestMismatch` and the whole listing refuses rather than advertising a phantom.

## The shape (composition only)

A new file `pond/apps/session_list.rye`:

- **`SessionSummary`** — a bounded record: the session's name (a slice into a fixed `[max_name]u8`), its edit-count, and its live position. No pixels, no recipe body — just what a keeper needs to choose.
- **`SessionListing`** — a bounded array of summaries (at most `tablecloth.max_artifacts`).
- **`list_sessions(cat, store)`** — walk `0..cat.count`, select every artifact whose name ends in `.session`, `open_session` each (HUNK18, verified before parse), and record its summary. A tampered session refuses through the open, so the listing is trustworthy as a whole or it names its failure.
- **`render_listing(listing, out)`** — the listing travels as a flat-Bron `format session-list-v1` record, one `session <name> <edits> <position>` line per entry, matching the tree's manifest idiom (fixed point with a future parser, deferred).

## What the witness must prove

1. **Exactly the sessions** — store two sessions and one non-session artifact (an image or edit-list); the listing names exactly the two sessions, in held order, skipping the non-session.
2. **True summaries** — each summary's edit-count and position equal the stored cursor's, and a session with a redo tail reports a position below its edit-count (a keeper can see it stands rewound).
3. **Honest as a whole** — a tampered session in the catalog makes `list_sessions` refuse `DigestMismatch` rather than advertising a session it cannot reopen.
4. **Travels as text** — the listing renders to a bounded `format session-list-v1` record.

No network, no key, no funds — pure composition over public APIs.

## Why this is the next Lindy crux

A keeper who cannot find their saved work does not really have saved work. Listing is read every time a keeper opens the app, for years — and it costs no new storage and no new pixels, only a walk over what is already held, every summary honest because every one is verified.
