# Resins and Hash Tiers -- Archive and Digest Law

*Two vocabulary choices prepared for the archive-verdict ratification: **resins** as the content-addressed unit Amber seals, and a **two-tier SHA3 policy** so forever-names and working-store names each carry the width their promise deserves.*

**Stamp:** `20260703.191112`
**Language:** EN
**Style:** Gauge (see `../GAUGE_STYLE.md`)
**Lens:** TAME -- safety first, performance second, the joy of the craft third
**Status:** Ratified (`20260703.191312 UDT`) -- Kaeden affirmed **for**; lap-1 export paths renamed to **`resins/`** at hygiene `20260706.235812` (golden manifest digest unchanged).
**Ground:** [`20260701-221512_cellar-functional-spec.md`](20260701-221512_cellar-functional-spec.md) - [`20260702-035018_puddle-sandboxed-rye-containers.md`](../../external-research/20260702-035018_puddle-sandboxed-rye-containers.md) - [`../../external-research/yonder/20260617-195312_mantra.md`](../../external-research/yonder/20260617-195312_mantra.md) - [`../active-designing/20260703-140212_the-bench.md`](../../active-designing/20260703-140212_the-bench.md)
**Companions:** kitchen twin [`external-research/20260709-235931_resins-cellar-vessel-plainly.md`](../../external-research/20260709-235931_resins-cellar-vessel-plainly.md)

Radiant pass `20260725.035645`

---

## Amber and the resin

**Amber** is **cellar software** -- the module and the discipline that seals a moment cold **in place** at home. A **resin** is one content-addressed unit at grain size: the stored bytes at a SHA3 name, cut at a content-defined boundary, listed in a Kumara-signed `.bron` manifest.

**Amphora** is **vessel software** -- the sealed container that carries resins (and other signed cargo) **in motion** across a crossing; it leaves the cellar under Amber's seal law and may return to a second dock for a cold scrub.

The manifest **catalogs**; it does not wrap the payload in an opaque bag. Each resin **is** the matter. The digest **is** the address and the proof -- not a separate checksum file that could drift from the bytes it names. Compression, when a lap adopts it, transforms the resin's bytes; the digest names **what is stored**. Tar and zip remain **transport only** -- never the trust boundary.

Lap one exports under **`resins/`** and pins `openssl dgst -sha3-256` as the independent host oracle. Path and word now align at ring one.

---

## The two-tier SHA3 policy

One hash family, two widths -- chosen by the **promise the name makes**, not by habit.

| Tier | Algorithm | Promise | Examples |
|------|-----------|---------|----------|
| **Canonical** | **SHA3-512** | This name must mean one thing for as long as the work endures | Mantra weave states, sealed message content identity, Aurora stage names, long-lived weave facts |
| **Working** | **SHA3-256** | High-volume store units, bead filenames, hosts that pin an external oracle | Amber resins, Tablecloth blobs, manifest entry digests in lap one, Comlink refs where path size matters |

SHA3-256 already carries collision resistance beyond any feasible reach at project scale. SHA3-512 is the **wider margin** where the promise is forever -- not a fix for a weakness in working-tier resins.

When both tiers appear in one log or on one wire, every digest carries an **algorithm tag** so eras verify side by side. That tag is horizon on TASKS; this policy names the intent today.

---

### Amendment `20260906.192644` -- and where SHA-256 is the right answer

The two tiers above govern **what this tree seals for itself**, and they are obeyed: the waymark
registry is SHA3-512, and `crypto/sha3_digest.rye` computes both tiers over authored Keccak so no
external binary is needed -- written after `openssl` was pinned and found absent, and after
`sha256sum` was nearly substituted for it. That substitution would have silently rewritten every
content address in the tree, since SHA-2 is a different algorithm rather than a second spelling of
SHA3.

**SHA-256 stays wherever an outside party fixes the choice**, and three named classes carry that,
each for its own reason:

| Class | Why the algorithm is not ours to pick | Standing example |
|---|---|---|
| **Protocol** | an external specification names SHA-256 in its own definition | Bitcoin addresses, BIP39, base58check |
| **Vendor checksum** | a publisher's number must be verified in the publisher's algorithm | toolchain fetches |
| **Coreutils-verifiable record** | a keeper holding only coreutils can still check it -- *two tools, one answer* | `mycelium/warrant_true.rye`, the GISM provenance receipts |

Reaching for SHA3 in any of those would make a record **less** checkable, and a seal exists to make
a record more so.

**The open question was always the other one:** whether a recorded digest is ever compared against
the bytes it claims to describe. A seal nothing reads is prose, and prose goes false in silence. `tools/s/sealed_digest_witness.rish` over `tools/fixtures/s/sealed_digest_scan.sh` holds
that at **zero unread**, reading past dated testimony, a bare fingerprint, and an outside
publisher's quoted value. That last exclusion is earned: a guard demanding a checker for someone
else's number would be asking for a physical device inside a witness, which is exactly what the
GrapheneOS boot hash in `two-dev-environments-and-mobile-emulation.md` is. Measured at seating: **4 seals, 0
unread**, proven on nine planted cases in a throwaway repository.

## Refusal and availability

A store may decline to hold a resin. The **resin-refusal fact** (today recorded as resin-refusal in TASKS) gives the no its receipt without describing the refused. Availability remains a fold-choice: peers serve resins; receivers verify the digest; the home rack is root of authorship, never sole servant of popularity.

---

## What ratification seated

Kaeden affirmed **for** (`20260703.191312 UDT`). Agents cite this spec as standing law for archive units and digest tiers. Path rename to `resins/` landed at `20260706.235812`; golden manifest digest unchanged.

---

*May every resin be the bytes it claims. May forever-names wear the wider hash. And may the manifest order what the seal already proved.*
