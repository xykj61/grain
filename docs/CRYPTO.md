# Crypto -- the Season G audit front door

**Language:** EN - **Voice:** Kyri - **Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Status:** Checkable -- Season G operator and auditor guide
**Depth:** guide
**Ceiling:** <=150 lines
**Last updated:** `20260824.121500` -- compressed to route rather than recite, after this page's
rung table measured as a subset copy of [`crypto/MODULES.md`](../crypto/MODULES.md): 80 modules
named here against 87 standing in the directory (REDS %195)
**Compresses:** [`crypto/README.md`](../crypto/README.md) - [`crypto/MODULES.md`](../crypto/MODULES.md) - [`crypto/LADDER.md`](../crypto/LADDER.md) - [`crypto/PARITY.md`](../crypto/PARITY.md) - [`crypto/CONSTANT_TIME.md`](../crypto/CONSTANT_TIME.md) - [`20260815-175524_rye-first-crypto-parity-and-the-decision-wave.md`](../active-designing/date/20260815/20260815-175524_rye-first-crypto-parity-and-the-decision-wave.md) - the Season G session logs (raw beneath)

---

## Thesis -- cryptography written in the open, checked against the world

Grain will face a security audit, and building our own cryptography in the open --
disciplined, bounded, and parity-checked against published references -- is the honest way
to earn it. Every primitive in [`crypto/`](../crypto/) is authored in pure **Rye**, calls
**no `std.crypto`**, and is proven **byte-for-byte** against both a public RFC known-answer
and Zig's own independent `std.crypto`. The library serves every module that will ever sign,
verify, agree a key, or seal a message: **Kumara** identity, **Vault** sealed storage,
**Comlink** sessions, and the **Lotus** signed carry.

**Rye-first, the priority spine:** the mathematics lands in green-witnessed Rye, and any Glow
surface stands on that witness rather than ahead of it.

**Clean-room:** [`Monocypher`](../vendor/monocypher) (CC0/BSD-dual, vendored, unmodified) is the
parity *target*, studied through its public API and the RFC vectors rather than copied
([`gratitude-licenses.md`](../.claude/rules/gratitude-licenses.md)).

---

## Where the record lives -- this page routes, the directory holds

This is the **compression shelf**, and its law is written at the top of
[`README.md`](README.md): pages here distill, hold no load-bearing pins, and leave the raw record
standing beneath them. So the rung-by-rung account lives in `crypto/`, beside the code, where a
standing guard holds each page to the directory it describes.

| Question an auditor asks | The page that answers it | What keeps it true |
|---|---|---|
| What is in this library? | [`crypto/MODULES.md`](../crypto/MODULES.md) -- one row per module, in families | [`crypto_module_roster_witness.rish`](../tools/cr/crypto_module_roster_witness.rish) holds every row to the directory |
| Why is it in this order? | [`crypto/LADDER.md`](../crypto/LADDER.md) -- each rung's reasoning, in dependency order | the suite runs the rungs in that order and names the first RED |
| What was it checked against? | [`crypto/PARITY.md`](../crypto/PARITY.md) -- the vendored-Monocypher parity record | [`crypto_vendored_parity_suite.rish`](../tools/cr/crypto_vendored_parity_suite.rish) compiles the vendor fresh and diffs bytes |
| What is *not* yet proven? | [`crypto/CONSTANT_TIME.md`](../crypto/CONSTANT_TIME.md) -- every file's posture toward a secret | a reading, kept honest by naming the horizon rather than claiming a measurement |
| How many modules, and how many proven? | [`crypto_count_guard_witness.rish`](../tools/cr/crypto_count_guard_witness.rish) | a bijection between files on disk and witnesses the suite registers; it prints both counts |

**No count is typed on this page,** and that is deliberate. This page carried a table of 80
modules while 87 stood in the directory, and a subset copy of a roster goes short more quietly
than a short roster does -- a reader sees rows rather than the set they were drawn from. The
count guard computes both numbers on demand (REDS %80, %105, %191, %195).

---

## Proving it -- one command greens the whole library

```bash
rishi/bin/rishi run tools/cr/crypto_suite_witness.rish
```

[`crypto_suite_witness.rish`](../tools/cr/crypto_suite_witness.rish) rebuilds each
`crypto/<name>.rye` fresh from source into the gitignored `crypto/bin/`, runs every per-file
witness in dependency order, and names the exact file the moment one goes RED. A GREEN suite
means every claim here is re-provable by tooling rather than trusted from a commit message --
measurement beats memory. It then runs the count guard above.

To prove one rung alone, run its witness:

```bash
rishi/bin/rishi run tools/cr/crypto_ed25519_sign_witness.rish
rishi/bin/rishi run tools/cr/crypto_vault_seal_witness.rish
```

Each witness asserts its `GREEN crypto-<name>` line against the RFC known-answer **and** a
cross-check against Zig's independent `std.crypto`, so parity is proven against two witnesses
at once: the published vector, and a second implementation that reached the same bytes without
seeing our code.

---

## Constant-time posture -- a scoped horizon, named honestly

Correctness is settled; **timing-safety is a scoped horizon rather than a settled claim.** A
timing claim is a measurement, and this library claims no measurement yet.
[`crypto/CONSTANT_TIME.md`](../crypto/CONSTANT_TIME.md) draws the full map, file by file, with
line citations. In one screen, every primitive sits in exactly one posture toward a secret:

- **public-only** -- reads only public values (verify, decode, the group law, the
  Edwards<->Montgomery conversion of a *public* key). Variable time here leaks no secret,
  because the operation holds none.
- **data-independent by construction** -- touches a secret, and keeps control flow and memory
  access fixed regardless of its value: the ChaCha/Poly arithmetic, the AEAD tag compare
  (which accumulates the byte difference and tests once), the `fe25519` reduction and inversion
  ladder, and **X25519's Montgomery ladder** (a fixed step count with a branchless masked
  conditional swap). This is the strongest posture pure Rye asserts without a measurement, and
  it still awaits one, since a compiler may undo branchless source.
- **deliberately variable-time** -- `ed25519_scalarmul.rye` (double-and-add branches on the
  secret scalar's bits) and `ed25519_sign.rye`, which composes it. Correct and parity-GREEN,
  and **timing-safe only once measured** -- named here rather than hidden, and the sharpest
  horizon in the library. A future measurement round puts these on metal before any timing
  claim is earned.

---

## The custody gate -- the library builds and verifies; it never holds a key

Every witness runs over **test** keys and the RFC's public vectors: no real identity key, no
network, no funds, no real device. Signing a record, or agreeing a session, with the
maintainer's **own** identity key stays a **custody gate** (gate %3 / %4) -- the agent builds
and proves the mathematics, and the key stays Keaton's hand. `ed25519_sign.rye`'s
`derive_public(seed)` and `sign(seed, msg)` take a caller-supplied seed, and a test seed is not
the maintainer's identity key.

**Monocypher-source parity is landed** -- the vendored `vendor/monocypher` is compiled fresh
and diffed byte-for-byte against our authored Rye over the published vectors, rung by rung.
[`crypto/PARITY.md`](../crypto/PARITY.md) names which rungs stand and what each one anchors to;
that page moved the record word for word out of `crypto/README.md` when it split, and it is the
one place the parity account lives.

---

## How to add a rung

1. **Name the claim** in `active-designing/` (dated, raw layer first) and pick the published
   reference it will be parity-checked against.
2. **Author in pure Rye**, under TAME Guidance -- bound everything, two or more asserts per
   function, `// invariant:` on each, no `std.crypto`, no copied Monocypher line.
3. **Write the witness** `tools/cr/crypto_<name>_witness.rish`, asserting the RFC known-answer
   **and** a cross-check against Zig's `std.crypto`.
4. **Register it** in `crypto_suite_witness.rish` in dependency order, and run the whole suite
   GREEN.
5. **Record its row** in [`crypto/MODULES.md`](../crypto/MODULES.md), its reasoning in
   [`crypto/LADDER.md`](../crypto/LADDER.md), and its posture in
   [`crypto/CONSTANT_TIME.md`](../crypto/CONSTANT_TIME.md). This page compresses, so it needs no
   edit: it routes to those three, and each is held to the directory by its own guard.

---

## Dependencies

| Teacher | Role |
|---------|------|
| **Monocypher** (Loup Vaillant) | Parity target -- public API and RFC vectors; CC0/BSD-dual, vendored, unmodified |
| **Zig `std.crypto`** | Independent second implementation, cross-checked inside every witness |
| **The RFC / FIPS authors** | The published known-answer vectors every rung is proven against |

---

*May this crypto, written in the open and checked against the world, be worthy of the trust a
hand places in it -- and may every keeper who reaches for it find a door they can read all the way down.*
