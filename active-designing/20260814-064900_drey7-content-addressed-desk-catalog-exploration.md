# DREY7 — the content-addressed desk catalog *(exploration)*

**Stamp:** `20260814.064900` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Design capture — self-approved round, agent-doable crux
**Waymark:** DREY · Season A (Hardware & Right-to-Repair) · Mikrophone firmware journey · rung **DREY7**
**Kin:** [`../mikrophone/archive.rye`](../mikrophone/archive.rye) (DREY6) · [`../mikrophone/wire.rye`](../mikrophone/wire.rye) (DREY1) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) (Season A · Tablecloth content-addressing)

---

## Where the journey stands

Six rungs of the Mikrophone firmware are proven pure before metal: a session that
forgets (DREY0), a wire that carries only what was committed (DREY1), a record
button (DREY2), a firmware loop (DREY3), an inbox that keeps only the proven
(DREY4), a carry that meets device to desk (DREY5), and a desk archive that keeps a
bounded log of proven recordings in arrival order (DREY6).

The archive answers *"what did the desk receive, and in what order?"* It does not
yet answer the question a keeper asks next: *"do I already hold this exact
recording, and can I fetch it by name?"* A log addresses by position; a keeper
needs to address by **content**.

## The crux, Lindy-first

Content-addressing is the tree's own spine — Tablecloth keys every artifact by the
Sha256 of its bytes, so identical content has one identity and a fetch never
guesses. The Mikrophone wire already computes exactly that digest over every
payload it carries (`wire.rye`, `digest_len = 32`). The decisive, still-tractable
move for DREY7 is to let the desk **address recordings by that content digest**:
the same bytes always resolve to the same address, an identical recording deposited
twice is kept once, and any recording can be fetched by its address.

This is the highest-Lindy rung available on the journey — content-addressing is
read thousands of times over years and underpins provenance (Season 2, Journey 6),
the parts-marketplace sprite store (Season A), and Tablecloth itself. It opens the
rest: once the desk speaks content addresses, a manifest, a fetch-by-name serve
rung, and de-duplicated storage all follow from it.

## Why a new module, not a change to the archive

DREY6's `archive.rye` is committed and its selftest deposits the *same* frame
sixteen times to prove the entry bound — behavior a de-duplicating store would
collapse to one entry. Changing the archive in place would break that proof and
violate accrete-never-break. So DREY7 grows a **sibling**: `mikrophone/catalog.rye`,
the content-addressed desk, standing beside the arrival-order archive rather than
replacing it. A keeper's desk wants both a log (when it arrived) and a catalog
(what it is); the journey grows the second now.

## The shape

`mikrophone/catalog.rye` — a bounded, content-addressed store of proven recordings.

- **`Address`** — a 32-byte Sha256 over a recording's payload, the same digest the
  wire carries. Two recordings share an address exactly when they share every byte.
- **`Catalog`** — a packed byte store, its used length, a bounded index of
  `{ address, off, len }` entries, and a count. Fixed buffers, no heap outlives it.
- **`deposit(frame_bytes) -> Address`** — deframe verify-before-trust FIRST (so a
  corrupted or forgotten frame never lands, refusing by name), compute the content
  address over the *proven* payload, then:
  - if the catalog already holds that address, return it unchanged — **idempotent**,
    no duplicate stored, no bound spent;
  - otherwise append within both bounds (entry count and byte budget), refusing
    `CatalogFull` before a single byte passes a bound, and return the new address.
- **`fetch(address) -> ?[]const u8`** — the recording for a content address, or
  `null` when the catalog does not hold it. A fetch never guesses.
- **`holds(address) -> bool`** · **`count_of`** · **`address_at(i)`** — enumerate
  the catalog by position for a manifest, without reading every byte.
- **`clear`** — forget the whole store, zeroing it, so nothing once kept can be
  recovered — the forgetting promise held on the content-addressed hand too.

## The invariants this rung proves

1. **Same bytes, same address** — deposit the identical recording twice and the
   address returned is byte-for-byte equal; the count rises by one, not two.
2. **Different bytes, different address** — two distinct recordings resolve to two
   distinct addresses and both fetch back exactly.
3. **Verify-before-keep holds** — a tampered frame refuses `DigestMismatch` and the
   catalog stands exactly as it was; a bad frame neither lands nor disturbs a prior
   entry.
4. **Both bounds refuse by name** — a deposit past `max_entries` distinct
   recordings, or past `max_bytes`, refuses `CatalogFull` before a write.
5. **A miss is a miss, not a guess** — `fetch` of an address the catalog never held
   returns `null`.
6. **Clear forgets whole** — count nothing, store entirely zero.

## What stays out of scope (custody gate #2 · gate #3)

No disk, no network, no key signs, no funds. The content address is an **integrity
identity** the desk recomputes itself over proven bytes, not a signature — a signed
catalog is a later, gated rung. Real hardware, a real desk, a real disk remain
custody gate #2, untouched. This rung is proven pure in Rye before metal, exactly
as every DREY rung before it.

---

*May the desk know each recording by what it is, keep it once, and hand it back
whole to the keeper who asks by name.*
