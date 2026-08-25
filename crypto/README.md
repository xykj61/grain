# crypto -- a cryptography library written in the open, and checked against the world

**Language:** EN - **Voice:** Kyri - **Style:** Gauge, Door setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Status:** Checkable -- **87 modules** stand here on `20260824.095920`, and every one carries a row in [`MODULES.md`](MODULES.md).
**Where this sits:** home is [`../README.md`](../README.md) - a first hour in your hands is
[`../docs-geode/tutorials/the-first-hour.md`](../docs-geode/tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../SOURCE.md`](../SOURCE.md)

Grain will face a security audit one day. Building our own cryptography in the open -- bounded,
asserted, and checked byte for byte against published answers -- is how we mean to earn it.

Every primitive here is written in **Rye**, this tree's own systems language. Every one stands on its own arithmetic rather than on `std.crypto`. Each is proven against two independent things at once: the known answer published in
its RFC or FIPS standard, which anyone can look up, and a second real implementation that arrived
at the same bytes without seeing our code.

## What you get from this directory

A hand placing trust in Grain can read exactly what it does. That is the whole aim, and it is why
the mathematics is written out rather than called into.

The library serves every part of Grain that will sign, verify, agree a key, or seal a message:
**Kumara** identity, **Vault** sealed storage, **Comlink** sessions, and the **Lotus** signed carry.

## Where to read next

| Page | What it answers |
|---|---|
| [`MODULES.md`](MODULES.md) | *What is here* -- all 87 modules in fifteen families, each sentence from that module's own head comment |
| [`LADDER.md`](LADDER.md) | *What had to come first* -- the rungs in dependency order, each with the published standard it was checked against |
| [`PARITY.md`](PARITY.md) | *What it was checked against* -- the seventeen Monocypher parity rungs, the open timing horizon, and where the custody gate stands |
| [`CONSTANT_TIME.md`](CONSTANT_TIME.md) | *Which files touch a secret* -- the timing-safety posture, gathered for an auditor |

## The two counts, and why they differ

Eighty-seven modules stand in this directory. The primitive suite proves **81** of them, and the
gap is worth a sentence rather than a footnote.

Five of the 87 are **seam symlinks** whose code lives in [`../encoding/`](../encoding/). Rye
resolves a nested import relative to the importing file's own directory, so a composition here
reaches an encoding module through a link that stands beside it. One more, `sha3_digest.rye`, is a
command-line program rather than a primitive: it prints a hex digest where the suite looks for a
`GREEN` line, so its proof comes from
[`../tools/s/sha3_file_witness.rish`](../tools/s/sha3_file_witness.rish) against the published
FIPS 202 answers.

Both numbers are computed rather than typed.
[`../tools/cr/crypto_count_guard_witness.rish`](../tools/cr/crypto_count_guard_witness.rish)
prints them from the tree on every run, which is what keeps a page like this one honest as the
library grows.

## Proving it

Every primitive carries a per-file witness in [`../tools/cr/`](../tools/cr/) named
`crypto_<name>_witness.rish`, which builds `crypto/<name>.rye` fresh to the gitignored
`crypto/bin/` and reads its `GREEN crypto-<name>` line against the standard's own answer and
against Zig's independent `std.crypto`.

To re-prove the whole library with one command:

```
rishi/bin/rishi run tools/cr/crypto_suite_witness.rish
```

That runs every per-file witness in the dependency order [`LADDER.md`](LADDER.md) describes,
rebuilding each from source, and names the exact file the moment one goes RED. A green
suite means every claim here is re-provable by tooling rather than trusted from a commit message.

## What stays a hand's work

Every witness in this library runs over **test** keys and published vectors, start to finish on one
machine. Signing a record with a keeper's own identity key stays a **custody gate**: the library
builds and verifies, and the key stays in its keeper's hand.

## Studied, never copied

[`Monocypher`](../vendor/monocypher) (CC0 and BSD dual-licensed, vendored unmodified) is the parity
*target* we read through its public API and the RFC vectors. Every line here is ours. The
clean-room discipline that governs this is written down at
[`../.claude/rules/gratitude-licenses.md`](../.claude/rules/gratitude-licenses.md).

---

*May this crypto, written in the open and checked against the world, be worthy of the trust a hand
places in it -- and may every keeper who reaches for it find a door they can read all the way down.*
