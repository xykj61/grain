# HUNK34 — a keeper lists their installed preset books, an honest index

**Stamp:** `20260813.184007` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- self-approved design round · **Season A** (Hardware & Right-to-Repair) · **waymark HUNK** · Photos-app journey · rung **HUNK34**
**Kin:** [`../pond/apps/preset_store.rye`](../pond/apps/preset_store.rye) (HUNK32) · [`../pond/apps/session_list.rye`](../pond/apps/session_list.rye) (HUNK19/20) · [`../image/filter_preset.rye`](../image/filter_preset.rye) (HUNK30)

## Where the road stands

HUNK32 banked a curated filter book content-addressed — store a book, reopen it whole from cold out of its name. HUNK19/20 gave the keeper the *index* over the sibling surface: list every saved editing session with an honest summary, travelling both ways as text. The preset store has no such index yet: a keeper who has installed several filter books cannot see what they hold.

By Lindy-first, crux-first, that index is the crux. A keeper installs filter packs the way they save sessions, and the daily question is the same — *what do I have, and how much is in each?* The listing is read far more often than any single store, so the effort compounds; and it reuses a proven idiom exactly rather than inventing a new one.

## The keystone (HUNK34)

`pond/apps/preset_list.rye`, mirroring `session_list` seam-for-seam over the preset store:

- `list_books(cat, store, out)` — walk the catalog, select every artifact whose name ends in `.presets`, and `open_book` each **verified** (HUNK32 — every bead proven against its digest and the whole against its recorded address before parse), recording a bounded `BookSummary` (name + preset count). The honesty guarantee borrowed from `session_list`: a listing never names a book it cannot honestly reopen, so a tampered book makes the *whole* listing refuse `DigestMismatch` rather than advertise a phantom.
- `render_listing` / `parse_listing` — the listing travels both ways as a `format preset-list-v1` record, one `book <name> <presets>` line per entry, so `render(parse(render(x)))` is a fixed point (HUNK7's idiom). A bad header, an unknown tag, a malformed field, an extra field, or a preset count past `filter_preset.max_presets` each refuse `BadListing` — the book's own ceiling enforced again at the text edge; more than `max_summaries` lines refuse `TooManyEntries`.

## The properties the witness proves

1. **Lists exactly the installed books** — two `.presets` artifacts and one non-preset artifact in the catalog list to exactly the two books in held order, the non-preset skipped and never opened as a book.
2. **True summaries** — each book's preset count read from a verified reopen (the stock book reports its nine presets).
3. **Travels both ways** — the listing renders to a bounded record and parses back to the same names and counts, a fixed point.
4. **Refusals named** — a bad header / tag / field / extra field / over-ceiling count refuse `BadListing`; too many entries `TooManyEntries`.
5. **Honest as a whole** — a tampered book makes the whole listing refuse `DigestMismatch`.

No network, no key, no funds — a listing reads the catalog, stores nothing.

## Horizons (named, not half-built)

- A richer summary line carrying each book's preset *names* (a nested field over the same grammar).
- The Skate view of the index (compose HUNK2's down-map or a plain text panel).
- The served index — a Comlink-served listing of a keeper's installed books (stops at the Comlink-served custody gate).
