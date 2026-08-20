# DREY8 — the desk manifest of holdings *(exploration)*

**Stamp:** `20260814.065231` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Design capture — self-approved round, agent-doable crux
**Waymark:** DREY · Season A (Hardware & Right-to-Repair) · Mikrophone firmware journey · rung **DREY8**
**Kin:** [`../mikrophone/catalog.rye`](../mikrophone/catalog.rye) (DREY7) · [`../mikrophone/wire.rye`](../mikrophone/wire.rye) (DREY1) · [`20260814-064900_drey7-content-addressed-desk-catalog-exploration.md`](20260814-064900_drey7-content-addressed-desk-catalog-exploration.md)

---

## Where the journey stands

DREY7 gave the desk a content-addressed catalog: every recording keyed by the
Sha256 of its payload, kept once, fetched by name. The desk now knows each
recording by what it *is*. It cannot yet **describe** what it holds to another
hand without shipping every byte of every payload.

## The crux, Lindy-first

Content-addressed sync — git's *have/want*, IPFS's *provider records* — begins with
one hand telling another *what it holds*, cheaply, by address alone. The desk that
can emit a compact **manifest of its holdings** lets a far hand compute exactly
which recordings it still needs before a single payload byte crosses. That is the
decisive, still-tractable next move, and it is high-Lindy: a manifest format read
by two hands for years is the seam a whole sync protocol later stands on.

DREY8 stays the **"have"** side only — purely descriptive, purely local, read-only.
It stops deliberately short of *serving* the payloads a far hand wants; that serve
rung reaches the **Comlink-served custody gate** (Season 1, Journey 2) and waits
for the maintainer's word. Describing holdings crosses no gate.

## The shape

`mikrophone/manifest.rye` — a bounded, self-describing, verify-before-trust
manifest of a catalog's holdings, built with the exact discipline of DREY1's wire.

- **Layout** — `magic("MMAN") · version(1) · count(u32) · digest(32) · records`,
  where each record is `address(32) · len(u32)`. The digest is a Sha256 over the
  record region, so a single flipped byte in any address or length fails the check.
- **`write_manifest(catalog, out)`** — emit the manifest for a catalog: one record
  per kept recording, in first-deposit order, carrying its content address and
  payload length. No payload bytes travel — only addresses and lengths.
- **`verify(bytes) -> records`** — prove the manifest whole BEFORE any record is
  read: too short for a header, wrong magic, wrong version, a count past the entry
  bound, a truncated tail, and finally a digest that must match — every check runs
  in order and refuses by name, exactly as `wire.deframe` does.
- **`count_in(records)` · `address_in(records, i)` · `len_in(records, i)`** — read a
  verified record region by position, so a far hand enumerates holdings without a
  byte of payload.
- **`wanted(local_catalog, records, i) -> bool`** — the have/want primitive: whether
  the i-th advertised address is one the local catalog does *not* already hold.

## The invariants this rung proves

1. **Round-trip is exact** — a catalog's manifest verifies and reads back the same
   count, and each advertised address and length equals the catalog's own.
2. **No payload travels** — the manifest's whole size is `header + count·36`,
   independent of how large the recordings are.
3. **Verify-before-read holds** — every corruption (short, bad magic, bad version,
   count overflow, truncation, a flipped record byte) refuses by name before a
   record is yielded.
4. **have/want is honest** — a far hand holding a subset finds exactly the missing
   addresses `wanted`, and holds none it already has.
5. **Bounded** — the manifest never outgrows `max_manifest`, fixed by the catalog's
   own entry ceiling.

## What stays out of scope (custody gate #2 · Comlink-served gate)

No disk, no network, no key signs, no funds. The manifest is described and verified
in memory; *serving* the wanted payloads to a far hand over a real transport is the
gated rung that follows. The digest is an integrity identity, not a signature. Real
hardware stays custody gate #2; the served constellation reaches the Comlink-served
gate — both untouched, this rung proven pure in Rye before metal.

---

*May the desk say plainly what it holds, so a far hand asks only for what it lacks,
and not one byte crosses that a keeper did not need.*
