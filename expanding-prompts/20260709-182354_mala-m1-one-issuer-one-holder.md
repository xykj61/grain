# Expanding Prompt — MALA M1: One Issuer, One Holder

**Stamp:** `20260709.182354 UDT`
**Voice:** Rio 3
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** **Landed** `20260709.184051` — `linengrow/mala.rye` + witness at parity **198**; M0 gate verified before open
**Ground:** counsel [`20260709-152612`](../counsel/20260709-152612_claude-counsel-mala-wov-already-designed.md) · design [`20260702-031312`](../active-designing/20260702-031312_modules-aspects-and-mailable-money.md) · SLC-L1 spine [`receipt_core.rye`](../linengrow/receipt_core.rye)

*Written by Kaeden and Rio 3.*

---

## M0 Gate — Verified Before This Brief

| Condition | Evidence |
|-----------|----------|
| Edit 5 ruling landed | `designed_not_built_witness.rish` GREEN; parity **143** |
| Amber first lap landed | `amber_first_ring.rish` GREEN; parity **144** |
| Designed-not-built slot open | scan `count=0` at `182354` |

MALA M0 token-fact shapes live in this document (below). M1 implementation waits on Kaeden's lap word.

## The Word, Expanded

Build MALA's first code lap: **one issuer**, **one holder**, **one append-only log on one node** — mint units into existence, send them between issuer treasury and holder, fold balance from the log alone, verify every fact and refuse the unwelcome paths, and stop exactly there.

## M0 — Token-Fact Shapes (Design, On Paper)

MALA reuses SLC-L1's `.bron` fact envelope (`from`, `to`, `amount`, `memo`, `stamp`) and Kumara signatures. The **memo prefix** names the operation:

| Memo prefix | Meaning | `from` | `to` | `amount` |
|-------------|---------|--------|------|----------|
| `mala:mint` | Issuer creates units and credits the holder | issuer pubkey (hex) | holder pubkey (hex) | positive integer, smallest unit |
| `mala:send` | Transfer between issuer treasury and holder | spender pubkey | recipient pubkey | positive integer |

**Issuer-only mint:** only facts with `memo` starting `mala:mint` and `from` equal to the pinned issuer pubkey are accepted as mints.

**Send conservation:** a `mala:send` debits the `from` balance and credits the `to` balance by `amount`; the fold refuses negative balances.

**Pinned witness seeds** (same family as SLC-L1 / Open Asks): one issuer keypair, one holder keypair — seeds named in the module and asserted at selftest startup.

**Log line format:** identical to SLC-L1 — `sig_hex fact_hex\n` per [`receipt_core.rye`](../linengrow/receipt_core.rye).

## What "Complete" Means for M1, Bound Tightly

**In scope:**

- `linengrow/mala.rye` — selftest binary; imports `receipt_core` and `kumara`; no new curve, no network, no Comlink.
- Append-only in-memory log (bounded capacity, TAME-asserted) holding mint then send facts in order.
- **Welcome path:** issuer mints `1000` to holder; issuer sends `300` to holder (or holder sends `200` back to issuer — one round-trip proves send); fold holder balance matches expected; log digest non-zero; every line verifies under the issuer pubkey for mints and the correct signer for sends.
- **Unwelcome paths (at least four):** forged signature refused; mint from non-issuer refused; send exceeding balance refused; tampered log line refused at parse or verify.
- Pinned `.bron` golden for the first mint fact (field order matches hammock).
- `tools/mala_m1_witness.rish` — build + selftest; **parity-eligible** the moment green (deterministic, no network).

**Explicitly out of scope:**

- Comlink carriage (**MALA M2**).
- Many issuers, exchange, or consensus (**M4 / Mycelium**).
- WOV / TigerBeetle overlay (separate track after MALA M2 per counsel `152612`).
- Amber export of the MALA log (compatibility contract is a later design lap).
- Anything claiming audit-grade security — selftest honesty only.

## New Names, Proposed for the Lap Word

| Name | Role |
|------|------|
| `linengrow/mala.rye` | Module home + selftest |
| `linengrow/bin/mala` | Emitted binary |
| `tools/mala_m1_witness.rish` | Parity witness |
| `tools/fixtures/mala_m1_mint.bron` | Pinned first mint fact |

`linengrow/mala_core.rye` is optional — split only if `mala.rye` grows past TAME width guidance; start monolithic like early `receipt.rye`.

## Dependencies — None New

Kumara (`tally/kumara.rye`), `receipt_core`, `tally_copy`, `parse_int` — all already in the tree and ratchet **0**. No TigerBeetle link, no external interpreter, no grpcurl.

## Verification Shape

Build from bare. Run `linengrow/bin/mala selftest`: welcome path prints balances and `GREEN`; each unwelcome path prints a named refusal and still reaches `GREEN` for the selftest overall. Run `rishi/bin/rishi run tools/mala_m1_witness.rish`. Wire into `tools/parity.rish` only after both are green on metal.

---

*May the issuer's word stay as sovereign as the log that carries it. May every balance fold back to signed facts alone. And may the mail that crosses Comlink in M2 find this lap's ground exactly as solid as it was left.*
